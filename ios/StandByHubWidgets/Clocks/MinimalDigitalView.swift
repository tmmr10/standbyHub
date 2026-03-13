import SwiftUI
import WidgetKit

struct MinimalDigitalView: View {
    let entry: ClockEntry

    @Environment(\.widgetFamily) var family

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm"
        return formatter.string(from: entry.date)
    }

    private var timeSize: CGFloat {
        family == .systemLarge ? 96 : 64
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(timeString)
                .font(.system(size: timeSize, weight: .ultraLight, design: .default))
                .foregroundColor(entry.theme.accent)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
