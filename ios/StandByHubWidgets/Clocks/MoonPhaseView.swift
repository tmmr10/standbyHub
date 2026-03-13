import SwiftUI
import WidgetKit

struct MoonPhaseView: View {
    let entry: ClockEntry

    @Environment(\.widgetFamily) var family

    private var isLarge: Bool { family == .systemLarge }

    private var moonPhase: Double {
        let reference = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            year: 2000, month: 1, day: 6, hour: 18, minute: 14
        ).date!
        let days = entry.date.timeIntervalSince(reference) / 86400.0
        let phase = days.truncatingRemainder(dividingBy: 29.53) / 29.53
        return phase < 0 ? phase + 1 : phase
    }

    private var phaseName: String {
        let p = moonPhase
        if p < 0.0625 { return String(localized: "moon.newMoon") }
        if p < 0.1875 { return String(localized: "moon.waxingCrescent") }
        if p < 0.3125 { return String(localized: "moon.firstQuarter") }
        if p < 0.4375 { return String(localized: "moon.waxingGibbous") }
        if p < 0.5625 { return String(localized: "moon.fullMoon") }
        if p < 0.6875 { return String(localized: "moon.waningGibbous") }
        if p < 0.8125 { return String(localized: "moon.lastQuarter") }
        if p < 0.9375 { return String(localized: "moon.waningCrescent") }
        return String(localized: "moon.newMoon")
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm"
        return formatter.string(from: entry.date)
    }

    private var moonEmoji: String {
        let p = moonPhase
        if p < 0.0625 { return "🌑" }
        if p < 0.1875 { return "🌒" }
        if p < 0.3125 { return "🌓" }
        if p < 0.4375 { return "🌔" }
        if p < 0.5625 { return "🌕" }
        if p < 0.6875 { return "🌖" }
        if p < 0.8125 { return "🌗" }
        if p < 0.9375 { return "🌘" }
        return "🌑"
    }

    var body: some View {
        VStack(spacing: isLarge ? 10 : 6) {
            Text(moonEmoji)
                .font(.system(size: isLarge ? 80 : 56))

            Text(phaseName)
                .font(.system(size: isLarge ? 18 : 11, weight: .medium))
                .foregroundColor(entry.theme.accent.opacity(0.6))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(timeString)
                .font(.system(size: isLarge ? 36 : 22, weight: .light, design: .rounded))
                .foregroundColor(entry.theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
