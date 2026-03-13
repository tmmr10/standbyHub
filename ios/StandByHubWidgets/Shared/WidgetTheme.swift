import SwiftUI

struct WidgetTheme {
    let accent: Color
    let background: Color
    let textPrimary: Color
    let textSecondary: Color

    static func from(settings: WidgetSettingsData) -> WidgetTheme {
        from(settings: settings, date: Date())
    }

    static func from(settings: WidgetSettingsData, date: Date) -> WidgetTheme {
        let accent: Color
        if settings.timeOfDayReactivity {
            let hour = Calendar.current.component(.hour, from: date)
            accent = TimeOfDayColor.forHour(hour)
        } else {
            accent = OLEDColors.accent(from: settings.accentColorHex)
        }
        return WidgetTheme(
            accent: accent,
            background: OLEDColors.trueBlack,
            textPrimary: OLEDColors.textPrimary,
            textSecondary: OLEDColors.textSecondary
        )
    }

    /// Theme with per-slot accent color + background override
    static func from(settings: WidgetSettingsData, slotType: String) -> WidgetTheme {
        from(settings: settings, slotType: slotType, date: Date())
    }

    static func from(settings: WidgetSettingsData, slotType: String, date: Date) -> WidgetTheme {
        let accent: Color
        if settings.timeOfDayReactivity {
            let hour = Calendar.current.component(.hour, from: date)
            accent = TimeOfDayColor.forHour(hour)
        } else {
            accent = OLEDColors.accent(from: settings.accentHex(for: slotType))
        }
        let bgHex = settings.backgroundHex(for: slotType)
        let background = bgHex.isEmpty ? OLEDColors.trueBlack : OLEDColors.colorFromHex(bgHex)
        return WidgetTheme(
            accent: accent,
            background: background,
            textPrimary: OLEDColors.textPrimary,
            textSecondary: OLEDColors.textSecondary
        )
    }
}

enum TimeOfDayColor {
    static func forHour(_ hour: Int) -> Color {
        switch hour {
        case 0...4: return Color(red: 0.1, green: 0.14, blue: 0.49)
        case 5...6: return Color(red: 0, green: 0.37, blue: 0.39)
        case 7...8: return Color(red: 1, green: 0.56, blue: 0)
        case 9...11: return Color(red: 0, green: 0.87, blue: 1)
        case 12...16: return Color(red: 0, green: 0.59, blue: 0.65)
        case 17...18: return Color(red: 1, green: 0.44, blue: 0)
        case 19: return Color(red: 0.75, green: 0.21, blue: 0.05)
        case 20...21: return Color(red: 0.29, green: 0.08, blue: 0.57)
        default: return Color(red: 0.1, green: 0.14, blue: 0.49)
        }
    }

    static func forCurrentHour() -> Color {
        forHour(Calendar.current.component(.hour, from: Date()))
    }
}
