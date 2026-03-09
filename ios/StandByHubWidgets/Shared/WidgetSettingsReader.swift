import Foundation

struct WidgetSettingsData: Codable {
    let selectedClock: String
    let selectedAmbient: String
    let accentColorHex: String
    let showSeconds: Bool
    let use24HourFormat: Bool
    let timeOfDayReactivity: Bool
    let dashboardSlots: [DashboardSlotData]
    let isPro: Bool

    static let `default` = WidgetSettingsData(
        selectedClock: "minimalDigital",
        selectedAmbient: "aurora",
        accentColorHex: "FF00DDFF",
        showSeconds: false,
        use24HourFormat: true,
        timeOfDayReactivity: false,
        dashboardSlots: [
            DashboardSlotData(type: "calendar", enabled: true, position: 0),
            DashboardSlotData(type: "weather", enabled: true, position: 1),
            DashboardSlotData(type: "battery", enabled: true, position: 2),
        ],
        isPro: false
    )
}

struct DashboardSlotData: Codable {
    let type: String
    let enabled: Bool
    let position: Int
}

final class WidgetSettingsReader {
    private static let appGroupID = "group.com.tmmr.standbyHub"
    private static let settingsKey = "widget_settings"

    static func read() -> WidgetSettingsData {
        guard let defaults = UserDefaults(suiteName: appGroupID),
              let json = defaults.string(forKey: settingsKey),
              let data = json.data(using: .utf8),
              let settings = try? JSONDecoder().decode(WidgetSettingsData.self, from: data)
        else {
            return .default
        }
        return settings
    }
}
