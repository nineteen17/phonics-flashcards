# Testing Workflow - Sequential Checklist

Follow this checklist in order. Check off each item as you complete it.

---

## Setup & Prerequisites

### Test Environment Setup
- [ ] Have iPhone/iPad with iOS 17+ available (or simulator)
- [ ] App Store Connect sandbox tester account created
- [ ] Signed into sandbox account on test device (Settings → App Store)
- [ ] Product "com.phonicsflashcards.premiumunlock" configured in App Store Connect
- [ ] Fresh build installed on test device

---

## Part 1: Basic App Functionality (15 minutes)

### First Launch
- [ ] Launch app for first time
- [ ] App loads without crashes
- [ ] No "Publishing changes" warnings in console/logs
- [ ] Home screen displays phonics groups
- [ ] Phonics data loads successfully (no error alerts)

### Browse Free Content
- [ ] Tap on a phonics group to expand
- [ ] See list of cards (some should have lock icons)
- [ ] Tap a FREE card (no lock icon)
- [ ] Flashcard view opens successfully
- [ ] Can see phonics title (e.g., "at")
- [ ] Can see first word with phonetic highlighting
- [ ] Progress bar shows at top
- [ ] "Word 1 of X" displays correctly

### Navigate Flashcards with Tinder-Style Swipe Gestures (CRITICAL)
- [ ] **Test expanded swipe area:**
  - [ ] Try swiping ANYWHERE in the middle section (not just the card)
  - [ ] **Verify:** Entire area between header and word list is swipeable ✅
  - [ ] Much larger and more intuitive than old button navigation

- [ ] **Test Tinder-style drag animation:**
  - [ ] Start dragging the card but don't release
  - [ ] **Verify:** ONLY the word card moves (phonics title stays fixed) ✅
  - [ ] **Verify:** Word card follows your finger in real-time ✅
  - [ ] **Verify:** Word card rotates slightly as you drag (offset/20) ✅
  - [ ] **Verify:** Word card becomes slightly see-through (0.8 opacity) ✅
  - [ ] **Verify:** Phonics title at top does NOT move or rotate ✅
  - [ ] Release drag before 80pt
  - [ ] **Verify:** Word card snaps back to center with spring animation ✅

- [ ] **Swipe left to next word:**
  - [ ] Swipe left >80pt → navigates to next word
  - [ ] **Verify:** Word card springs back to center after navigation ✅
  - [ ] **Verify:** Old word fades out quickly (no lingering) ✅
  - [ ] **Verify:** New word fades in with scale animation ✅
  - [ ] **Verify:** Phonics title stays the same throughout ✅
  - [ ] **Verify:** Transition is smooth and crisp (0.2s)
  - [ ] Try multiple rapid swipes → all gestures recognized
  - [ ] **Verify:** No lag or dropped gestures
  - [ ] **Verify:** No ghosting or overlapping words

- [ ] **Swipe right to previous word:**
  - [ ] Navigate to second or later word
  - [ ] Swipe right >80pt → goes back to previous word
  - [ ] **Verify:** Spring animation is smooth ✅
  - [ ] On first word, swipe right → card drags but snaps back (no navigation) ✅

- [ ] **Complete session with swipe:**
  - [ ] Navigate to last word
  - [ ] **Swipe left >80pt** (as if going to next)
  - [ ] **Verify:** "Session Complete!" alert appears ✅
  - [ ] **CRITICAL:** This is how users complete sessions - must work perfectly
  - [ ] **Verify:** Shows total words and mastery percentage

### Mark Words as Mastered (Star Button)
- [ ] On any word, verify empty star icon displays below word
- [ ] Tap the empty star icon
- [ ] **Verify:** Star fills with spring animation ✅
- [ ] **Verify:** "Mastered!" text appears briefly next to star ✅
- [ ] **Verify:** "Mastered!" text fades after ~1.5 seconds ✅
- [ ] **Verify:** Mastery percentage increases at top
- [ ] Scroll word list at bottom → mastered word has filled star badge
- [ ] Navigate to different word and back → star remains filled
- [ ] Tap different word in bottom list → jumps to that word correctly

