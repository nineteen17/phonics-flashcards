# Phonics Flashcards App

An offline iOS learning tool designed for parents to teach phonics interactively.

## Features

### Core Functionality
- **116 Phonics Cards** across 9 groups (Short Vowels, Long Vowels, Blends, etc.)
- **Interactive Flashcards** with tap-to-reveal functionality
- **Progress Tracking** - Track words mastered and study sessions
- **Offline First** - All content works without internet
- **No Account Required** - Everything stored locally on device

### Monetization
- **Half Free, Half Premium** - ~58 cards free, ~58 cards premium
- **One-Time Purchase** - $9.99 lifetime unlock using StoreKit
- **Restore Purchases** - Full restore functionality included

### Technical Features
- **SwiftUI** - Modern declarative UI
- **MVVM + Repository Architecture** - Clean separation of concerns
- **Local Data Storage** - UserDefaults for progress, JSON for content
- **StoreKit 2** - Modern in-app purchase implementation
- **iOS 17+** - Built for latest iOS version

## Architecture

```
phonics-flashcards-app/
├── Models/
│   ├── PhonicsCard.swift          # Data models for cards and groups
│   └── UserProgress.swift         # Progress tracking models
├── Repositories/
│   └── PhonicsRepository.swift    # Data access layer
├── Managers/
│   ├── ProgressManager.swift      # UserDefaults persistence
│   └── StoreKitManager.swift      # In-app purchase handling
├── ViewModels/
│   ├── HomeViewModel.swift        # Home screen logic
│   └── FlashcardViewModel.swift   # Flashcard session logic
├── Views/
│   ├── HomeView.swift            # Main screen
│   ├── GroupCardView.swift       # Group display component
│   ├── FlashcardView.swift       # Study session screen
│   ├── PremiumPaywallView.swift  # Purchase screen
│   └── SettingsView.swift        # Settings and stats
├── phonics.json                   # Content data (116 cards)
├── Configuration.storekit         # StoreKit testing config
└── phonics_flashcardsApp.swift   # App entry point
```

## Data Structure

### Phonics Card
```swift
{
  "group": "Short Vowels",
  "title": "at",
  "words": ["cat", "hat", "mat", "rat", "bat", ...]
}
```

### Progress Tracking
- Cards studied
- Words mastered per card
- Total study sessions
- Last study date

## StoreKit Product

**Product ID:** `com.phonicsflashcards.premiumunlock`
**Type:** Non-Consumable
**Price:** $9.99 USD

## Development Setup

1. Open `phonics-flashcards.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run (⌘R)

### Testing In-App Purchases

1. The app includes `Configuration.storekit` for local testing
2. In Xcode, go to Product > Scheme > Edit Scheme
3. Select Run > Options
4. Set StoreKit Configuration to `Configuration.storekit`
5. Use the debug "Unlock Premium (Test)" button in Settings

### Production Setup

Before releasing to App Store:

1. Configure the in-app purchase in App Store Connect:
   - Product ID: `com.phonicsflashcards.premiumunlock`
   - Type: Non-Consumable
   - Price: $9.99 USD

2. Add required capabilities in Xcode:
   - In-App Purchase capability

3. Test with sandbox testers in App Store Connect

## Usage

### For Users

1. **Browse Cards**: Tap groups to expand and see all cards
2. **Study**: Tap a card to start a study session
3. **Learn**: Tap to reveal each word
4. **Mark Progress**: Mark words as mastered with the star button
5. **Unlock Premium**: Purchase to access all 116 cards

### For Developers

#### Adding New Cards
Edit `phonics.json` and add new cards following the structure:
```json
{
  "group": "Group Name",
  "title": "Phonics Title",
  "words": ["word1", "word2", ...]
}
```

#### Changing Free/Premium Split
Edit `PhonicsRepository.swift` line ~40:
```swift
cards[index].isPremium = (index % 2 != 0) // Change logic here
```

## Testing

### Manual Testing Checklist
- [ ] App launches successfully
- [ ] All groups display correctly
- [ ] Free cards are accessible
- [ ] Premium cards show lock icon
- [ ] Flashcard view works (tap to reveal)
- [ ] Progress saves and persists
- [ ] Premium purchase flow works
- [ ] Restore purchases works
- [ ] Settings display correct stats
- [ ] Reset progress works

### Debug Features
- Unlock premium for testing (Settings > Debug)
- Reset premium status (Settings > Debug)
- Reset all progress (Settings > Data Management)

## Known Limitations

1. **No Cloud Sync** - Progress is device-local only
2. **No Audio** - Currently text-only flashcards
3. **No Custom Lists** - Users cannot create custom card sets
4. **English Only** - No internationalization yet

## Future Enhancements

- [ ] Audio pronunciation for words
- [ ] Gamification (streaks, achievements)
- [ ] Custom card sets
- [ ] iCloud sync for progress
- [ ] iPad optimization
- [ ] Additional phonics groups
- [ ] Parent dashboard with detailed analytics

## License

Copyright © 2025. All rights reserved.

## Support

For issues or questions, please contact support.
