import SwiftUI
import WidgetKit

struct OceanView: View {
    let entry: AmbientEntry

    private var colors: [Color] {
        let shift = Double(entry.gradientIndex) * 0.03
        return [
            Color(hue: 0.52 + shift, saturation: 1.0, brightness: 0.8),
            Color(hue: 0.58 + shift, saturation: 0.9, brightness: 0.6),
            Color(hue: 0.65 + shift, saturation: 0.8, brightness: 0.3),
            OLEDColors.trueBlack,
        ]
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
