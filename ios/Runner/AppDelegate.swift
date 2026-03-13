import Flutter
import UIKit
import WidgetKit
import CoreLocation
import EventKit

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {

    private let appGroupID = "group.com.tmmr.standbyHub"
    private var locationManager: CLLocationManager?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Request calendar access
        requestCalendarAccess()

        // Enable battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        writeBatteryLevel()

        // Observe battery level changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )

        // Request location for weather
        setupLocation()

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
            case "saveBackgroundImage":
                if let args = call.arguments as? [String: Any],
                   let sourcePath = args["sourcePath"] as? String,
                   let widgetKey = args["widgetKey"] as? String {
                    self.saveBackgroundImage(sourcePath: sourcePath, widgetKey: widgetKey, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing sourcePath or widgetKey", details: nil))
                }
            case "removeBackgroundImage":
                if let args = call.arguments as? [String: Any],
                   let filename = args["filename"] as? String {
                    self.removeBackgroundImage(filename: filename)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing filename", details: nil))
                }
            case "getBackgroundImagePath":
                if let args = call.arguments as? [String: Any],
                   let filename = args["filename"] as? String,
                   let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.appGroupID) {
                    let fileURL = containerURL.appendingPathComponent(filename)
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        result(fileURL.path)
                    } else {
                        result(nil)
                    }
                } else {
                    result(nil)
                }
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
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                result(nil)
            case "reloadWidget":
                if let args = call.arguments as? [String: Any],
                   let kind = args["kind"] as? String {
                    if #available(iOS 14.0, *) {
                        WidgetCenter.shared.reloadTimelines(ofKind: kind)
                    }
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

    // MARK: - Calendar Access

    private func requestCalendarAccess() {
        let store = EKEventStore()
        if #available(iOS 17.0, *) {
            store.requestFullAccessToEvents { granted, error in
                if granted {
                    if #available(iOS 14.0, *) {
                        WidgetCenter.shared.reloadTimelines(ofKind: "StandByDashboardWidget")
                    }
                }
            }
        } else {
            store.requestAccess(to: .event) { granted, error in
                if granted {
                    if #available(iOS 14.0, *) {
                        WidgetCenter.shared.reloadTimelines(ofKind: "StandByDashboardWidget")
                    }
                }
            }
        }
    }

    // MARK: - Battery

    private func writeBatteryLevel() {
        let level = UIDevice.current.batteryLevel
        let percent: Int
        if level < 0 {
            // Simulator or unknown — write a simulated value
            percent = 85
        } else {
            percent = Int(level * 100)
        }
        let defaults = UserDefaults(suiteName: appGroupID)
        defaults?.set(percent, forKey: "battery_level")
        defaults?.synchronize()
    }

    @objc private func batteryLevelDidChange() {
        writeBatteryLevel()
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: "StandByDashboardWidget")
        }
    }

    // MARK: - Location (for Weather)

    private func setupLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchWeather(for: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Location failed — write fallback weather
        let defaults = UserDefaults(suiteName: appGroupID)
        defaults?.set(20, forKey: "weather_temp")
        defaults?.set("cloud.sun.fill", forKey: "weather_icon")
        defaults?.synchronize()
    }

    // MARK: - Weather (WeatherKit via Apple Weather REST or simple approach)

    private func fetchWeather(for location: CLLocation) {
        // Use Apple Weather URL scheme for a simple approach
        // For production: use WeatherKit framework
        // For now: use OpenMeteo (free, no API key needed)
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let urlStr = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,weather_code&timezone=auto"

        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let current = json["current"] as? [String: Any],
                  let temp = current["temperature_2m"] as? Double,
                  let weatherCode = current["weather_code"] as? Int
            else { return }

            let defaults = UserDefaults(suiteName: self.appGroupID)
            defaults?.set(Int(temp.rounded()), forKey: "weather_temp")
            defaults?.set(self.weatherIcon(for: weatherCode), forKey: "weather_icon")
            defaults?.synchronize()

            DispatchQueue.main.async {
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadTimelines(ofKind: "StandByDashboardWidget")
                }
            }
        }.resume()
    }

    // MARK: - Background Image

    private func saveBackgroundImage(sourcePath: String, widgetKey: String, result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            guard let containerURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: self.appGroupID
            ) else {
                DispatchQueue.main.async {
                    result(FlutterError(code: "NO_CONTAINER", message: "App Group container not found", details: nil))
                }
                return
            }

            guard let originalImage = UIImage(contentsOfFile: sourcePath) else {
                DispatchQueue.main.async {
                    result(FlutterError(code: "NO_IMAGE", message: "Could not load image", details: nil))
                }
                return
            }

            // Resize to max 1024px
            let resized = originalImage.resized(maxDimension: 1024)

            // Compress as JPEG
            guard let jpegData = resized.jpegData(compressionQuality: 0.7) else {
                DispatchQueue.main.async {
                    result(FlutterError(code: "COMPRESS_FAIL", message: "JPEG compression failed", details: nil))
                }
                return
            }

            let filename = "bg_\(widgetKey).jpg"
            let fileURL = containerURL.appendingPathComponent(filename)

            do {
                try jpegData.write(to: fileURL)
                DispatchQueue.main.async {
                    result(filename)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "WRITE_FAIL", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    private func removeBackgroundImage(filename: String) {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        ) else { return }
        let fileURL = containerURL.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: fileURL)
    }

    private func weatherIcon(for code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1, 2: return "cloud.sun.fill"
        case 3: return "cloud.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 61, 63, 65: return "cloud.rain.fill"
        case 66, 67: return "cloud.sleet.fill"
        case 71, 73, 75, 77: return "cloud.snow.fill"
        case 80, 81, 82: return "cloud.heavyrain.fill"
        case 85, 86: return "cloud.snow.fill"
        case 95, 96, 99: return "cloud.bolt.rain.fill"
        default: return "cloud.sun.fill"
        }
    }
}

// MARK: - UIImage Resize

extension UIImage {
    func resized(maxDimension: CGFloat) -> UIImage {
        let ratio = max(size.width, size.height) / maxDimension
        guard ratio > 1 else { return self }
        let newSize = CGSize(width: size.width / ratio, height: size.height / ratio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
