# Getting Started - Simplified iOS-Only Version

If you want to start with just an iPhone/iPad app first, here's a simplified approach:

## Quick Start (iOS Only)

### Option 1: Using Xcode (Recommended)

1. **Open Xcode** (download from Mac App Store if needed)

2. **Create New Project**
   - File → New → Project
   - Choose "iOS" → "App"
   - Product Name: `BatteryAlert`
   - Interface: SwiftUI
   - Language: Swift

3. **Replace Default Files**
   - Delete the default `ContentView.swift` and `BatteryAlertApp.swift`
   - Add these files from the project:
     - `Shared/Models/BatterySettings.swift`
     - `Shared/ViewModels/BatteryMonitor.swift`
     - `iOS/BatteryAlertApp.swift`
     - `iOS/ContentView.swift`

4. **Update Info.plist**
   - Select your project → Info tab
   - Add key: `NSUserNotificationsUsageDescription`
   - Value: `Battery Alert needs notification permission to alert you when your battery reaches the set threshold.`
   - Add key: `UIBackgroundModes` (Array)
     - Add item: `processing`

5. **Build and Run**
   - Connect your iPhone/iPad OR use simulator
   - Click the Run button (⌘R)
   - Grant notification permissions when prompted

### Option 2: Using Swift Playgrounds (iPad Only)

If you have an iPad but no Mac:

1. **Install Swift Playgrounds** from App Store

2. **Create New App**

3. **Copy the Code**
   - You'll need to combine the files into a single app
   - Start with the iOS files
   - Add the shared code

4. **Run on iPad**

## Testing Your App

### Simulate Battery Changes

Since you can't easily change real battery level for testing:

1. **Use Simulator** (Xcode)
   - Features → Battery → Set to 75%
   - Features → Battery → Charging

2. **Test on Real Device**
   - Plug in your device
   - Set threshold to current level - 5%
   - Wait for battery to charge

### Quick Test

To verify the app works:

1. Set threshold to 50%
2. Plug in device when battery is below 50%
3. Wait for it to charge past 50%
4. You should get an alert!

## Customization Ideas

### Change Colors

In `ContentView.swift`, modify the gradient:

```swift
LinearGradient(
    gradient: Gradient(colors: [
        Color(hue: 0.55, saturation: 0.8, brightness: 0.3),  // Change these
        Color(hue: 0.6, saturation: 0.6, brightness: 0.2)    // values
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Change Default Threshold

In `BatterySettings.swift`:

```swift
var alertThreshold: Int = 80  // Change to 75, 85, etc.
```

### Add Custom Alert Sound

1. Add a sound file (.wav or .caf) to your project
2. In `BatteryMonitor.swift`, modify `sendNotification()`:

```swift
content.sound = UNNotificationSound(named: UNNotificationSoundName("your_sound.wav"))
```

## Common Issues & Solutions

### "App won't build"

**Error**: Cannot find type 'BatteryMonitor'
- **Solution**: Make sure all Swift files are added to your target
- Right-click file → Target Membership → Check your app

**Error**: Code signing error
- **Solution**: Xcode → Settings → Accounts → Sign in with Apple ID
- Project → Signing & Capabilities → Select your team

### "Notifications not working"

**Check 1**: Did you grant permission?
- Settings → Notifications → Battery Alert → Allow Notifications

**Check 2**: Is the usage description in Info.plist?
- Add `NSUserNotificationsUsageDescription` key

**Check 3**: Is the device charging?
- Alerts only trigger when charging

### "Battery level shows -1 or 0"

**Solution**: Add this to `BatteryMonitor.swift` in `startMonitoring()`:

```swift
UIDevice.current.isBatteryMonitoringEnabled = true
```

This should already be there, but double-check!

## Next Steps

Once you have the iOS version working:

1. **Test thoroughly** on your iPhone/iPad
2. **Customize** the UI to your liking
3. **Add macOS version** (if you have a MacBook)
4. **Add watchOS version** (if you have an Apple Watch)

## Alternative: Even Simpler Version

If you want an even simpler version to start, here's a minimal single-file app:

### SingleFileApp.swift

```swift
import SwiftUI
import UserNotifications
import UIKit

@main
struct BatteryAlertApp: App {
    var body: some Scene {
        WindowGroup {
            SimpleBatteryView()
        }
    }
}

struct SimpleBatteryView: View {
    @State private var batteryLevel: Int = 0
    @State private var isCharging: Bool = false
    @State private var threshold: Int = 80
    
    var body: some View {
        VStack(spacing: 30) {
            Text("\(batteryLevel)%")
                .font(.system(size: 72, weight: .bold))
            
            Text(isCharging ? "⚡ Charging" : "🔋 Not Charging")
                .font(.title2)
            
            Stepper("Alert at \(threshold)%", value: $threshold, in: 50...95, step: 5)
                .padding()
            
            Button("Start Monitoring") {
                startMonitoring()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            requestNotificationPermission()
            updateBattery()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    func startMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            updateBattery()
        }
    }
    
    func updateBattery() {
        batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        isCharging = UIDevice.current.batteryState == .charging
        
        if isCharging && batteryLevel >= threshold {
            sendAlert()
        }
    }
    
    func sendAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Battery Alert!"
        content.body = "Your battery has reached \(batteryLevel)%"
        content.sound = .defaultCritical
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
```

This is a **super simple** version that:
- Shows battery level
- Lets you set threshold
- Sends alerts when reached
- All in one file!

## Resources

### Learning SwiftUI
- [Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui)

### Battery Monitoring
- [UIDevice Documentation](https://developer.apple.com/documentation/uikit/uidevice)
- [User Notifications](https://developer.apple.com/documentation/usernotifications)

### Getting Help
- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftui)

## Tips for Success

1. **Start Simple**: Get the basic version working first
2. **Test Often**: Run the app frequently while developing
3. **Read Errors**: Xcode's error messages are usually helpful
4. **Use Simulator**: Faster than deploying to device each time
5. **Ask for Help**: Developer community is very helpful!

---

Good luck with your battery monitoring app! 🔋⚡
