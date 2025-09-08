import SwiftUI

struct WallpaperBackground: View {
    var image: Image?
    var fallbackAsset: String?
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Group {
                if let img = image {
                    img.resizable()
                } else if let asset = fallbackAsset, let ui = UIImage(named: asset) {
                    Image(uiImage: ui).resizable()
                } else {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.35), Color.indigo.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
            .blur(radius: 16, opaque: true)
            .ignoresSafeArea()
        }
    }
}
