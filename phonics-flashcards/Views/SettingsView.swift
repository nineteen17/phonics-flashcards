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
    @State private var profileEditorConfig: ProfileEditorConfig?

    private var activeProfileBinding: Binding<UUID> {
        Binding<UUID>(
            get: {
                progressManager.activeProfileId
            },
            set: { newValue in
                progressManager.setActiveProfile(newValue)
            }
        )
    }

    var body: some View {
        NavigationStack {
            List {
                premiumStatusSection
                profilesSection
                appearanceSection
                statisticsSection
                dataManagementSection
                aboutSection
                #if DEBUG
                debugSection
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
                    progressManager.resetActiveProgress()
                }
            } message: {
                Text("Are you sure you want to clear \(progressManager.activeProfileDisplayName)'s progress? This cannot be undone.")
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showPremiumPaywall) {
                PremiumPaywallView()
            }
            .sheet(item: $profileEditorConfig) { config in
                ProfileEditorView(
                    mode: config.mode.viewMode,
                    initialName: config.initialName,
                    initialColor: config.initialColor
                ) { name, color in
                    switch config.mode {
                    case .new:
                        progressManager.addProfile(name: name, color: color)
                    case .edit(let profile):
                        progressManager.updateProfile(id: profile.id, name: name, color: color)
                    }
                }
            }
            .alert("Restore Failed", isPresented: $showRestoreError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(restoreErrorMessage)
            }
        }
    }

    // MARK: - Section Views

    private var premiumStatusSection: some View {
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
    }

    private var profilesSection: some View {
        Section {
            Picker("Active Profile", selection: activeProfileBinding) {
                ForEach(progressManager.profiles) { record in
                    Text(record.profile.displayName)
                        .tag(record.id)
                }
            }
            .pickerStyle(.menu)
            .accessibilityLabel("Active profile picker")

            ForEach(progressManager.profiles) { record in
                profileButton(for: record)
            }

            if progressManager.canAddMoreProfiles {
                addProfileButton
            } else {
                maxProfilesText
            }
        } header: {
            Text("Profiles")
        }
    }

    private func profileButton(for record: ProfileProgressRecord) -> some View {
        Button {
            profileEditorConfig = .edit(record.profile)
        } label: {
            HStack {
                Circle()
                    .fill(record.profile.color.color)
                    .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(record.profile.displayName)
                    Text("Tap to edit name or color")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if record.id == progressManager.activeProfileId {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
    }

    private var addProfileButton: some View {
        Button {
            profileEditorConfig = .new(
                name: progressManager.suggestedProfileName(),
                color: progressManager.suggestedProfileColor()
            )
        } label: {
            Label("Add Profile", systemImage: "plus.circle.fill")
        }
    }

    private var maxProfilesText: some View {
        Text("You've added the maximum of 5 profiles.")
            .font(.caption)
            .foregroundColor(.secondary)
    }

    private var appearanceSection: some View {
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
    }

    private var statisticsSection: some View {
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
    }

    private var dataManagementSection: some View {
        Section("Active Profile Progress") {
            Button(role: .destructive) {
                showResetAlert = true
            } label: {
                Text("Reset \(progressManager.activeProfileDisplayName)'s Progress")
            }
            .accessibilityLabel("Reset all progress")
            .accessibilityHint("Warning: This will permanently delete all your learning progress")

            Text("Clears sessions and mastered words for the selected profile only.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var aboutSection: some View {
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
    }

    #if DEBUG
    private var debugSection: some View {
        Section("Debug") {
            Button("Unlock Premium (Test)") {
                storeManager.unlockPremiumForTesting()
            }

            Button("Reset Premium (Test)") {
                storeManager.resetPremiumForTesting()
            }
        }
    }
    #endif
}

private struct ProfileEditorConfig: Identifiable {
    enum Mode {
        case new
        case edit(ChildProfile)
    }

    let id = UUID()
    let mode: Mode
    let initialName: String
    let initialColor: ProfileColor

    static func new(name: String, color: ProfileColor) -> ProfileEditorConfig {
        ProfileEditorConfig(mode: .new, initialName: name, initialColor: color)
    }

    static func edit(_ profile: ChildProfile) -> ProfileEditorConfig {
        ProfileEditorConfig(
            mode: .edit(profile),
            initialName: profile.name,
            initialColor: profile.color
        )
    }
}

private extension ProfileEditorConfig.Mode {
    var viewMode: ProfileEditorView.Mode {
        switch self {
        case .new:
            return .new
        case .edit:
            return .edit
        }
    }
}

#Preview {
    SettingsView()
}
