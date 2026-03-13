import SwiftUI

struct BatterySlotView: View {
    let theme: WidgetTheme
    let data: DashboardData

    private var levelText: String {
        data.batteryLevel > 0 ? "\(data.batteryLevel)%" : "--%"
    }

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: data.batteryIcon)
                .font(.system(size: 14))
                .foregroundColor(batteryColor)

            Text(levelText)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(theme.accent)
                .minimumScaleFactor(0.7)
        }
        .padding(6)
    }

    private var batteryColor: Color {
        if data.batteryLevel <= 20 { return .red }
        if data.batteryLevel <= 40 { return .orange }
        return theme.accent
    }
}
