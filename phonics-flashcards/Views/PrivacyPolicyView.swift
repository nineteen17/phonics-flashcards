//
//  PrivacyPolicyView.swift
//  phonics-flashcards
//
//  Created by Claude on 18/11/2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Text("Last Updated: November 18, 2025")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Divider()

                    // Introduction
                    PolicySection(
                        title: "Introduction",
                        content: "Phonics Flashcards (\"we\", \"our\", or \"the app\") is committed to protecting your privacy. This privacy policy explains how we handle your information when you use our app."
                    )

                    // Data Collection
                    PolicySection(
                        title: "Data We Collect",
                        content: "We collect minimal data to provide you with the best learning experience:\n\n• Study Progress: Your card completion status and mastered words are stored locally on your device using iOS UserDefaults.\n\n• Study Statistics: Total study sessions, cards studied, and words mastered are tracked locally.\n\n• App Preferences: Theme settings and other preferences are stored locally on your device.\n\n• Purchase Information: In-app purchase transactions are processed and verified through Apple's StoreKit framework."
                    )

                    // Data Storage
                    PolicySection(
                        title: "How We Store Your Data",
                        content: "All your learning data is stored locally on your device using iOS UserDefaults. We do not:\n\n• Send your data to external servers\n• Share your data with third parties\n• Track your activity beyond the app\n• Collect personally identifiable information"
                    )

                    // Third-Party Services
                    PolicySection(
                        title: "Third-Party Services",
                        content: "We use Apple's StoreKit for in-app purchases. Purchase transactions are subject to Apple's Privacy Policy. We do not receive or store any payment information - all transactions are handled securely by Apple."
                    )

                    // Data Deletion
                    PolicySection(
                        title: "Your Data Rights",
                        content: "You have complete control over your data:\n\n• Reset Progress: You can delete all your learning progress through the Settings menu.\n\n• Uninstall: Deleting the app will remove all locally stored data from your device.\n\n• No Account Required: We don't require account creation, so there are no server-side profiles to manage."
                    )

                    // Children's Privacy
                    PolicySection(
                        title: "Children's Privacy",
                        content: "Phonics Flashcards is designed for educational use by children. We are committed to protecting children's privacy:\n\n• We do not collect personal information\n• We do not include third-party advertising\n• We do not include social media features\n• All data is stored locally on the device"
                    )

                    // Changes to Privacy Policy
                    PolicySection(
                        title: "Changes to This Policy",
                        content: "We may update this privacy policy from time to time. Any changes will be reflected in the \"Last Updated\" date above. Continued use of the app after changes constitutes acceptance of the updated policy."
                    )

                    // Contact
                    PolicySection(
                        title: "Contact Us",
                        content: "If you have any questions about this privacy policy, please contact us through the App Store."
                    )

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PolicySection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
