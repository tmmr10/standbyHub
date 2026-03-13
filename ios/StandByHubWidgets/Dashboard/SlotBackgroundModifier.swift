import SwiftUI

struct SlotBackgroundModifier: ViewModifier {
    let ambient: String
    let bgHex: String
    let imageLoader: () -> UIImage?

    func body(content: Content) -> some View {
        if ambient == "image", let img = imageLoader() {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(Color.black.opacity(0.45))
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else if let colors = AmbientBackground.gradient(for: ambient, bgHex: bgHex) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                )
        } else {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(OLEDColors.surfaceCard)
                )
        }
    }
}

extension View {
    func slotBackground(ambient: String, bgHex: String, imageLoader: @escaping () -> UIImage?) -> some View {
        modifier(SlotBackgroundModifier(ambient: ambient, bgHex: bgHex, imageLoader: imageLoader))
    }
}
