import Foundation

enum ProStatusChecker {
    static var isPro: Bool {
        WidgetSettingsReader.read().isPro
    }
}
