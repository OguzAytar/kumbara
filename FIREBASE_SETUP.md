# Firebase Analytics & Privacy Compliance Setup

## Overview
Bu proje Firebase Analytics kullanır ve Google Play Store ile App Store politikalarına uyum sağlar.

## 🔥 Firebase Analytics Features

### Implemented Analytics:
- ✅ App lifecycle events (open, screen views)
- ✅ User settings (theme, language, notifications)
- ✅ Onboarding completion tracking
- ✅ Notification permission requests
- ✅ Data operations (backup, restore, delete)
- ✅ Error tracking
- ✅ Custom events

### Analytics Helper Usage:
```dart
// Screen tracking
FirebaseAnalyticsHelper.logScreenView(screenName: 'Home');

// User properties
FirebaseAnalyticsHelper.setUserProperties(
  language: 'tr',
  theme: 'dark',
  notificationsEnabled: true,
);

// Custom events
FirebaseAnalyticsHelper.logSavingsGoalCreated(
  goalId: 'goal_123',
  targetAmount: 1000.0,
  currency: 'TRY',
);
```

## 📱 Platform Compliance

### Android (Google Play Store)
1. **Advertising ID Declaration**: ✅ Added to AndroidManifest.xml
2. **Firebase Analytics Config**: ✅ global_tracker.xml created
3. **Privacy Policy**: ✅ PRIVACY_POLICY.md created
4. **Permissions**: All analytics permissions declared

### iOS (App Store)
1. **App Tracking Transparency**: ✅ ATT framework integrated
2. **Usage Descriptions**: ✅ NSUserTrackingUsageDescription added
3. **Firebase Config**: ✅ Analytics enabled in Info.plist
4. **Privacy Manifest**: Automatically handled by Firebase

## 🛡️ Privacy & GDPR Compliance

### Data Collection:
- **Device ID**: For analytics (anonymized)
- **App Usage**: Screen views, feature usage
- **Settings**: Theme, language preferences
- **NO Personal Data**: No names, emails, or sensitive info

### Data Storage:
- **Local Only**: All user savings data stored locally
- **Analytics**: Anonymous usage data sent to Firebase
- **Encryption**: Local SQLite database encrypted

### User Rights:
- ✅ Right to disable analytics (via notification settings)
- ✅ Right to delete local data
- ✅ Right to app removal (uninstall)

## 🚀 Firebase Setup Required

### 1. Create Firebase Project:
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init
```

### 2. Generate Configuration:
```bash
# Generate Firebase config files
flutterfire configure --project=your-project-id
```

### 3. Replace Dummy Config:
The `lib/firebase_options.dart` file contains dummy values. Replace with real values from Firebase Console.

## 📊 Google Play Console Setup

### Data Safety Section:
1. Go to Google Play Console → App Content → Data Safety
2. Declare the following data types:
   - **Device identifiers**: For analytics
   - **App activity**: Screen views, feature usage
   - **App info and performance**: Crash reports

### Privacy Policy:
1. Use the provided `PRIVACY_POLICY.md` as template
2. Host it on a public URL
3. Add URL to Google Play Console

## 🍎 App Store Connect Setup

### Privacy Nutrition Labels:
1. Go to App Store Connect → App Information → Privacy
2. Declare data collection:
   - **Identifiers → Device ID**: For analytics
   - **Usage Data → Product Interaction**: For app improvement

### Advertising Identifier:
1. If prompted, declare that you use IDFA for analytics
2. Select "Serve advertisements within the app" → NO
3. Select "Measure advertising effectiveness" → NO
4. Select "Measure app performance" → YES

## ⚠️ Important Notes

### Before Publishing:
1. Replace dummy Firebase config with real values
2. Test analytics in Firebase Console
3. Update Privacy Policy with your contact information
4. Test App Tracking Transparency on iOS 14.5+

### GDPR Compliance:
- Analytics is anonymous and doesn't require explicit consent
- Users can disable via app settings
- Local data can be deleted by user

### Testing:
```bash
# Test Firebase Analytics
flutter run --release
# Check Firebase Console → Analytics → DebugView
```

## 📞 Support
For questions about privacy compliance or Firebase setup, refer to:
- [Firebase Analytics Documentation](https://firebase.google.com/docs/analytics)
- [Google Play Data Safety](https://support.google.com/googleplay/android-developer/answer/10787469)
- [App Store Privacy Guidelines](https://developer.apple.com/app-store/app-privacy-details/)
