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
    
    @Published var error: Error?
    
    init() {
        Task {
            await loadPackages()
            await updateStatus()
        }
    }
    
    func purchase(_ package: Purchases.Package) async {
        do {
            let (_, purchaserInfo, _) = try await Purchases.shared.purchasePackage(package)
            await updateStatus(purchaserInfo: purchaserInfo)
        } catch {
            await catchError(error)
        }
        await loadPackages()
    }
    
    private func _purchasePackage(_ package: Purchases.Package) async throws -> (transaction: SKPaymentTransaction?, purchaserInfo: Purchases.PurchaserInfo?, userCancelled: Bool) {
        try await withCheckedThrowingContinuation { continuation in
            Purchases.shared.purchasePackage(package) { transaction, purchaserInfo, error, userCancelled in
                if let error = error, !userCancelled {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (transaction, purchaserInfo, userCancelled))
                }
            }
        }
    }
    
    func restorePurchases() async {
        do {
            let purchaserInfo = try await Purchases.shared.restoreTransactions()
            await updateStatus(purchaserInfo: purchaserInfo)
            await loadPackages()
        } catch {
            await catchError(error)
        }
    }
    
    @discardableResult func loadStatus() async -> Bool {
        do {
            let info = try await Purchases.shared.purchaserInfo()
            Task {
                await updateStatus()
            }
            return status(for: info)
        } catch {
            await catchError(error)
        }
        return false
    }
    
    @MainActor private func loadPackages() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            packages = offerings.current?.availablePackages
        } catch {
            catchError(error)
        }
    }
    
    private func updateStatus() async {
        do {
            let purchaserInfo = try await Purchases.shared.purchaserInfo()
            await updateStatus(purchaserInfo: purchaserInfo)
        } catch {
            await catchError(error)
        }
    }
    
    @MainActor private func updateStatus(purchaserInfo: Purchases.PurchaserInfo) {
        let plusEntitlementName = "plus"
        if let entitlement = purchaserInfo.entitlements.active[plusEntitlementName] {
            hasPlus = entitlement.isActive
            expirationDate = entitlement.expirationDate
        } else {
            hasPlus = false
            expirationDate = nil
        }
    }
    
    private func status(for purchaserInfo: Purchases.PurchaserInfo) -> Bool {
        let plusEntitlementName = "plus"
        if let entitlement = purchaserInfo.entitlements.active[plusEntitlementName] {
            return entitlement.isActive
        } else {
            return false
        }
    }
}

extension Purchases.Package: Identifiable {
    public var id: String { identifier }
}
