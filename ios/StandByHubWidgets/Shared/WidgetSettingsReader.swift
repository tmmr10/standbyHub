import Foundation

struct WidgetSettingsData: Codable {
    let selectedClock: String
    let selectedAmbient: String
    let accentColorHex: String
    let backgroundColorHex: String
    let showSeconds: Bool
    let use24HourFormat: Bool
    let timeOfDayReactivity: Bool
    let dashboardSlots: [DashboardSlotData]
    let isPro: Bool
    let temperatureUnit: String
    let calendarAccentHex: String
    let weatherAccentHex: String
    let batteryAccentHex: String
    let dashboardPreset: String
    let dashboardAccentHex: String
    let savedDashboards: [SavedDashboardData]
    let calendarBackgroundHex: String
    let calendarAmbient: String
    let weatherBackgroundHex: String
    let weatherAmbient: String
    let batteryBackgroundHex: String
    let batteryAmbient: String
    let dashboardBackgroundHex: String
    let dashboardAmbient: String
    let moonPhaseAccentHex: String
    let moonPhaseBackgroundHex: String
    let moonPhaseAmbient: String
    let clockBackgroundImage: String
    let calendarBackgroundImage: String
    let weatherBackgroundImage: String
    let batteryBackgroundImage: String
    let dashboardBackgroundImage: String
    let moonPhaseBackgroundImage: String
    let photoWidgetImage: String

