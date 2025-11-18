//
//  FlashcardViewModel.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation
import SwiftUI

/// ViewModel for flashcard study session
@MainActor
class FlashcardViewModel: ObservableObject {
    @Published var currentWordIndex = 0
    @Published var masteredWords: Set<String> = []
    @Published var sessionComplete = false

    let card: PhonicsCard
    private let progressManager = ProgressManager.shared

    var currentWord: String {
        guard currentWordIndex < card.words.count else {
            return ""
        }
        return card.words[currentWordIndex]
    }

    var progress: Double {
        guard !card.words.isEmpty else { return 0 }
        return Double(currentWordIndex) / Double(card.words.count)
    }

    var isLastWord: Bool {
        currentWordIndex == card.words.count - 1
    }

    var totalWords: Int {
        card.words.count
    }

    init(card: PhonicsCard) {
        self.card = card

        // Load previously mastered words
        if let cardProgress = progressManager.getProgress(for: card.title) {
            self.masteredWords = cardProgress.masteredWords
        }

        // Defer recording study session to prevent publishing during view construction
        Task { @MainActor in
            progressManager.recordStudySession(for: card.title)
        }
    }

    /// Mark current word as mastered
    func markCurrentWordMastered() {
        masteredWords.insert(currentWord)
        progressManager.markWordMastered(cardTitle: card.title, word: currentWord)
    }

    /// Move to next word
    func nextWord() {
        if currentWordIndex < card.words.count - 1 {
            withAnimation {
                currentWordIndex += 1
            }
        } else {
            sessionComplete = true
        }
    }

    /// Move to previous word
    func previousWord() {
        if currentWordIndex > 0 {
            withAnimation {
                currentWordIndex -= 1
            }
        }
    }

    /// Jump to specific word
    func jumpToWord(at index: Int) {
        guard index >= 0 && index < card.words.count else { return }
        withAnimation {
            currentWordIndex = index
        }
    }

    /// Check if a word is mastered
    func isWordMastered(_ word: String) -> Bool {
        return masteredWords.contains(word)
    }

    /// Get mastery percentage
    var masteryPercentage: Double {
        guard !card.words.isEmpty else { return 0 }
        return Double(masteredWords.count) / Double(card.words.count)
    }

    /// Reset session
    func resetSession() {
        currentWordIndex = 0
        sessionComplete = false
    }
}
