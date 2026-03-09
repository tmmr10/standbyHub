import SwiftUI
import WidgetKit

struct AuroraView: View {
    let entry: AmbientEntry

    private var colors: [Color] {
        let shift = Double(entry.gradientIndex) * 0.1
        return [
            Color(hue: 0.35 + shift, saturation: 0.8, brightness: 0.7),
            Color(hue: 0.55 + shift, saturation: 0.7, brightness: 0.8),
            Color(hue: 0.75 + shift, saturation: 0.6, brightness: 0.6),
            OLEDColors.trueBlack,
        ]
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: 0.3, y: 0),
            endPoint: UnitPoint(x: 0.7, y: 1)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
