//
//  ContentView.swift
//  BatteryAlert (iOS)
//
//  Main user interface for iOS/iPadOS
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hue: 0.55, saturation: 0.8, brightness: 0.3),
                        Color(hue: 0.6, saturation: 0.6, brightness: 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    let isLandscape = geometry.size.width > geometry.size.height
                    
                    if isLandscape {
                        landscapeLayout(in: geometry.size)
                    } else {
                        portraitLayout(in: geometry.size)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(batteryMonitor)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func portraitLayout(in size: CGSize) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                BatteryView(
                    level: batteryMonitor.batteryLevel,
                    isCharging: batteryMonitor.isCharging,
                    threshold: batteryMonitor.settings.alertThreshold
                )
                
                statusBlock
                
                infoGrid
                
                batteryHealthCard
                
                settingsButton
            }
            .frame(minHeight: size.height)
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
    }
    
    private func landscapeLayout(in size: CGSize) -> some View {
        ScrollView {
            HStack(alignment: .center, spacing: 30) {
                VStack(spacing: 20) {
                    BatteryView(
                        level: batteryMonitor.batteryLevel,
                        isCharging: batteryMonitor.isCharging,
                        threshold: batteryMonitor.settings.alertThreshold
                    )
                    .scaleEffect(1.05)
                    
                    statusBlock
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 20) {
                    infoGrid
                    batteryHealthCard
                    settingsButton
                }
                .frame(maxWidth: .infinity)
            }
            .frame(minHeight: size.height)
            .padding(.horizontal, 30)
            .padding(.vertical, 24)
        }
    }
    
    private var statusBlock: some View {
        VStack(spacing: 12) {
            Text("\(batteryMonitor.batteryLevel)%")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                Image(systemName: batteryMonitor.isCharging ? "bolt.fill" : "bolt.slash.fill")
                    .foregroundColor(batteryMonitor.isCharging ? .yellow : .gray)
                
                Text(batteryMonitor.isCharging ? "Charging" : "Not Charging")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private var infoGrid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        return LazyVGrid(columns: columns, spacing: 16) {
            infoCard(
                title: "Threshold",
                value: "\(batteryMonitor.settings.alertThreshold)%"
            )
            
            infoCard(
                title: "ETA to \(batteryMonitor.settings.alertThreshold)%",
                value: etaText,
                subtitle: etaSubtitle
            )
        }
    }
    
    private var batteryHealthCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Battery Health")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .textCase(.uppercase)
                .tracking(1.2)
            
            Text("Best practice: keep charge between 20-80% for longer battery lifespan.")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.85))
            
            Text("For your exact battery health, check Settings > Battery > Battery Health.")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var settingsButton: some View {
        Button(action: { showSettings = true }) {
            HStack {
                Image(systemName: "gearshape.fill")
                Text("Settings")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hue: 0.58, saturation: 0.7, brightness: 0.5),
                                Color(hue: 0.62, saturation: 0.6, brightness: 0.4)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
    }
    
    private var etaText: String {
        guard batteryMonitor.isCharging else { return "-" }
        guard let minutes = batteryMonitor.estimatedMinutesToThreshold else { return "Calculating..." }
        if minutes <= 0 {
            return "Reached"
        }
        return "~\(minutes) min"
    }
    
    private var etaSubtitle: String {
        if !batteryMonitor.isCharging {
            return "Not charging"
        }
        if batteryMonitor.batteryLevel >= batteryMonitor.settings.alertThreshold {
            return "At threshold"
        }
        return "Remaining mins"
    }
    
    private func infoCard(title: String, value: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .textCase(.uppercase)
                .tracking(1.1)
            
            Text(value)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct BatteryView: View {
    let level: Int
    let isCharging: Bool
    let threshold: Int
    
    var batteryColor: Color {
        if level >= threshold {
            return .green
        } else if level >= 20 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            // Battery outline
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.5), lineWidth: 6)
                .frame(width: 200, height: 100)
            
            // Battery terminal
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.5))
                .frame(width: 10, height: 40)
                .offset(x: 105)
            
            // Battery fill
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    batteryColor,
                                    batteryColor.opacity(0.7)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: (geometry.size.width - 20) * CGFloat(level) / 100)
                    
                    Spacer()
                }
                .padding(10)
            }
            .frame(width: 200, height: 100)
            
            // Charging indicator
            if isCharging {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .shadow(color: .yellow, radius: 10)
            }
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    @Environment(\.dismiss) var dismiss
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
        NavigationView {
            ZStack {
                Color(hue: 0.6, saturation: 0.1, brightness: 0.15)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        Toggle("Enable Alerts", isOn: $isEnabled)
                    } header: {
                        Text("General")
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                    
                    Section {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Alert at")
                                Spacer()
                                Text("\(Int(threshold))%")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                            
                            Slider(value: $threshold, in: 1...100, step: 1)
                                .tint(.green)
                        }
                        .padding(.vertical, 8)
                    } header: {
                        Text("Battery Threshold")
                    } footer: {
                        Text("You'll be alerted when battery reaches this level while charging")
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                    
                    Section {
                        Toggle("Sound", isOn: $soundEnabled)
                        Toggle("Vibration", isOn: $vibrationEnabled)
                    } header: {
                        Text("Alert Options")
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                    
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Battery Health Tip", systemImage: "lightbulb.fill")
                                .font(.headline)
                                .foregroundColor(.yellow)
                            
                            Text("Keeping your battery between 20-80% can help extend its lifespan. Avoid charging to 100% regularly.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveSettings()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BatteryMonitor())
    }
}
