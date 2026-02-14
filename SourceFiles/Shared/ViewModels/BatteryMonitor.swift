//
//  BatteryMonitor.swift
//  BatteryAlert
//
//  Core battery monitoring logic shared across platforms
//

import Foundation
import Combine
import UserNotifications

#if os(iOS)
import UIKit
#elseif os(macOS)
import IOKit.ps
#elseif os(watchOS)
import WatchKit
#endif

class BatteryMonitor: ObservableObject {
    @Published var batteryLevel: Int = 0
    @Published var isCharging: Bool = false
    @Published var settings: BatterySettings
    @Published var estimatedMinutesToThreshold: Int? = nil
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var lastLevelSample: (level: Int, date: Date)?
    private var recentRates: [Double] = []
    private let maxRateSamples = 6
    
    init() {
        self.settings = BatterySettings.load()
        setupNotifications()
        startMonitoring()
    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func startMonitoring() {
        #if os(iOS)
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Initial update
        updateBatteryStatus()
        
        // Monitor battery level changes
        NotificationCenter.default.addObserver(
            forName: UIDevice.batteryLevelDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateBatteryStatus()
        }
        
        // Monitor charging state changes
        NotificationCenter.default.addObserver(
            forName: UIDevice.batteryStateDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateBatteryStatus()
        }
        #else
        // For macOS and watchOS, use timer-based polling
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.updateBatteryStatus()
        }
        timer?.fire() // Initial update
        #endif
    }
    
    private func updateBatteryStatus() {
        #if os(iOS)
        let level = BatteryMonitor.normalizedPercent(UIDevice.current.batteryLevel) ?? batteryLevel
        let charging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
        #elseif os(macOS)
        let (level, charging) = getMacOSBatteryInfo()
        #elseif os(watchOS)
        let level = BatteryMonitor.normalizedPercent(WKInterfaceDevice.current().batteryLevel) ?? batteryLevel
        let charging = WKInterfaceDevice.current().batteryState == .charging
        #endif
        
        DispatchQueue.main.async {
            let wasCharging = self.isCharging
            self.batteryLevel = level
            self.isCharging = charging
            
            // Reset alert flag when unplugged
            if !charging && self.settings.hasAlertedForCurrentCharge {
                self.settings.hasAlertedForCurrentCharge = false
                self.settings.save()
            }
            
            self.updateChargeEstimate(wasCharging: wasCharging)
            
            // Check if we should alert
            self.checkAndAlert()
        }
    }
    
    private static func normalizedPercent(_ deviceLevel: Float) -> Int? {
        // batteryLevel can be -1.0 when unknown; clamp and round for consistent UI.
        if deviceLevel < 0 {
            return nil
        }
        let raw = max(0.0, min(1.0, Double(deviceLevel)))
        return Int((raw * 100.0).rounded())
    }
    
    private func updateChargeEstimate(wasCharging: Bool) {
        if !isCharging {
            lastLevelSample = nil
            recentRates.removeAll()
            estimatedMinutesToThreshold = nil
            return
        }
        
        let now = Date()
        
        if !wasCharging {
            // Reset sampling when charging starts
            lastLevelSample = (batteryLevel, now)
            recentRates.removeAll()
        } else if let last = lastLevelSample {
            if batteryLevel > last.level {
                let deltaLevel = batteryLevel - last.level
                let deltaMinutes = now.timeIntervalSince(last.date) / 60.0
                if deltaMinutes > 0 {
                    let rate = Double(deltaLevel) / deltaMinutes
                    recentRates.append(rate)
                    if recentRates.count > maxRateSamples {
                        recentRates.removeFirst()
                    }
                }
                lastLevelSample = (batteryLevel, now)
            } else if batteryLevel < last.level {
                // Battery dipped while charging; reset estimate
                lastLevelSample = (batteryLevel, now)
                recentRates.removeAll()
            }
        } else {
            lastLevelSample = (batteryLevel, now)
        }
        
        updateRemainingEstimate()
    }
    
    private func updateRemainingEstimate() {
        guard isCharging else {
            estimatedMinutesToThreshold = nil
            return
        }
        guard batteryLevel < settings.alertThreshold else {
            estimatedMinutesToThreshold = 0
            return
        }
        guard !recentRates.isEmpty else {
            estimatedMinutesToThreshold = nil
            return
        }
        
        let averageRate = recentRates.reduce(0.0, +) / Double(recentRates.count)
        guard averageRate > 0.01 else {
            estimatedMinutesToThreshold = nil
            return
        }
        
        let remaining = Double(settings.alertThreshold - batteryLevel) / averageRate
        estimatedMinutesToThreshold = Int(ceil(remaining))
    }
    
    #if os(macOS)
    private func getMacOSBatteryInfo() -> (level: Int, charging: Bool) {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        guard let source = sources.first else {
            return (0, false)
        }
        
        let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as! [String: AnyObject]
        
        let capacity = description[kIOPSCurrentCapacityKey] as? Int ?? 0
        let isCharging = description[kIOPSIsChargingKey] as? Bool ?? false
        
        return (capacity, isCharging)
    }
    #endif
    
    private func checkAndAlert() {
        guard settings.isEnabled,
              isCharging,
              batteryLevel >= settings.alertThreshold,
              !settings.hasAlertedForCurrentCharge else {
            return
        }
        
        // Mark that we've alerted for this charge cycle
        settings.hasAlertedForCurrentCharge = true
        settings.save()
        
        // Trigger notification
        sendNotification()
        
        // Play sound/vibration
        if settings.soundEnabled || settings.vibrationEnabled {
            playAlert()
        }
    }
    
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Battery Alert! 🔋"
        content.body = "Your battery has reached \(batteryLevel)%. Time to unplug!"
        // Use standard sound to avoid critical alert entitlement requirements.
        content.sound = settings.soundEnabled ? .default : nil
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Immediate delivery
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func playAlert() {
        #if os(iOS)
        if settings.vibrationEnabled {
            // Play haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            // Repeat vibration for emphasis
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                generator.notificationOccurred(.warning)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                generator.notificationOccurred(.warning)
            }
        }
        #endif
    }
    
    func updateSettings(_ newSettings: BatterySettings) {
        var normalized = newSettings
        normalized.alertThreshold = BatterySettings.clampThreshold(normalized.alertThreshold)
        self.settings = normalized
        self.settings.save()
        updateRemainingEstimate()
    }
    
    deinit {
        timer?.invalidate()
        #if os(iOS)
        NotificationCenter.default.removeObserver(self)
        #endif
    }
}
