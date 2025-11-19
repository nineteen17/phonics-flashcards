# Testing Checklist - App Store Readiness

## Critical Purchase Flow Testing (Phase 1 & 2 Fixes)

### ✅ Premium Purchase Flow
- [ ] **Fresh install purchase**
  - Install app on clean device/simulator
  - Navigate to premium paywall
  - Verify price displays correctly (not "Loading..." or "Price unavailable")
  - Complete purchase successfully
  - Verify premium unlocks immediately
  - Verify locked cards become accessible
  - Close and reopen app - verify premium still unlocked

- [ ] **Purchase with network issues**
  - Start purchase process
  - Enable airplane mode during purchase
  - Verify appropriate error message displays
  - Disable airplane mode
  - Retry purchase - should succeed
  - Verify retry logic works (3 attempts with delays)

- [ ] **Purchase verification failure recovery**
  - Complete purchase
  - Force quit app during transaction processing
  - Reopen app
  - Verify premium unlocks automatically (transaction listener recovery)

### ✅ Restore Purchases Flow
- [ ] **Successful restore**
  - Purchase premium on Device A
  - Install app on Device B (same Apple ID)
  - Tap "Restore Purchases"
  - Verify premium unlocks
  - Verify success feedback shown

- [ ] **Restore with no previous purchases**
  - Fresh Apple ID (no purchases)
  - Tap "Restore Purchases"
  - Verify error shows: "No previous purchases found"
  - Verify recovery suggestion displayed
  - NOT a silent failure ✅

- [ ] **Restore with network error**
  - Enable airplane mode
  - Tap "Restore Purchases"
  - Verify error shows: "App Store connection issue"
  - Verify helpful recovery message
  - Disable airplane mode and retry

### ✅ Transaction Listener
- [ ] **Background transaction processing**
  - Start purchase on Device A
  - Kill app before transaction completes
  - Reopen app
  - Verify transaction processes automatically
  - Verify premium unlocks without user action

## Data Integrity Testing (Phase 1 Fixes)

### ✅ Progress Data Persistence
- [ ] **Normal save/load**
  - Study several cards, mark words as mastered
  - Note mastery percentages
  - Force quit app
  - Reopen app
  - Verify all progress preserved correctly

- [ ] **Corrupted data recovery**
  - Study cards and build progress
  - (Manual test: corrupt UserDefaults data)
  - Reopen app
  - Verify backup recovery works
  - Verify no data loss

- [ ] **Multiple rapid saves**
  - Rapidly mark many words as mastered
  - Verify no race conditions
  - Verify all progress saves correctly
  - No duplicate saves ✅

### ✅ Singleton State Consistency
- [ ] **Premium status across views**
  - Purchase premium
  - Navigate to Settings - verify checkmark shows
  - Navigate to Home - verify locked cards unlocked
  - Navigate back to Settings - still shows premium
  - Navigate to Premium Paywall - should auto-dismiss or show already owned

- [ ] **Progress across views**
  - Study flashcards, mark words mastered
  - Return to home
  - Verify progress badges updated
  - Open Settings
  - Verify statistics updated
  - All views show consistent data ✅

## User Experience Testing (Phase 2 Fixes)

### ✅ Error Messages
- [ ] **Phonics data loading errors**
  - (Manual test: corrupt phonics.json)
  - Launch app
  - Verify user-friendly error: "We're having trouble loading the flashcards"
  - Verify NO technical jargon shown
  - Verify recovery suggestion helpful
  - Appropriate for children/parents ✅

- [ ] **Purchase errors**
  - Attempt purchase with no payment method
  - Verify error message is clear
  - Verify recovery suggestion provided
  - User can understand what to do next

### ✅ Product Loading
- [ ] **Initial load success**
  - Fresh install
  - Open premium paywall
  - Verify actual price loads (e.g., "$4.99")
  - Verify "Loading..." transitions to real price

- [ ] **Network failure retry**
  - Enable airplane mode
  - Launch app
  - Navigate to premium paywall
  - Verify "Price unavailable" shown
  - Disable airplane mode
  - Wait or pull-to-refresh
  - Verify price loads successfully after retry

### ✅ Swipe Gesture Navigation (CRITICAL)
- [ ] **Swipe left to next word**
  - Open any flashcard
  - Swipe left on the card area
  - Verify navigates to next word
  - Verify animation is smooth
  - Try multiple swipes in succession
  - Verify no lag or dropped gestures

- [ ] **Swipe right to previous word**
  - Navigate to second or later word
  - Swipe right on the card area
  - Verify navigates to previous word
  - Verify smooth animation
  - On first word, swipe right does nothing ✅

