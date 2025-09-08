import SwiftUI

private struct FlyOut: AnimatableModifier {
    var progress: CGFloat      // 0 → 1
    let angle: CGFloat         // degrees
    let distance: CGFloat      // pts

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .offset(x: progress * distance)
//            .rotation3DEffect(.degrees(Double(progress * angle)), axis: (x: 0, y: 1, z: 0), anchor: .trailing, perspective: 0.6)
//            .opacity(CGFloat(1) - progress * 0.25)
//            .blur(radius: progress * 2)
//            .scaleEffect(1 - progress * 0.02, anchor: .trailing)
    }
}

extension AnyTransition {
    static func flyOutLeft(angle: CGFloat = 0, distance: CGFloat = -600) -> AnyTransition {
        .asymmetric(
            insertion: .identity,
            removal: .modifier(
                active: FlyOut(progress: 1, angle: angle, distance: distance),
                identity: FlyOut(progress: 0, angle: angle, distance: 0)
            )
        )
    }
}
