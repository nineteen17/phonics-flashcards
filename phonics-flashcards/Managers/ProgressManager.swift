//
//  ProgressManager.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation

/// Manages user progress persistence using UserDefaults
class ProgressManager: ObservableObject {
    static let shared = ProgressManager()

    @Published private(set) var progressData: UserProgressData

    private let progressKey = "user_progress_data"
    private let defaults = UserDefaults.standard

    private init() {
        // Load existing progress or create new
        if let data = defaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode(UserProgressData.self, from: data) {
            self.progressData = decoded
        } else {
            self.progressData = UserProgressData()
        }

        // Update last opened date
        progressData.lastOpenedDate = Date()
        saveProgress()
    }

    /// Save progress to UserDefaults
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(progressData) {
            defaults.set(encoded, forKey: progressKey)
        }
    }

    /// Mark a word as mastered for a card
    func markWordMastered(cardTitle: String, word: String) {
        DispatchQueue.main.async { [weak self] in
            self?.progressData.updateProgress(for: cardTitle, masteredWord: word)
            self?.saveProgress()
        }
    }

    /// Record a study session for a card
    func recordStudySession(for cardTitle: String) {
        DispatchQueue.main.async { [weak self] in
            self?.progressData.updateProgress(for: cardTitle)
            self?.progressData.totalStudySessions += 1
            self?.saveProgress()
        }
    }

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
        guard let progress = progressData.cardProgress[cardTitle] else {
            return false
        }
        return progress.masteredWords.contains(word)
    }

    /// Reset all progress (for testing or settings)
    func resetAllProgress() {
        progressData = UserProgressData()
        progressData.lastOpenedDate = Date()
        saveProgress()
    }

    /// Get total cards studied
    var totalCardsStudied: Int {
        return progressData.cardProgress.count
    }

    /// Get total study sessions
    var totalStudySessions: Int {
        return progressData.totalStudySessions
    }

    /// Get total words mastered across all cards
    var totalWordsMastered: Int {
        return progressData.cardProgress.values.reduce(0) { $0 + $1.masteredWords.count }
    }
}
