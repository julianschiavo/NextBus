//
//  PayBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import Loadability
import StoreKit
import RevenueCat

class PayBuddy: NSObject, ObservableObject, ThrowsErrors, PurchasesDelegate {
    private struct PurchaseResult {
        let transaction: SKPaymentTransaction?
        let purchaserInfo: PurchaserInfo?
        let wasUserCancelled: Bool
    }
    
    @Published var hasPlus = false {
        didSet {
            UserDefaults.shared.set(hasPlus, forKey: "PayBuddy_HasPlus_Cached")
        }
    }
    @Published var expirationDate: Date?
    
    @Published var packages: [Package]?
    
    @Published var error: Error?
    
    private var purchaserInfo: PurchaserInfo?
    
    override init() {
        super.init()
        
        Purchases.shared.delegate = self
        
        hasPlus = UserDefaults.shared.bool(forKey: "PayBuddy_HasPlus_Cached")
        
        Task {
            await loadPackages()
            await refresh()
        }
    }
    
    func purchase(_ package: Package) async {
        do {
            let result = try await _purchase(package: package)
            await updatePurchaserInfo(result.purchaserInfo)
        } catch {
            await catchError(error)
        }
        await loadPackages()
    }
    
    func restorePurchases() async {
        do {
            let purchaserInfo = try await _restore()
            await updatePurchaserInfo(purchaserInfo)
        } catch {
            await catchError(error)
        }
    }
    
    @MainActor private func loadPackages() async {
        do {
            let offerings = try await _offerings()
            packages = offerings.current?.availablePackages ?? []
        } catch {
            catchError(error)
        }
    }
    
    func refresh() async {
        do {
            let purchaserInfo = try await _purchaserInfo()
            await updatePurchaserInfo(purchaserInfo)
        } catch {
            await catchError(error)
        }
    }
    
    func loadCurrentStatus() async -> Bool {
        await refresh()
        return hasPlus
    }
    
    private func updatePurchaserInfo(_ purchaserInfo: PurchaserInfo?) async {
        print("[RC]", "Updating Purchaser Info")
        guard let purchaserInfo = purchaserInfo else { return }
        self.purchaserInfo = purchaserInfo
        
        await MainActor.run {
            print("[RC]", "Updating Status")
            guard let entitlement = purchaserInfo.entitlements.active["plus"] else {
                print("[RC]", "No Entitlement Found")
                hasPlus = false
                expirationDate = nil
                return
            }
            
            print("[RC]", "Entitlement Found — Active?", entitlement.isActive, "Expiring?", entitlement.expirationDate)
            hasPlus = entitlement.isActive
            expirationDate = entitlement.expirationDate
        }
    }
    
    // MARK: - RevenueCat Async Support
    
    private func _purchase(package: Package) async throws -> PurchaseResult {
        try await withCheckedThrowingContinuation { continuation in
            Purchases.shared.purchase(package: package) { transaction, purchaserInfo, error, userCancelled in
                if let error = error, !userCancelled {
                    continuation.resume(throwing: error)
                } else {
                    let result = PurchaseResult(transaction: transaction, purchaserInfo: purchaserInfo, wasUserCancelled: userCancelled)
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    private func _restore() async throws -> PurchaserInfo {
        try await withCheckedThrowingContinuation { continuation in
            Purchases.shared.restoreTransactions { purchaserInfo, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let purchaserInfo = purchaserInfo {
                    continuation.resume(returning: purchaserInfo)
                }
            }
        }
    }
    
    private func _purchaserInfo() async throws -> PurchaserInfo {
        try await withCheckedThrowingContinuation { continuation in
            Purchases.shared.purchaserInfo { purchaserInfo, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let purchaserInfo = purchaserInfo {
                    continuation.resume(returning: purchaserInfo)
                }
            }
        }
    }
    
    private func _offerings() async throws -> Offerings {
        try await withCheckedThrowingContinuation { continuation in
            Purchases.shared.offerings { offerings, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let offerings = offerings {
                    continuation.resume(returning: offerings)
                }
            }
        }
    }
    
    // MARK: - PurchasesDelegate
    
    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: PurchaserInfo) {
        Task {
            await updatePurchaserInfo(purchaserInfo)
        }
    }
}

extension Package: Identifiable {
    public var id: String { identifier }
}
