# Project Structure

```
BatteryAlert/
│
├── README.md                          # Project overview and features
├── SETUP_GUIDE.md                     # Detailed setup instructions
├── QUICK_REFERENCE.md                 # User guide and troubleshooting
│
├── BatteryAlert/
│   │
│   ├── Shared/                        # Code shared across all platforms
│   │   ├── Models/
│   │   │   └── BatterySettings.swift  # Settings data model
│   │   │
│   │   └── ViewModels/
│   │       └── BatteryMonitor.swift   # Core battery monitoring logic
│   │
│   ├── iOS/                           # iOS/iPadOS specific code
│   │   ├── BatteryAlertApp.swift      # iOS app entry point
│   │   ├── ContentView.swift          # Main iOS UI
│   │   └── Info.plist                 # iOS configuration
│   │
│   ├── macOS/                         # macOS specific code
│   │   ├── BatteryAlertApp.swift      # macOS app entry point
│   │   ├── MenuBarView.swift          # Menu bar UI
│   │   └── Info.plist                 # macOS configuration
│   │
│   └── watchOS/                       # Apple Watch specific code
│       ├── BatteryAlertApp.swift      # watchOS app entry point
│       ├── WatchContentView.swift     # Watch UI
│       └── Info.plist                 # watchOS configuration
│
└── Screenshots/                       # UI mockups (generated)
    ├── ios_battery_app.png
    ├── macos_menu_bar.png
    └── watchos_battery_app.png
```

## File Descriptions

### Shared Components

#### `BatterySettings.swift`
- Data model for app settings
- Handles persistence via UserDefaults
- Properties:
  - `alertThreshold`: Battery percentage to alert at
  - `isEnabled`: Whether alerts are active
  - `soundEnabled`: Play sound with alerts
  - `vibrationEnabled`: Haptic feedback (iOS/watchOS)
  - `hasAlertedForCurrentCharge`: Prevents duplicate alerts

#### `BatteryMonitor.swift`
- Core business logic
- Platform-specific battery monitoring
- Notification handling
- Observable object for SwiftUI
- Key methods:
  - `startMonitoring()`: Begins battery monitoring
  - `updateBatteryStatus()`: Reads current battery state
  - `checkAndAlert()`: Triggers alerts when threshold reached
  - `sendNotification()`: Creates and sends notifications

### iOS/iPadOS

#### `BatteryAlertApp.swift` (iOS)
- SwiftUI app entry point
- Initializes BatteryMonitor
- Sets up environment

#### `ContentView.swift`
- Main user interface
- Battery visualization
- Settings sheet
- Components:
  - `ContentView`: Main screen
  - `BatteryView`: Visual battery indicator
  - `SettingsView`: Configuration panel

### macOS

#### `BatteryAlertApp.swift` (macOS)
- Menu bar app entry point
- App delegate for background running
- MenuBarExtra integration

#### `MenuBarView.swift`
- Menu bar dropdown UI
- Quick status display
- Settings window
- Components:
  - `MenuBarView`: Dropdown menu
  - `BatteryIndicator`: Visual battery bar
  - `MacSettingsView`: Settings window

### watchOS

#### `BatteryAlertApp.swift` (watchOS)
- Watch app entry point
- Initializes monitoring

#### `WatchContentView.swift`
- Compact watch interface
- Circular battery ring
- Settings view
- Components:
  - `WatchContentView`: Main screen
  - `WatchSettingsView`: Settings panel

## Code Architecture

### Design Patterns

1. **MVVM (Model-View-ViewModel)**
   - Model: `BatterySettings`
   - ViewModel: `BatteryMonitor`
   - View: Platform-specific views

2. **Observer Pattern**
   - `BatteryMonitor` is `ObservableObject`
   - Views observe via `@EnvironmentObject`
   - Automatic UI updates on state changes

3. **Singleton Pattern**
   - `BatterySettings.shared` for default settings
   - Single instance of `BatteryMonitor` per app

### Data Flow

```
User Action → View → BatteryMonitor → BatterySettings → UserDefaults
                ↓
         Notification System
                ↓
            User Alert
```

### Platform Abstraction

```swift
#if os(iOS)
    // iOS-specific code
#elseif os(macOS)
    // macOS-specific code
#elseif os(watchOS)
    // watchOS-specific code
#endif
```

