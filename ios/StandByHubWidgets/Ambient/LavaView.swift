import SwiftUI
import WidgetKit

struct LavaView: View {
    let entry: AmbientEntry

    private var colors: [Color] {
        let shift = Double(entry.gradientIndex) * 0.05
        return [
            Color(hue: 0.05 + shift, saturation: 1.0, brightness: 0.9),
            Color(hue: 0.02 + shift, saturation: 0.9, brightness: 0.7),
            Color(hue: 0.0 + shift, saturation: 1.0, brightness: 0.4),
            OLEDColors.trueBlack,
        ]
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: 0.2, y: 0),
            endPoint: UnitPoint(x: 0.8, y: 1)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