- [ ] **Swipe to complete session**
  - Navigate to last word in flashcard
  - Swipe left (as if going to next)
  - Verify "Session Complete!" popup appears ✅
  - Verify popup shows total words and mastery percentage
  - This is CRITICAL - users must know to swipe left on last word

- [ ] **Swipe gesture boundaries**
  - Verify vertical swipes don't trigger navigation
  - Verify diagonal swipes only respond to horizontal component
  - Verify minimum swipe distance required (not accidental touches)
  - Verify gestures work on iPad and iPhone

- [ ] **Swipe vs tap interaction**
  - Verify can still tap star button while swiping works
  - Verify can still tap words in bottom list
  - Verify gestures don't interfere with scrolling word list
  - No conflicts between gesture recognizers ✅

### ✅ Mastered Button Feature
- [ ] **Star button interaction**
  - Open any flashcard
  - Navigate to an unmastered word
  - Verify empty star icon displays below word
  - Tap the star icon
  - Verify star fills with animation (spring effect)
  - Verify "Mastered!" text appears briefly next to star
  - Verify "Mastered!" text fades after ~1.5 seconds
  - Navigate to different word and back
  - Verify star remains filled

- [ ] **Star button states**
  - On unmastered word: star is empty (outline only)
  - On mastered word: star is filled (solid yellow)
  - Verify tapping filled star does nothing (already mastered)
  - Verify accessibility label changes based on state

## iPad Layout Optimization

### ✅ iPad-Specific Layout
- [ ] **Word list grid on iPad**
  - Open flashcard on iPad (or iPad simulator)
  - Scroll to "All Words" section at bottom
  - Verify words display in evenly-distributed grid layout
  - Verify NO horizontal scrolling (unlike iPhone)
  - Verify words wrap to multiple rows if needed
  - Verify grid adapts to screen width
  - Tap any word in grid - verify navigation works

- [ ] **iPhone horizontal scroll preserved**
  - Open flashcard on iPhone (or iPhone simulator)
  - Scroll to "All Words" section
  - Verify horizontal scrolling list (NOT grid)
  - Verify auto-scroll to current word works
  - Verify layout unchanged from previous version

- [ ] **iPad larger fonts**
  - Open flashcard on iPad
  - Verify phonics title is ~30% larger than iPhone
  - Verify word display is ~30% larger than iPhone
  - Verify better use of white space
  - Verify card height increased (280pt vs 200pt)
  - Overall layout feels balanced, not cramped

- [ ] **iPhone layout unchanged**
  - Open flashcard on iPhone
  - Verify fonts same size as before
  - Verify spacing unchanged
  - Verify card height 200pt (not increased)
  - Layout feels balanced and appropriate for screen size

## Accessibility Testing (Dynamic Type - H2)

### ✅ Dynamic Type Scaling
- [ ] **Default size (Medium)**
  - Open app with default text size
  - Verify all text readable
  - Verify layout not broken

- [ ] **Larger text sizes**
  - Settings → Display & Brightness → Text Size
  - Set to largest size (XXXL or larger)
  - Return to app
  - **FlashcardView:**
    - [ ] Phonics title scales appropriately
    - [ ] Word display scales appropriately
    - [ ] Navigation buttons scale
    - [ ] No text truncation
    - [ ] Layout remains usable
  - **HomeView:**
    - [ ] Group names readable
    - [ ] Card counts readable
    - [ ] Progress percentages in circles scale
  - **PremiumPaywallView:**
    - [ ] Star icon scales
    - [ ] All text readable
    - [ ] Purchase button text scales
  - **SettingsView:**
    - [ ] All labels and values readable
    - [ ] Statistics readable

- [ ] **Smaller text sizes**
  - Set text size to smallest
  - Verify everything still displays correctly
  - Verify no layout issues

- [ ] **Bold text enabled**
  - Settings → Accessibility → Display & Text Size → Bold Text
  - Enable bold text
  - Verify app handles bold text properly
  - Verify no layout breaks

### ✅ VoiceOver Accessibility
- [ ] **FlashcardView navigation**
  - Enable VoiceOver
  - Verify all elements have proper labels
  - Verify card navigation works
  - Verify star button accessible
  - Verify star button label: "Mark as mastered" (empty star) or "Word mastered" (filled star)
  - Verify progress announcements clear

- [ ] **Premium flow VoiceOver**
  - Navigate to premium paywall with VoiceOver
  - Verify purchase button has clear label
  - Verify restore button accessible
  - Verify price announced correctly

