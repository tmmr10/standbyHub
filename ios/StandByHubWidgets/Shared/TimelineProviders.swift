import WidgetKit
import SwiftUI

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
        let theme = WidgetTheme.from(settings: settings)

        var entries: [ClockEntry] = []
        let now = Date()
        let calendar = Calendar.current

        // Generate entries for the next 60 minutes (one per minute)
        for minuteOffset in 0..<60 {
            let date = calendar.date(byAdding: .minute, value: minuteOffset, to: now)!
            // Round to the start of the minute
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let roundedDate = calendar.date(from: components)!
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

        // Generate entries every 10 minutes for the next 2 hours
        for offset in 0..<12 {
            let date = calendar.date(byAdding: .minute, value: offset * 10, to: now)!
            entries.append(AmbientEntry(date: date, settings: settings, gradientIndex: offset))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Dashboard Timeline Entry

struct DashboardEntry: TimelineEntry {
    let date: Date
    let settings: WidgetSettingsData
    let theme: WidgetTheme
}

// MARK: - Dashboard Timeline Provider

struct DashboardTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> DashboardEntry {
        let settings = WidgetSettingsData.default
        return DashboardEntry(date: Date(), settings: settings, theme: .from(settings: settings))
    }

    func getSnapshot(in context: Context, completion: @escaping (DashboardEntry) -> Void) {
        let settings = WidgetSettingsReader.read()
        completion(DashboardEntry(date: Date(), settings: settings, theme: .from(settings: settings)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DashboardEntry>) -> Void) {
        let settings = WidgetSettingsReader.read()
        let theme = WidgetTheme.from(settings: settings)

        var entries: [DashboardEntry] = []
        let now = Date()
        let calendar = Calendar.current

        // Update every 15 minutes
        for offset in 0..<8 {
            let date = calendar.date(byAdding: .minute, value: offset * 15, to: now)!
            entries.append(DashboardEntry(date: date, settings: settings, theme: theme))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
