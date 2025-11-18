//
//  PremiumPaywallView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct PremiumPaywallView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    headerSection

                    // Features
                    featuresSection

                    // Purchase button
                    purchaseSection

                    // Restore button
                    restoreSection
                }
                .padding()
            }
            .navigationTitle("Unlock Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)

            Text("Unlock All Phonics Cards")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Get access to all \(PhonicsRepository.shared.premiumCardsCount) premium phonics cards")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            FeatureRow(
                icon: "book.fill",
                title: "Complete Library",
                description: "Access all \(PhonicsRepository.shared.totalCards) phonics cards"
            )

            FeatureRow(
                icon: "arrow.down.circle.fill",
                title: "Offline Access",
                description: "All content works offline, no internet required"
            )

            FeatureRow(
                icon: "chart.line.uptrend.xyaxis",
                title: "Track Progress",
                description: "Monitor your child's learning journey"
            )

            FeatureRow(
                icon: "infinity",
                title: "One-Time Purchase",
                description: "Pay once, own forever. No subscriptions!"
            )
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }

    private var purchaseSection: some View {
        VStack(spacing: 12) {
            Button {
                purchasePremium()
            } label: {
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Unlock for \(storeManager.premiumPriceString)")
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isPurchasing)

            Text("One-time payment • Lifetime access")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var restoreSection: some View {
        VStack(spacing: 8) {
            Button {
                restorePurchases()
            } label: {
                Text("Restore Purchases")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .disabled(isPurchasing)

            Text("Already purchased? Restore your access")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func purchasePremium() {
        isPurchasing = true

        Task {
            do {
                let transaction = try await storeManager.purchasePremium()
                if transaction != nil {
                    // Purchase successful
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isPurchasing = false
        }
    }

    private func restorePurchases() {
        isPurchasing = true

        Task {
            await storeManager.restorePurchases()
            isPurchasing = false

            if storeManager.isPremiumUnlocked {
                dismiss()
            } else {
                errorMessage = "No previous purchases found"
                showError = true
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    PremiumPaywallView()
}
