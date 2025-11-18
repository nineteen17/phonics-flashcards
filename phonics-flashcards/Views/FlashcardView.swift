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

    init(card: PhonicsCard) {
        self.card = card
        _viewModel = StateObject(wrappedValue: FlashcardViewModel(card: card))
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
                .tint(.blue)

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
                .foregroundColor(.blue)

            // Tap to reveal word
            Button {
                viewModel.toggleWordVisibility()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 200)

                    if viewModel.showingWord {
                        VStack(spacing: 12) {
                            Text(viewModel.currentWord)
                                .font(.system(size: 60, weight: .semibold))
                                .foregroundColor(.primary)

                            if viewModel.isWordMastered(viewModel.currentWord) {
                                Image(systemName: "star.fill")
                                    .font(.title)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Text("Tap to reveal")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Mark as mastered button
            if viewModel.showingWord && !viewModel.isWordMastered(viewModel.currentWord) {
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
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(), value: viewModel.showingWord)
    }

    private var controlsView: some View {
        HStack(spacing: 40) {
            Button {
                viewModel.previousWord()
            } label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
            }
            .disabled(viewModel.currentWordIndex == 0)
            .opacity(viewModel.currentWordIndex == 0 ? 0.3 : 1.0)

            Button {
                viewModel.nextWord()
            } label: {
                Image(systemName: viewModel.isLastWord ? "checkmark.circle.fill" : "chevron.right.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical)
    }

    private var wordListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All Words")
                .font(.caption)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(card.words.enumerated()), id: \.offset) { index, word in
                        Button {
                            viewModel.jumpToWord(at: index)
                        } label: {
                            HStack(spacing: 4) {
                                Text(word)
                                    .font(.caption)
                                    .fontWeight(index == viewModel.currentWordIndex ? .bold : .regular)

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
                                Color.blue : Color.gray.opacity(0.2)
                            )
                            .foregroundColor(
                                index == viewModel.currentWordIndex ? .white : .primary
                            )
                            .cornerRadius(8)
                        }
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
