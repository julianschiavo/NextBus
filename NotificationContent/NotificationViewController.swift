    //
    //  NotificationViewController.swift
    //  NotificationContent
    //
    //  Created by Julian Schiavo on 17/1/2021.
    //  Copyright © 2021 Julian Schiavo. All rights reserved.
    //

import Combine
import SwiftUI
import UIKit
import UserNotifications
import UserNotificationsUI

@objc(NotificationViewController)
class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        let decoder = JSONDecoder()
        guard let encodedRoute = userInfo["route"] as? Data,
              let route = try? decoder.decode(Route.self, from: encodedRoute),
              let encodedStop = userInfo["stop"] as? Data,
              let stop = try? decoder.decode(Stop.self, from: encodedStop) else { return }
        
        let info = SimpleBusInfo()
        info.route = route
        info.stop = stop
        
        let view = SimpleBusInfoView(info: info)
        let hostingController = UIHostingController(rootView: view)
        attachChild(hostingController)
    }
    
    private func attachChild(_ viewController: UIViewController) {
        addChild(viewController)
        
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        if let subview = viewController.view {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            
                // Set the child controller's view to be the exact same size as the parent controller's view.
            subview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            subview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        viewController.didMove(toParent: self)
    }
}
