//
//  StoreKitManager.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation
import StoreKit

/// Manages in-app purchases using StoreKit 2
@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    // Product ID for premium unlock
    private let premiumProductID = "com.phonicsflashcards.premiumunlock"

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isLoading = false
    @Published var isPremiumUnlocked = false

    private var updateListenerTask: Task<Void, Error>?

    private init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        // Load products and check purchase status
        Task {
            await loadProducts()
            await checkPurchaseStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    /// Load available products from the App Store
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // In production, this will load from App Store Connect
            // For development, you need to configure the product in App Store Connect
            let products = try await Product.products(for: [premiumProductID])
            self.products = products
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    /// Purchase the premium unlock
    func purchasePremium() async throws -> Transaction? {
        guard let product = products.first(where: { $0.id == premiumProductID }) else {
            throw StoreError.productNotFound
        }

        isLoading = true
        defer { isLoading = false }

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await checkPurchaseStatus()
            return transaction

        case .userCancelled:
            return nil

        case .pending:
            return nil

        @unknown default:
            return nil
        }
    }

    /// Restore previous purchases
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        try? await AppStore.sync()
        await checkPurchaseStatus()
    }

    /// Check if premium is already purchased
    private func checkPurchaseStatus() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                purchasedIDs.insert(transaction.productID)
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }

        self.purchasedProductIDs = purchasedIDs
        self.isPremiumUnlocked = purchasedIDs.contains(premiumProductID)

        // Also check UserDefaults as a backup (for testing)
        if UserDefaults.standard.bool(forKey: "premium_unlocked") {
            self.isPremiumUnlocked = true
        }
    }

    /// Listen for transaction updates
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.checkPurchaseStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }

    /// Verify transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    /// Get product price string
    var premiumPriceString: String {
        products.first(where: { $0.id == premiumProductID })?.displayPrice ?? "$9.99"
    }

    /// For testing purposes only - manually unlock premium
    func unlockPremiumForTesting() {
        UserDefaults.standard.set(true, forKey: "premium_unlocked")
        isPremiumUnlocked = true
    }

    /// For testing purposes only - reset premium status
    func resetPremiumForTesting() {
        UserDefaults.standard.set(false, forKey: "premium_unlocked")
        isPremiumUnlocked = false
    }
}

enum StoreError: Error {
    case failedVerification
    case productNotFound
}
