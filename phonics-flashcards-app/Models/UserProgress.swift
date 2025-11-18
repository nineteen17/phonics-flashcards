//
//  UserProgress.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation

/// Tracks user progress for a specific phonics card
struct CardProgress: Codable {
    let cardId: String // Using title as ID for persistence
    var lastStudiedDate: Date?
    var timesStudied: Int
    var masteredWords: Set<String>

    init(cardId: String, lastStudiedDate: Date? = nil, timesStudied: Int = 0, masteredWords: Set<String> = []) {
        self.cardId = cardId
        self.lastStudiedDate = lastStudiedDate
        self.timesStudied = timesStudied
        self.masteredWords = masteredWords
    }
}

/// Overall user progress and statistics
struct UserProgressData: Codable {
    var cardProgress: [String: CardProgress] // Key: card title
    var totalStudySessions: Int
    var lastOpenedDate: Date?

    init(cardProgress: [String: CardProgress] = [:], totalStudySessions: Int = 0, lastOpenedDate: Date? = nil) {
        self.cardProgress = cardProgress
        self.totalStudySessions = totalStudySessions
        self.lastOpenedDate = lastOpenedDate
    }

    mutating func updateProgress(for cardTitle: String, masteredWord: String? = nil) {
        var progress = cardProgress[cardTitle] ?? CardProgress(cardId: cardTitle)
        progress.timesStudied += 1
        progress.lastStudiedDate = Date()
        if let word = masteredWord {
            progress.masteredWords.insert(word)
        }
        cardProgress[cardTitle] = progress
    }

    func getProgress(for cardTitle: String) -> CardProgress? {
        return cardProgress[cardTitle]
    }

    func getMasteryPercentage(for card: PhonicsCard) -> Double {
        guard let progress = cardProgress[card.title], !card.words.isEmpty else {
            return 0.0
        }
        return Double(progress.masteredWords.count) / Double(card.words.count)
    }
}
