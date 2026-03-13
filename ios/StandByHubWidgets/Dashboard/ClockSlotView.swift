import SwiftUI

/// Compact clock view used as a dashboard slot
struct ClockSlotView: View {
    let theme: WidgetTheme
    let settings: WidgetSettingsData
    let date: Date

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = settings.use24HourFormat ? "HH:mm" : "h:mm"
        return f.string(from: date)
    }

    private var periodString: String? {
        if settings.use24HourFormat { return nil }
        let f = DateFormatter()
        f.dateFormat = "a"
        return f.string(from: date)
    }

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: "clock.fill")
                .font(.system(size: 14))
                .foregroundColor(theme.accent)

            Text(timeString)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(theme.textPrimary)
                .minimumScaleFactor(0.7)

            if let period = periodString {
                Text(period)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(theme.textSecondary)
            }
        }
        .padding(6)
    }
}
