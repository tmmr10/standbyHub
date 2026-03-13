import SwiftUI
import WidgetKit

struct BinaryClockView: View {
    let entry: ClockEntry

    @Environment(\.widgetFamily) var family

    private var digits: [Int] {
        let calendar = Calendar.current
        let h = calendar.component(.hour, from: entry.date)
        let m = calendar.component(.minute, from: entry.date)
        return [h / 10, h % 10, m / 10, m % 10]
    }

    private var dotSize: CGFloat { family == .systemLarge ? 20 : 14 }

    var body: some View {
        HStack(spacing: family == .systemLarge ? 10 : 6) {
            BinaryColumn(value: digits[0], accent: entry.theme.accent, dotSize: dotSize)
            BinaryColumn(value: digits[1], accent: entry.theme.accent, dotSize: dotSize)

            Rectangle()
                .fill(Color.clear)
                .frame(width: family == .systemLarge ? 16 : 10)

            BinaryColumn(value: digits[2], accent: entry.theme.accent, dotSize: dotSize)
            BinaryColumn(value: digits[3], accent: entry.theme.accent, dotSize: dotSize)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BinaryColumn: View {
    let value: Int
    let accent: Color
    var dotSize: CGFloat = 14

    var body: some View {
        VStack(spacing: 4) {
            ForEach((0..<4).reversed(), id: \.self) { bit in
                Circle()
                    .fill((value >> bit) & 1 == 1 ? accent : accent.opacity(0.15))
                    .frame(width: dotSize, height: dotSize)
            }
        }
    }
}
