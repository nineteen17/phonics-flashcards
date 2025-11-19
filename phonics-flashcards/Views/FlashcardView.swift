//
//  FlashcardView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct FlashcardView: View {
    let card: PhonicsCard
    @StateObject private var viewModel: FlashcardViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var showMasteredFeedback = false

    // Dynamic Type scaling for custom font sizes
    @ScaledMetric(relativeTo: .largeTitle) private var phonicsTitleSize: CGFloat = 80
    @ScaledMetric(relativeTo: .title) private var wordDisplaySize: CGFloat = 60
    @ScaledMetric(relativeTo: .title2) private var navigationButtonSize: CGFloat = 50

    // iPad gets larger sizes for better space utilization
    private var adaptivePhonicsSize: CGFloat {
        horizontalSizeClass == .regular ? phonicsTitleSize * 1.3 : phonicsTitleSize
    }

    private var adaptiveWordSize: CGFloat {
        horizontalSizeClass == .regular ? wordDisplaySize * 1.3 : wordDisplaySize
    }

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    private var groupColor: Color {
        ColorTheme.colorForGroup(card.group)
    }

    init(card: PhonicsCard) {
        self.card = card
        _viewModel = StateObject(wrappedValue: FlashcardViewModel(card: card))
    }

    /// Creates attributed text with phonetic part colored
    private func highlightedWord(_ word: String, phonetic: String, color: Color) -> Text {
        let lowercaseWord = word.lowercased()
        let lowercasePhonetic = phonetic.lowercased()

        // Handle patterns with underscores (e.g., "a_e" = magic e patterns)
        if lowercasePhonetic.contains("_") {
            return highlightMagicEPattern(word: word, phonetic: lowercasePhonetic, color: color)
        }

        // Check if word starts with the phonetic pattern
        if lowercaseWord.hasPrefix(lowercasePhonetic) {
            let phoneticEndIndex = word.index(word.startIndex, offsetBy: phonetic.count)
            let phoneticPart = String(word[..<phoneticEndIndex])
            let remainingPart = String(word[phoneticEndIndex...])

            return Text(phoneticPart).foregroundColor(color) + Text(remainingPart)
        } else {
            // Otherwise, try to find it anywhere in the word
            if let range = lowercaseWord.range(of: lowercasePhonetic) {
                let startIndex = word.distance(from: word.startIndex, to: range.lowerBound)
                let endIndex = startIndex + phonetic.count

                let beforePart = String(word.prefix(startIndex))
                let phoneticPart = String(word[word.index(word.startIndex, offsetBy: startIndex)..<word.index(word.startIndex, offsetBy: endIndex)])
                let afterPart = String(word.suffix(word.count - endIndex))

                return Text(beforePart) + Text(phoneticPart).foregroundColor(color) + Text(afterPart)
            }
        }

        // If phonetic pattern not found, return the word as-is
        return Text(word)
    }

    /// Highlights "magic e" patterns (e.g., a_e in "cake" highlights 'a' and 'e')
    private func highlightMagicEPattern(word: String, phonetic: String, color: Color) -> Text {
        let lowercaseWord = word.lowercased()

        // Split phonetic pattern by underscore (e.g., "a_e" -> ["a", "e"])
        let parts = phonetic.split(separator: "_").map(String.init)
        guard parts.count == 2 else { return Text(word) }

        let firstVowel = parts[0]
        let lastLetter = parts[1]

        // Find the first vowel and the final letter
        guard let firstRange = lowercaseWord.range(of: firstVowel),
              lowercaseWord.hasSuffix(lastLetter) else {
            return Text(word)
        }

        // Calculate indices
        let firstVowelStart = word.distance(from: word.startIndex, to: firstRange.lowerBound)
        let firstVowelEnd = firstVowelStart + firstVowel.count
        let lastLetterStart = word.count - lastLetter.count

        // Split word into parts
        let beforeFirst = String(word.prefix(firstVowelStart))
        let firstPart = String(word[word.index(word.startIndex, offsetBy: firstVowelStart)..<word.index(word.startIndex, offsetBy: firstVowelEnd)])
        let middle = String(word[word.index(word.startIndex, offsetBy: firstVowelEnd)..<word.index(word.startIndex, offsetBy: lastLetterStart)])
        let lastPart = String(word.suffix(lastLetter.count))

        // Return highlighted text
        return Text(beforeFirst) +
               Text(firstPart).foregroundColor(color) +
               Text(middle) +
               Text(lastPart).foregroundColor(color)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with progress
            headerView

            Spacer()

            // Main flashcard
            flashcardContent
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { gesture in
                            handleSwipe(gesture: gesture)
                        }
                )

            Spacer()

            // Word list
            wordListView
        }
        .padding()
        .navigationTitle(card.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Session Complete!", isPresented: $viewModel.sessionComplete) {
            Button("Continue") {
                dismiss()
            }
            Button("Review Again") {
                viewModel.resetSession()
            }
        } message: {
            Text("You've completed all \(viewModel.totalWords) words!\n\nMastery: \(Int(viewModel.masteryPercentage * 100))%")
        }
    }

    private func handleSwipe(gesture: DragGesture.Value) {
        let horizontalAmount = gesture.translation.width
        let verticalAmount = gesture.translation.height

        // Only respond to primarily horizontal swipes
        if abs(horizontalAmount) > abs(verticalAmount) {
            if horizontalAmount < 0 {
                // Swipe left - next word
                if viewModel.isLastWord {
                    // On last word, swiping right completes the session
                    viewModel.completeSession()
                } else {
                    viewModel.nextWord()
                }
            } else {
                // Swipe right - previous word (only if not on first word)
                if viewModel.currentWordIndex > 0 {
                    viewModel.previousWord()
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 12) {
            // Progress bar
            ProgressView(value: viewModel.progress)
                .tint(groupColor)
                .accessibilityLabel("Learning progress")
                .accessibilityValue("\(Int(viewModel.progress * 100)) percent complete")

            HStack {
                Text("Word \(viewModel.currentWordIndex + 1) of \(viewModel.totalWords)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Current word: \(viewModel.currentWordIndex + 1) of \(viewModel.totalWords)")

                Spacer()

                Text("Mastery: \(Int(viewModel.masteryPercentage * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Mastery level: \(Int(viewModel.masteryPercentage * 100)) percent")
            }
        }
    }

    private var flashcardContent: some View {
        VStack(spacing: isIPad ? 30 : 20) {
            // Phonics title (always visible)
            Text(card.title)
                .font(.system(size: adaptivePhonicsSize, weight: .bold))
                .foregroundColor(groupColor)
                .accessibilityLabel("Sound pattern: \(card.title)")

            // Word display with mastered star button
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(groupColor.opacity(0.1))
                    .frame(height: isIPad ? 280 : 200)

                VStack(spacing: 16) {
                    highlightedWord(viewModel.currentWord, phonetic: card.title, color: groupColor)
                        .font(.system(size: adaptiveWordSize, weight: .semibold))
                        .accessibilityLabel("Word: \(viewModel.currentWord)")

                    // Star button for mastering word
                    HStack(spacing: 8) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                viewModel.markCurrentWordMastered()
                                showMasteredFeedback = true
                            }
                            // Hide feedback after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showMasteredFeedback = false
                                }
                            }
                        } label: {
                            Image(systemName: viewModel.isWordMastered(viewModel.currentWord) ? "star.fill" : "star")
                                .font(.system(size: isIPad ? 44 : 36))
                                .foregroundColor(.yellow)
                                .scaleEffect(viewModel.isWordMastered(viewModel.currentWord) ? 1.0 : 0.9)
                        }
                        .accessibilityLabel(viewModel.isWordMastered(viewModel.currentWord) ? "Word mastered" : "Mark as mastered")
                        .accessibilityHint(viewModel.isWordMastered(viewModel.currentWord) ? "Already mastered" : "Double tap to mark \(viewModel.currentWord) as learned")

                        if showMasteredFeedback && viewModel.isWordMastered(viewModel.currentWord) {
                            Text("Mastered!")
                                .font(.headline)
                                .foregroundColor(groupColor)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(viewModel.isWordMastered(viewModel.currentWord) ?
                              "Word: \(viewModel.currentWord). Mastered" :
                              "Word: \(viewModel.currentWord). Not yet mastered")
        }
    }


    private var wordListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All Words")
                .font(.caption)
                .foregroundColor(.secondary)
                .accessibilityLabel("Word list")

            if isIPad {
                // iPad: Evenly distributed grid layout
                wordGridView
            } else {
                // iPhone: Horizontal scrolling layout
                wordScrollView
            }
        }
        .padding(.top)
    }

    private var wordGridView: some View {
        let columns = [
            GridItem(.adaptive(minimum: 80, maximum: 120), spacing: 12)
        ]

        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Array(card.words.enumerated()), id: \.offset) { index, word in
                wordButton(index: index, word: word)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Word grid")
    }

    private var wordScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(card.words.enumerated()), id: \.offset) { index, word in
                        wordButton(index: index, word: word)
                            .id(index) // Add ID for ScrollViewReader
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Horizontal word list")
            .onChange(of: viewModel.currentWordIndex) { _, newIndex in
                withAnimation {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }

    private func wordButton(index: Int, word: String) -> some View {
        Button {
            viewModel.jumpToWord(at: index)
        } label: {
            HStack(spacing: 4) {
                // Use colored highlighting for words, but adjust color based on selection
                if index == viewModel.currentWordIndex {
                    // When selected, show in white on colored background
                    Text(word)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    // When not selected, show with phonetic highlighting
                    highlightedWord(word, phonetic: card.title, color: groupColor)
                        .font(.caption)
                }

                if viewModel.isWordMastered(word) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                index == viewModel.currentWordIndex ?
                groupColor : Color.gray.opacity(0.2)
            )
            .cornerRadius(8)
        }
        .accessibilityLabel("\(word)\(viewModel.isWordMastered(word) ? ", mastered" : "")")
        .accessibilityHint(index == viewModel.currentWordIndex ? "Currently selected" : "Double tap to jump to this word")
    }
}

#Preview {
    NavigationStack {
        FlashcardView(
            card: PhonicsCard(
                group: "Short Vowels",
                title: "at",
                words: ["cat", "hat", "mat", "rat", "bat"],
                isPremium: false
            )
        )
    }
}
