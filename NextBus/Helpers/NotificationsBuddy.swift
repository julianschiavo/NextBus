//
//  NotificationsBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 17/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import UserNotifications

class NotificationsBuddy: ObservableObject, ThrowsErrors {
    @Published var hasAuthorization = false
    @Published var didRequestAuthorization = false
    @Published var error: IdentifiableError?
    
    private let center = UNUserNotificationCenter.current()
    
    init() {
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.hasAuthorization = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
                self?.didRequestAuthorization = settings.authorizationStatus != .notDetermined
            }
        }
    }
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.catchError(error)
                self?.didRequestAuthorization = true
                if granted {
                    self?.hasAuthorization = true
                }
            }
        }
    }
}
