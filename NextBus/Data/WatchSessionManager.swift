//
//  WatchSessionManager.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    private var session: WCSession? {
        guard WCSession.isSupported() else { return nil }
        return .default
    }
    
    var isAppleWatchPaired: Bool {
        activateIfNeeded()
        return session?.isPaired ?? false
    }
    
    var fileTransferQueue = [URL]()
    
    func activateIfNeeded() {
        if session?.activationState != .activated {
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sendFile(at url: URL) {
        activateIfNeeded()
        
        guard let session = session else { return }
        
        if session.activationState == .activated {
            print("WCSession Transferring file at URL \(url) to Apple Watch")
            session.transferFile(url, metadata: nil)
        } else {
            guard fileTransferQueue.contains(url) == false else { return }
            print("WCSession Adding file at URL \(url) to transfer queue")
            fileTransferQueue.append(url)
        }
    }
    
    func sendFilesInQueue() {
        for file in fileTransferQueue {
            sendFile(at: file)
        }
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if let error = error {
            print("WCSession An error occured when attempting to transfer file at URL \(fileTransfer.file.fileURL) to Apple Watch (Error: \(error.localizedDescription))")
        } else {
            print("WCSession Successfully transferred file at URL \(fileTransfer.file.fileURL) to Apple Watch")
        }
    }
    
    // MARK: WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession An error occured when attempting to complete activation (Error: \(error.localizedDescription))")
        } else if activationState == .activated {
            sendFilesInQueue()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        return
    }
    
    // MARK: Singleton
    
    static let shared = WatchSessionManager()
    
    private override init() {
        super.init()
        session?.delegate = self
        session?.activate()
    }
}
