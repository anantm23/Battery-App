# Battery Alert - Setup Guide

## 📱 Building and Installing the App

Since this is a native Apple app, you'll need to build it using Xcode. Here's how to get started:

### Prerequisites

1. **Mac with macOS Ventura (13.0) or later**
2. **Xcode 14.0 or later** - Download from the Mac App Store
3. **Apple Developer Account** (free or paid)
   - Free account: Can run on your own devices for 7 days at a time
   - Paid account ($99/year): Can distribute and run indefinitely

### Step 1: Create Xcode Project

Since we've created the Swift source files, you now need to create an Xcode project:

1. Open Xcode
2. Select **File → New → Project**
3. Choose **Multiplatform → App**
4. Fill in the details:
   - Product Name: `BatteryAlert`
   - Team: Select your Apple Developer team
   - Organization Identifier: `com.batteryalert` (or your own)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Include Tests: Optional

### Step 2: Add Source Files to Project

1. In Xcode, delete the default `ContentView.swift` and `BatteryAlertApp.swift` files
2. Drag and drop the source files from this repository into your Xcode project:
   - `Shared/Models/BatterySettings.swift` → Shared folder
   - `Shared/ViewModels/BatteryMonitor.swift` → Shared folder
   - `iOS/BatteryAlertApp.swift` → iOS folder (target: iOS only)
   - `iOS/ContentView.swift` → iOS folder (target: iOS only)
   - `macOS/BatteryAlertApp.swift` → macOS folder (target: macOS only)
   - `macOS/MenuBarView.swift` → macOS folder (target: macOS only)
   - `watchOS/BatteryAlertApp.swift` → watchOS folder (target: watchOS only)
   - `watchOS/WatchContentView.swift` → watchOS folder (target: watchOS only)

3. Make sure to check the appropriate target membership for each file

### Step 3: Configure Info.plist

For each platform, add the Info.plist settings:

#### iOS/iPadOS:
- Copy contents from `iOS/Info.plist` to your iOS target's Info.plist
- Or add these keys manually in Xcode's Info tab

#### macOS:
- Copy contents from `macOS/Info.plist` to your macOS target's Info.plist
- The `LSUIElement` key makes it a menu bar app

#### watchOS:
- Copy contents from `watchOS/Info.plist` to your watchOS target's Info.plist

### Step 4: Configure Capabilities

For each target, enable the following capabilities:

1. Select your project in Xcode
2. Select each target (iOS, macOS, watchOS)
3. Go to **Signing & Capabilities** tab
4. Add capability: **Background Modes** (iOS only)
   - Check: "Background processing"
5. Add capability: **Push Notifications** (optional, for future features)

### Step 5: Build and Run

#### For iPhone/iPad:
1. Select the iOS target and your device/simulator
2. Click the Run button (⌘R)
3. Grant notification permissions when prompted

#### For Mac:
1. Select the macOS target
2. Click the Run button (⌘R)
3. The app will appear in your menu bar (top-right corner)
4. Grant notification permissions when prompted

#### For Apple Watch:
1. You need an iPhone paired with an Apple Watch
2. Select the watchOS target and your paired watch
3. Click the Run button (⌘R)
4. The app will install on your watch

### Step 6: First Launch Setup

1. **Grant Permissions**: When you first launch the app, it will request notification permissions. Tap "Allow" to receive battery alerts.

2. **Configure Settings**:
   - iOS/watchOS: Tap the Settings button
   - macOS: Click the menu bar icon → Settings
   
3. **Set Your Threshold**: Adjust the battery alert threshold (default is 80%)

4. **Enable Alerts**: Make sure alerts are enabled

## 🔧 Troubleshooting

### App won't build
- Make sure all files have the correct target membership
- Check that you've selected a valid development team
- Verify minimum deployment targets match your devices

### Notifications not working
- Check Settings → Notifications → Battery Alert
- Make sure you granted notification permissions
- On macOS, check System Settings → Notifications → Battery Alert

### Battery monitoring not working
- iOS: The app needs to be running (can be in background)
- macOS: The menu bar app should always be running
- watchOS: The app needs to be open or recently used

### Code signing issues
- Make sure you're signed in with your Apple ID in Xcode
- Go to Xcode → Settings → Accounts
- Select your team in the project's Signing & Capabilities

## 📲 Alternative: Using Swift Playgrounds (iOS/iPadOS only)

If you don't have a Mac, you can try building a simplified version using Swift Playgrounds on iPad:

1. Install Swift Playgrounds from the App Store
2. Create a new App project
3. Copy the iOS source code
4. Note: Some features may be limited

## 🎯 Usage Tips

### iOS/iPadOS
- Keep the app running in the background
- The app will alert you even when locked
- You can close the app after setup; iOS will wake it for battery monitoring

### macOS
- The app runs in the menu bar
- Click the bolt icon to see battery status
- The app launches at login (optional - configure in System Settings)

### Apple Watch
- The app works independently on the watch
- Useful when charging your watch overnight
- Haptic feedback will wake you if needed

## 🔋 Battery Health Tips

The app helps you maintain battery health by preventing overcharging. Here are additional tips:

1. **Keep battery between 20-80%** for optimal longevity
2. **Avoid extreme temperatures** when charging
3. **Use optimized battery charging** (iOS/macOS have this built-in)
4. **Unplug when you reach your threshold** (that's what this app is for!)

## 🚀 Future Enhancements

Potential features to add:
- [ ] iCloud sync for settings across devices
- [ ] Shortcuts integration
- [ ] Widget support
- [ ] Historical battery data
- [ ] Custom alert sounds
- [ ] Low battery alerts (below 20%)

## 📝 License

MIT License - Feel free to modify and distribute as needed.

## 🤝 Contributing

This is a personal project, but feel free to fork and customize for your needs!

---

**Need Help?** If you encounter issues during setup, make sure:
1. You're using the latest version of Xcode
2. Your devices are running compatible OS versions
3. You've granted all necessary permissions
4. Your Apple Developer account is properly configured
