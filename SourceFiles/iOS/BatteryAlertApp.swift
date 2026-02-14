//
//  BatteryAlertApp.swift
//  BatteryAlert (iOS)
//
//  Main app entry point for iOS/iPadOS
//

import SwiftUI

@main
struct BatteryAlertApp: App {
    @StateObject private var batteryMonitor = BatteryMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(batteryMonitor)
        }
    }
}
