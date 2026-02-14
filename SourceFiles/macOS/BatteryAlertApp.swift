//
//  BatteryAlertApp.swift
//  BatteryAlert (macOS)
//
//  Main app entry point for macOS
//

import SwiftUI
import AppKit

@main
struct BatteryAlertApp: App {
    @StateObject private var batteryMonitor = BatteryMonitor()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Battery Alert", systemImage: "bolt.fill") {
            MenuBarView()
                .environmentObject(batteryMonitor)
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Keep app running in background
        NSApp.setActivationPolicy(.accessory)
    }
}
