import SwiftUI
import WidgetKit

struct SmartDashboardView: View {
    let entry: DashboardEntry

    @Environment(\.widgetFamily) var family

    private var enabledSlots: [DashboardSlotData] {
        entry.settings.dashboardSlots
            .filter { $0.enabled }
            .sorted { $0.position < $1.position }
    }

    private func theme(for slotType: String) -> WidgetTheme {
        WidgetTheme.from(settings: entry.settings, slotType: slotType)
    }

    private func loadBackgroundImage(for widgetType: String) -> UIImage? {
        let filename = entry.settings.backgroundImage(for: widgetType)
        guard !filename.isEmpty,
              let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.tmmr.standbyHub")
        else { return nil }
        let fileURL = containerURL.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    var body: some View {
        Group {
            if family == .systemLarge {
                let slots = Array(enabledSlots.prefix(6))
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 6),
                    GridItem(.flexible(), spacing: 6),
                ], spacing: 6) {
                    ForEach(slots, id: \.type) { slot in
                        slotView(for: slot)
                            .frame(maxWidth: .infinity)
                            .frame(height: 90)
                    }
                }
                .padding(10)
            } else if family == .systemSmall {
                VStack(spacing: 6) {
                    ForEach(enabledSlots.prefix(3), id: \.type) { slot in
                        compactSlotRow(for: slot)
                    }
                }
                .padding(10)
            } else {
                HStack(spacing: 8) {
                    ForEach(enabledSlots.prefix(4), id: \.type) { slot in
                        slotView(for: slot)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }

    @ViewBuilder
    private func slotView(for slot: DashboardSlotData) -> some View {
        let slotTheme = theme(for: slot.type)
        let slotContent: AnyView = {
            switch slot.type {
            case "clock":
                return AnyView(ClockSlotView(theme: slotTheme, settings: entry.settings, date: entry.date))
            case "calendar":
                return AnyView(CalendarSlotView(theme: slotTheme, data: entry.data))
            case "weather":
                return AnyView(WeatherSlotView(theme: slotTheme, data: entry.data))
            case "battery":
                return AnyView(BatterySlotView(theme: slotTheme, data: entry.data))
            case "moonPhase":
                return AnyView(MoonPhaseSlotView(theme: slotTheme, date: entry.date, settings: entry.settings))
            case "photo":
                return AnyView(PhotoSlotView(theme: slotTheme, settings: entry.settings))
            default:
                return AnyView(EmptyView())
            }
        }()
        if slot.type == "photo" {
            slotContent
        } else {
            slotContent.slotBackground(
                ambient: entry.settings.ambientMode(for: slot.type),
                bgHex: entry.settings.backgroundHex(for: slot.type),
                imageLoader: { loadBackgroundImage(for: slot.type) }
            )
        }
    }

    @ViewBuilder
    private func compactSlotRow(for slot: DashboardSlotData) -> some View {
        let slotTheme = theme(for: slot.type)
        HStack(spacing: 8) {
            Image(systemName: iconName(for: slot.type))
                .font(.system(size: 12))
                .foregroundColor(slotTheme.accent)
                .frame(width: 16)

            Text(valueText(for: slot.type))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(slotTheme.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(OLEDColors.surfaceCard)
        )
    }

    private func iconName(for type: String) -> String {
        switch type {
        case "clock": return "clock.fill"
        case "calendar": return "calendar"
        case "weather": return entry.data.weatherIcon
        case "battery": return entry.data.batteryIcon
        case "moonPhase": return "moon.fill"
        case "photo": return "photo.fill"
        default: return "questionmark"
        }
    }

    private func valueText(for type: String) -> String {
        switch type {
        case "clock":
            let f = DateFormatter()
            f.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm a"
            return f.string(from: entry.date)
        case "calendar":
            if let time = entry.data.nextEventTime {
                return time
            }
            let f = DateFormatter()
            f.dateFormat = "d. MMM"
            f.locale = Locale.current
            return f.string(from: Date())
        case "weather":
            return entry.data.temperatureShort
        case "battery":
            return entry.data.batteryLevel > 0 ? "\(entry.data.batteryLevel)%" : "--%"
        case "moonPhase":
            return MoonPhaseSlotView.currentEmoji(for: entry.date)
        case "photo":
            return String(localized: "photo.label")
        default:
            return ""
        }
    }

    private func labelText(for type: String) -> String {
        switch type {
        case "clock": return String(localized: "label.clock")
        case "calendar":
            return entry.data.nextEventTitle ?? String(localized: "label.calendar")
        case "weather": return String(localized: "label.weather")
        case "battery": return String(localized: "battery.label")
        case "moonPhase": return String(localized: "label.moon")
        case "photo": return String(localized: "photo.label")
        default: return ""
        }
    }
}