## Privacy & Security Testing (Phase 1 Fixes)

### ✅ Privacy Manifest Compliance
- [ ] **Verify PrivacyInfo.xcprivacy exists**
  - Check file is in project
  - Verify UserDefaults usage declared
  - Verify no analytics/tracking listed

- [ ] **No data collection**
  - Use network monitoring tool
  - Verify no analytics endpoints called
  - Verify no tracking requests
  - Verify no user data transmitted

## Performance Testing

### ✅ App Launch
- [ ] Cold launch (app not in memory)
  - Measure time to home screen
  - Should be < 3 seconds
  - No publishing warnings in console ✅

- [ ] Warm launch (app in background)
  - Should be instant
  - Progress data loads correctly

### ✅ Flashcard Performance
- [ ] Navigate between flashcards rapidly
  - No lag or stuttering
  - Smooth animations
  - Progress saves don't block UI

### ✅ Memory Management
- [ ] Complete multiple study sessions
  - Monitor memory usage
  - Verify no memory leaks
  - Verify no excessive memory growth
  - Singletons don't duplicate ✅

## Edge Cases

### ✅ Network Transitions
- [ ] **Airplane mode during use**
  - Start studying cards
  - Enable airplane mode
  - Continue studying
  - Verify progress still saves locally
  - Disable airplane mode
  - Verify premium status refreshes

### ✅ App Lifecycle
- [ ] **Background/Foreground transitions**
  - Start studying cards
  - Background app (home button)
  - Wait 30 seconds
  - Return to app
  - Verify state preserved
  - Verify no crashes

- [ ] **Force quit recovery**
  - Mid-study session, force quit
  - Reopen app
  - Verify progress saved
  - Verify can continue from where left off

### ✅ Multi-device Sync
- [ ] **Purchase on multiple devices**
  - Purchase on Device A
  - Install on Device B (same Apple ID)
  - Restore purchases
  - Verify premium unlocks
  - Study on Device B
  - Note: Progress is local-only (by design)

## App Store Submission Readiness

### ✅ Final Verification
- [ ] App builds without warnings
- [ ] No publishing warnings in console
- [ ] All assets present (icons, screenshots)
- [ ] Privacy policy accessible in Settings
- [ ] Version number set correctly (1.0.0)
- [ ] Bundle ID correct
- [ ] Signing configured
- [ ] Product ID configured in App Store Connect

---

## Testing Priority

**CRITICAL (Must Pass):**
- ✅ Premium purchase flow
- ✅ Restore purchases
- ✅ Progress data persistence
- ✅ Swipe gesture navigation (especially completing session on last word)
- ✅ No crashes or data loss

**HIGH (Should Pass):**
- ✅ Dynamic Type scaling
- ✅ Error messages user-friendly
- ✅ VoiceOver accessibility
- ✅ Product loading retry

**MEDIUM (Nice to Have):**
- Network transition handling
- Memory management
- Performance benchmarks

---

## Test Devices

**Recommended test matrix:**
- [ ] iPhone SE (small screen)
- [ ] iPhone 14 Pro (standard)
- [ ] iPhone 14 Pro Max (large screen)
- [ ] iPad (if supporting iPad)
- [ ] iOS 17.0 (minimum version)
- [ ] iOS 18.x (latest version)

**Simulators are fine for:**
- Dynamic Type testing
- Basic functionality
- Layout testing

**Real devices required for:**
- StoreKit purchase testing (sandbox)
- Performance testing
- Final validation

---

## How to Test StoreKit in Sandbox

1. **Create Sandbox Tester Account:**
   - App Store Connect → Users and Access → Sandbox Testers
   - Create test Apple ID

2. **Sign in on Device:**
   - Settings → App Store → Sandbox Account
   - Sign in with test Apple ID

3. **Test Purchases:**
   - Use sandbox account to purchase
   - Purchases are free in sandbox
   - Can "restore" and test multiple times

4. **Important:**
   - Don't sign in to real App Store with sandbox account
   - Sandbox purchases don't cost money
   - Can test unlimited purchases

---

## Issues to Watch For

**From Previous Fixes:**
- ⚠️ "Publishing changes from within view updates" warnings (FIXED)
- ⚠️ Race conditions in purchase status checks (FIXED)
- ⚠️ Silent restore failures (FIXED)
- ⚠️ Technical error messages to users (FIXED)
- ⚠️ Hardcoded font sizes (FIXED)

**Still Possible:**
- Network timeouts (should show appropriate errors)
- Edge cases in transaction processing (should recover)
- Layout issues on different screen sizes (test on multiple devices)
