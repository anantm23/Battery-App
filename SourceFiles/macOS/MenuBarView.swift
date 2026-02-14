//
//  MenuBarView.swift
//  BatteryAlert (macOS)
//
//  Menu bar interface for macOS
//

import SwiftUI
import AppKit

struct MenuBarView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Battery Alert")
                        .font(.headline)
                    
                    Spacer()
                }
                
                Divider()
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
            
            // Battery status
            VStack(spacing: 16) {
                // Battery level
                HStack {
                    Text("Battery Level")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(batteryMonitor.batteryLevel)%")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(batteryColor)
                }
                
                // Charging status
                HStack {
                    Text("Status")
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: batteryMonitor.isCharging ? "bolt.fill" : "bolt.slash.fill")
                            .foregroundColor(batteryMonitor.isCharging ? .yellow : .gray)
                        Text(batteryMonitor.isCharging ? "Charging" : "Not Charging")
                            .font(.subheadline)
                    }
                }
                
                // Alert threshold
                HStack {
                    Text("Alert Threshold")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(batteryMonitor.settings.alertThreshold)%")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                
                Divider()
                
                // Visual battery indicator
                BatteryIndicator(
                    level: batteryMonitor.batteryLevel,
                    threshold: batteryMonitor.settings.alertThreshold
                )
                .frame(height: 40)
            }
            .padding()
            
            Divider()
            
            // Actions
            VStack(spacing: 8) {
                Button(action: { showSettings = true }) {
                    HStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.accentColor.opacity(0.1))
                )
                .padding(.horizontal)
                
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .frame(width: 300)
        .sheet(isPresented: $showSettings) {
            MacSettingsView()
                .environmentObject(batteryMonitor)
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

struct BatteryIndicator: View {
    let level: Int
    let threshold: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                
                // Fill
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(level) / 100)
                
                // Threshold marker
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2)
                    .offset(x: geometry.size.width * CGFloat(threshold) / 100)
                
                // Percentage text
                Text("\(level)%")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var gradientColors: [Color] {
        if level >= threshold {
            return [.green, .green.opacity(0.7)]
        } else if level >= 20 {
            return [.yellow, .orange]
        } else {
            return [.red, .red.opacity(0.7)]
        }
    }
}

struct MacSettingsView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    @Environment(\.dismiss) var dismiss
    @State private var threshold: Double
    @State private var isEnabled: Bool
    @State private var soundEnabled: Bool
    
    init() {
        let settings = BatterySettings.load()
        _threshold = State(initialValue: Double(settings.alertThreshold))
        _isEnabled = State(initialValue: settings.isEnabled)
        _soundEnabled = State(initialValue: settings.soundEnabled)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Done") {
                    saveSettings()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))
            
            Divider()
            
            // Settings content
            Form {
                Section {
                    Toggle("Enable Battery Alerts", isOn: $isEnabled)
                } header: {
                    Text("General")
                        .font(.headline)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Alert Threshold")
                            Spacer()
                            Text("\(Int(threshold))%")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                        
                        Slider(value: $threshold, in: 1...100, step: 1)
                        
                        Text("Alert when battery reaches this level while charging")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Battery Threshold")
                        .font(.headline)
                }
                
                Section {
                    Toggle("Play Sound", isOn: $soundEnabled)
                } header: {
                    Text("Alert Options")
                        .font(.headline)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Battery Health Tip", systemImage: "lightbulb.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                        
                        Text("Keeping your battery between 20-80% can help extend its lifespan. Avoid charging to 100% regularly.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .formStyle(.grouped)
            .padding()
        }
        .frame(width: 450, height: 500)
    }
    
    private func saveSettings() {
        var newSettings = batteryMonitor.settings
        newSettings.alertThreshold = Int(threshold)
        newSettings.isEnabled = isEnabled
        newSettings.soundEnabled = soundEnabled
        batteryMonitor.updateSettings(newSettings)
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
            .environmentObject(BatteryMonitor())
    }
}