### Test Progress Persistence
- [ ] Mark 3-5 words as mastered across different cards
- [ ] Note which words and cards you mastered
- [ ] Force quit the app completely
- [ ] Reopen app
- [ ] Navigate to same cards
- [ ] **Verify:** All mastered words still show stars ✅
- [ ] **Verify:** Mastery percentages still correct ✅

---

## Part 2: Premium Paywall Testing (10 minutes)

### Access Paywall
- [ ] From home screen, tap Settings
- [ ] Premium Status section shows lock icon (not unlocked)
- [ ] Tap "Unlock Premium" button
- [ ] Premium paywall opens
- [ ] Star icon displays at top
- [ ] Price displays (should show actual price, not "Loading..." or "Price unavailable")
- [ ] Note the price: __________

### Paywall Content Verification
- [ ] "Unlock All Phonics Cards" title visible
- [ ] Shows count of premium cards available
- [ ] 4 feature rows display:
  - [ ] Complete Library
  - [ ] Offline Access
  - [ ] Track Progress
  - [ ] One-Time Purchase
- [ ] "Unlock for $X.XX" button visible
- [ ] "Restore Purchases" button visible
- [ ] Close button (X) works

### Try Locked Card
- [ ] Close paywall, go back to home
- [ ] Find a LOCKED card (has lock icon)
- [ ] Tap the locked card
- [ ] Premium paywall opens automatically ✅
- [ ] Close paywall

---

## Part 3: Restore Purchases - No Purchase Scenario (5 minutes)

### Test Restore with No Purchase
- [ ] Open Settings
- [ ] Tap "Restore Purchases" button
- [ ] Wait for processing
- [ ] **Verify:** Error alert appears (not silent failure) ✅
- [ ] **Verify:** Alert title is "Restore Failed"
- [ ] **Verify:** Message says "No previous purchases found"
- [ ] **Verify:** Helpful recovery suggestion shown
- [ ] Tap OK to dismiss
- [ ] Premium still locked ✅

---

## Part 4: Premium Purchase Flow (10 minutes)

### Complete Purchase
- [ ] Open premium paywall again
- [ ] Tap "Unlock for $X.XX" button
- [ ] Sandbox purchase dialog appears
- [ ] Complete sandbox purchase (free in sandbox)
- [ ] **Verify:** Paywall dismisses automatically
- [ ] **Verify:** NO errors shown

### Verify Premium Unlocked
- [ ] Open Settings
- [ ] **Verify:** Green checkmark next to "Premium Unlocked" ✅
- [ ] **Verify:** "Unlock Premium" button no longer visible
- [ ] Close settings

### Verify Cards Unlocked
- [ ] Go to home screen
- [ ] **Verify:** Previously locked cards NO LONGER have lock icons ✅
- [ ] Tap a previously locked card
- [ ] **Verify:** Opens flashcard view (not paywall) ✅
- [ ] Navigate through words successfully

### Test Premium Persistence
- [ ] Force quit app completely
- [ ] Reopen app
- [ ] Open Settings
- [ ] **Verify:** Premium still shows green checkmark ✅
- [ ] **Verify:** Cards still unlocked ✅

---

## Part 5: Restore Purchases - Success Scenario (5 minutes)

### Reset for Restore Test
- [ ] IF IN DEBUG BUILD: Open Settings → Debug section → Tap "Reset Premium (Test)"
- [ ] IF PRODUCTION: Delete app, reinstall, skip to "Restore Previous Purchase"
- [ ] **Verify:** Premium status shows locked again

### Restore Previous Purchase
- [ ] Open Settings or Premium Paywall
- [ ] Tap "Restore Purchases"
- [ ] Wait for processing (may take a few seconds)
- [ ] **Verify:** Premium unlocks automatically ✅
- [ ] **Verify:** Success feedback shown (paywall dismisses or alert)
- [ ] **Verify:** Cards unlock again
- [ ] **Verify:** Settings shows green checkmark

