//
//  BatteryAlertApp.swift
//  BatteryAlert (watchOS)
//
//  Main app entry point for Apple Watch
//

import SwiftUI

@main
struct BatteryAlertApp: App {
    @StateObject private var batteryMonitor = BatteryMonitor()
    
    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environmentObject(batteryMonitor)
        }
    }
}
