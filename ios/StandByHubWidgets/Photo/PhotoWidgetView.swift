import SwiftUI
import WidgetKit

struct PhotoWidgetView: View {
    let entry: DashboardEntry

    @Environment(\.widgetFamily) var family

    private var imageName: String {
        entry.settings.photoWidgetImage
    }

    var body: some View {
        ZStack {
            if !imageName.isEmpty, let uiImage = loadImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                // Dark overlay for OLED
                Color.black.opacity(0.4)

                // Optional time overlay at bottom
                VStack {
                    Spacer()
                    HStack {
                        Text(timeString)
                            .font(.system(size: family == .systemLarge ? 28 : 18, weight: .medium, design: .rounded))
                            .foregroundColor(OLEDColors.textPrimary)
                            .shadow(color: .black.opacity(0.6), radius: 4)
                        Spacer()
                        Text(dateString)
                            .font(.system(size: family == .systemLarge ? 14 : 11, weight: .medium))
                            .foregroundColor(OLEDColors.textSecondary)
                            .shadow(color: .black.opacity(0.6), radius: 4)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                }
            } else {
                OLEDColors.trueBlack
                VStack(spacing: 8) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 32))
                        .foregroundColor(OLEDColors.textMuted)
                    Text(String(localized: "photo.noPhoto"))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(OLEDColors.textMuted)
                    Text(String(localized: "photo.chooseImage"))
                        .font(.system(size: 10))
                        .foregroundColor(OLEDColors.textMuted.opacity(0.6))
                }
            }
        }
    }

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = entry.settings.use24HourFormat ? "HH:mm" : "h:mm"
        return f.string(from: entry.date)
    }

    private var dateString: String {
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateFormat = "E, d. MMM"
        return f.string(from: entry.date)
    }

    private func loadImage() -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.tmmr.standbyHub"
        ) else { return nil }
        let fileURL = containerURL.appendingPathComponent(imageName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}
