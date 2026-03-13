import SwiftUI
import WidgetKit

// MARK: - Ambient Background View

struct AmbientBackgroundView<Content: View>: View {
    let mode: String
    let bgHex: String
    let imageName: String
    let content: Content

    init(mode: String, bgHex: String, imageName: String = "", @ViewBuilder content: () -> Content) {
        self.mode = mode
        self.bgHex = bgHex
        self.imageName = imageName
        self.content = content()
    }

    @ViewBuilder
    private var backgroundContent: some View {
        if mode == "image", !imageName.isEmpty, let uiImage = loadImage() {
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                Color.black.opacity(0.55)
            }
        } else if let colors = AmbientBackground.gradient(for: mode, bgHex: bgHex) {
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            OLEDColors.trueBlack
        }
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(for: .widget) {
                backgroundContent
            }
    }

    private func loadImage() -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.tmmr.standbyHub"
        ) else { return nil }
        let fileURL = containerURL.appendingPathComponent(imageName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}

// MARK: - Clock Widget

struct StandByClockWidget: Widget {
    let kind = "StandByClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            ClockWidgetView(entry: entry)
        }
        .configurationDisplayName(LocalizedStringResource("widget.clock.name"))
        .description(LocalizedStringResource("widget.clock.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClockWidgetView: View {
    let entry: ClockEntry

    var body: some View {
        AmbientBackgroundView(
            mode: entry.settings.selectedAmbient,
            bgHex: entry.settings.backgroundColorHex,
            imageName: entry.settings.clockBackgroundImage
        ) {
            Group {
                switch entry.settings.selectedClock {
                case "flipClock":
                    FlipClockView(entry: entry)
                case "analogClassic":
                    AnalogClassicView(entry: entry)
                case "binaryClock":
                    BinaryClockView(entry: entry)
                case "pixelArtClock":
                    PixelArtClockView(entry: entry)
                default:
                    MinimalDigitalView(entry: entry)
                }
            }
        }
    }
}

// MARK: - Dashboard Widget (Combined)

struct StandByDashboardWidget: Widget {
    let kind = "StandByDashboardWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardTimelineProvider()) { entry in
            AmbientBackgroundView(
                mode: entry.settings.dashboardAmbient,
                bgHex: entry.settings.dashboardBackgroundHex,
                imageName: entry.settings.dashboardBackgroundImage
            ) {
                SmartDashboardView(entry: entry)
            }

        }
        .configurationDisplayName(LocalizedStringResource("widget.dashboard.name"))
        .description(LocalizedStringResource("widget.dashboard.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Individual Widgets

struct StandByCalendarWidget: Widget {
    let kind = "StandByCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardTimelineProvider()) { entry in
            AmbientBackgroundView(
                mode: entry.settings.calendarAmbient,
                bgHex: entry.settings.calendarBackgroundHex,
                imageName: entry.settings.calendarBackgroundImage
            ) {
                AdaptiveCalendarView(entry: entry)
            }

        }
        .configurationDisplayName(LocalizedStringResource("widget.calendar.name"))
        .description(LocalizedStringResource("widget.calendar.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct StandByWeatherWidget: Widget {
    let kind = "StandByWeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardTimelineProvider()) { entry in
            AmbientBackgroundView(
                mode: entry.settings.weatherAmbient,
                bgHex: entry.settings.weatherBackgroundHex,
                imageName: entry.settings.weatherBackgroundImage
            ) {
                AdaptiveWeatherView(entry: entry)
            }

        }
        .configurationDisplayName(LocalizedStringResource("widget.weather.name"))
        .description(LocalizedStringResource("widget.weather.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct StandByBatteryWidget: Widget {
    let kind = "StandByBatteryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardTimelineProvider()) { entry in
            AmbientBackgroundView(
                mode: entry.settings.batteryAmbient,
                bgHex: entry.settings.batteryBackgroundHex,
                imageName: entry.settings.batteryBackgroundImage
            ) {
                AdaptiveBatteryView(entry: entry)
            }

        }
        .configurationDisplayName(LocalizedStringResource("widget.battery.name"))
        .description(LocalizedStringResource("widget.battery.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Adaptive Views (Small / Medium / Large)

struct AdaptiveCalendarView: View {
    let entry: DashboardEntry
    @Environment(\.widgetFamily) var family

    private var slotTheme: WidgetTheme {
        WidgetTheme.from(settings: entry.settings, slotType: "calendar")
    }

    var body: some View {
        if family == .systemLarge {
            VStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 40))
                    .foregroundColor(slotTheme.accent)

                if let title = entry.data.nextEventTitle {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(slotTheme.accent)
                        .lineLimit(2)
                    if let time = entry.data.nextEventTime {
                        Text(String(localized: "event.atTime \(time)"))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(slotTheme.accent)
                    }
                } else {
                    Text(dateString)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(slotTheme.textPrimary)
                    Text(String(localized: "event.noEventsToday"))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(slotTheme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if family == .systemMedium {
            HStack(spacing: 16) {
                Image(systemName: "calendar")
                    .font(.system(size: 28))
                    .foregroundColor(slotTheme.accent)

                VStack(alignment: .leading, spacing: 4) {
                    if let title = entry.data.nextEventTitle {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(slotTheme.accent)
                            .lineLimit(1)
                        if let time = entry.data.nextEventTime {
                            Text(String(localized: "event.atTime \(time)"))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(slotTheme.accent)
                        }
                    } else {
                        Text(dateString)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(slotTheme.textPrimary)
                        Text(String(localized: "event.noEventsToday"))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(slotTheme.textSecondary)
                    }
                }

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            CalendarSlotView(theme: slotTheme, data: entry.data)
        }
    }

    private var dateString: String {
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateFormat = "E, d. MMM"
        return f.string(from: Date())
    }
}

struct AdaptiveWeatherView: View {
    let entry: DashboardEntry
    @Environment(\.widgetFamily) var family

    private var slotTheme: WidgetTheme {
        WidgetTheme.from(settings: entry.settings, slotType: "weather")
    }

    var body: some View {
        if family == .systemLarge {
            VStack(spacing: 12) {
                Image(systemName: entry.data.weatherIcon)
                    .font(.system(size: 48))
                    .symbolRenderingMode(.multicolor)

                Text(tempText)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(slotTheme.accent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if family == .systemMedium {
            HStack(spacing: 16) {
                Image(systemName: entry.data.weatherIcon)
                    .font(.system(size: 32))
                    .symbolRenderingMode(.multicolor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(tempText)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(slotTheme.accent)
                }

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            WeatherSlotView(theme: slotTheme, data: entry.data)
        }
    }

    private var tempText: String {
        entry.data.temperatureText
    }
}

struct AdaptiveBatteryView: View {
    let entry: DashboardEntry
    @Environment(\.widgetFamily) var family

    private var slotTheme: WidgetTheme {
        WidgetTheme.from(settings: entry.settings, slotType: "battery")
    }

    var body: some View {
        if family == .systemLarge {
            VStack(spacing: 12) {
                Image(systemName: entry.data.batteryIcon)
                    .font(.system(size: 40))
                    .foregroundColor(batteryColor)

                Text(levelText)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(slotTheme.accent)

                // Larger bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(OLEDColors.surfaceCard)
                        .frame(width: 200, height: 16)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(batteryColor)
                        .frame(width: max(8, 200 * CGFloat(entry.data.batteryLevel) / 100.0), height: 16)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if family == .systemMedium {
            HStack(spacing: 16) {
                Image(systemName: entry.data.batteryIcon)
                    .font(.system(size: 28))
                    .foregroundColor(batteryColor)

                VStack(alignment: .leading, spacing: 4) {
                    Text(levelText)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(slotTheme.accent)
                }

                Spacer()

                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(OLEDColors.surfaceCard)
                        .frame(width: 24, height: 60)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(batteryColor)
                        .frame(width: 24, height: max(4, 60 * CGFloat(entry.data.batteryLevel) / 100.0))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            BatterySlotView(theme: slotTheme, data: entry.data)
        }
    }

    private var levelText: String {
        entry.data.batteryLevel > 0 ? "\(entry.data.batteryLevel)%" : "--%"
    }

    private var batteryColor: Color {
        if entry.data.batteryLevel <= 20 { return .red }
        if entry.data.batteryLevel <= 40 { return .orange }
        return slotTheme.accent
    }
}

// MARK: - Moon Phase Widget (Standalone)

struct StandByMoonPhaseWidget: Widget {
    let kind = "StandByMoonPhaseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            let settings = entry.settings
            let theme = WidgetTheme.from(settings: settings, slotType: "moonPhase")
            AmbientBackgroundView(
                mode: settings.moonPhaseAmbient,
                bgHex: settings.moonPhaseBackgroundHex,
                imageName: settings.moonPhaseBackgroundImage
            ) {
                MoonPhaseView(entry: ClockEntry(date: entry.date, settings: settings, theme: theme))
            }

        }
        .configurationDisplayName(LocalizedStringResource("widget.moonPhase.name"))
        .description(LocalizedStringResource("widget.moonPhase.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Photo Widget

struct StandByPhotoWidget: Widget {
    let kind = "StandByPhotoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardTimelineProvider()) { entry in
            PhotoWidgetView(entry: entry)
                .containerBackground(OLEDColors.trueBlack, for: .widget)
        }
        .configurationDisplayName(LocalizedStringResource("widget.photo.name"))
        .description(LocalizedStringResource("widget.photo.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Bundle

@main
struct StandByHubWidgetBundle: WidgetBundle {
    var body: some Widget {
        StandByClockWidget()
        StandByDashboardWidget()
        StandByCalendarWidget()
        StandByWeatherWidget()
        StandByBatteryWidget()
        StandByMoonPhaseWidget()
        StandByPhotoWidget()
    }
}
