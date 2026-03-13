import SwiftUI

struct CalendarSlotView: View {
    let theme: WidgetTheme
    let data: DashboardData

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: "calendar")
                .font(.system(size: 14))
                .foregroundColor(theme.accent)

            if let title = data.nextEventTitle {
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(theme.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                if let time = data.nextEventTime {
                    Text(time)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(theme.accent)
                        .minimumScaleFactor(0.8)
                }
            } else {
                Text(dayString)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(theme.textPrimary)
                    .minimumScaleFactor(0.7)

                Text(monthString)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(theme.textSecondary)
            }
        }
        .padding(6)
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }

    private var monthString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM"
        return formatter.string(from: Date()).uppercased()
    }
}
