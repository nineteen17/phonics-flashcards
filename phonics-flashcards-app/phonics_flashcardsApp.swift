//
//  phonics_flashcardsApp.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 18/11/2025.
//

import SwiftUI

@main
struct phonics_flashcardsApp: App {
    // Initialize managers
    @StateObject private var storeManager = StoreKitManager.shared
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var repository = PhonicsRepository.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeManager)
                .environmentObject(progressManager)
                .environmentObject(repository)
        }
    }
}