---

## Part 6: Accessibility - Dynamic Type Testing (15 minutes)

### Test Default Size
- [ ] Settings app → Display & Brightness → Text Size
- [ ] Ensure slider at default/middle position
- [ ] Return to phonics app
- [ ] Open a flashcard
- [ ] **Verify:** All text readable and properly sized
- [ ] **Verify:** Phonics title (big text) displays well
- [ ] **Verify:** Word display looks good
- [ ] **Verify:** Navigation buttons (chevrons) appropriate size

### Test Largest Text Size
- [ ] Settings app → Display & Brightness → Text Size
- [ ] Move slider to MAXIMUM (far right)
- [ ] Return to phonics app (app may reload)
- [ ] Open a flashcard
- [ ] **Verify:** Phonics title scaled larger ✅
- [ ] **Verify:** Word display scaled larger ✅
- [ ] **Verify:** Navigation buttons scaled larger ✅
- [ ] **Verify:** No text truncated or cut off
- [ ] **Verify:** Layout still usable (not broken)
- [ ] Navigate to home screen
- [ ] **Verify:** Group names readable
- [ ] **Verify:** Progress percentages in circles scaled
- [ ] Open Settings
- [ ] **Verify:** All labels and values readable
- [ ] Open Premium Paywall
- [ ] **Verify:** Star icon scaled larger ✅
- [ ] **Verify:** All text readable and not cut off

### Test Smallest Text Size
- [ ] Settings app → Display & Brightness → Text Size
- [ ] Move slider to MINIMUM (far left)
- [ ] Return to phonics app
- [ ] Open flashcard, home, settings, paywall
- [ ] **Verify:** Everything still displays correctly
- [ ] **Verify:** Text not too small to read
- [ ] **Verify:** No layout issues

### Test Bold Text
- [ ] Settings app → Accessibility → Display & Text Size
- [ ] Enable "Bold Text" (will restart device)
- [ ] After restart, open phonics app
- [ ] Navigate through all screens
- [ ] **Verify:** App handles bold text properly
- [ ] **Verify:** No layout breaks
- [ ] Disable bold text and restart

### Reset Text Size
- [ ] Settings app → Display & Brightness → Text Size
- [ ] Return slider to default/middle position

---

## Part 7: VoiceOver Accessibility (10 minutes)

### Enable VoiceOver
- [ ] Settings app → Accessibility → VoiceOver
- [ ] Turn VoiceOver ON
- [ ] (Tip: Triple-click home/side button to toggle VoiceOver quickly)

### Test Flashcard Navigation
- [ ] Open phonics app with VoiceOver on
- [ ] Swipe right to navigate to a flashcard
- [ ] Tap to open flashcard
- [ ] **Verify:** Phonics title announced clearly
- [ ] **Verify:** Current word announced
- [ ] Swipe to next/previous buttons
- [ ] **Verify:** Buttons have clear labels ("Next word", "Previous word")
- [ ] **Verify:** Disabled states announced
- [ ] Swipe to star button (mastered button)
- [ ] **Verify:** Label says "Mark as mastered" (empty star) or "Word mastered" (filled star)
- [ ] **Verify:** Clear hint provided
- [ ] Double-tap to activate (if not already mastered)
- [ ] **Verify:** Mastery state announced correctly

### Test Premium Flow
- [ ] Navigate to Settings with VoiceOver
- [ ] **Verify:** Premium status announced clearly
- [ ] Navigate to paywall
- [ ] **Verify:** Price announced correctly
- [ ] **Verify:** Purchase button clear
- [ ] **Verify:** Restore button accessible
- [ ] Swipe through feature list
- [ ] **Verify:** All features announced

### Disable VoiceOver
- [ ] Triple-click home/side button to turn off VoiceOver
- [ ] (Or Settings → Accessibility → VoiceOver → OFF)

