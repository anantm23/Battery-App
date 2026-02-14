//
//  WatchContentView.swift
//  BatteryAlert (watchOS)
//
//  Main user interface for Apple Watch
//

import SwiftUI

struct WatchContentView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Battery ring
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(batteryMonitor.batteryLevel) / 100)
                            .stroke(
                                batteryColor,
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut, value: batteryMonitor.batteryLevel)
                        
                        VStack(spacing: 4) {
                            Text("\(batteryMonitor.batteryLevel)%")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                            
                            if batteryMonitor.isCharging {
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(width: 120, height: 120)
                    .padding(.top)
                    
                    // Status
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: batteryMonitor.isCharging ? "bolt.fill" : "bolt.slash.fill")
                                .foregroundColor(batteryMonitor.isCharging ? .yellow : .gray)
                            Text(batteryMonitor.isCharging ? "Charging" : "Not Charging")
                                .font(.caption)
                        }
                        
                        Text("Alert at \(batteryMonitor.settings.alertThreshold)%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Settings button
                    NavigationLink(destination: WatchSettingsView()) {
                        Label("Settings", systemImage: "gearshape.fill")
                            .font(.footnote)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Battery")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var batteryColor: Color {
        let level = batteryMonitor.batteryLevel
        if level >= batteryMonitor.settings.alertThreshold {
            return .green
        } else if level >= 20 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct WatchSettingsView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    @State private var threshold: Double
    @State private var isEnabled: Bool
    @State private var soundEnabled: Bool
    @State private var vibrationEnabled: Bool
    
    init() {
        let settings = BatterySettings.load()
        _threshold = State(initialValue: Double(settings.alertThreshold))
        _isEnabled = State(initialValue: settings.isEnabled)
        _soundEnabled = State(initialValue: settings.soundEnabled)
        _vibrationEnabled = State(initialValue: settings.vibrationEnabled)
    }
    
    var body: some View {
        List {
            Section {
                Toggle("Enable Alerts", isOn: $isEnabled)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Threshold")
                        Spacer()
                        Text("\(Int(threshold))%")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    
                    Slider(value: $threshold, in: 1...100, step: 1)
                }
            } header: {
                Text("Alert Level")
            }
            
            Section {
                Toggle("Sound", isOn: $soundEnabled)
                Toggle("Haptic", isOn: $vibrationEnabled)
            } header: {
                Text("Alerts")
            }
            
            Section {
                Button("Save") {
                    saveSettings()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Settings")
    }
    
    private func saveSettings() {
        var newSettings = batteryMonitor.settings
        newSettings.alertThreshold = Int(threshold)
        newSettings.isEnabled = isEnabled
        newSettings.soundEnabled = soundEnabled
        newSettings.vibrationEnabled = vibrationEnabled
        batteryMonitor.updateSettings(newSettings)
    }
}

struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchContentView()
            .environmentObject(BatteryMonitor())
    }
}
