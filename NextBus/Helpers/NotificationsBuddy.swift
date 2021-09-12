//
//  NotificationsBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 17/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability
import UserNotifications

@MainActor class NotificationsBuddy: ObservableObject, ThrowsErrors {
    @Published var hasAuthorization = false
    @Published var didRequestAuthorization = false
    @Published var error: Error?
    
    private let center = UNUserNotificationCenter.current()
    
    init() {
        Task {
            await update()
        }
    }
    
    private func update() async {
        let settings = await _getNotificationSettings()
        hasAuthorization = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
        didRequestAuthorization = settings.authorizationStatus != .notDetermined
    }
    
    private func _getNotificationSettings() async -> UNNotificationSettings {
        await withCheckedContinuation { continuation in
            center.getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }
    }
    
    func requestAuthorization() async {
        didRequestAuthorization = true
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings])
            if granted {
                hasAuthorization = true
            }
        } catch {
            catchError(error)
        }
    }
}
