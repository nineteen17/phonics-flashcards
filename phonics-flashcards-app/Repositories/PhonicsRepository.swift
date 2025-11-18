//
//  PhonicsRepository.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation

/// Repository for managing phonics data
class PhonicsRepository: ObservableObject {
    static let shared = PhonicsRepository()

    @Published private(set) var allCards: [PhonicsCard] = []
    @Published private(set) var groups: [PhonicsGroup] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private init() {
        loadPhonicsData()
    }

    /// Load phonics data from bundled JSON file
    func loadPhonicsData() {
        isLoading = true
        error = nil

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                // Load JSON file from bundle
                guard let url = Bundle.main.url(forResource: "phonics", withExtension: "json") else {
                    throw NSError(domain: "PhonicsRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "phonics.json file not found in bundle"])
                }

                let data = try Data(contentsOf: url)
                var cards = try JSONDecoder().decode([PhonicsCard].self, from: data)

                // Mark approximately half as premium (cards at even indices are free)
                for index in cards.indices {
                    cards[index].isPremium = (index % 2 != 0)
                }

                // Group cards by their group property
                let groupedDict = Dictionary(grouping: cards, by: { $0.group })
                let groups = groupedDict.map { (key, value) in
                    PhonicsGroup(name: key, cards: value)
                }.sorted { $0.name < $1.name }

                DispatchQueue.main.async {
                    self.allCards = cards
                    self.groups = groups
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                    print("Error loading phonics data: \(error)")
                }
            }
        }
    }

    /// Get all cards for a specific group
    func getCards(for groupName: String) -> [PhonicsCard] {
        return allCards.filter { $0.group == groupName }
    }

    /// Get a specific card by title
    func getCard(byTitle title: String) -> PhonicsCard? {
        return allCards.first { $0.title == title }
    }

    /// Get all free cards
    func getFreeCards() -> [PhonicsCard] {
        return allCards.filter { !$0.isPremium }
    }

    /// Get all premium cards
    func getPremiumCards() -> [PhonicsCard] {
        return allCards.filter { $0.isPremium }
    }

    /// Total number of cards
    var totalCards: Int {
        return allCards.count
    }

    /// Number of free cards
    var freeCardsCount: Int {
        return allCards.filter { !$0.isPremium }.count
    }

    /// Number of premium cards
    var premiumCardsCount: Int {
        return allCards.filter { $0.isPremium }.count
    }
}
