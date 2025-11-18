//
//  GroupCardView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct GroupCardView: View {
    let group: PhonicsGroup
    @ObservedObject var viewModel: HomeViewModel
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Group Header
            Button {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(group.name)
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack {
                            Text("\(group.totalCards) cards")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            if group.premiumCards > 0 && !viewModel.isPremiumUnlocked {
                                Text("• \(group.freeCards) free")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }

                    Spacer()

                    // Progress indicator
                    CircularProgressView(
                        progress: viewModel.getGroupProgressPercentage(for: group),
                        color: group.color
                    )

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Cards List
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(group.cards) { card in
                        NavigationLink {
                            if viewModel.canAccessCard(card) {
                                FlashcardView(card: card)
                            } else {
                                PremiumPaywallView()
                            }
                        } label: {
                            CardRowView(
                                card: card,
                                progress: viewModel.getProgressPercentage(for: card),
                                isLocked: !viewModel.canAccessCard(card)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(group.color.opacity(0.15))
        .cornerRadius(12)
    }
}

struct CardRowView: View {
    let card: PhonicsCard
    let progress: Double
    let isLocked: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text("\(card.words.count) words")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isLocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.orange)
            } else if progress > 0 {
                CircularProgressView(
                    progress: progress,
                    color: ColorTheme.colorForGroup(card.group),
                    size: 30
                )
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(8)
        .opacity(isLocked ? 0.6 : 1.0)
    }
}

struct CircularProgressView: View {
    let progress: Double
    var color: Color = .blue
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 3)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            if progress > 0 {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size * 0.3))
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    let sampleGroup = PhonicsGroup(
        name: "Short Vowels",
        cards: [
            PhonicsCard(group: "Short Vowels", title: "at", words: ["cat", "hat", "mat"], isPremium: false),
            PhonicsCard(group: "Short Vowels", title: "an", words: ["can", "man", "pan"], isPremium: true)
        ]
    )

    GroupCardView(group: sampleGroup, viewModel: HomeViewModel())
        .padding()
}
