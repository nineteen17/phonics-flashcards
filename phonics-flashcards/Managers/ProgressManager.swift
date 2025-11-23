//
//  ProgressManager.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation

/// Ensures all mutations to @Published happen on the main thread
@MainActor
class ProgressManager: ObservableObject {
    static let shared = ProgressManager()

    @Published private(set) var progressData: UserProgressData
    @Published private(set) var profiles: [ProfileProgressRecord]
    @Published private(set) var activeProfileId: UUID
    @Published var lastSaveError: Error?
    @Published var showSaveErrorAlert = false

    private struct ProfileStore: Codable {
        var profiles: [ProfileProgressRecord]
        var activeProfileId: UUID?
    }

    private static let profileKey = "user_profile_progress_store_v1"
    private static let profileBackupKey = "user_profile_progress_store_backup_v1"
    private static let legacyProgressKey = "user_progress_data"
    private static let legacyBackupKey = "user_progress_data_backup"
    private let defaults = UserDefaults.standard
    private let maxProfiles = 5

    private init() {
        let store = ProgressManager.loadInitialProfileStore()
        var resolvedProfiles = store.profiles

        if resolvedProfiles.isEmpty {
            let defaultProfile = ChildProfile(name: "Learner 1", color: .sky)
            resolvedProfiles = [ProfileProgressRecord(profile: defaultProfile, progress: UserProgressData())]
        }

        var resolvedActiveId = store.activeProfileId ?? resolvedProfiles.first!.id

        if !resolvedProfiles.contains(where: { $0.id == resolvedActiveId }) {
            resolvedActiveId = resolvedProfiles.first!.id
        }

        var activeProgress = resolvedProfiles.first(where: { $0.id == resolvedActiveId })?.progress ?? UserProgressData()
        activeProgress.lastOpenedDate = Date()
        if let index = resolvedProfiles.firstIndex(where: { $0.id == resolvedActiveId }) {
            resolvedProfiles[index].progress = activeProgress
        }

        profiles = resolvedProfiles
        activeProfileId = resolvedActiveId
        progressData = activeProgress

        saveProfiles()
    }

    // MARK: - Public Accessors

    var activeProfile: ChildProfile? {
        profiles.first(where: { $0.id == activeProfileId })?.profile
    }

    var activeProfileDisplayName: String {
        activeProfile?.displayName ?? "Learner"
    }

    var activeProfileColor: ProfileColor {
        activeProfile?.color ?? .sky
    }

    var canAddMoreProfiles: Bool {
        profiles.count < maxProfiles
    }

    var remainingProfileSlots: Int {
        maxProfiles - profiles.count
    }

    // MARK: - Profile Management

    func setActiveProfile(_ id: UUID) {
        guard let record = profiles.first(where: { $0.id == id }) else { return }
        activeProfileId = id

        var progress = record.progress
        progress.lastOpenedDate = Date()
        updateActiveProfileProgress(progress)
    }

    func addProfile(name: String, color: ProfileColor) {
        guard canAddMoreProfiles else { return }

        var progress = UserProgressData()
        progress.lastOpenedDate = Date()

        let profile = ChildProfile(name: sanitizedName(name, fallbackIndex: profiles.count + 1), color: color)
        let record = ProfileProgressRecord(profile: profile, progress: progress)

        profiles.append(record)
        activeProfileId = record.id
        progressData = progress
        saveProfiles()
    }

    func updateProfile(id: UUID, name: String, color: ProfileColor) {
        guard let index = profiles.firstIndex(where: { $0.id == id }) else { return }
        profiles[index].profile.name = sanitizedName(name)
        profiles[index].profile.color = color

        if id == activeProfileId {
            progressData = profiles[index].progress
        }

        saveProfiles()
    }

    func suggestedProfileName() -> String {
        "Learner \(profiles.count + 1)"
    }

    func suggestedProfileColor() -> ProfileColor {
        let used = Set(profiles.map { $0.profile.color })
        if let unused = ProfileColor.allCases.first(where: { !used.contains($0) }) {
            return unused
        }
        return ProfileColor.allCases.randomElement() ?? .sky
    }

    // MARK: - Persistence

    private static func loadInitialProfileStore() -> ProfileStore {
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard

        if let data = defaults.data(forKey: profileKey),
           let decoded = try? decoder.decode(ProfileStore.self, from: data) {
            #if DEBUG
            print("✅ Loaded profile store from primary storage")
            #endif
            return decoded
        }

        if let backupData = defaults.data(forKey: profileBackupKey),
           let decoded = try? decoder.decode(ProfileStore.self, from: backupData) {
            defaults.set(backupData, forKey: profileKey)
            print("⚠️ Loaded profile store from backup")
            return decoded
        }

        if let legacyProgress = loadLegacyProgress(defaults: defaults) {
            let profile = ChildProfile(name: "Learner 1", color: .sky)
            let record = ProfileProgressRecord(profile: profile, progress: legacyProgress)
            return ProfileStore(profiles: [record], activeProfileId: profile.id)
        }

        return ProfileStore(profiles: [], activeProfileId: nil)
    }

