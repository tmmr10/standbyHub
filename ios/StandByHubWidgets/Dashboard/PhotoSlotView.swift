import SwiftUI

struct PhotoSlotView: View {
    let theme: WidgetTheme
    let settings: WidgetSettingsData

    private var imageName: String {
        settings.photoWidgetImage
    }

    var body: some View {
        Group {
            if !imageName.isEmpty, let uiImage = loadImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .overlay(Color.black.opacity(0.35))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                VStack(spacing: 4) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 18))
                        .foregroundColor(theme.accent.opacity(0.5))
                    Text(String(localized: "photo.label"))
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(theme.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(OLEDColors.surfaceCard)
                )
            }
        }
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
