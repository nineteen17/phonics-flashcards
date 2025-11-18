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
    
    private let progressKey = "user_progress_data"
    private let defaults = UserDefaults.standard
    
    private init() {
        // Load existing data safely
        if let data = defaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode(UserProgressData.self, from: data) {
            self.progressData = decoded
        } else {
            self.progressData = UserProgressData()
        }
        
        // Always update last opened
        progressData.lastOpenedDate = Date()
        saveProgress()
    }
    
    // MARK: - Persistence
    
    private func saveProgress() {
        guard let encoded = try? JSONEncoder().encode(progressData) else { return }
        defaults.set(encoded, forKey: progressKey)
    }
    
    // MARK: - Progress Updates
    
    /// Mark a word as mastered for a card
    func markWordMastered(cardTitle: String, word: String) {
        progressData.updateProgress(for: cardTitle, masteredWord: word)
        saveProgress()
    }
    
    /// Record a study session for a card
    func recordStudySession(for cardTitle: String) {
        progressData.updateProgress(for: cardTitle)
        progressData.totalStudySessions += 1
        saveProgress()
    }
    
    /// Reset all progress
    func resetAllProgress() {
        progressData = UserProgressData()
        progressData.lastOpenedDate = Date()
        saveProgress()
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