    private static func loadLegacyProgress(defaults: UserDefaults) -> UserProgressData? {
        let decoder = JSONDecoder()
        if let data = defaults.data(forKey: legacyProgressKey),
           let decoded = try? decoder.decode(UserProgressData.self, from: data) {
            return decoded
        }

        if let backupData = defaults.data(forKey: legacyBackupKey),
           let decoded = try? decoder.decode(UserProgressData.self, from: backupData) {
            defaults.set(backupData, forKey: legacyProgressKey)
            return decoded
        }

        return nil
    }

    private func saveProfiles() {
        do {
            let store = ProfileStore(profiles: profiles, activeProfileId: activeProfileId)
            let encoded = try JSONEncoder().encode(store)

            if let existingData = defaults.data(forKey: Self.profileKey) {
                defaults.set(existingData, forKey: Self.profileBackupKey)
            }

            defaults.set(encoded, forKey: Self.profileKey)
            lastSaveError = nil

            #if DEBUG
            print("✅ Profile progress saved successfully")
            #endif
        } catch {
            lastSaveError = error
            showSaveErrorAlert = true

            print("❌ CRITICAL: Failed to save profile store: \(error.localizedDescription)")
            attemptRecoveryFromBackup()
        }
    }

    /// Attempt to recover data from backup if main save failed
    private func attemptRecoveryFromBackup() {
        guard let backupData = defaults.data(forKey: Self.profileBackupKey),
              let store = try? JSONDecoder().decode(ProfileStore.self, from: backupData) else {
            print("❌ No backup available for recovery")
            return
        }

        print("⚠️ Recovering from backup...")
        defaults.set(backupData, forKey: Self.profileKey)
        profiles = store.profiles
        activeProfileId = store.activeProfileId ?? store.profiles.first?.id ?? activeProfileId

        if let record = profiles.first(where: { $0.id == activeProfileId }) {
            progressData = record.progress
        }
    }

    // MARK: - Progress Updates

    /// Mark a word as mastered for a card
    func markWordMastered(cardTitle: String, word: String) {
        modifyActiveProgress { progress in
            progress.updateProgress(for: cardTitle, masteredWord: word)
        }
    }

    /// Record a study session for a card
    func recordStudySession(for cardTitle: String) {
        modifyActiveProgress { progress in
            progress.updateProgress(for: cardTitle)
            progress.totalStudySessions += 1
        }
    }

    /// Reset the active profile's progress
    func resetActiveProgress() {
        modifyActiveProgress { progress in
            progress = UserProgressData()
        }
    }

    private func modifyActiveProgress(_ mutation: (inout UserProgressData) -> Void) {
        guard var progress = profiles.first(where: { $0.id == activeProfileId })?.progress else { return }
        mutation(&progress)
        progress.lastOpenedDate = Date()
        updateActiveProfileProgress(progress)
    }

    private func updateActiveProfileProgress(_ progress: UserProgressData, persist: Bool = true) {
        guard let index = profiles.firstIndex(where: { $0.id == activeProfileId }) else { return }
        profiles[index].progress = progress
        progressData = progress

        if persist {
            saveProfiles()
        }
    }

    private func sanitizedName(_ name: String, fallbackIndex: Int? = nil) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            return trimmed
        }

        if let fallbackIndex = fallbackIndex {
            return "Learner \(fallbackIndex)"
        }

        return "Learner"
    }

    // MARK: - Getters

    /// Get progress for a specific card
    func getProgress(for cardTitle: String) -> CardProgress? {
        return progressData.getProgress(for: cardTitle)
    }

    /// Get mastery percentage for a card
    func getMasteryPercentage(for card: PhonicsCard) -> Double {
        return progressData.getMasteryPercentage(for: card)
    }

    /// Check if a word is mastered
    func isWordMastered(cardTitle: String, word: String) -> Bool {
        guard let progress = progressData.cardProgress[cardTitle] else { return false }
        return progress.masteredWords.contains(word)
    }

    /// Total cards studied
    var totalCardsStudied: Int {
        progressData.cardProgress.count
    }

    /// Total study sessions across all time
    var totalStudySessions: Int {
        progressData.totalStudySessions
    }

    /// Total words mastered across all cards
    var totalWordsMastered: Int {
        progressData.cardProgress.values.reduce(0) { $0 + $1.masteredWords.count }
    }
}
