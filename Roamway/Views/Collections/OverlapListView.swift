import SwiftUI

struct OverlapListView<Data: RandomAccessCollection, Row: View>: View
where Data.Element: Identifiable {
    let data: Data
    var overlap: CGFloat = 12
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 24
    var rowHeight: CGFloat? = nil
    @ViewBuilder var row: (Data.Element) -> Row

    var body: some View {
        let totalOverlap = overlap * CGFloat(max(0, data.count - 1))

        ScrollView {
            VStack(spacing: 0) {
                // ⬇️ animate only this height change (the “nudge”)
                Color.clear
                    .frame(height: totalOverlap)
                    .animation(.easeInOut(duration: 0.35), value: totalOverlap)

                // Cards, overlapped with fixed offsets (no implicit animation here)
                ZStack(alignment: .top) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { idx, item in
                        row(item)
                            .frame(height: rowHeight)
                            .offset(y: -CGFloat(idx) * overlap) // pull each card up
                            .zIndex(Double(data.count - idx))
                            // prevent sibling reflow animations
                            .transaction { t in t.disablesAnimations = true }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
    }
}
