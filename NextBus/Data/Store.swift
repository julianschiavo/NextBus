//
//  Store.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import UserNotifications

class Store: ObservableObject {
    @Published var favorites: Favorites
    @Published var recents: Recents
    @Published var schedule: Schedule
    
    @Published var __favorites: [RouteStop]?
    @Published var __recents: [RouteStop]?
    @Published var __scheduleBlocks: [ScheduleBlock]?
    
    static var appGroupFolderURL: URL = {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") ??
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ??
            URL(fileURLWithPath: "")
    }()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
            fatalError("Failed to find app group folder")
        }
        Store.appGroupFolderURL = folder
        self.favorites = Favorites(appGroupFolderURL: Store.appGroupFolderURL)
        self.recents = Recents(appGroupFolderURL: Store.appGroupFolderURL)
        self.schedule = Schedule(appGroupFolderURL: Store.appGroupFolderURL)
        
        self.favorites.$all
            .receive(on: DispatchQueue.main)
            .sink { all in
                self.__favorites = all
            }
            .store(in: &cancellables)
        self.recents.$all
            .receive(on: DispatchQueue.main)
            .sink { all in
                self.__recents = all
            }
            .store(in: &cancellables)
        self.schedule.$all
            .receive(on: DispatchQueue.main)
            .sink { all in
                self.__scheduleBlocks = all
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Favorites
    
    class Favorites: ObservableObject {
        @Published private(set) var all = [RouteStop]() {
            didSet {
                save()
            }
        }
        
        private let decoder = JSONDecoder()
        private let encoder = JSONEncoder()
        private let url: URL
        
        fileprivate init(appGroupFolderURL: URL) {
            self.url = appGroupFolderURL
                .appendingPathComponent("UserFavorites")
                .appendingPathExtension("json")
            DispatchQueue.global(qos: .userInteractive).async {
                let all = self.load()
                DispatchQueue.main.async {
                    self.all = all
                }
            }
        }
        
        func contains(route: Route, stop: Stop) -> Bool {
            contains(RouteStop(route: route, stop: stop))
        }
        
        func contains(_ routeStop: RouteStop) -> Bool {
            all.contains { $0.id == routeStop.id }
        }
        
        func set(_ isFavorite: Bool, route: Route, stop: Stop) {
            set(isFavorite, routeStop: RouteStop(route: route, stop: stop))
        }
        
        func set(_ isFavorite: Bool, routeStop: RouteStop) {
            withAnimation {
                if isFavorite {
                    all.append(routeStop)
                } else {
                    all.removeAll { $0.id == routeStop.id }
                }
            }
        }
        
        func load() -> [RouteStop] {
            guard let data = FileManager.default.contents(atPath: url.path),
                  let favorites = try? decoder.decode([RouteStop].self, from: data)
            else { return [] }
            return favorites
                .removingDuplicates()
                .sorted {
                    $0.route.localizedName.localizedStandardCompare(
                        $1.route.localizedName
                    ) == .orderedAscending
                }
        }
        
        private func save() {
            guard let data = try? encoder.encode(all) else { return }
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    // MARK: - Recently Viewed
    
    class Recents: ObservableObject {
        @Published private(set) var all = [RouteStop]() {
            didSet {
                save()
            }
        }
        
        private let decoder = JSONDecoder()
        private let encoder = JSONEncoder()
        private let url: URL
        
        fileprivate init(appGroupFolderURL: URL) {
            self.url = appGroupFolderURL
                .appendingPathComponent("RecentlyViewed")
                .appendingPathExtension("json")
            DispatchQueue.global(qos: .userInteractive).async {
                let all = self.load()
                DispatchQueue.main.async {
                    self.all = all
                }
            }
        }
        
        func add(route: Route, stop: Stop) {
            add(RouteStop(route: route, stop: stop))
        }
        
        func add(_ routeStop: RouteStop) {
            guard !contains(routeStop) else { return }
            withAnimation {
                if all.count == 4 {
                    all.removeLast()
                }
                all.insert(routeStop, at: 0)
            }
        }
        
        func contains(route: Route, stop: Stop) -> Bool {
            contains(RouteStop(route: route, stop: stop))
        }
        
        func contains(_ routeStop: RouteStop) -> Bool {
            all.contains { $0.id == routeStop.id }
        }
        
        func remove(route: Route, stop: Stop) {
            remove(RouteStop(route: route, stop: stop))
        }
        
        func remove(_ routeStop: RouteStop) {
            guard contains(routeStop) else { return }
            withAnimation {
                all.removeAll { $0.id == routeStop.id }
            }
        }
        
        func load() -> [RouteStop] {
            guard let data = FileManager.default.contents(atPath: url.path),
                  let all = try? decoder.decode([RouteStop].self, from: data)
            else { return [] }
            return all.removingDuplicates()
        }
        
        private func save() {
            guard let data = try? encoder.encode(all) else { return }
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    // MARK: - Schedule
    
    class Schedule: ObservableObject {
        @Published private(set) var all = [ScheduleBlock]() {
            didSet {
                save()
            }
        }
        
        private let decoder = JSONDecoder()
        private let encoder = JSONEncoder()
        private let url: URL
        
        fileprivate init(appGroupFolderURL: URL) {
            self.url = appGroupFolderURL
                .appendingPathComponent("Schedule")
                .appendingPathExtension("json")
            DispatchQueue.global(qos: .userInteractive).async {
                let all = self.load()
                DispatchQueue.main.async {
                    self.all = all
                }
            }
        }
        
        func add(_ block: ScheduleBlock) {
            withAnimation {
                all.insert(block, at: 0)
            }
        }
        
        func update(_ block: ScheduleBlock) {
            withAnimation {
                delete(block)
                add(block)
            }
        }
        
        func delete(_ block: ScheduleBlock) {
            withAnimation {
                all.removeAll { $0.id == block.id }
            }
        }
        
        func delete(at offsets: IndexSet) {
            withAnimation {
                all.remove(atOffsets: offsets)
            }
        }
        
        func load() -> [ScheduleBlock] {
            guard let data = FileManager.default.contents(atPath: url.path),
                  let blocks = try? decoder.decode([ScheduleBlock].self, from: data)
            else { return [] }
            blocks.forEach {
                scheduleNotifications(for: $0)
            }
            return blocks
                .removingDuplicates()
                .sorted {
                    $0.startDate < $1.startDate
                }
        }
        
        private func save() {
            guard let data = try? encoder.encode(all) else { return }
            try? data.write(to: url, options: [.atomic])
        }
        
        // MARK: - Notifications
        
        func scheduleNotifications(for block: ScheduleBlock) {
            guard block.sendsNotifications else { return }
            
            let jsonEncoder = JSONEncoder()
            let route = try? jsonEncoder.encode(block.route)
            let stop = try? jsonEncoder.encode(block.stop)
            
            let content = UNMutableNotificationContent()
            content.title = Localizable.Notifications.title(block.name)
            content.body = Localizable.Notifications.description(block.route.localizedName)
            content.categoryIdentifier = "Schedule"
            content.threadIdentifier = block.id.uuidString
            content.userInfo["name"] = block.name
            content.userInfo["route"] = route
            content.userInfo["stop"] = stop
            
            let date = Calendar.current.dateComponents([.hour, .minute, .second], from: block.startDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            
            let request = UNNotificationRequest(identifier: block.id.uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { _ in }
        }
        
        func cancelNotifications(for block: ScheduleBlock) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [block.id.uuidString])
        }
    }
}
