import SwiftUI
import WidgetKit

struct AnalogClassicView: View {
    let entry: ClockEntry

    private var hourAngle: Angle {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: entry.date) % 12)
        let minute = Double(calendar.component(.minute, from: entry.date))
        return .degrees((hour + minute / 60) * 30 - 90)
    }

    private var minuteAngle: Angle {
        let minute = Double(Calendar.current.component(.minute, from: entry.date))
        return .degrees(minute * 6 - 90)
    }

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height) - 16
            let radius = size / 2

            ZStack {
                // Hour markers
                ForEach(0..<12, id: \.self) { i in
                    let angle = Angle.degrees(Double(i) * 30 - 90)
                    let outerR = radius - 4
                    let innerR = radius - 14

                    Path { path in
                        path.move(to: CGPoint(
                            x: radius + 8 + outerR * cos(angle.radians),
                            y: radius + 8 + outerR * sin(angle.radians)
                        ))
                        path.addLine(to: CGPoint(
                            x: radius + 8 + innerR * cos(angle.radians),
                            y: radius + 8 + innerR * sin(angle.radians)
                        ))
                    }
                    .stroke(entry.theme.accent.opacity(0.5), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                }

                // Circle
                Circle()
                    .stroke(OLEDColors.surfaceCard, lineWidth: 2)
                    .frame(width: size, height: size)

                // Hour hand
                Path { path in
                    path.move(to: CGPoint(x: radius + 8, y: radius + 8))
                    path.addLine(to: CGPoint(
                        x: radius + 8 + radius * 0.5 * cos(hourAngle.radians),
                        y: radius + 8 + radius * 0.5 * sin(hourAngle.radians)
                    ))
                }
                .stroke(entry.theme.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))

                // Minute hand
                Path { path in
                    path.move(to: CGPoint(x: radius + 8, y: radius + 8))
                    path.addLine(to: CGPoint(
                        x: radius + 8 + radius * 0.75 * cos(minuteAngle.radians),
                        y: radius + 8 + radius * 0.75 * sin(minuteAngle.radians)
                    ))
                }
                .stroke(entry.theme.accent, style: StrokeStyle(lineWidth: 2, lineCap: .round))

                // Center dot
                Circle()
                    .fill(entry.theme.accent)
                    .frame(width: 8, height: 8)
                    .position(x: radius + 8, y: radius + 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(OLEDColors.trueBlack)
    }
}
