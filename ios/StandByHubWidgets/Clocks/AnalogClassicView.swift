import SwiftUI
import WidgetKit

struct AnalogClassicView: View {
    let entry: ClockEntry

    private var hourAngle: Double {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: entry.date) % 12)
        let minute = Double(calendar.component(.minute, from: entry.date))
        return (hour + minute / 60.0) * 30.0 - 90.0
    }

    private var minuteAngle: Double {
        let minute = Double(Calendar.current.component(.minute, from: entry.date))
        return minute * 6.0 - 90.0
    }

    var body: some View {
        Canvas { context, size in
            let dim = min(size.width, size.height) - 16.0
            let radius = dim / 2.0
            let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            let accent = entry.theme.accent

            // Circle outline
            let circlePath = Path(ellipseIn: CGRect(
                x: center.x - radius, y: center.y - radius,
                width: dim, height: dim
            ))
            context.stroke(circlePath, with: .color(OLEDColors.surfaceCard), lineWidth: 2)

            // Hour markers
            for i in 0..<12 {
                let angle = Double(i) * 30.0 - 90.0
                let rad = angle * .pi / 180.0
                let outerR = radius - 4.0
                let innerR = radius - 14.0
                var markerPath = Path()
                markerPath.move(to: CGPoint(
                    x: center.x + outerR * cos(rad),
                    y: center.y + outerR * sin(rad)
                ))
                markerPath.addLine(to: CGPoint(
                    x: center.x + innerR * cos(rad),
                    y: center.y + innerR * sin(rad)
                ))
                context.stroke(markerPath, with: .color(accent.opacity(0.5)),
                               style: StrokeStyle(lineWidth: 2, lineCap: .round))
            }

            // Hour hand
            let hourRad = hourAngle * .pi / 180.0
            var hourPath = Path()
            hourPath.move(to: center)
            hourPath.addLine(to: CGPoint(
                x: center.x + radius * 0.5 * cos(hourRad),
                y: center.y + radius * 0.5 * sin(hourRad)
            ))
            context.stroke(hourPath, with: .color(accent),
                           style: StrokeStyle(lineWidth: 3, lineCap: .round))

            // Minute hand
            let minRad = minuteAngle * .pi / 180.0
            var minPath = Path()
            minPath.move(to: center)
            minPath.addLine(to: CGPoint(
                x: center.x + radius * 0.75 * cos(minRad),
                y: center.y + radius * 0.75 * sin(minRad)
            ))
            context.stroke(minPath, with: .color(accent),
                           style: StrokeStyle(lineWidth: 2, lineCap: .round))

            // Center dot
            let dotRect = CGRect(x: center.x - 4, y: center.y - 4, width: 8, height: 8)
            context.fill(Path(ellipseIn: dotRect), with: .color(accent))
        }
        .background(Color.clear)
    }
}
