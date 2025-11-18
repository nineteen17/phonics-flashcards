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

    var body: some View {
        VStack(spacing: 0) {
            // Header with progress
            headerView

            Spacer()

            // Main flashcard
            flashcardContent

            Spacer()

            // Navigation controls
            controlsView

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

    private var headerView: some View {
        VStack(spacing: 12) {
            // Progress bar
            ProgressView(value: viewModel.progress)
                .tint(groupColor)

            HStack {
                Text("Word \(viewModel.currentWordIndex + 1) of \(viewModel.totalWords)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("Mastery: \(Int(viewModel.masteryPercentage * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var flashcardContent: some View {
        VStack(spacing: 20) {
            // Phonics title (always visible)
            Text(card.title)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(groupColor)

            // Word display
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(groupColor.opacity(0.1))
                    .frame(height: 200)

                VStack(spacing: 12) {
                    highlightedWord(viewModel.currentWord, phonetic: card.title, color: groupColor)
                        .font(.system(size: 60, weight: .semibold))

                    if viewModel.isWordMastered(viewModel.currentWord) {
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                }
            }

            // Mark as mastered button
            if !viewModel.isWordMastered(viewModel.currentWord) {
                Button {
                    withAnimation {
                        viewModel.markCurrentWordMastered()
                    }
                } label: {
                    Label("Mark as Mastered", systemImage: "star.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
            }
        }
    }

    private var controlsView: some View {
        HStack(spacing: 40) {
            Button {
                viewModel.previousWord()
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(groupColor)
            }
            .disabled(viewModel.currentWordIndex == 0)
            .opacity(viewModel.currentWordIndex == 0 ? 0.3 : 1.0)

            Button {
                viewModel.nextWord()
            } label: {
                Image(systemName: viewModel.isLastWord ? "checkmark.circle.fill" : "chevron.right.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(groupColor)
            }
        }
        .padding(.vertical)
    }

    private var wordListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All Words")
                .font(.caption)
                .foregroundColor(.secondary)

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(card.words.enumerated()), id: \.offset) { index, word in
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
                            .id(index) // Add ID for ScrollViewReader
                        }
                    }
                }
                .onChange(of: viewModel.currentWordIndex) { _, newIndex in
                    withAnimation {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
        .padding(.top)
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
