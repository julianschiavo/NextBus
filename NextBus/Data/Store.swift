//
//  Store.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class Store: ObservableObject {
    @Published var favorites: Favorites
    @Published var recentlyViewed: RecentlyViewed
    
    @Published var __favorites = OrderedSet<RouteStop>()
    @Published var __recentlyViewed = OrderedSet<RouteStop>()
    
    private let appGroupFolderURL: URL
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
            fatalError("Failed to find app group folder")
        }
        appGroupFolderURL = folder
        self.favorites = Favorites(appGroupFolderURL: appGroupFolderURL)
        self.recentlyViewed = RecentlyViewed(appGroupFolderURL: appGroupFolderURL)
        
        self.favorites.$all
            .receive(on: DispatchQueue.main)
            .sink { all in
                self.__favorites = all
            }
            .store(in: &cancellables)
        self.recentlyViewed.$all
            .receive(on: DispatchQueue.main)
            .sink { all in
                self.__recentlyViewed = all
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Favorites
    
    class Favorites: ObservableObject {
        @Published var all = OrderedSet<RouteStop>() {
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
            self.all = OrderedSet(self.load())
        }
        
        func contains(route: Route, stop: Stop) -> Bool {
            contains(RouteStop(route: route, stop: stop))
        }
        
        func contains(_ routeStop: RouteStop) -> Bool {
            all.contains(routeStop)
        }
        
        func set(_ isFavorite: Bool, route: Route, stop: Stop) {
            set(isFavorite, routeStop: RouteStop(route: route, stop: stop))
        }
        
        func set(_ isFavorite: Bool, routeStop: RouteStop) {
            if isFavorite {
                all.append(routeStop)
            } else {
                all.remove(routeStop)
            }
        }
        
        private func load() -> [RouteStop] {
            guard let data = FileManager.default.contents(atPath: url.path),
                  let favorites = try? decoder.decode([RouteStop].self, from: data)
            else { return [] }
            return favorites
                .sorted {
                    $0.route.localizedName.localizedStandardCompare(
                        $1.route.localizedName
                    ) == .orderedAscending
                }
        }
        
        private func save() {
            guard let data = try? encoder.encode(Array(all)) else { return }
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    // MARK: - Recently Viewed
    
    class RecentlyViewed: ObservableObject {
        @Published var all = OrderedSet<RouteStop>() {
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
            self.all = OrderedSet(self.load())
        }
        
        func add(route: Route, stop: Stop) {
            add(RouteStop(route: route, stop: stop))
        }
        
        func add(_ routeStop: RouteStop) {
            guard !contains(routeStop) else { return }
            if all.count == 4 {
                all.removeLast()
            }
            all.insert(routeStop, at: 0)
            
        }
        
        
        func contains(route: Route, stop: Stop) -> Bool {
            contains(RouteStop(route: route, stop: stop))
        }
        
        func contains(_ routeStop: RouteStop) -> Bool {
            all.contains(routeStop)
        }
        
        func remove(route: Route, stop: Stop) {
            remove(RouteStop(route: route, stop: stop))
        }
        
        func remove(_ routeStop: RouteStop) {
            guard contains(routeStop) else { return }
            all.remove(routeStop)
        }
        
        private func load() -> [RouteStop] {
            guard let data = FileManager.default.contents(atPath: url.path),
                  let all = try? decoder.decode([RouteStop].self, from: data)
            else { return [] }
            return all
        }
        
        private func save() {
            guard let data = try? encoder.encode(Array(all)) else { return }
            try? data.write(to: url, options: [.atomic])
        }
    }
}
