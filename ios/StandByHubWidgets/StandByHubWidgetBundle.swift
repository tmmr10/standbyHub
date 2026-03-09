import SwiftUI
import WidgetKit

// MARK: - Clock Widget

struct StandByClockWidget: Widget {
    let kind = "StandByClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            ClockWidgetView(entry: entry)
        }
        .configurationDisplayName("StandBy Clock")
        .description("Wähle aus 5 einzigartigen Uhren-Stilen")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ClockWidgetView: View {
    let entry: ClockEntry

    var body: some View {
        Group {
            switch entry.settings.selectedClock {
            case "flipClock":
                FlipClockView(entry: entry)
            case "analogClassic":
                AnalogClassicView(entry: entry)
            case "gradientClock":
                GradientClockView(entry: entry)
            case "binaryClock":
                BinaryClockView(entry: entry)
            default:
                MinimalDigitalView(entry: entry)
            }
        }
        .containerBackground(OLEDColors.trueBlack, for: .widget)
    }
}

// MARK: - Ambient Widget

struct StandByAmbientWidget: Widget {
    let kind = "StandByAmbientWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AmbientTimelineProvider()) { entry in
            AmbientWidgetView(entry: entry)
        }
        .configurationDisplayName("StandBy Ambient")
        .description("Stimmungsvolle Farbverläufe für deinen Nachttisch")
        .supportedFamilies([.systemMedium])
    }
}

struct AmbientWidgetView: View {
    let entry: AmbientEntry

    var body: some View {
        Group {
            switch entry.settings.selectedAmbient {
            case "lava":
                LavaView(entry: entry)
            case "ocean":
                OceanView(entry: entry)
            default:
                AuroraView(entry: entry)
            }
        }
        .containerBackground(OLEDColors.trueBlack, for: .widget)
    }
}

// MARK: - Dashboard Widget

struct StandByDashboardWidget: Widget {
    let kind = "StandByDashboardWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardTimelineProvider()) { entry in
            SmartDashboardView(entry: entry)
                .containerBackground(OLEDColors.trueBlack, for: .widget)
        }
        .configurationDisplayName("StandBy Dashboard")
        .description("Kalender, Wetter & Batterie auf einen Blick")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Widget Bundle

@main
struct StandByHubWidgetBundle: WidgetBundle {
    var body: some Widget {
        StandByClockWidget()
        StandByAmbientWidget()
        StandByDashboardWidget()
    }
}