---

## Part 8: Error Handling & Edge Cases (15 minutes)

### Comprehensive Tinder-Style Swipe Testing (CRITICAL)
- [ ] Open any flashcard
- [ ] **Test expanded swipe area:**
  - [ ] Swipe anywhere in middle section → works ✅
  - [ ] Swipe on card itself → works
  - [ ] Swipe above card → works
  - [ ] Swipe below card → works
  - [ ] **Verify:** Entire middle area is swipeable

- [ ] **Test real-time drag animation:**
  - [ ] Start dragging left slowly
  - [ ] **Verify:** ONLY word card moves (title stays fixed) ✅
  - [ ] **Verify:** Word card moves with your finger ✅
  - [ ] **Verify:** Word card rotates proportionally (offset/20) ✅
  - [ ] **Verify:** Word card opacity changes to 0.8 ✅
  - [ ] **Verify:** Phonics title does NOT move/rotate ✅
  - [ ] Release before 80pt threshold
  - [ ] **Verify:** Word card springs back to center smoothly
  - [ ] Repeat dragging right
  - [ ] **Verify:** Same animation behavior

- [ ] **Test swipe threshold (80pt):**
  - [ ] Drag card ~50pt and release → snaps back (no navigation)
  - [ ] Drag card ~79pt and release → snaps back (no navigation)
  - [ ] Drag card ~81pt and release → navigates ✅
  - [ ] **Verify:** 80pt threshold is consistent and reliable

- [ ] **Test rapid swiping:**
  - [ ] Swipe left → next word
  - [ ] Immediately swipe left again → next word
  - [ ] Continue rapidly 5-10 times
  - [ ] **Verify:** All swipes recognized
  - [ ] **Verify:** No lag or dropped gestures
  - [ ] **Verify:** Animation stays smooth

- [ ] **Test session completion on last word:**
  - [ ] Navigate to last word
  - [ ] Swipe left >80pt (as if next)
  - [ ] **Verify:** "Session Complete!" popup appears immediately ✅
  - [ ] **Verify:** Shows total words and mastery percentage
  - [ ] Tap "Review Again"
  - [ ] Navigate to last word again
  - [ ] Swipe left again
  - [ ] **Verify:** Popup appears again (repeatable)

- [ ] **Test gesture boundaries:**
  - [ ] On first word, swipe right >80pt → card drags but snaps back ✅
  - [ ] Can still tap star button (no conflict)
  - [ ] Can still tap words in bottom list (no conflict)
  - [ ] Can still scroll word list on iPhone (no conflict)
  - [ ] iPad grid still tappable (no conflict)
  - [ ] Verify dragging doesn't interfere with other tap targets

### Test Airplane Mode During Use
- [ ] Open a flashcard, mark some words mastered
- [ ] Enable Airplane Mode
- [ ] Continue navigating with swipes and marking words
- [ ] **Verify:** Swipe gestures continue to work normally
- [ ] **Verify:** Progress still saves locally
- [ ] Return to home
- [ ] **Verify:** Mastery badges updated
- [ ] Disable Airplane Mode
- [ ] Wait a moment
- [ ] **Verify:** Premium status still correct

### Test Network Error on Product Loading
- [ ] Delete and reinstall app (or use fresh simulator)
- [ ] Before opening app, enable Airplane Mode
- [ ] Open app
- [ ] Navigate to Premium Paywall
- [ ] **Verify:** Shows "Price unavailable" (not a crash)
- [ ] Disable Airplane Mode
- [ ] Close and reopen paywall
- [ ] **Verify:** Price loads successfully after retry

### Test Background/Foreground
- [ ] Open a flashcard, mark a word as mastered
- [ ] Press home button (background app)
- [ ] Wait 30 seconds
- [ ] Reopen app
- [ ] **Verify:** Returns to same flashcard
- [ ] **Verify:** Mastered word still has star
- [ ] **Verify:** No crashes

