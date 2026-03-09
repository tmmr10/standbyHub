import SwiftUI

enum OLEDColors {
    static let trueBlack = Color(red: 0, green: 0, blue: 0)
    static let surfaceDark = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let surfaceCard = Color(red: 0.133, green: 0.133, blue: 0.133)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.67)
    static let textMuted = Color(white: 0.4)

    static func accent(from hex: String) -> Color {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = UInt64(cleaned, radix: 16) else {
            return Color(red: 0, green: 0.867, blue: 1) // #00DDFF
        }
        let a = Double((value >> 24) & 0xFF) / 255.0
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        return Color(red: r, green: g, blue: b).opacity(a)
    }
}
