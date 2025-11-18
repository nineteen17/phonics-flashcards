//
//  HomeView.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var storeManager = StoreKitManager.shared
    @StateObject private var repository = PhonicsRepository.shared
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
        }
    }

    private var statsHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                StatBadge(
                    title: "Sessions",
                    value: "\(viewModel.totalStudySessions)",
                    icon: "book.fill",
                    color: .pastelLavender
                )
                StatBadge(
                    title: "Words Mastered",
                    value: "\(viewModel.totalWordsMastered)",
                    icon: "star.fill",
                    color: .pastelPeach
                )
            }
        }
        .padding()
        .background(Color.pastelMint.opacity(0.2))
        .cornerRadius(12)
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
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .blue

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
