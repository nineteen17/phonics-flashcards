//
//  SettingsView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showResetAlert = false
    @State private var showPrivacyPolicy = false
    @State private var showPremiumPaywall = false

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

                    if !storeManager.isPremiumUnlocked {
                        Button("Unlock Premium") {
                            showPremiumPaywall = true
                        }
                        .foregroundColor(.blue)
                    }

                    Button("Restore Purchases") {
                        Task {
                            await storeManager.restorePurchases()
                        }
                    }
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
        }
    }
}

#Preview {
    SettingsView()
}
