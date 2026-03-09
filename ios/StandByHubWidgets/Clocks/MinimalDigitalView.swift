import SwiftUI
import WidgetKit

struct MinimalDigitalView: View {
    let entry: ClockEntry

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm"
        return formatter.string(from: entry.date)
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "E, d. MMM"
        return formatter.string(from: entry.date)
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(timeString)
                .font(.system(size: 64, weight: .ultraLight, design: .default))
                .foregroundColor(entry.theme.accent)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(dateString)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(entry.theme.accent.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(OLEDColors.trueBlack)
    }
}