### Test Force Quit Recovery
- [ ] Open a flashcard, mark several words mastered
- [ ] Force quit app (swipe up in app switcher)
- [ ] Reopen app
- [ ] Navigate to same flashcard
- [ ] **Verify:** All mastered words still show stars ✅
- [ ] **Verify:** Progress preserved

---

## Part 9: Multi-Screen & Layout Testing (10 minutes)

### iPhone Portrait Lock (CRITICAL)
- [ ] **Test on iPhone (any model up to iPhone 16 Pro Max):**
  - [ ] Open any flashcard in portrait mode
  - [ ] **Verify:** All content visible and well-laid out
  - [ ] Try rotating device to landscape
  - [ ] **Verify:** App STAYS in portrait mode (does NOT rotate) ✅
  - [ ] **CRITICAL:** iPhone flashcards are portrait-only for better UX
  - [ ] Navigate to Home screen
  - [ ] Return to flashcard
  - [ ] **Verify:** Portrait lock still active
  - [ ] Force quit app and reopen
  - [ ] Open flashcard
  - [ ] **Verify:** Portrait lock applies immediately

### iPad Landscape Support
- [ ] **Test on iPad (any size):**
  - [ ] Open any flashcard in portrait mode
  - [ ] **Verify:** All content visible
  - [ ] Rotate iPad to landscape
  - [ ] **Verify:** iPad DOES rotate to landscape ✅
  - [ ] **Verify:** Layout adapts properly (grid, larger fonts work)
  - [ ] Swipe gestures still work in landscape
  - [ ] All elements remain usable in both orientations

### Different Device Sizes (if testing on multiple devices)
- [ ] **On iPhone SE (small screen):**
  - [ ] All text visible
  - [ ] No truncation
  - [ ] Buttons reachable
  - [ ] Word list horizontal scroll works
- [ ] **On iPhone Pro Max (large screen):**
  - [ ] Content scales appropriately
  - [ ] No excessive white space
  - [ ] Layout looks balanced
  - [ ] Word list horizontal scroll works
- [ ] **On iPad (regular size class):**
  - [ ] Open flashcard view
  - [ ] **Verify:** Phonics title ~30% larger than iPhone ✅
  - [ ] **Verify:** Word display ~30% larger than iPhone ✅
  - [ ] **Verify:** Card height larger (280pt vs 200pt) ✅
  - [ ] **Verify:** Better use of white space (not cramped)
  - [ ] Scroll to "All Words" section
  - [ ] **Verify:** Words display in evenly-distributed GRID layout ✅
  - [ ] **Verify:** NO horizontal scrolling (unlike iPhone) ✅
  - [ ] **Verify:** Words wrap to multiple rows
  - [ ] **Verify:** Grid adapts to screen width
  - [ ] Tap any word in grid
  - [ ] **Verify:** Navigation to word works correctly
  - [ ] Overall layout feels balanced and appropriate for iPad screen

---

## Part 10: Statistics & Settings Verification (5 minutes)

### Check Statistics
- [ ] Complete at least 2 full flashcard sessions
- [ ] Mark multiple words as mastered
- [ ] Open Settings
- [ ] Statistics section shows:
  - [ ] Total Study Sessions: [Count should match sessions completed]
  - [ ] Cards Studied: [Should be > 0]
  - [ ] Words Mastered: [Should match total mastered words]
- [ ] **Verify:** All counts are accurate

### About Section
- [ ] Scroll to About section in Settings
- [ ] **Verify:** Version shows 1.0.0
- [ ] **Verify:** Total Cards count matches repository
- [ ] **Verify:** Free Cards count shown
- [ ] **Verify:** Premium Cards count shown
- [ ] Tap "Privacy Policy"
- [ ] **Verify:** Privacy policy view opens
- [ ] **Verify:** Content loads and is readable
- [ ] Close privacy policy

