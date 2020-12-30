//
//  HostingController.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 26/12/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import SwiftUI
import WatchKit

class HostingController: WKHostingController<HomeView> {
    
//    let routeDataManager = RouteDataManager()
    
    override var body: HomeView {
//        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
//            fatalError("Failed to find app group folder")
//        }
//        var directoryContents = try! FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//        
//        for url in directoryContents {
//            try! FileManager.default.removeItem(at: url)
//        }
        
        return HomeView()
    }
}
