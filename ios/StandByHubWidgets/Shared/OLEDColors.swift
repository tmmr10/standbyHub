import SwiftUI

enum OLEDColors {
    static let trueBlack = Color(red: 0, green: 0, blue: 0)
    static let surfaceDark = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let surfaceCard = Color(red: 0.133, green: 0.133, blue: 0.133)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.67)
    static let textMuted = Color(white: 0.4)

    static func accent(from hex: String) -> Color {
        colorFromHex(hex)
    }

    static func colorFromHex(_ hex: String) -> Color {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty, let value = UInt64(cleaned, radix: 16) else {
            return Color.white
        }
        let a = Double((value >> 24) & 0xFF) / 255.0
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        return Color(red: r, green: g, blue: b).opacity(a)
    }
}

// Ambient background gradients for clock widgets
enum AmbientBackground {
    static func gradient(for mode: String, bgHex: String) -> [Color]? {
        switch mode {
        case "none":
            return nil
        case "aurora":
            return [
                Color(hue: 0.35, saturation: 0.8, brightness: 0.5),
                Color(hue: 0.55, saturation: 0.7, brightness: 0.4),
                Color(hue: 0.75, saturation: 0.6, brightness: 0.3),
                OLEDColors.trueBlack,
            ]
        case "lava":
            return [
                Color(hue: 0.05, saturation: 1.0, brightness: 0.5),
                Color(hue: 0.02, saturation: 0.9, brightness: 0.35),
                Color(hue: 0.0, saturation: 1.0, brightness: 0.2),
                OLEDColors.trueBlack,
            ]
        case "ocean":
            return [
                Color(hue: 0.52, saturation: 1.0, brightness: 0.45),
                Color(hue: 0.58, saturation: 0.9, brightness: 0.3),
                Color(hue: 0.65, saturation: 0.8, brightness: 0.15),
                OLEDColors.trueBlack,
            ]
        case "sunset":
            return [
                Color(hue: 0.08, saturation: 1.0, brightness: 0.5),
                Color(hue: 0.95, saturation: 0.8, brightness: 0.4),
                Color(hue: 0.78, saturation: 0.9, brightness: 0.2),
                OLEDColors.trueBlack,
            ]
        case "forest":
            return [
                Color(hue: 0.35, saturation: 0.9, brightness: 0.25),
                Color(hue: 0.45, saturation: 0.8, brightness: 0.2),
                Color(hue: 0.47, saturation: 0.9, brightness: 0.15),
                OLEDColors.trueBlack,
            ]
        case "nebula":
            return [
                Color(hue: 0.78, saturation: 1.0, brightness: 0.5),
                Color(hue: 0.82, saturation: 0.8, brightness: 0.45),
                Color(hue: 0.92, saturation: 0.9, brightness: 0.2),
                OLEDColors.trueBlack,
            ]
        case "custom":
            let base = OLEDColors.colorFromHex(bgHex)
            return [base.opacity(0.6), base.opacity(0.2), OLEDColors.trueBlack]
        case "image":
            return nil
        default:
            return nil
        }
    }
}
