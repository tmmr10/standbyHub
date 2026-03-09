import SwiftUI
import WidgetKit

struct FlipClockView: View {
    let entry: ClockEntry

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

    var body: some View {
        HStack(spacing: 4) {
            FlipDigit(character: String(hourString.first ?? "0"), accent: entry.theme.accent)
            FlipDigit(character: String(hourString.last ?? "0"), accent: entry.theme.accent)

            Text(":")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(entry.theme.accent)
                .padding(.horizontal, 4)

            FlipDigit(character: String(minuteString.first ?? "0"), accent: entry.theme.accent)
            FlipDigit(character: String(minuteString.last ?? "0"), accent: entry.theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(OLEDColors.trueBlack)
    }
}

struct FlipDigit: View {
    let character: String
    let accent: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(OLEDColors.surfaceDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            // Split line
            Rectangle()
                .fill(OLEDColors.trueBlack)
                .frame(height: 1.5)

            Text(character)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(accent)
        }
        .frame(width: 40, height: 58)
    }
}
