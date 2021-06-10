//
//  PayBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import Loadability
import Purchases

class PayBuddy: ObservableObject, ThrowsErrors {
    
    @Published var packages: [Purchases.Package]?
    @Published var hasPlus = false
    @Published var expirationDate: Date?
    
    @Published var error: IdentifiableError?
    
    init() {
        loadPackages()
        updateStatus()
    }
    
    func purchase(_ package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { transaction, purchaserInfo, error, cancelled in
            if !cancelled {
                self.catchError(error)
            }
            if let info = purchaserInfo {
                self.updateStatus(purchaserInfo: info)
            }
        }
        loadPackages()
    }
    
    func restorePurchases() {
        Purchases.shared.restoreTransactions { purchaserInfo, error in
            self.catchError(error)
            if let info = purchaserInfo {
                self.updateStatus(purchaserInfo: info)
            }
        }
        loadPackages()
    }
    
    func loadStatus(completion: @escaping (Bool) -> Void) {
        Purchases.shared.purchaserInfo { purchaserInfo, error in
            self.catchError(error)
            if let info = purchaserInfo {
                self.updateStatus(purchaserInfo: info)
            }
            completion(self.hasPlus)
        }
    }
    
    private func loadPackages() {
        Purchases.shared.offerings { (offerings, error) in
            guard let offerings = offerings else {
                self.catchError(error)
                return
            }
            DispatchQueue.main.async {
                self.packages = offerings.current?.availablePackages
            }
        }
    }
    
    private func updateStatus() {
        Purchases.shared.purchaserInfo { purchaserInfo, error in
            self.catchError(error)
            if let info = purchaserInfo {
                self.updateStatus(purchaserInfo: info)
            }
        }
    }
    
    private func updateStatus(purchaserInfo: Purchases.PurchaserInfo) {
        let plusEntitlementName = "plus"
        if let entitlement = purchaserInfo.entitlements.active[plusEntitlementName] {
            hasPlus = entitlement.isActive
            expirationDate = entitlement.expirationDate
        } else {
            hasPlus = false
            expirationDate = nil
        }
    }
}

extension Purchases.Package: Identifiable {
    public var id: String { identifier }
}
