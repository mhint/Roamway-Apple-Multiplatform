import SwiftUI

struct SwipeableRowView<Content: View, Actions: View>: View {
    let maxReveal: CGFloat
    var haptics: Bool = true

    @ViewBuilder var content: () -> Content
    @ViewBuilder var actions: () -> Actions

    @GestureState private var drag: CGSize = .zero
    @GestureState private var isHoriz: Bool = false
    @State private var offsetX: CGFloat = 0          // 0 … -maxReveal
    @State private var isOpen: Bool = false

    private let cornerRadius: CGFloat = 16
    private let notchRadius: CGFloat = 10
    private let snap = Animation.interactiveSpring(response: 0.25, dampingFraction: 0.88, blendDuration: 0.1)

    var body: some View {
        ZStack(alignment: .trailing) {
            // UNDERLAY: actions stay fixed
            actions()
                .padding(.trailing, 8)
                .frame(width: maxReveal)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .mask(
                    Rectangle()
                        .overlay(
                            TicketShape()
                                .offset(x: visualOffset)
                                .fill(.black)
                                .blendMode(.destinationOut)
                        )
                        .compositingGroup()
                )
            
            // OVERLAY: the WHOLE ticket (with its own shape/stroke/mask) moves as one unit
            card
                .offset(x: visualOffset)
                .contentShape(Rectangle())
                // Let taps pass through to actions only when open & not actively dragging:
                .allowsHitTesting(!(isOpen || isHoriz))
                .onTapGesture { if isOpen { withAnimation(snap) { close() } } }
                .animation(snap, value: offsetX)
        }
        // 🚫 Do NOT clip/mask the container—mask is on `card`, so it moves with it.
        .contentShape(Rectangle())
        .highPriorityGesture(rowDrag)
        .onDisappear { close() }
    }

    // This is your moving "ticket" group. If JourneyRowView already draws the shape,
    // keep it there and remove the background/overlay here.
    private var card: some View {
        content()
            .background(
                TicketShape()
                    .fill(.ultraThinMaterial, style: FillStyle(eoFill: true))
            )
            .overlay(
                TicketShape()
                    .stroke(.secondary.opacity(0.25), lineWidth: 1)
            )
            .clipShape(TicketShape()) // mask moves with card
    }

    // Direction-locked drag on the container; only horizontal drags affect the row
    private var rowDrag: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .updating($drag) { v, s, _ in s = v.translation }
            .updating($isHoriz) { v, s, _ in
                let dx = abs(v.translation.width), dy = abs(v.translation.height)
                s = isOpen ? (dx > 2) : (dx > dy + 4)  // lenient when open
            }
            .onChanged { v in
                guard isOpen ? (abs(v.translation.width) > 2) : (abs(v.translation.width) > abs(v.translation.height) + 4) else { return }
                let proposed = offsetX + v.translation.width
                offsetX = clampWithRubberBand(proposed)
            }
            .onEnded { v in
                guard isOpen ? (abs(v.translation.width) > 2) : (abs(v.translation.width) > abs(v.translation.height) + 4) else { return }
                let predicted = offsetX + v.predictedEndTranslation.width
                withAnimation(snap) { (predicted < -maxReveal * 0.33) ? open() : close() }
            }
    }

    private var visualOffset: CGFloat {
        isHoriz ? clampWithRubberBand(offsetX + drag.width) : offsetX
    }
    private func clampWithRubberBand(_ x: CGFloat) -> CGFloat {
        if x < -maxReveal { return -maxReveal + rubberBand(x + maxReveal) }
        if x > 0         { return rubberBand(x) }
        return x
    }
    private func rubberBand(_ d: CGFloat, c: CGFloat = 0.55) -> CGFloat { (c * d) / (abs(d) + c * maxReveal) }
    private func open() { if !isOpen, haptics { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }; offsetX = -maxReveal; isOpen = true }
    private func close() { offsetX = 0; isOpen = false }
}
