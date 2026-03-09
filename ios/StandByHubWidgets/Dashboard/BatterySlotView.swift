import SwiftUI

struct BatterySlotView: View {
    let theme: WidgetTheme

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "battery.75percent")
                .font(.system(size: 20))
                .foregroundColor(theme.accent)

            Text("75%")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(theme.textPrimary)

            Text("BATTERIE")
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
