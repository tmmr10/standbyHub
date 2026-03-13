import SwiftUI
import WidgetKit

struct PixelArtClockView: View {
    let entry: ClockEntry

    @Environment(\.widgetFamily) var family

    private var isLarge: Bool { family == .systemLarge }

    private var hour: Int {
        Calendar.current.component(.hour, from: entry.date)
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm"
        return formatter.string(from: entry.date)
    }

    private var sceneColors: (sky: Color, mountain: Color, ground: Color, icon: String) {
        let h = hour
        if h >= 6 && h < 10 {
            return (Color(red: 1.0, green: 0.6, blue: 0.34), Color(red: 0.18, green: 0.31, blue: 0.09), Color(red: 0.23, green: 0.49, blue: 0.04), "sun.rise.fill")
        }
        if h >= 10 && h < 17 {
            return (Color(red: 0.31, green: 0.76, blue: 0.97), Color(red: 0.18, green: 0.49, blue: 0.2), Color(red: 0.30, green: 0.69, blue: 0.31), "sun.max.fill")
        }
        if h >= 17 && h < 20 {
            return (Color(red: 0.18, green: 0.11, blue: 0.31), Color(red: 0.1, green: 0.1, blue: 0.18), Color(red: 0.09, green: 0.13, blue: 0.24), "sunset.fill")
        }
        return (Color(red: 0.05, green: 0.11, blue: 0.16), Color(red: 0.11, green: 0.16, blue: 0.22), Color(red: 0.11, green: 0.16, blue: 0.22), "moon.stars.fill")
    }

    var body: some View {
        let colors = sceneColors
        VStack(spacing: isLarge ? 10 : 6) {
            ZStack {
                VStack(spacing: 0) {
                    Rectangle().fill(colors.sky).frame(height: isLarge ? 70 : 40)
                    MountainShape()
                        .fill(colors.mountain)
                        .frame(height: isLarge ? 35 : 20)
                    Rectangle().fill(colors.ground).frame(height: isLarge ? 35 : 20)
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))

                VStack {
                    HStack {
                        Image(systemName: colors.icon)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: isLarge ? 24 : 16))
                        Spacer()
                    }
                    .padding(.leading, 8)
                    .padding(.top, 6)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: isLarge ? 140 : 80)

            Text(timeString)
                .font(.system(size: isLarge ? 40 : 24, weight: .bold, design: .monospaced))
                .foregroundColor(entry.theme.accent)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MountainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.15, y: rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.55, y: rect.height * 0.05))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width * 0.85, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
