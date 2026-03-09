import SwiftUI

struct WidgetTheme {
    let accent: Color
    let background: Color
    let textPrimary: Color
    let textSecondary: Color

    static func from(settings: WidgetSettingsData) -> WidgetTheme {
        let accent: Color
        if settings.timeOfDayReactivity {
            accent = TimeOfDayColor.forCurrentHour()
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