## Key Technologies

### Frameworks Used

- **SwiftUI**: Modern declarative UI
- **Combine**: Reactive programming
- **UserNotifications**: Alert system
- **UIKit** (iOS): Battery monitoring
- **IOKit** (macOS): Power source info
- **WatchKit** (watchOS): Device info

### APIs

- `UIDevice.batteryLevel` (iOS)
- `IOPSCopyPowerSourcesInfo` (macOS)
- `WKInterfaceDevice.batteryLevel` (watchOS)
- `UNUserNotificationCenter` (all platforms)

## Building the Project

### Xcode Project Setup

1. Create multiplatform app project
2. Add source files to appropriate targets
3. Configure Info.plist for each platform
4. Set deployment targets:
   - iOS: 15.0+
   - macOS: 12.0+
   - watchOS: 8.0+

### Target Configuration

Each platform needs:
- Correct source files
- Info.plist settings
- Capabilities (notifications, background modes)
- Code signing

### Dependencies

None! This is a pure Swift project with no external dependencies.

## Testing

### Manual Testing Checklist

- [ ] Battery level updates correctly
- [ ] Charging state detected
- [ ] Alert triggers at threshold
- [ ] Only one alert per charge cycle
- [ ] Settings persist across launches
- [ ] Notifications appear
- [ ] Sound/haptic works (if enabled)
- [ ] Background monitoring works

### Platform-Specific Testing

**iOS**:
- [ ] Works when app is backgrounded
- [ ] Lock screen notifications
- [ ] Haptic feedback

**macOS**:
- [ ] Menu bar icon appears
- [ ] Dropdown shows correct info
- [ ] Runs in background

**watchOS**:
- [ ] Circular progress updates
- [ ] Haptic alerts work
- [ ] Settings save correctly

## Customization Guide

### Changing Default Threshold

In `BatterySettings.swift`:
```swift
var alertThreshold: Int = 80  // Change to desired default
```

### Adjusting Threshold Range

In settings views, modify:
```swift
Slider(value: $threshold, in: 50...95, step: 5)
// Change range: 50...95 to your desired min...max
```

### Changing Update Frequency

In `BatteryMonitor.swift`:
```swift
timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true)
// Change 30.0 to desired seconds
```

### Custom Alert Sounds

1. Add sound file to project
2. In `sendNotification()`:
```swift
content.sound = UNNotificationSound(named: UNNotificationSoundName("your_sound.wav"))
```

## Performance Considerations

### Battery Impact
- **iOS**: Minimal (uses system notifications)
- **macOS**: ~0.1% CPU (30-second polling)
- **watchOS**: Minimal (efficient polling)

### Memory Usage
- Small footprint (~5-10 MB)
- No memory leaks (proper cleanup in deinit)

### Optimization Tips
- Use longer polling intervals if needed
- Disable monitoring when not charging (future enhancement)
- Use background tasks efficiently

## Security & Privacy

### Data Collection
- **None**: No analytics or tracking
- **Local Only**: All data stays on device
- **No Network**: No internet connection needed

### Permissions
- Notifications: Required for alerts
- Background: iOS only, for monitoring

### User Data
- Settings stored in UserDefaults
- No personal information collected
- No iCloud sync (could be added)

## Troubleshooting Development Issues

### Build Errors

**"Cannot find type 'BatteryMonitor'"**
- Check target membership of files
- Ensure shared files are included in all targets

**Code signing errors**
- Select development team in project settings
- Check bundle identifiers are unique

### Runtime Issues

**Battery level always 0**
- iOS: Check `isBatteryMonitoringEnabled = true`
- macOS: Verify IOKit framework is linked

**Notifications not appearing**
- Check Info.plist has notification usage description
- Verify permissions granted in system settings

## Future Development

### Planned Features
1. iCloud sync for settings
2. Widget support (iOS/macOS)
3. Shortcuts integration
4. Historical data tracking
5. Battery health metrics
6. Custom alert sounds
7. Multiple threshold profiles

### Potential Improvements
- Reduce polling frequency when not charging
- Add battery health predictions
- Integrate with Apple Health (if applicable)
- Add complications for watchOS
- Support for multiple notification styles

---

**Last Updated**: January 2026  
**Swift Version**: 5.9+  
**Xcode Version**: 14.0+
