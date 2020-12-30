//
//  WatchSessionManager.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 11/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import WatchConnectivity
import WatchKit

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    private let appGroupFolderURL: URL
    
    private var session = WCSession.default
    
    func start() {
        session.delegate = self
        session.activate()
    }
    
    // MARK: WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let fileName = file.fileURL.lastPathComponent
        let newFileURL = appGroupFolderURL.appendingPathComponent(fileName)
        print("Old", file.fileURL, "New", newFileURL)
        do {
            try FileManager.default.moveItem(at: file.fileURL, to: newFileURL)
        } catch {
            print("An error occured when attempting to move file at URL \(file.fileURL) to URL \(newFileURL)")
        }
    }
    
    // MARK: Singleton
    
    static let shared = WatchSessionManager()
    
    private override init() {
        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
            fatalError("Failed to find app group folder")
        }
        appGroupFolderURL = folder
        
        super.init()
        start()
    }
}
