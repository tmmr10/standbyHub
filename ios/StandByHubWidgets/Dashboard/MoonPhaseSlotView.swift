import SwiftUI

struct MoonPhaseSlotView: View {
    let theme: WidgetTheme
    let date: Date
    let settings: WidgetSettingsData

    private var moonPhase: Double {
        let reference = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            year: 2000, month: 1, day: 6, hour: 18, minute: 14
        ).date!
        let days = date.timeIntervalSince(reference) / 86400.0
        let phase = days.truncatingRemainder(dividingBy: 29.53) / 29.53
        return phase < 0 ? phase + 1 : phase
    }

    private var phaseName: String {
        MoonPhaseSlotView.phaseName(for: moonPhase)
    }

    private var moonEmoji: String {
        MoonPhaseSlotView.emoji(for: moonPhase)
    }

    var body: some View {
        VStack(spacing: 3) {
            Text(moonEmoji)
                .font(.system(size: 22))

            Text(phaseName)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(theme.accent.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(timeString)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(theme.accent)
        }
        .padding(6)
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = settings.use24HourFormat ? "HH:mm" : "h:mm"
        return formatter.string(from: date)
    }

    // MARK: - Static helpers for compact row

    static func currentEmoji(for date: Date) -> String {
        let phase = computePhase(for: date)
        return emoji(for: phase)
    }

    static func currentPhaseName(for date: Date) -> String {
        let phase = computePhase(for: date)
        return phaseName(for: phase)
    }

    private static func computePhase(for date: Date) -> Double {
        let reference = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            year: 2000, month: 1, day: 6, hour: 18, minute: 14
        ).date!
        let days = date.timeIntervalSince(reference) / 86400.0
        let phase = days.truncatingRemainder(dividingBy: 29.53) / 29.53
        return phase < 0 ? phase + 1 : phase
    }

    private static func emoji(for p: Double) -> String {
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

    private static func phaseName(for p: Double) -> String {
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
}
