# Battery Alert - Quick Reference

## 🎯 What This App Does

Battery Alert is a native Apple ecosystem app that monitors your device's battery level and alerts you when it reaches your desired threshold (default: 80%). This helps preserve battery health by preventing overcharging to 100%.

## 📱 Supported Platforms

- **iPhone & iPad** (iOS/iPadOS 15.0+)
- **Mac** (macOS 12.0+)
- **Apple Watch** (watchOS 8.0+)

## ⚡ Key Features

### Real-Time Monitoring
- Continuously monitors battery level
- Detects charging state changes
- Works in background (iOS/macOS)

### Smart Alerts
- Notification when threshold reached
- Sound alerts (customizable)
- Haptic feedback (iOS/watchOS)
- Only alerts once per charge cycle

### Customizable Settings
- Adjustable threshold (50-95%)
- Toggle alerts on/off
- Control sound/vibration
- Settings persist across launches

### Platform-Specific Features

#### iOS/iPadOS
- Beautiful gradient UI with glassmorphism
- Battery visualization
- Background monitoring
- Lock screen notifications

#### macOS
- Menu bar integration
- Always-on monitoring
- System notifications
- Minimal resource usage

#### watchOS
- Circular battery ring
- Haptic alerts
- Standalone operation
- Optimized for small screen

## 🔔 How Alerts Work

1. **Charging Detected**: App monitors battery level
2. **Threshold Reached**: When battery hits your set percentage (e.g., 80%)
3. **Alert Triggered**: You receive:
   - Push notification
   - Sound (if enabled)
   - Vibration/haptic (if enabled)
4. **One Alert Per Cycle**: Won't alert again until you unplug and replug

## ⚙️ Settings Explained

### Alert Threshold
- **Range**: 50% - 95%
- **Default**: 80%
- **Recommended**: 80% for optimal battery health
- **Step**: 5% increments

### Enable Alerts
- Turn monitoring on/off
- Useful when you occasionally need 100% charge

### Sound
- Play system sound with notification
- Uses critical alert sound (iOS)

### Vibration/Haptic
- Physical feedback when alert triggers
- Repeats 3 times on iOS for emphasis

## 🔋 Battery Health Tips

### Why 80%?
- Lithium-ion batteries last longer when kept between 20-80%
- Charging to 100% regularly can reduce battery lifespan
- Heat during charging + full charge = faster degradation

### Best Practices
1. **Charge to 80%** for daily use
2. **Charge to 100%** only when needed (travel, long day)
3. **Avoid deep discharges** (below 20%)
4. **Use optimized charging** (iOS/macOS built-in feature)
5. **Avoid extreme temperatures** while charging

### When to Charge to 100%
- Before long trips
- When you need maximum battery life
- Once a month for battery calibration

## 📊 Usage Scenarios

### Daily Use
```
1. Plug in device
2. App monitors in background
3. Alert at 80%
4. Unplug device
5. Use throughout day
```

### Overnight Charging (Not Recommended)
```
Better approach:
1. Use iOS/macOS "Optimized Battery Charging"
2. Or use this app and wake up to unplug at 80%
```

### Work/Study Session
```
1. Plug in at desk
2. Get alert when ready
3. Unplug and continue on battery
4. Extends battery lifespan
```

## 🎨 UI Overview

### iOS/iPadOS
- **Main Screen**: Battery visualization, current level, charging status
- **Settings**: Threshold slider, toggle options, battery tips
- **Colors**: 
  - Green: Above threshold
  - Yellow: 20-79%
  - Red: Below 20%

### macOS
- **Menu Bar Icon**: Bolt symbol
- **Dropdown**: Quick status view
- **Settings Window**: Full configuration options

### watchOS
- **Main Screen**: Circular battery ring
- **Settings**: Compact configuration
- **Complications**: (Future feature)

## 🔧 Troubleshooting

### Not Receiving Alerts?

**Check Permissions**
- iOS: Settings → Notifications → Battery Alert → Allow Notifications
- macOS: System Settings → Notifications → Battery Alert → Allow Notifications

**Check App Settings**
- Open app
- Verify "Enable Alerts" is ON
- Check threshold is set correctly

**Check Battery State**
- Must be charging
- Must reach threshold
- Only alerts once per charge cycle

### Battery Level Shows 0% or -1%

**iOS**: 
- Restart the app
- Check battery monitoring is enabled in code

**macOS**: 
- Some Macs without batteries will show 0%
- App designed for MacBooks with batteries

### App Draining Battery?

**Normal Behavior**:
- iOS: Minimal impact (uses system notifications)
- macOS: Very low CPU usage (checks every 30 seconds)
- watchOS: Minimal impact

**If Excessive**:
- Check for infinite loops in code
- Verify timer intervals are correct
- Use Xcode Instruments to profile

## 📱 Platform Differences

| Feature | iOS/iPadOS | macOS | watchOS |
|---------|-----------|-------|---------|
| Background Monitoring | ✅ | ✅ | Limited |
| Notifications | ✅ | ✅ | ✅ |
| Haptic Feedback | ✅ | ❌ | ✅ |
| Menu Bar | ❌ | ✅ | ❌ |
| Always Running | Background | Yes | Recent Apps |

## 🚀 Advanced Tips

### For Developers

**Customizing Alert Threshold**
- Edit `BatterySettings.swift`
- Change default value or range

**Adding Custom Sounds**
- Add sound file to project
- Modify `sendNotification()` in `BatteryMonitor.swift`

**Changing Update Frequency**
- iOS: Uses system notifications (automatic)
- macOS/watchOS: Modify timer interval in `startMonitoring()`

### For Power Users

**Multiple Devices**
- Install on all devices
- Set same threshold for consistency
- Each device monitors independently

**Automation (Future)**
- Could integrate with Shortcuts
- Trigger actions when alert fires
- Log battery data

## 📈 Future Enhancements

Planned features:
- [ ] iCloud sync for settings
- [ ] Historical battery data
- [ ] Battery health metrics
- [ ] Custom alert sounds
- [ ] Widget support
- [ ] Shortcuts integration
- [ ] Low battery alerts
- [ ] Charging time estimates

## 💡 Pro Tips

1. **Set and Forget**: Configure once, works automatically
2. **Calibrate Monthly**: Charge to 100% once a month
3. **Use Optimized Charging**: Enable in iOS/macOS settings
4. **Monitor Battery Health**: Check Settings → Battery → Battery Health
5. **Combine Methods**: Use this app + system optimized charging

## 📞 Support

### Common Questions

**Q: Will this work if the app is closed?**
A: 
- iOS: Yes, uses background monitoring
- macOS: Must be running (menu bar app)
- watchOS: Must be in recent apps

**Q: Does it work with wireless charging?**
A: Yes, works with any charging method

**Q: Can I set different thresholds for different devices?**
A: Yes, settings are per-device

**Q: Will it alert me every time?**
A: Only once per charge cycle (until you unplug)

## 📄 Technical Details

### Battery Monitoring APIs
- **iOS**: `UIDevice.current.batteryLevel`
- **macOS**: `IOKit` framework
- **watchOS**: `WKInterfaceDevice.current().batteryLevel`

### Update Frequency
- **iOS**: Real-time (system notifications)
- **macOS**: Every 30 seconds
- **watchOS**: Every 30 seconds

### Permissions Required
- User Notifications (all platforms)
- Background Processing (iOS only)

### Data Storage
- Settings stored in `UserDefaults`
- No cloud storage (privacy-first)
- No analytics or tracking

---

**Version**: 1.0  
**Last Updated**: January 2026  
**License**: MIT
