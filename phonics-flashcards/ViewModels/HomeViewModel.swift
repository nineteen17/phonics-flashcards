//
//  HomeViewModel.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation
import SwiftUI

/// ViewModel for the home screen
@MainActor
class HomeViewModel: ObservableObject {
    @Published var groups: [PhonicsGroup] = []
    @Published var isLoading = false
    @Published var showPremiumPaywall = false
    @Published var selectedGroup: PhonicsGroup?

    private let repository = PhonicsRepository.shared
    private let storeManager = StoreKitManager.shared
    private let progressManager = ProgressManager.shared

    init() {
        // Don't call loadData() here - deferred to .task modifier in HomeView
        // This prevents "Publishing changes from within view updates" warning
    }

    func loadData() {
        isLoading = true

        // Observe repository changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.groups = self.repository.groups
            self.isLoading = false
        }
    }

    /// Get filtered cards for a group based on premium status
    func getAccessibleCards(for group: PhonicsGroup) -> [PhonicsCard] {
        if storeManager.isPremiumUnlocked {
            return group.cards
        } else {
            return group.cards.filter { !$0.isPremium }
        }
    }

    /// Check if user can access a card
    func canAccessCard(_ card: PhonicsCard) -> Bool {
        return !card.isPremium || storeManager.isPremiumUnlocked
    }

    /// Get progress percentage for a card
    func getProgressPercentage(for card: PhonicsCard) -> Double {
        return progressManager.getMasteryPercentage(for: card)
    }

    /// Get progress percentage for a group
    /// Calculates progress against ALL cards in the group (free + premium combined)
    /// but only counts progress for accessible cards
    func getGroupProgressPercentage(for group: PhonicsGroup) -> Double {
        let accessibleCards = getAccessibleCards(for: group)
        guard !group.cards.isEmpty else { return 0 }

        // Sum up progress for only accessible cards
        let totalProgress = accessibleCards.reduce(0.0) { sum, card in
            sum + progressManager.getMasteryPercentage(for: card)
        }
        // Progress is calculated as a percentage of ALL cards (free + premium)
        // This ensures free users see realistic progress (e.g., 1/10 = 10%, not 1/5 = 20%)
        return totalProgress / Double(group.cards.count)
    }

    /// Total study sessions
    var totalStudySessions: Int {
        progressManager.totalStudySessions
    }

    /// Total words mastered
    var totalWordsMastered: Int {
        progressManager.totalWordsMastered
    }

    /// Is premium unlocked
    var isPremiumUnlocked: Bool {
        storeManager.isPremiumUnlocked
    }

    /// Show paywall if trying to access premium content
    func handleCardTap(_ card: PhonicsCard) {
        if !canAccessCard(card) {
            showPremiumPaywall = true
        }
    }
}
