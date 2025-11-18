//
//  ColorTheme.swift
//  phonics-flashcards
//
//  Created by Claude on 18/11/2025.
//

import SwiftUI

/// Vibrant saturated color theme for phonics groups
struct ColorTheme {
    /// Get a vibrant saturated color for a group
    static func colorForGroup(_ groupName: String) -> Color {
        let colors: [String: Color] = [
            "Short Vowels": .vibrantPink,
            "Consonant Blends": .vibrantLavender,
            "Digraphs": .vibrantMint,
            "Diphthongs": .vibrantPeach,
            "Ending Blends": .vibrantSkyBlue,
            "Hard & Soft C/G": .vibrantLemon,
            "R-Controlled": .vibrantCoral,
            "Trigraphs": .vibrantSage,
            "Vowel Teams": .vibrantLilac
        ]

        return colors[groupName] ?? .vibrantBlue
    }
}

/// Vibrant saturated color extensions
extension Color {
    static let vibrantPink = Color(red: 1.0, green: 0.2, blue: 0.5)
    static let vibrantLavender = Color(red: 0.7, green: 0.3, blue: 0.95)
    static let vibrantMint = Color(red: 0.2, green: 0.9, blue: 0.6)
    static let vibrantPeach = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let vibrantSkyBlue = Color(red: 0.2, green: 0.65, blue: 1.0)
    static let vibrantLemon = Color(red: 1.0, green: 0.9, blue: 0.0)
    static let vibrantCoral = Color(red: 1.0, green: 0.35, blue: 0.3)
    static let vibrantSage = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let vibrantLilac = Color(red: 0.75, green: 0.25, blue: 0.85)
    static let vibrantBlue = Color(red: 0.3, green: 0.5, blue: 1.0)
}
