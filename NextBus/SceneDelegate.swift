//
//  SceneDelegate.swift
//  NextBus
//
//  Created by Julian Schiavo on 18/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import BackgroundTasks
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var homeViewController = HomeViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
//        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
//            fatalError("Failed to find app group folder")
//        }
//        let directoryContents = try! FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//
//        for url in directoryContents {
//            try! FileManager.default.removeItem(at: url)
//        }
        
        // Use a UIHostingController as window root view controller.
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.navigationBar.tintColor = .white
        navController.navigationBar.prefersLargeTitles = true
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.preferredFont(for: .largeTitle, weight: .heavy).rounded]
        barAppearance.backgroundColor = .systemPink
        navController.navigationBar.standardAppearance = barAppearance
        navController.navigationBar.compactAppearance = barAppearance
        navController.navigationBar.scrollEdgeAppearance = barAppearance
        
        
        
        window = UIWindow(windowScene: windowScene)
        window?.tintColor = .systemPink
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    // Schedule a background task to update route and stop data
    func scheduleUpdateDataBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.julianschiavo.nextbus.tasks.updatedata")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // Fetch no earlier than 15 minutes from now
        request.requiresNetworkConnectivity = true
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule update data background task: \(error)")
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        scheduleUpdateDataBackgroundTask()
    }


}

