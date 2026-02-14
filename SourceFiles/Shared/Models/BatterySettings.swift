//
//  BatterySettings.swift
//  BatteryAlert
//
//  Shared data model for battery alert settings
//

import Foundation

struct BatterySettings: Codable {
    var alertThreshold: Int = 80
    var isEnabled: Bool = true
    var soundEnabled: Bool = true
    var vibrationEnabled: Bool = true
    var hasAlertedForCurrentCharge: Bool = false
    
    static let shared = BatterySettings()
    
    private static let userDefaultsKey = "BatteryAlertSettings"
    
    static func clampThreshold(_ value: Int) -> Int {
        return min(100, max(1, value))
    }
    
    static func load() -> BatterySettings {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              var settings = try? JSONDecoder().decode(BatterySettings.self, from: data) else {
            return BatterySettings()
        }
        settings.alertThreshold = BatterySettings.clampThreshold(settings.alertThreshold)
        return settings
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: BatterySettings.userDefaultsKey)
        }
    }
}
