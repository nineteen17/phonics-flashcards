//
//  HomeView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var storeManager = StoreKitManager.shared
    @ObservedObject private var repository = PhonicsRepository.shared
    @ObservedObject private var progressManager = ProgressManager.shared
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Header
                    statsHeader

                    // Premium Status Banner
                    if !storeManager.isPremiumUnlocked {
                        premiumBanner
                    }

                    // Groups List
                    ForEach(viewModel.groups) { group in
                        GroupCardView(
                            group: group,
                            viewModel: viewModel
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Phonics Flashcards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                    .accessibilityLabel("Settings")
                    .accessibilityHint("Open settings menu")
                }
            }
            .sheet(isPresented: $viewModel.showPremiumPaywall) {
                PremiumPaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .alert("Error Loading Data", isPresented: $repository.showErrorAlert) {
                Button("Retry") {
                    repository.loadPhonicsData()
                }
                Button("OK", role: .cancel) { }
            } message: {
                if let error = repository.error {
                    Text("\(error.localizedDescription)\n\n\(error.recoverySuggestion ?? "")")
                }
            }
            .task {
                // Load data after view is ready to prevent publishing warnings
                viewModel.loadData()
            }
        }
    }

    private var statsHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            profileSummary

            HStack(spacing: 20) {
                StatBadge(
                    title: "Sessions",
                    value: "\(viewModel.totalStudySessions)",
                    icon: "book.fill",
                    color: .vibrantLavender
                )
                StatBadge(
                    title: "Words Mastered",
                    value: "\(viewModel.totalWordsMastered)",
                    icon: "star.fill",
                    color: .vibrantPeach
                )
            }
        }
        .padding()
        .background(Color.vibrantMint.opacity(0.2))
        .cornerRadius(12)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Statistics overview")
    }

    private var profileSummary: some View {
        HStack {
            HStack(spacing: 10) {
                Circle()
                    .fill(progressManager.activeProfileColor.color)
                    .frame(width: 26, height: 26)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.caption2)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(progressManager.activeProfileDisplayName)
                        .font(.headline)
                    Text("Active Profile")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(progressManager.profiles.count)/5 profiles")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .accessibilityLabel("Active profile: \(progressManager.activeProfileDisplayName). \(progressManager.profiles.count) out of 5 profiles in use")
    }

    private var premiumBanner: some View {
        Button {
            viewModel.showPremiumPaywall = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock All Cards")
                        .font(.headline)
                    Text("Get access to all \(PhonicsRepository.shared.premiumCardsCount) premium cards")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "lock.fill")
                    .foregroundColor(.orange)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("Unlock all cards")
        .accessibilityHint("Double tap to view premium upgrade options. Get access to all \(PhonicsRepository.shared.premiumCardsCount) premium cards")
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .blue
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

#Preview {
    HomeView()
}
