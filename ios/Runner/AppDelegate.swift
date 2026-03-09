import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {

    private let appGroupID = "group.com.tmmr.standbyHub"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller = window?.rootViewController as! FlutterViewController

        // Settings channel
        let settingsChannel = FlutterMethodChannel(
            name: "com.tmmr.standbyHub/settings",
            binaryMessenger: controller.binaryMessenger
        )
        settingsChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            switch call.method {
            case "saveSettings":
                if let args = call.arguments as? [String: Any],
                   let json = args["json"] as? String {
                    let defaults = UserDefaults(suiteName: self.appGroupID)
                    defaults?.set(json, forKey: "widget_settings")
                    defaults?.synchronize()
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing json", details: nil))
                }
            case "loadSettings":
                let defaults = UserDefaults(suiteName: self.appGroupID)
                let json = defaults?.string(forKey: "widget_settings") ?? ""
                result(json)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Widget reload channel
        let widgetChannel = FlutterMethodChannel(
            name: "com.tmmr.standbyHub/widget",
            binaryMessenger: controller.binaryMessenger
        )
        widgetChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "reloadAllWidgets":
                WidgetCenter.shared.reloadAllTimelines()
                result(nil)
            case "reloadWidget":
                if let args = call.arguments as? [String: Any],
                   let kind = args["kind"] as? String {
                    WidgetCenter.shared.reloadTimelines(ofKind: kind)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing kind", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