### Reset Progress
- [ ] In Settings, scroll to Data Management
- [ ] Tap "Reset All Progress"
- [ ] Alert appears asking for confirmation
- [ ] Tap Cancel first
- [ ] Tap "Reset All Progress" again
- [ ] Tap "Reset" to confirm
- [ ] **Verify:** Statistics reset to 0
- [ ] Navigate to flashcards
- [ ] **Verify:** All stars/mastery removed
- [ ] **Verify:** Premium status preserved (not reset)

---

## Part 11: Performance & Stability (5 minutes)

### Rapid Navigation
- [ ] Rapidly navigate between flashcards (tap next many times)
- [ ] **Verify:** No lag or stuttering
- [ ] **Verify:** Animations smooth
- [ ] Rapidly mark words as mastered
- [ ] **Verify:** UI doesn't freeze
- [ ] **Verify:** All stars appear correctly

### Memory Check
- [ ] Complete 5-10 full flashcard sessions
- [ ] Navigate through multiple groups
- [ ] Return to home repeatedly
- [ ] **Verify:** App remains responsive
- [ ] **Verify:** No noticeable slowdown
- [ ] Check device memory usage if possible
- [ ] Force quit and reopen
- [ ] **Verify:** Reopens quickly

### Console Check (Xcode)
- [ ] If running from Xcode, check console output
- [ ] **Verify:** No "Publishing changes from within view updates" warnings
- [ ] **Verify:** No "UITableView" warnings
- [ ] **Verify:** No memory warnings
- [ ] **Verify:** No StoreKit transaction errors (except expected test scenarios)

---

## Part 12: Final Pre-Submission Checks (5 minutes)

### Build Verification
- [ ] App builds without warnings in Xcode
- [ ] No compiler errors
- [ ] No yellow warning triangles in project navigator
- [ ] Archive builds successfully

### Asset Verification
- [ ] App icon displays correctly
- [ ] Launch screen displays
- [ ] All SF Symbols display correctly
- [ ] No missing images or placeholders

### Required Files Present
- [ ] phonics.json data file included in bundle
- [ ] PrivacyInfo.xcprivacy in project
- [ ] Privacy Policy accessible

### App Store Connect Setup
- [ ] Product ID "com.phonicsflashcards.premiumunlock" exists
- [ ] Pricing set correctly
- [ ] Product approved for sandbox testing
- [ ] Screenshots prepared (if ready for submission)

---

## Testing Complete! 🎉

### Summary Checklist
Count how many items you checked:
- [ ] **All critical tests passed** (Parts 1-5)
- [ ] **Accessibility tests passed** (Parts 6-7)
- [ ] **Edge cases handled** (Part 8)
- [ ] **Layout tests passed** (Part 9)
- [ ] **Settings/stats verified** (Part 10)
- [ ] **Performance acceptable** (Part 11)
- [ ] **Ready for submission** (Part 12)

### Issues Found
Document any issues discovered during testing:

**Issue 1:**
- [ ] Description: ___________________________________
- [ ] Steps to reproduce: ___________________________________
- [ ] Severity: Critical / High / Medium / Low

**Issue 2:**
- [ ] Description: ___________________________________
- [ ] Steps to reproduce: ___________________________________
- [ ] Severity: Critical / High / Medium / Low

**Issue 3:**
- [ ] Description: ___________________________________
- [ ] Steps to reproduce: ___________________________________
- [ ] Severity: Critical / High / Medium / Low

---

## Next Steps

If all tests passed:
- [ ] Create production build
- [ ] Submit to App Store Review
- [ ] Prepare for launch

If issues found:
- [ ] Report issues to development
- [ ] Fix critical issues
- [ ] Re-test affected areas
- [ ] Repeat testing cycle

---

**Testing Time Estimate:** ~1.5 - 2 hours total

**Recommended Test Order:**
1. Do Parts 1-5 in one session (critical path testing)
2. Do Parts 6-7 in another session (accessibility)
3. Do Parts 8-12 as final verification

Good luck with testing! 🚀
