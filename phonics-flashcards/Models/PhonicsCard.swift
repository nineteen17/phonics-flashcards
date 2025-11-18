//
//  PhonicsCard.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import Foundation
import SwiftUI

/// Represents a single phonics flashcard with a group, title, and word list
struct PhonicsCard: Codable, Identifiable, Hashable {
    let id: UUID
    let group: String
    let title: String
    let words: [String]
    var isPremium: Bool

    enum CodingKeys: String, CodingKey {
        case group, title, words
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.group = try container.decode(String.self, forKey: .group)
        self.title = try container.decode(String.self, forKey: .title)
        self.words = try container.decode([String].self, forKey: .words)
        self.id = UUID()
        self.isPremium = false // Will be set by repository
    }

    init(id: UUID = UUID(), group: String, title: String, words: [String], isPremium: Bool = false) {
        self.id = id
        self.group = group
        self.title = title
        self.words = words
        self.isPremium = isPremium
    }
}

/// Represents a group of phonics cards
struct PhonicsGroup: Identifiable, Hashable {
    let id: UUID
    let name: String
    var cards: [PhonicsCard]

    init(id: UUID = UUID(), name: String, cards: [PhonicsCard]) {
        self.id = id
        self.name = name
        self.cards = cards
    }

    var totalCards: Int {
        cards.count
    }

    var premiumCards: Int {
        cards.filter { $0.isPremium }.count
    }

    var freeCards: Int {
        cards.filter { !$0.isPremium }.count
    }

    /// Soft pastel color for this group
    var color: Color {
        ColorTheme.colorForGroup(name)
    }
}
