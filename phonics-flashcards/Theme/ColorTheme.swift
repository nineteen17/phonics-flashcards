//
//  ColorTheme.swift
//  phonics-flashcards
//
//  Created by Claude on 18/11/2025.
//

import SwiftUI

/// Soft pastel color theme for phonics groups
struct ColorTheme {
    /// Get a soft pastel color for a group
    static func colorForGroup(_ groupName: String) -> Color {
        let colors: [String: Color] = [
            "Short Vowels": .pastelPink,
            "Consonant Blends": .pastelLavender,
            "Digraphs": .pastelMint,
            "Diphthongs": .pastelPeach,
            "Ending Blends": .pastelSkyBlue,
            "Hard & Soft C/G": .pastelLemon,
            "R-Controlled": .pastelCoral,
            "Trigraphs": .pastelSage,
            "Vowel Teams": .pastelLilac
        ]

        return colors[groupName] ?? .pastelBlue
    }
}

/// Soft pastel color extensions
extension Color {
    static let pastelPink = Color(red: 1.0, green: 0.82, blue: 0.86)
    static let pastelLavender = Color(red: 0.90, green: 0.82, blue: 1.0)
    static let pastelMint = Color(red: 0.74, green: 0.98, blue: 0.85)
    static let pastelPeach = Color(red: 1.0, green: 0.85, blue: 0.73)
    static let pastelSkyBlue = Color(red: 0.68, green: 0.85, blue: 0.90)
    static let pastelLemon = Color(red: 1.0, green: 0.98, blue: 0.70)
    static let pastelCoral = Color(red: 1.0, green: 0.79, blue: 0.76)
    static let pastelSage = Color(red: 0.77, green: 0.87, blue: 0.74)
    static let pastelLilac = Color(red: 0.78, green: 0.64, blue: 0.78)
    static let pastelBlue = Color(red: 0.68, green: 0.78, blue: 0.91)
}
