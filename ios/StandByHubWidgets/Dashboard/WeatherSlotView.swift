import SwiftUI

struct WeatherSlotView: View {
    let theme: WidgetTheme

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 20))
                .foregroundColor(theme.accent)

            Text("--°")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(theme.textPrimary)

            Text("WETTER")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(OLEDColors.surfaceCard)
        )
    }
}
