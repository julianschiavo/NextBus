//
//  AppDelegate.swift
//  NextBus
//
//  Created by Julian Schiavo on 18/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import BackgroundTasks
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Register launch handlers for background tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.julianschiavo.nextbus.tasks.updatedata", using: nil) { task in
            task.expirationHandler = {
                // Cancel all the URL requests before the session is terminated
                APIManager.shared.lowPriorityURLSession.invalidateAndCancel()
                APIManager.shared.highPriorityURLSession.invalidateAndCancel()
                task.setTaskCompleted(success: false)
            }
            
            // As background sessions have limited execution time, fetch non-cached data before re-fetching cached data
            APIManager.shared.start {
                APIManager.shared.updateData(priority: .normal) { error in
                    task.setTaskCompleted(success: error == nil)
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

