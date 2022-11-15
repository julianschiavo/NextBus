//
//  ScheduleBlock.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
#if !os(watchOS)
import NiceNotifications
import UserNotifications
#endif

struct ScheduleBlock: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let name: String
    
    let days: [String]?
    let startDate: Date
    let endDate: Date
    
    let routeStops: [RouteStop]
    
    let showsOnWidget: Bool
    let sendsNotifications: Bool
}

#if !os(watchOS)
class ScheduleNotificationsGroup: LocalNotificationsGroup {
    let groupIdentifier = "scheduleNotifications"
    
    func getTimeline(completion: @escaping (NotificationsTimeline) -> ()) {
        Task {
            let timelines = await Store.shared.schedule.all
                .filter {
                    $0.sendsNotifications
                }
                .map {
                    timeline(for: $0)
                }
         
            let finalTimeline = NotificationsTimeline(combining: timelines)
            completion(finalTimeline)
        }
    }
    
    private func timeline(for block: ScheduleBlock) -> NotificationsTimeline {
        let hour = Calendar.current.dateComponents([.hour, .minute], from: block.startDate).hour ?? 0
        let minute = Calendar.current.dateComponents([.hour, .minute], from: block.startDate).minute ?? 0
        
        let days: [String] = (block.days ?? Calendar.current.standaloneWeekdaySymbols).isEmpty ? Calendar.current.standaloneWeekdaySymbols : block.days ?? []
        let weekdays: [DateBuilder.Week.GregorianWeekday] = days
            .map { day -> Int in
                (Calendar.current.standaloneWeekdaySymbols.firstIndex(of: day) ?? 0) + 1
            }
            .map {
                .init(rawValue: $0)
            }
        
        let dates = weekdays.flatMap {
            EveryWeek(forWeeks: 52, starting: .thisWeek)
                .weekday($0)
                .at(hour: hour, minute: minute)
        }
        
        return NotificationsTimeline {
            dates
                .schedule(with: self.content(for: block))
        }
    }
    
    private func content(for block: ScheduleBlock) -> UNMutableNotificationContent {
        let jsonEncoder = JSONEncoder()
        let routeStops = try? jsonEncoder.encode(block.routeStops)
        
        let content = UNMutableNotificationContent()
        content.title = Localizable.Notifications.title(block.name)
        content.body = Localizable.Notifications.description(block.routeStops.first?.route.localizedName ?? "bus")
        content.categoryIdentifier = "Schedule"
        content.interruptionLevel = .timeSensitive
        content.threadIdentifier = block.id.uuidString
        content.userInfo["name"] = block.name
        content.userInfo["routeStops"] = routeStops
        return content
    }
}
#endif
