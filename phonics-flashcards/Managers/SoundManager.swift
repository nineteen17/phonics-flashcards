//
//  SoundManager.swift
//  phonics-flashcards
//
//  Created by Nick Ririnui on 19/11/2025.
//

import AVFoundation
import Foundation

/// Manages sound effects throughout the app
class SoundManager {
    static let shared = SoundManager()

    private var swooshPlayer: AVAudioPlayer?
    private var sparklePlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
        loadSounds()
    }

    /// Configure audio session to respect silent mode
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Failed to setup audio session: \(error)")
        }
    }

    /// Pre-load sound files for instant playback
    private func loadSounds() {
        // Load swoosh sound
        if let swooshURL = Bundle.main.url(forResource: "simple-whoosh-382724", withExtension: "mp3") {
            do {
                swooshPlayer = try AVAudioPlayer(contentsOf: swooshURL)
                swooshPlayer?.volume = 0.7 // Set to 70% volume
                swooshPlayer?.prepareToPlay()
            } catch {
                print("⚠️ Failed to load swoosh sound: \(error)")
            }
        }

        // Load sparkle sound
        if let sparkleURL = Bundle.main.url(forResource: "cartoon_wink_magic_sparkle-6896", withExtension: "mp3") {
            do {
                sparklePlayer = try AVAudioPlayer(contentsOf: sparkleURL)
                sparklePlayer?.prepareToPlay()
            } catch {
                print("⚠️ Failed to load sparkle sound: \(error)")
            }
        }
    }

    /// Play swoosh sound (for swipe gestures)
    func playSwoosh() {
        swooshPlayer?.currentTime = 0 // Reset to start
        swooshPlayer?.play()
    }

    /// Play sparkle sound (for mastering words)
    func playSparkle() {
        sparklePlayer?.currentTime = 0 // Reset to start
        sparklePlayer?.play()
    }
}
