import SwiftUI
import WidgetKit

struct BinaryClockView: View {
    let entry: ClockEntry

    private var digits: [Int] {
        let calendar = Calendar.current
        let h = calendar.component(.hour, from: entry.date)
        let m = calendar.component(.minute, from: entry.date)
        return [h / 10, h % 10, m / 10, m % 10]
    }

    var body: some View {
        HStack(spacing: 6) {
            BinaryColumn(value: digits[0], accent: entry.theme.accent)
            BinaryColumn(value: digits[1], accent: entry.theme.accent)

            Rectangle()
                .fill(Color.clear)
                .frame(width: 10)

            BinaryColumn(value: digits[2], accent: entry.theme.accent)
            BinaryColumn(value: digits[3], accent: entry.theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(OLEDColors.trueBlack)
    }
}

struct BinaryColumn: View {
    let value: Int
    let accent: Color

    var body: some View {
        VStack(spacing: 4) {
            ForEach((0..<4).reversed(), id: \.self) { bit in
                Circle()
                    .fill((value >> bit) & 1 == 1 ? accent : accent.opacity(0.15))
                    .frame(width: 14, height: 14)
            }
        }
    }
}
