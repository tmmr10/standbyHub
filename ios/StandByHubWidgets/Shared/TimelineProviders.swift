import WidgetKit
import SwiftUI
import EventKit

// MARK: - Clock Timeline Entry

struct ClockEntry: TimelineEntry {
    let date: Date
    let settings: WidgetSettingsData
    let theme: WidgetTheme
}

// MARK: - Clock Timeline Provider

struct ClockTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        let settings = WidgetSettingsData.default
        return ClockEntry(date: Date(), settings: settings, theme: .from(settings: settings))
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        let settings = WidgetSettingsReader.read()
        completion(ClockEntry(date: Date(), settings: settings, theme: .from(settings: settings)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let settings = WidgetSettingsReader.read()

        var entries: [ClockEntry] = []
        let now = Date()
        let calendar = Calendar.current

        for minuteOffset in 0..<60 {
            let date = calendar.date(byAdding: .minute, value: minuteOffset, to: now)!
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let roundedDate = calendar.date(from: components)!
            let theme = WidgetTheme.from(settings: settings, date: roundedDate)
            entries.append(ClockEntry(date: roundedDate, settings: settings, theme: theme))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Ambient Timeline Entry

struct AmbientEntry: TimelineEntry {
    let date: Date
    let settings: WidgetSettingsData
    let gradientIndex: Int
}

// MARK: - Ambient Timeline Provider

struct AmbientTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> AmbientEntry {
        AmbientEntry(date: Date(), settings: .default, gradientIndex: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (AmbientEntry) -> Void) {
        let settings = WidgetSettingsReader.read()
        completion(AmbientEntry(date: Date(), settings: settings, gradientIndex: 0))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AmbientEntry>) -> Void) {
        let settings = WidgetSettingsReader.read()

        var entries: [AmbientEntry] = []
        let now = Date()
        let calendar = Calendar.current

        for offset in 0..<12 {
            let date = calendar.date(byAdding: .minute, value: offset * 10, to: now)!
            entries.append(AmbientEntry(date: date, settings: settings, gradientIndex: offset))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Dashboard Data

struct DashboardData {
    let batteryLevel: Int
    let batteryIcon: String
    let nextEventTitle: String?
    let nextEventTime: String?
    let temperatureCelsius: Int?
    let weatherIcon: String
    let temperatureUnit: String // "celsius" or "fahrenheit"

    /// Formatted temperature string respecting unit preference
    var temperatureText: String {
        guard let celsius = temperatureCelsius else { return "--°" }
        if temperatureUnit == "fahrenheit" {
            let f = Int(Double(celsius) * 9.0 / 5.0 + 32)
            return "\(f)°F"
        }
        return "\(celsius)°C"
    }

    /// Short temperature (without unit suffix, for compact views)
    var temperatureShort: String {
        guard let celsius = temperatureCelsius else { return "--°" }
        if temperatureUnit == "fahrenheit" {
            let f = Int(Double(celsius) * 9.0 / 5.0 + 32)
            return "\(f)°"
        }
        return "\(celsius)°"
    }

    static let placeholder = DashboardData(
        batteryLevel: 75,
        batteryIcon: "battery.75percent",
        nextEventTitle: nil,
        nextEventTime: nil,
        temperatureCelsius: nil,
        weatherIcon: "cloud.sun.fill",
        temperatureUnit: "celsius"
    )
}

// MARK: - Dashboard Timeline Entry

struct DashboardEntry: TimelineEntry {
    let date: Date
    let settings: WidgetSettingsData
    let theme: WidgetTheme
    let data: DashboardData
}

// MARK: - Dashboard Timeline Provider

struct DashboardTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> DashboardEntry {
        let settings = WidgetSettingsData.default
        return DashboardEntry(
            date: Date(),
            settings: settings,
            theme: .from(settings: settings),
            data: .placeholder
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DashboardEntry) -> Void) {
        let settings = WidgetSettingsReader.read()
        let data = fetchDashboardData(settings: settings)
        completion(DashboardEntry(
            date: Date(),
            settings: settings,
            theme: .from(settings: settings),
            data: data
        ))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DashboardEntry>) -> Void) {
        let settings = WidgetSettingsReader.read()
        let data = fetchDashboardData(settings: settings)

        var entries: [DashboardEntry] = []
        let now = Date()
        let calendar = Calendar.current

        for offset in 0..<8 {
            let date = calendar.date(byAdding: .minute, value: offset * 15, to: now)!
            let theme = WidgetTheme.from(settings: settings, date: date)
            entries.append(DashboardEntry(date: date, settings: settings, theme: theme, data: data))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    // MARK: - Data Fetching

    private func fetchDashboardData(settings: WidgetSettingsData) -> DashboardData {
        let battery = fetchBattery()
        let event = fetchNextEvent()
        let weather = fetchWeather()

        return DashboardData(
            batteryLevel: battery.level,
            batteryIcon: battery.icon,
            nextEventTitle: event?.title,
            nextEventTime: event?.time,
            temperatureCelsius: weather?.temperature,
            weatherIcon: weather?.icon ?? "cloud.sun.fill",
            temperatureUnit: settings.temperatureUnit
        )
    }

    // MARK: Battery

    private func fetchBattery() -> (level: Int, icon: String) {
        // Read battery level from App Group (written by Flutter app)
        let defaults = UserDefaults(suiteName: "group.com.tmmr.standbyHub")
        let level = defaults?.integer(forKey: "battery_level") ?? -1

        if level < 0 {
            // Fallback: no data from app yet
            return (level: 0, icon: "battery.0percent")
        }

        let icon: String
        switch level {
        case 0..<13: icon = "battery.0percent"
        case 13..<38: icon = "battery.25percent"
        case 38..<63: icon = "battery.50percent"
        case 63..<88: icon = "battery.75percent"
        default: icon = "battery.100percent"
        }

        return (level: level, icon: icon)
    }

    // MARK: Calendar (EventKit)

    private func fetchNextEvent() -> (title: String, time: String)? {
        let store = EKEventStore()

        // Check authorization status
        let status = EKEventStore.authorizationStatus(for: .event)
        guard status == .fullAccess || status == .authorized else {
            return nil
        }

        let now = Date()
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: now)!

        let predicate = store.predicateForEvents(withStart: now, end: endOfDay, calendars: nil)
        let events = store.events(matching: predicate)
            .filter { !$0.isAllDay }
            .sorted { $0.startDate < $1.startDate }

        guard let next = events.first else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeStr = formatter.string(from: next.startDate)

        let title = next.title ?? "Termin"
        // Truncate long titles
        let shortTitle = title.count > 18 ? String(title.prefix(16)) + "…" : title

        return (title: shortTitle, time: timeStr)
    }

    // MARK: Weather

    private func fetchWeather() -> (temperature: Int, icon: String)? {
        // Read cached weather from App Group (written by Flutter app or background task)
        let defaults = UserDefaults(suiteName: "group.com.tmmr.standbyHub")
        guard let temp = defaults?.object(forKey: "weather_temp") as? Int else {
            return nil
        }
        let icon = defaults?.string(forKey: "weather_icon") ?? "cloud.sun.fill"
        return (temperature: temp, icon: icon)
    }
}
