# 🔋 Battery Alert - Apple Ecosystem App

<div align="center">

**Never overcharge your devices again!**

A beautiful, native app for iPhone, iPad, Mac, and Apple Watch that alerts you when your battery reaches your desired threshold (default: 80%) to help preserve battery health.

[Get Started](#-quick-start) • [Features](#-features) • [Documentation](#-documentation) • [Screenshots](#-app-previews)

</div>

---

## 🎯 Why Battery Alert?

**The Problem**: Charging your devices to 100% regularly degrades battery health over time, reducing lifespan by years.

**The Solution**: Battery Alert monitors your device and notifies you when it reaches your optimal charge level (typically 80%), helping you maintain battery health at 90%+ for longer.

**The Result**: Extended battery lifespan, better performance, and money saved on replacements!

## ⚡ Features

### 🔋 Smart Monitoring
- **Real-time tracking** of battery level and charging state
- **Background monitoring** - works even when app is closed
- **One alert per cycle** - won't spam you with notifications
- **Platform-optimized** - native APIs for each device

### 🎨 Beautiful Design
- **iOS/iPadOS**: Stunning gradient UI with glassmorphism effects
- **macOS**: Clean menu bar app that stays out of your way
- **watchOS**: Circular battery ring optimized for small screen
- **Dark mode** optimized across all platforms

### ⚙️ Customizable
- **Adjustable threshold** (50-95%, default 80%)
- **Toggle alerts** on/off as needed
- **Sound & haptic** options
- **Settings persist** across app launches

### 🔒 Privacy First
- **No data collection** - zero analytics or tracking
- **No internet required** - works completely offline
- **Local only** - all processing on your device
- **Open source** - see exactly what it does

## 📱 Platform Support

| Platform | Version | Status |
|----------|---------|--------|
| 📱 iPhone & iPad | iOS 15.0+ | ✅ Full Support |
| 💻 Mac | macOS 12.0+ | ✅ Full Support |
| ⌚ Apple Watch | watchOS 8.0+ | ✅ Full Support |

## 🚀 Quick Start

### Option 1: Detailed Setup (All Platforms)
**→ See [SETUP_GUIDE.md](SETUP_GUIDE.md)** for complete Xcode setup instructions

### Option 2: Quick Start (iOS Only)
**→ See [GETTING_STARTED.md](GETTING_STARTED.md)** for simplified iOS-only version

### 3-Minute Setup
1. Open Xcode and create a new Multiplatform App
2. Copy the source files from `BatteryAlert/` folder
3. Build and run (⌘R)

**That's it!** Full instructions in the setup guides above.

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** | 📋 Complete overview of everything |
| **[SETUP_GUIDE.md](SETUP_GUIDE.md)** | 🛠️ Detailed Xcode setup for all platforms |
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | 🎓 Simplified guide for beginners |
| **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** | 📖 User guide & troubleshooting |
| **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** | 🏗️ Architecture & development guide |

## 🎨 App Previews

### iOS/iPadOS
Beautiful gradient interface with battery visualization and smooth animations.

### macOS
Clean menu bar app with quick status view and settings.

### Apple Watch
Circular battery ring with haptic alerts, optimized for wrist.

## 📁 Project Structure

```
BatteryAlert/
├── Shared/
│   ├── Models/
│   │   └── BatterySettings.swift      # Settings & persistence
│   └── ViewModels/
│       └── BatteryMonitor.swift       # Core monitoring logic
├── iOS/
│   ├── BatteryAlertApp.swift          # iOS entry point
│   ├── ContentView.swift              # iOS UI
│   └── Info.plist                     # iOS configuration
├── macOS/
│   ├── BatteryAlertApp.swift          # macOS entry point
│   ├── MenuBarView.swift              # Menu bar UI
│   └── Info.plist                     # macOS configuration
└── watchOS/
    ├── BatteryAlertApp.swift          # watchOS entry point
    ├── WatchContentView.swift         # Watch UI
    └── Info.plist                     # watchOS configuration
```

## 🔧 How It Works

1. **Plug in your device** - Start charging normally
2. **App monitors** - Tracks battery level in background
3. **Alert at threshold** - Get notified when you hit 80% (or your custom level)
4. **Unplug and enjoy** - Extended battery lifespan!

### Technical Details

- **iOS**: Uses `UIDevice.batteryLevel` with system notifications
- **macOS**: Uses `IOKit` framework with 30-second polling
- **watchOS**: Uses `WKInterfaceDevice` with efficient monitoring
- **Notifications**: `UserNotifications` framework for all platforms

## 🔋 Battery Health Benefits

### Why 80%?
Lithium-ion batteries last significantly longer when kept between 20-80%. Charging to 100% regularly causes:
- Faster capacity degradation
- Reduced overall lifespan
- Lower maximum charge over time

### Real Impact
- **2-3 years** extended battery lifespan
- **90%+ health** maintained longer
- **$69-99 saved** on battery replacement
- **Better for environment** - fewer replacements needed

## 🛠️ Requirements

### For Building
- Mac with macOS Ventura (13.0) or later
- Xcode 14.0 or later
- Apple Developer account (free tier works!)

### For Running
- iPhone/iPad with iOS 15.0+
- Mac with macOS 12.0+
- Apple Watch with watchOS 8.0+

**Note**: You can test on simulators without physical devices!

## 💡 Usage Tips

### Daily Use
- Set threshold to 80% for regular charging
- Charge to 100% only when needed (travel, long day)
- Combine with iOS/macOS "Optimized Battery Charging"

### Best Practices
1. Keep battery between 20-80% most of the time
2. Avoid extreme temperatures while charging
3. Charge to 100% once a month for calibration
4. Use this app + system optimized charging for best results

## 🐛 Troubleshooting

**Not receiving alerts?**
- Check notification permissions in Settings
- Verify alerts are enabled in app
- Make sure device is charging

**Battery level shows 0%?**
- Restart the app
- Check battery monitoring is enabled

**More help?** See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for detailed troubleshooting.

## 🚀 Future Enhancements

Planned features:
- [ ] iCloud sync for settings across devices
- [ ] Widget support (iOS/macOS)
- [ ] Shortcuts integration
- [ ] Historical battery data
- [ ] Battery health metrics
- [ ] Custom alert sounds
- [ ] Low battery alerts (below 20%)
- [ ] Charging time estimates

## 🤝 Contributing

This is an open-source project! Feel free to:
- Fork and customize for your needs
- Submit improvements
- Report issues
- Share with others

## 📄 License

**MIT License** - Free to use, modify, and distribute!

See the LICENSE file for details.

## 🙏 Acknowledgments

Built with:
- **SwiftUI** - Apple's modern UI framework
- **Combine** - Reactive programming
- **Native APIs** - Platform-specific battery monitoring
- **Love for batteries** - And the environment! 🌱

---

<div align="center">

**Ready to extend your battery life?**

[Get Started Now](SETUP_GUIDE.md) • [Read the Docs](PROJECT_SUMMARY.md) • [Quick Start](GETTING_STARTED.md)

Made with ⚡ for battery health

</div>
