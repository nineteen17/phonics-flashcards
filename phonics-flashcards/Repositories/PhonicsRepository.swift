//
//  PhonicsRepository.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation

/// Custom errors for phonics repository
enum PhonicsRepositoryError: LocalizedError {
    case fileNotFound
    case invalidData
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Unable to find phonics data file. Please reinstall the app."
        case .invalidData:
            return "The phonics data is corrupted. Please reinstall the app."
        case .decodingFailed(let error):
            return "Failed to load phonics data: \(error.localizedDescription)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .fileNotFound, .invalidData:
            return "Try reinstalling the app from the App Store."
        case .decodingFailed:
            return "Please contact support if this problem persists."
        }
    }
}

/// Repository for managing phonics data
class PhonicsRepository: ObservableObject {
    static let shared = PhonicsRepository()

    @Published private(set) var allCards: [PhonicsCard] = []
    @Published private(set) var groups: [PhonicsGroup] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: PhonicsRepositoryError?
    @Published var showErrorAlert = false

    private init() {
        loadPhonicsData()
    }

    /// Load phonics data from bundled JSON file
    func loadPhonicsData() {
        isLoading = true
        error = nil
        showErrorAlert = false

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                // Load JSON file from bundle
                guard let url = Bundle.main.url(forResource: "phonics", withExtension: "json") else {
                    throw PhonicsRepositoryError.fileNotFound
                }

                guard let data = try? Data(contentsOf: url), !data.isEmpty else {
                    throw PhonicsRepositoryError.invalidData
                }

                var cards: [PhonicsCard]
                do {
                    cards = try JSONDecoder().decode([PhonicsCard].self, from: data)
                } catch {
                    throw PhonicsRepositoryError.decodingFailed(error)
                }

                // Validate we have cards
                guard !cards.isEmpty else {
                    throw PhonicsRepositoryError.invalidData
                }

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
            } catch let repositoryError as PhonicsRepositoryError {
                DispatchQueue.main.async {
                    self.error = repositoryError
                    self.showErrorAlert = true
                    self.isLoading = false
                    print("❌ PhonicsRepository Error: \(repositoryError.localizedDescription)")
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = .decodingFailed(error)
                    self.showErrorAlert = true
                    self.isLoading = false
                    print("❌ PhonicsRepository Error: \(error)")
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
