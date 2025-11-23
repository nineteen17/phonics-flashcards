//
//  ChildProfile.swift
//  phonics-flashcards
//
//  Created by ChatGPT on 22/11/2025.
//

import SwiftUI

/// Accent colors a child can choose from when creating a profile.
enum ProfileColor: String, CaseIterable, Codable, Identifiable {
    case coral
    case mint
    case sky
    case lilac
    case gold
    case navy

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .coral:
            return .vibrantCoral
        case .mint:
            return .vibrantMint
        case .sky:
            return .vibrantSkyBlue
        case .lilac:
            return .vibrantLilac
        case .gold:
            return .vibrantLemon
        case .navy:
            return .vibrantBlue
        }
    }

    var label: String {
        switch self {
        case .coral: return "Coral"
        case .mint: return "Mint"
        case .sky: return "Sky"
        case .lilac: return "Lilac"
        case .gold: return "Gold"
        case .navy: return "Blue"
        }
    }
}

/// Represents a single child profile.
struct ChildProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var color: ProfileColor

    init(id: UUID = UUID(), name: String, color: ProfileColor) {
        self.id = id
        self.name = name
        self.color = color
    }

    var displayName: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Learner" : trimmed
    }
}

/// Binds a profile to its saved progress.
struct ProfileProgressRecord: Identifiable, Codable {
    var profile: ChildProfile
    var progress: UserProgressData

    var id: UUID {
        profile.id
    }
}
