//
//  SettingsView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var storeManager = StoreKitManager.shared
    @ObservedObject private var progressManager = ProgressManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showResetAlert = false
    @State private var showPrivacyPolicy = false
    @State private var showPremiumPaywall = false
    @State private var showRestoreError = false
    @State private var restoreErrorMessage = ""

    var body: some View {
        NavigationStack {
            List {
                // Premium Status Section
                Section("Premium Status") {
                    HStack {
                        Text("Premium Unlocked")
                        Spacer()
                        if storeManager.isPremiumUnlocked {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Premium status: \(storeManager.isPremiumUnlocked ? "Unlocked" : "Locked")")

                    if !storeManager.isPremiumUnlocked {
                        Button("Unlock Premium") {
                            showPremiumPaywall = true
                        }
                        .foregroundColor(.blue)
                        .accessibilityLabel("Unlock premium")
                        .accessibilityHint("Double tap to view premium upgrade options")
                    }

                    Button("Restore Purchases") {
                        Task {
                            do {
                                try await storeManager.restorePurchases()
                            } catch {
                                restoreErrorMessage = error.localizedDescription
                                showRestoreError = true
                            }
                        }
                    }
                    .accessibilityLabel("Restore purchases")
                    .accessibilityHint("If you already purchased premium, double tap to restore your access")
                }

                // Appearance Section
                Section("Appearance") {
                    Picker("Theme", selection: $themeManager.currentTheme) {
                        ForEach(AppTheme.allCases, id: \.rawValue) { theme in
                            HStack {
                                Image(systemName: theme.icon)
                                Text(theme.rawValue)
                            }
                            .tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityLabel("Theme picker")
                    .accessibilityValue(themeManager.currentTheme)
                    .accessibilityHint("Choose between light, dark, or automatic theme")
                }

                // Statistics Section
                Section("Statistics") {
                    HStack {
                        Text("Total Study Sessions")
                        Spacer()
                        Text("\(progressManager.totalStudySessions)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Cards Studied")
                        Spacer()
                        Text("\(progressManager.totalCardsStudied)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Words Mastered")
                        Spacer()
                        Text("\(progressManager.totalWordsMastered)")
                            .foregroundColor(.secondary)
                    }
                }

                // Data Management Section
                Section("Data Management") {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Text("Reset All Progress")
                    }
                    .accessibilityLabel("Reset all progress")
                    .accessibilityHint("Warning: This will permanently delete all your learning progress")
                }

                // About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Total Cards")
                        Spacer()
                        Text("\(PhonicsRepository.shared.totalCards)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Free Cards")
                        Spacer()
                        Text("\(PhonicsRepository.shared.freeCardsCount)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Premium Cards")
                        Spacer()
                        Text("\(PhonicsRepository.shared.premiumCardsCount)")
                            .foregroundColor(.secondary)
                    }

                    Button {
                        showPrivacyPolicy = true
                    } label: {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                    .accessibilityLabel("Privacy policy")
                    .accessibilityHint("Double tap to view privacy policy")
                }

                // Debug Section (only for testing)
                #if DEBUG
                Section("Debug") {
                    Button("Unlock Premium (Test)") {
                        storeManager.unlockPremiumForTesting()
                    }

                    Button("Reset Premium (Test)") {
                        storeManager.resetPremiumForTesting()
                    }
                }
                #endif
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .accessibilityLabel("Close settings")
                }
            }
            .alert("Reset Progress", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    progressManager.resetAllProgress()
                }
            } message: {
                Text("Are you sure you want to reset all progress? This cannot be undone.")
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showPremiumPaywall) {
                PremiumPaywallView()
            }
            .alert("Restore Failed", isPresented: $showRestoreError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(restoreErrorMessage)
            }
        }
    }
}

#Preview {
    SettingsView()
}
