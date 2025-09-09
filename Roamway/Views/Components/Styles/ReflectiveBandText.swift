struct ReflectiveBandText: View {
    var text: String
    var height: CGFloat = 20

    @StateObject private var tilt = TiltMotionManager()

    private func repeated(_ s: String) -> String {
        Array(repeating: s, count: 20).joined(separator: " • ")
    }

    var body: some View {
        ZStack {
            Text(repeated(text))
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize()
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
                .frame(height: height)
                .background(.thinMaterial)

            GeometryReader { geo in
                let w = geo.size.width
                let stripeW = max(w * 0.25, 80)
                // Map roll (±45°) to [0, 1] across the band
                let clamped = max(-.pi/4, min(.pi/4, tilt.roll))
                let t = (clamped / (.pi/4) + 1) / 2 // 0...1
                let x = t * w

                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .white.opacity(0.0), location: 0.0),
                        .init(color: .white.opacity(0.35), location: 0.5),
                        .init(color: .white.opacity(0.0), location: 1.0),
                    ]),
                    startPoint: .leading, endPoint: .trailing
                )
                .frame(width: stripeW, height: height)
                .position(x: x, y: height/2)
                .blendMode(.screen)
                .allowsHitTesting(false)
            }
            .frame(height: height)
        }
        .onAppear { tilt.start() }
        .onDisappear { tilt.stop() }
        .drawingGroup()
    }
}