    // Manual decoder for backward-compatibility
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        selectedClock = try c.decodeIfPresent(String.self, forKey: .selectedClock) ?? "minimalDigital"
        selectedAmbient = try c.decodeIfPresent(String.self, forKey: .selectedAmbient) ?? "none"
        accentColorHex = try c.decodeIfPresent(String.self, forKey: .accentColorHex) ?? "FFFFFFFF"
        backgroundColorHex = try c.decodeIfPresent(String.self, forKey: .backgroundColorHex) ?? "FF1A237E"
        showSeconds = try c.decodeIfPresent(Bool.self, forKey: .showSeconds) ?? false
        use24HourFormat = try c.decodeIfPresent(Bool.self, forKey: .use24HourFormat) ?? true
        timeOfDayReactivity = try c.decodeIfPresent(Bool.self, forKey: .timeOfDayReactivity) ?? false
        dashboardSlots = try c.decodeIfPresent([DashboardSlotData].self, forKey: .dashboardSlots) ?? WidgetSettingsData.defaultSlots
        isPro = try c.decodeIfPresent(Bool.self, forKey: .isPro) ?? false
        temperatureUnit = try c.decodeIfPresent(String.self, forKey: .temperatureUnit) ?? "celsius"
        calendarAccentHex = try c.decodeIfPresent(String.self, forKey: .calendarAccentHex) ?? ""
        weatherAccentHex = try c.decodeIfPresent(String.self, forKey: .weatherAccentHex) ?? ""
        batteryAccentHex = try c.decodeIfPresent(String.self, forKey: .batteryAccentHex) ?? ""
        dashboardPreset = try c.decodeIfPresent(String.self, forKey: .dashboardPreset) ?? "all"
        dashboardAccentHex = try c.decodeIfPresent(String.self, forKey: .dashboardAccentHex) ?? ""
        savedDashboards = try c.decodeIfPresent([SavedDashboardData].self, forKey: .savedDashboards) ?? []
        calendarBackgroundHex = try c.decodeIfPresent(String.self, forKey: .calendarBackgroundHex) ?? ""
        calendarAmbient = try c.decodeIfPresent(String.self, forKey: .calendarAmbient) ?? "none"
        weatherBackgroundHex = try c.decodeIfPresent(String.self, forKey: .weatherBackgroundHex) ?? ""
        weatherAmbient = try c.decodeIfPresent(String.self, forKey: .weatherAmbient) ?? "none"
        batteryBackgroundHex = try c.decodeIfPresent(String.self, forKey: .batteryBackgroundHex) ?? ""
        batteryAmbient = try c.decodeIfPresent(String.self, forKey: .batteryAmbient) ?? "none"
        dashboardBackgroundHex = try c.decodeIfPresent(String.self, forKey: .dashboardBackgroundHex) ?? ""
        dashboardAmbient = try c.decodeIfPresent(String.self, forKey: .dashboardAmbient) ?? "none"
        moonPhaseAccentHex = try c.decodeIfPresent(String.self, forKey: .moonPhaseAccentHex) ?? ""
        moonPhaseBackgroundHex = try c.decodeIfPresent(String.self, forKey: .moonPhaseBackgroundHex) ?? ""
        moonPhaseAmbient = try c.decodeIfPresent(String.self, forKey: .moonPhaseAmbient) ?? "none"
        clockBackgroundImage = try c.decodeIfPresent(String.self, forKey: .clockBackgroundImage) ?? ""
        calendarBackgroundImage = try c.decodeIfPresent(String.self, forKey: .calendarBackgroundImage) ?? ""
        weatherBackgroundImage = try c.decodeIfPresent(String.self, forKey: .weatherBackgroundImage) ?? ""
        batteryBackgroundImage = try c.decodeIfPresent(String.self, forKey: .batteryBackgroundImage) ?? ""
        dashboardBackgroundImage = try c.decodeIfPresent(String.self, forKey: .dashboardBackgroundImage) ?? ""
        moonPhaseBackgroundImage = try c.decodeIfPresent(String.self, forKey: .moonPhaseBackgroundImage) ?? ""
        photoWidgetImage = try c.decodeIfPresent(String.self, forKey: .photoWidgetImage) ?? ""
    }

    // Memberwise init
    init(
        selectedClock: String, selectedAmbient: String, accentColorHex: String,
        backgroundColorHex: String, showSeconds: Bool, use24HourFormat: Bool,
        timeOfDayReactivity: Bool, dashboardSlots: [DashboardSlotData],
        isPro: Bool, temperatureUnit: String, calendarAccentHex: String,
        weatherAccentHex: String, batteryAccentHex: String,
        dashboardPreset: String, dashboardAccentHex: String,
        savedDashboards: [SavedDashboardData], calendarBackgroundHex: String,
        calendarAmbient: String, weatherBackgroundHex: String,
        weatherAmbient: String, batteryBackgroundHex: String,
        batteryAmbient: String, dashboardBackgroundHex: String,
        dashboardAmbient: String, moonPhaseAccentHex: String,
        moonPhaseBackgroundHex: String, moonPhaseAmbient: String,
        clockBackgroundImage: String = "", calendarBackgroundImage: String = "",
        weatherBackgroundImage: String = "", batteryBackgroundImage: String = "",
        dashboardBackgroundImage: String = "", moonPhaseBackgroundImage: String = "",
        photoWidgetImage: String = ""
    ) {
        self.selectedClock = selectedClock
        self.selectedAmbient = selectedAmbient
        self.accentColorHex = accentColorHex
        self.backgroundColorHex = backgroundColorHex
        self.showSeconds = showSeconds
        self.use24HourFormat = use24HourFormat
        self.timeOfDayReactivity = timeOfDayReactivity
        self.dashboardSlots = dashboardSlots
        self.isPro = isPro
        self.temperatureUnit = temperatureUnit
        self.calendarAccentHex = calendarAccentHex
        self.weatherAccentHex = weatherAccentHex
        self.batteryAccentHex = batteryAccentHex
        self.dashboardPreset = dashboardPreset
        self.dashboardAccentHex = dashboardAccentHex
        self.savedDashboards = savedDashboards
        self.calendarBackgroundHex = calendarBackgroundHex
        self.calendarAmbient = calendarAmbient
        self.weatherBackgroundHex = weatherBackgroundHex
        self.weatherAmbient = weatherAmbient
        self.batteryBackgroundHex = batteryBackgroundHex
        self.batteryAmbient = batteryAmbient
        self.dashboardBackgroundHex = dashboardBackgroundHex
        self.dashboardAmbient = dashboardAmbient
        self.moonPhaseAccentHex = moonPhaseAccentHex
        self.moonPhaseBackgroundHex = moonPhaseBackgroundHex
        self.moonPhaseAmbient = moonPhaseAmbient
        self.clockBackgroundImage = clockBackgroundImage
        self.calendarBackgroundImage = calendarBackgroundImage
        self.weatherBackgroundImage = weatherBackgroundImage
        self.batteryBackgroundImage = batteryBackgroundImage
        self.dashboardBackgroundImage = dashboardBackgroundImage
        self.moonPhaseBackgroundImage = moonPhaseBackgroundImage
        self.photoWidgetImage = photoWidgetImage
    }

    /// Resolved accent for a slot type (falls back to global)
    func accentHex(for slotType: String) -> String {
        let override: String
        switch slotType {
        case "clock": override = ""
        case "calendar": override = calendarAccentHex
        case "weather": override = weatherAccentHex
        case "battery": override = batteryAccentHex
        case "moonPhase": override = moonPhaseAccentHex
        default: override = ""
        }
        return override.isEmpty ? accentColorHex : override
    }

    /// Resolved background for a slot type (empty = true black)
    func backgroundHex(for slotType: String) -> String {
        switch slotType {
        case "clock": return backgroundColorHex
        case "calendar": return calendarBackgroundHex
        case "weather": return weatherBackgroundHex
        case "battery": return batteryBackgroundHex
        case "moonPhase": return moonPhaseBackgroundHex
        default: return ""
        }
    }

    /// Resolved ambient mode for a slot type
    func ambientMode(for slotType: String) -> String {
        switch slotType {
        case "clock": return selectedAmbient
        case "calendar": return calendarAmbient
        case "weather": return weatherAmbient
        case "battery": return batteryAmbient
        case "moonPhase": return moonPhaseAmbient
        case "dashboard": return dashboardAmbient
        default: return "none"
        }
    }

    /// Background image filename for a widget type
    func backgroundImage(for slotType: String) -> String {
        switch slotType {
        case "clock": return clockBackgroundImage
        case "calendar": return calendarBackgroundImage
        case "weather": return weatherBackgroundImage
        case "battery": return batteryBackgroundImage
        case "dashboard": return dashboardBackgroundImage
        case "moonPhase": return moonPhaseBackgroundImage
        case "photo": return photoWidgetImage
        default: return ""
        }
    }

    /// Dashboard-specific accent (falls back to global)
    var resolvedDashboardAccentHex: String {
        dashboardAccentHex.isEmpty ? accentColorHex : dashboardAccentHex
    }

    private static let defaultSlots: [DashboardSlotData] = [
        DashboardSlotData(type: "clock", enabled: false, position: 0),
        DashboardSlotData(type: "calendar", enabled: true, position: 1),
        DashboardSlotData(type: "weather", enabled: true, position: 2),
        DashboardSlotData(type: "battery", enabled: true, position: 3),
        DashboardSlotData(type: "moonPhase", enabled: false, position: 4),
        DashboardSlotData(type: "photo", enabled: false, position: 5),
    ]

    static let `default` = WidgetSettingsData(
        selectedClock: "minimalDigital",
        selectedAmbient: "none",
        accentColorHex: "FFFFFFFF",
        backgroundColorHex: "FF1A237E",
        showSeconds: false,
        use24HourFormat: true,
        timeOfDayReactivity: false,
        dashboardSlots: defaultSlots,
        isPro: false,
        temperatureUnit: "celsius",
        calendarAccentHex: "",
        weatherAccentHex: "",
        batteryAccentHex: "",
        dashboardPreset: "all",
        dashboardAccentHex: "",
        savedDashboards: [],
        calendarBackgroundHex: "",
        calendarAmbient: "none",
        weatherBackgroundHex: "",
        weatherAmbient: "none",
        batteryBackgroundHex: "",
        batteryAmbient: "none",
        dashboardBackgroundHex: "",
        dashboardAmbient: "none",
        moonPhaseAccentHex: "",
        moonPhaseBackgroundHex: "",
        moonPhaseAmbient: "none",
    )
}

struct DashboardSlotData: Codable {
    let type: String
    let enabled: Bool
    let position: Int
}

struct SavedDashboardData: Codable {
    let name: String
    let slots: [DashboardSlotData]
    let accentColorHex: String
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
