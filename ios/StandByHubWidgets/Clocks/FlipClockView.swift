import SwiftUI
import WidgetKit

struct FlipClockView: View {
    let entry: ClockEntry

    @Environment(\.widgetFamily) var family

    private var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = entry.settings.use24HourFormat ? "HH" : "hh"
        return formatter.string(from: entry.date)
    }

    private var minuteString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: entry.date)
    }

    private var isLarge: Bool { family == .systemLarge }
    private var digitWidth: CGFloat { isLarge ? 60 : 40 }
    private var digitHeight: CGFloat { isLarge ? 88 : 58 }
    private var fontSize: CGFloat { isLarge ? 60 : 40 }
    private var colonSize: CGFloat { isLarge ? 72 : 48 }

    var body: some View {
        HStack(spacing: isLarge ? 6 : 4) {
            FlipDigit(character: String(hourString.first ?? "0"), accent: entry.theme.accent, width: digitWidth, height: digitHeight, fontSize: fontSize)
            FlipDigit(character: String(hourString.last ?? "0"), accent: entry.theme.accent, width: digitWidth, height: digitHeight, fontSize: fontSize)

            Text(":")
                .font(.system(size: colonSize, weight: .light))
                .foregroundColor(entry.theme.accent)
                .padding(.horizontal, 4)

            FlipDigit(character: String(minuteString.first ?? "0"), accent: entry.theme.accent, width: digitWidth, height: digitHeight, fontSize: fontSize)
            FlipDigit(character: String(minuteString.last ?? "0"), accent: entry.theme.accent, width: digitWidth, height: digitHeight, fontSize: fontSize)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FlipDigit: View {
    let character: String
    let accent: Color
    var width: CGFloat = 40
    var height: CGFloat = 58
    var fontSize: CGFloat = 40

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(OLEDColors.surfaceDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            Rectangle()
                .fill(OLEDColors.trueBlack)
                .frame(height: 1.5)

            Text(character)
                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                .foregroundColor(accent)
        }
        .frame(width: width, height: height)
    }
}
