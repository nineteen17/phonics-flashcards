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
    private var checkPurchaseTask: Task<Void, Never>?

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
    /// Retries up to 3 times on failure to handle network issues
    func loadProducts() async {
        // Don't reload if already loaded
        guard products.isEmpty else {
            print("ℹ️ Products already loaded, skipping")
            return
        }

        isLoading = true
        defer { isLoading = false }

        let maxRetries = 3
        var retries = 0

        while retries < maxRetries {
            do {
                // In production, this will load from App Store Connect
                // For development, you need to configure the product in App Store Connect
                let products = try await Product.products(for: [premiumProductID])
                self.products = products
                print("✅ Successfully loaded \(products.count) product(s)")
                return
            } catch {
                retries += 1
                print("❌ Failed to load products (attempt \(retries)/\(maxRetries)): \(error.localizedDescription)")

                if retries < maxRetries {
                    // Wait 1 second before retrying
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                } else {
                    print("❌ Failed to load products after \(maxRetries) attempts")
                }
            }
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

            // CRITICAL: Update state BEFORE finishing transaction
            // This prevents data loss if app crashes
            await checkPurchaseStatus()

            // Verify state was actually updated
            guard isPremiumUnlocked else {
                throw StoreError.purchaseFailed("Purchase verified but state not updated. Please restart the app.")
            }

            // NOW it's safe to finish the transaction
            await transaction.finish()
            return transaction

        case .userCancelled:
            print("User cancelled purchase")
            return nil

        case .pending:
            print("Purchase pending (e.g., Ask to Buy)")
            return nil

        @unknown default:
            return nil
        }
    }

    /// Restore previous purchases
    /// Throws specific errors to help users understand what went wrong
    func restorePurchases() async throws {
        isLoading = true
        defer { isLoading = false }

        do {
            // Sync with App Store
            try await AppStore.sync()

            // Wait briefly for transactions to update
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            // Check purchase status
            await checkPurchaseStatus()

            // Verify that premium was actually unlocked
            guard isPremiumUnlocked else {
                throw StoreError.noPreviousPurchases
            }

            print("✅ Successfully restored purchases")
        } catch let error as StoreError {
            // Re-throw our custom errors
            throw error
        } catch {
            // Convert system errors to user-friendly messages
            print("❌ Restore purchases failed: \(error.localizedDescription)")
            throw StoreError.restoreFailed("App Store connection issue")
        }
    }

    /// Check if premium is already purchased
    /// Prevents race conditions by cancelling any ongoing check
    private func checkPurchaseStatus() async {
        // Cancel previous check if still running
        checkPurchaseTask?.cancel()

        checkPurchaseTask = Task {
            var purchasedIDs: Set<String> = []

            for await result in Transaction.currentEntitlements {
                // Check for cancellation
                guard !Task.isCancelled else {
                    print("⚠️ Purchase status check cancelled")
                    return
                }

                do {
                    let transaction = try checkVerified(result)
                    purchasedIDs.insert(transaction.productID)
                } catch {
                    print("❌ Transaction verification failed: \(error.localizedDescription)")
                }
            }

            // Only update if task wasn't cancelled
            guard !Task.isCancelled else { return }

            self.purchasedProductIDs = purchasedIDs

            // SECURITY: Only trust StoreKit verified entitlements
            // UserDefaults backup removed - was security vulnerability
            self.isPremiumUnlocked = purchasedIDs.contains(premiumProductID)
        }

        // Wait for the task to complete
        await checkPurchaseTask?.value
    }

    /// Listen for transaction updates
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)

                    // Update state first
                    await self.checkPurchaseStatus()

                    // Only finish if verification succeeded AND state updated
                    if await self.isPremiumUnlocked {
                        await transaction.finish()
                        print("✅ Transaction update processed and finished")
                    } else {
                        print("⚠️ Transaction verified but state not updated - will retry")
                    }
                } catch {
                    print("❌ Transaction verification failed: \(error.localizedDescription)")
                    // Don't finish failed transactions - they'll retry on next app launch
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
        if let product = products.first(where: { $0.id == premiumProductID }) {
            return product.displayPrice
        }
        return isLoading ? "Loading..." : "Price unavailable"
    }

    #if DEBUG
    /// For testing purposes only - manually unlock premium
    /// WARNING: Only available in DEBUG builds
    func unlockPremiumForTesting() {
        isPremiumUnlocked = true
        print("⚠️ DEBUG: Premium unlocked for testing")
    }

    /// For testing purposes only - reset premium status
    /// WARNING: Only available in DEBUG builds
    func resetPremiumForTesting() {
        isPremiumUnlocked = false
        print("⚠️ DEBUG: Premium reset for testing")
    }
    #endif
}

enum StoreError: LocalizedError {
    case failedVerification
    case productNotFound
    case networkError
    case purchaseFailed(String)
    case restoreFailed(String)
    case noPreviousPurchases

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Purchase verification failed"
        case .productNotFound:
            return "Premium product not available"
        case .networkError:
            return "Cannot connect to the App Store"
        case .purchaseFailed(let reason):
            return "Purchase failed: \(reason)"
        case .restoreFailed(let reason):
            return "Restore failed: \(reason)"
        case .noPreviousPurchases:
            return "No previous purchases found"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .failedVerification:
            return "Please try again or contact support if the problem persists."
        case .productNotFound:
            return "The premium unlock is not available. Please try again later."
        case .networkError:
            return "Please check your internet connection and try again."
        case .purchaseFailed:
            return "Please try again or contact support if the problem persists."
        case .restoreFailed:
            return "Please try again later. If the problem continues, contact support."
        case .noPreviousPurchases:
            return "If you previously purchased premium on this device, try again in a few moments. Make sure you're signed in with the same Apple ID."
        }
    }
}
