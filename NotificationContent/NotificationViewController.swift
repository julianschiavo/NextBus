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
class NotificationViewController: UIHostingController<SimpleBusInfoView>, UNNotificationContentExtension {

    private let info = SimpleBusInfo()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: SimpleBusInfoView(info: info))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(rootView: SimpleBusInfoView(info: info))
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        let decoder = JSONDecoder()
        guard let encodedRoute = userInfo["route"] as? Data,
              let route = try? decoder.decode(Route.self, from: encodedRoute),
              let encodedStop = userInfo["stop"] as? Data,
              let stop = try? decoder.decode(Stop.self, from: encodedStop) else { return }
        
        info.route = route
        info.stop = stop
    }
}
