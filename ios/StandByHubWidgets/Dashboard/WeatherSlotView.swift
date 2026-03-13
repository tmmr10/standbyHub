import SwiftUI

struct WeatherSlotView: View {
    let theme: WidgetTheme
    let data: DashboardData

    private var tempText: String {
        data.temperatureShort
    }

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: data.weatherIcon)
                .font(.system(size: 14))
                .symbolRenderingMode(.multicolor)

            Text(tempText)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(theme.accent)
                .minimumScaleFactor(0.7)
        }
        .padding(6)
    }
}
