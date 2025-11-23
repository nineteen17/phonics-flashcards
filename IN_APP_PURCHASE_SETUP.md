# In-App Purchase Setup Guide

Complete guide for configuring the premium unlock feature in App Store Connect and understanding how pricing works.

---

## Table of Contents
1. [How Pricing Works](#how-pricing-works)
2. [App Store Connect Setup](#app-store-connect-setup)
3. [Product Configuration](#product-configuration)
4. [Testing with Sandbox](#testing-with-sandbox)
5. [Technical Implementation](#technical-implementation)
6. [Troubleshooting](#troubleshooting)

---

## How Pricing Works

### Price Configuration
- **You set the price in App Store Connect** (NOT in the code)
- Choose a **price tier** (e.g., Tier 5 = $4.99 USD)
- Apple automatically converts to **175+ countries and currencies**

### Dynamic Price Display
The app fetches the localized price at runtime:

```swift
// StoreKitManager.swift:226-231
var premiumPriceString: String {
    if let product = products.first(where: { $0.id == premiumProductID }) {
        return product.displayPrice  // ← Apple provides localized price
    }
    return isLoading ? "Loading..." : "Price unavailable"
}
```

### Multi-Country Pricing Examples
Apple's `displayPrice` automatically handles:
- **Currency conversion**: USD, EUR, GBP, JPY, AUD, etc.
- **Formatting**: Proper symbols and decimal places
- **Tax compliance**: Includes/excludes tax per local regulations

| Country | Display Price | Notes |
|---------|---------------|-------|
| 🇺🇸 United States | $4.99 | Base tier price |
| 🇬🇧 United Kingdom | £4.99 | Includes VAT |
| 🇪🇺 European Union | €5.49 | Includes VAT |
| 🇯🇵 Japan | ¥600 | Consumption tax included |
| 🇦🇺 Australia | A$7.99 | Includes GST |
| 🇨🇦 Canada | CA$6.99 | Plus applicable taxes |

**Important:** These are examples. Actual prices depend on your chosen tier and Apple's currency conversion rates.

---

## App Store Connect Setup

### Prerequisites
1. Paid Apple Developer Account ($99/year)
2. App created in App Store Connect
3. Bundle ID matches: `com.phonicsflashcards.app` (or your actual bundle ID)
4. Agreements signed (Paid Applications Agreement)

### Step-by-Step Setup

#### 1. **Navigate to In-App Purchases**
```
App Store Connect → My Apps → [Your App] → Features → In-App Purchases
```

#### 2. **Create New In-App Purchase**
- Click **"+"** (Create New)
- Select **"Non-Consumable"** (one-time purchase)

#### 3. **Configure Product Details**

**Product ID (CRITICAL):**
```
com.phonicsflashcards.premiumunlock
```
⚠️ **Must match exactly** - this is hardcoded in `StoreKitManager.swift:17`

**Reference Name:**
```
Premium Unlock
```
(Internal use only - not shown to users)

**Review Notes (Optional):**
```
Unlocks all premium phonics flashcards (60+ cards)
```

#### 4. **Set Price**
- Choose a **Price Schedule**
- Select a **Base Price Tier**

**Recommended Tiers:**
- **Tier 5** ($4.99 USD) - Standard educational app price
- **Tier 10** ($9.99 USD) - Premium educational app price
- **Tier 3** ($2.99 USD) - Budget-friendly option

Click **"Review Pricing"** to see auto-generated prices for all countries.

**Optional:** Manually adjust prices for specific countries if needed.

#### 5. **Add Localized Information**

For each language you support (minimum: English):

**Display Name:**
```
Premium Unlock
```

**Description:**
```
Unlock all 60+ premium phonics flashcards for comprehensive reading education. One-time purchase, lifetime access. No subscriptions.
```

**Review Screenshot:**
- Upload a screenshot showing the premium paywall
- Required for app review

#### 6. **App Store Promotion (Optional)**
- Toggle **"Available for Purchase"** ON if you want it in App Store search
- Add promotional image (540x540px)

**Recommended:** Keep OFF - users should discover in-app

#### 7. **Submit for Review**
- Click **"Submit"** on the In-App Purchase
- Wait for **"Ready to Submit"** status
- Submit with your app during App Review

---

## Product Configuration

### Current Product ID
```swift
// StoreKitManager.swift:17
private let premiumProductID = "com.phonicsflashcards.premiumunlock"
```

### Changing Product ID (If Needed)

**⚠️ WARNING:** Only do this BEFORE launch. Changing after users purchase causes issues.

1. **Update in App Store Connect** (create new product)
2. **Update in code:**
   ```swift
   // StoreKitManager.swift:17
   private let premiumProductID = "com.YOUR_NEW_PRODUCT_ID"
   ```

### StoreKit Configuration File (Optional)

For **local testing** without App Store Connect:

1. Create `StoreKit Configuration File` in Xcode
2. Add product with matching ID
3. Set price for testing
4. Enable in scheme: Edit Scheme → Run → Options → StoreKit Configuration

**Not required for production** - only for simulator testing.

---

## Testing with Sandbox

### Create Sandbox Tester Account

1. **App Store Connect → Users and Access → Sandbox Testers**
2. Click **"+"** to create tester
3. Use **fake email** (e.g., `test@example.com`)
4. **Don't use real Apple ID** - it will be permanently marked as sandbox

### Test on Real Device

**Setup:**
1. Settings → App Store → Sandbox Account
2. Sign in with sandbox tester email
3. Run app from Xcode

**Testing Purchases:**
- All purchases are **free** in sandbox
- Can test unlimited times
- Can test "Restore Purchases" by deleting and reinstalling

**⚠️ Important:**
- **Never sign into real App Store with sandbox account**
- Sandbox accounts don't work in production
- Must test on real device (not simulator, unless using StoreKit config file)

### Verification Checklist

- [ ] Price displays correctly (not "Loading..." or "Price unavailable")
- [ ] Can complete purchase successfully
- [ ] Premium unlocks immediately after purchase
- [ ] Locked cards become accessible
- [ ] Settings shows checkmark for premium status
- [ ] "Restore Purchases" works on fresh install
- [ ] Premium persists after force-quitting app
- [ ] Premium persists after device restart

---

## Technical Implementation

### StoreKit 2 Architecture

The app uses **StoreKit 2** (modern async/await API):

```swift
// StoreKitManager.swift - Singleton pattern
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    // Product management
    @Published private(set) var products: [Product] = []
    @Published var isPremiumUnlocked = false

    // Transaction listener (background processing)
    private var updateListenerTask: Task<Void, Error>?
}
```

### Key Features

**1. Automatic Transaction Listener**
```swift
// Processes purchases even if app was killed during transaction
private func listenForTransactions() -> Task<Void, Error>
```

**2. Retry Logic for Network Issues**
```swift
// Retries up to 3 times with 1-second delays
func loadProducts() async
```

**3. Race Condition Prevention**
```swift
// Cancels ongoing checks before starting new one
private func checkPurchaseStatus() async
```

**4. Secure Verification**
```swift
// Only trusts Apple-verified transactions
private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T
```

### Purchase Flow

```
User taps "Unlock Premium"
    ↓
StoreKitManager.purchasePremium()
    ↓
Product.purchase() [Apple handles payment]
    ↓
Verify transaction signature
    ↓
Update isPremiumUnlocked = true
    ↓
Finish transaction
    ↓
UI updates across all views
```

### Restore Flow

```
User taps "Restore Purchases"
    ↓
AppStore.sync() [Fetch latest entitlements]
    ↓
Check Transaction.currentEntitlements
    ↓
Verify each transaction
    ↓
Update isPremiumUnlocked if found
    ↓
Show success/error message
```

---

## Troubleshooting

### "Price unavailable" Error

**Possible Causes:**
1. Product not created in App Store Connect
2. Product ID mismatch
3. Network connection issue
4. Product not approved yet

**Solutions:**
- Verify product ID matches exactly: `com.phonicsflashcards.premiumunlock`
- Check product status is "Ready to Submit" or "Approved"
- Wait 1-2 hours after creating product (App Store cache delay)
- Check device internet connection
- Try force-quitting and reopening app

### "No Previous Purchases Found"

**Possible Causes:**
1. User never purchased premium
2. Different Apple ID
3. Network issue during restore
4. Transaction not finalized

**Solutions:**
- Verify signed in with correct Apple ID
- Try again in a few moments (transactions can lag)
- Check Settings → [Apple ID] → Media & Purchases
- Contact Apple Support if purchase charged but not restoring

### Purchase Doesn't Unlock Premium

**Possible Causes:**
1. Transaction listener not running
2. App killed before transaction finished
3. Verification failed

**Solutions:**
- Force quit and reopen app (transaction listener will retry)
- Check console for error messages
- Try "Restore Purchases" button
- Verify no errors in StoreKitManager logs

### Sandbox Testing Issues

**Common Problems:**

| Issue | Solution |
|-------|----------|
| Can't sign into sandbox | Use Settings → App Store → Sandbox (not Settings → [Apple ID]) |
| "Cannot connect to iTunes Store" | Sandbox may be temporarily down - try again later |
| Purchase keeps failing | Delete app, reinstall, try different sandbox account |
| Already purchased | Sandbox accounts remember purchases - create new tester |

### Production Issues

**If users report problems:**

1. **Check App Store Connect**
   - Verify product is "Approved" status
   - Check availability in all territories

2. **Review Logs**
   - Console logs show detailed StoreKit errors
   - Look for "Failed to load products" or "Transaction verification failed"

3. **Common User Issues**
   - User on older iOS version (require iOS 15+)
   - Parental controls blocking purchases
   - Payment method issues
   - Region restrictions

---

## Best Practices

### Price Changes
- Can change price anytime in App Store Connect
- Existing users keep their purchase
- New price only affects new buyers
- Users won't be charged again

### Refunds
- Users request through App Store (not from you)
- Apple handles refund policy
- You'll see refund in App Store Connect → Sales and Trends
- App continues to work after refund (can't revoke access)

### Privacy
- No personal data collected
- Purchase verification happens on-device
- Apple handles all payment processing
- See `PrivacyInfo.xcprivacy` for compliance

### Updates
- Premium status persists across app updates
- No migration needed
- Users never need to repurchase

---

## Related Files

### Code Files
- `StoreKitManager.swift` - Main purchase logic
- `PremiumPaywallView.swift` - Purchase UI
- `SettingsView.swift` - Shows premium status
- `PhonicsRepository.swift` - Filters premium cards

### Documentation
- `TESTING_CHECKLIST.md` - Purchase flow testing
- `TESTING_WORKFLOW.md` - Step-by-step test guide
- `APP_STORE_READINESS_AUDIT.md` - Pre-submission checks
- `PrivacyInfo.xcprivacy` - Privacy compliance

---

## Pre-Launch Checklist

Before submitting to App Store:

- [ ] Product created in App Store Connect with correct ID
- [ ] Price tier chosen and reviewed
- [ ] Localized information added (at least English)
- [ ] Screenshot uploaded for product review
- [ ] Tested purchase flow in sandbox
- [ ] Tested restore flow in sandbox
- [ ] Tested on multiple devices
- [ ] Verified premium unlocks correctly
- [ ] Verified pricing displays in multiple regions (via VPN or sandbox accounts)
- [ ] All error messages user-friendly
- [ ] Privacy manifest includes no data collection

---

## Additional Resources

### Apple Documentation
- [In-App Purchase Documentation](https://developer.apple.com/in-app-purchase/)
- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Sandbox Testing Guide](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox)

### App Store Review Guidelines
- [3.1.1 In-App Purchase](https://developer.apple.com/app-store/review/guidelines/#in-app-purchase)
- Non-consumables must restore across devices
- Must handle all purchase states gracefully
- Must provide restore mechanism

---

## Support & Troubleshooting

If you encounter issues not covered here:

1. Check Xcode console for error logs
2. Review App Store Connect product status
3. Test with fresh sandbox account
4. Check Apple Developer Forums
5. Contact Apple Developer Support

---

**Last Updated:** November 19, 2025
**StoreKit Version:** 2.0
**Minimum iOS Version:** 15.0
