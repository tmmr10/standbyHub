import SwiftUI
import WidgetKit

struct GradientClockView: View {
    let entry: ClockEntry

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm"
        return formatter.string(from: entry.date)
    }

    private var gradientColors: [Color] {
        let hour = Calendar.current.component(.hour, from: entry.date)
        let base = TimeOfDayColor.forHour(hour)
        return [
            base.opacity(0.8),
            base.opacity(0.3),
            OLEDColors.trueBlack
        ]
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )

            Text(timeString)
                .font(.system(size: 56, weight: .ultraLight))
                .foregroundColor(.white)
                .tracking(6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
