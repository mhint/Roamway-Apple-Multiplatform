import SwiftUI

struct ColorStyleSheetView: View {
    let title: String
    let journeyID: UUID
    @ObservedObject var viewModel: JourneyViewModel

    @State private var accent: Color
    @State private var fill: Color

    init(title: String, journey: Journey, viewModel: JourneyViewModel) {
        self.title = title
        self.journeyID = journey.id
        self.viewModel = viewModel

        // Seed states from current card
        if case .color(let cd) = journey.card.accent.kind {
            _accent = State(initialValue: cd.color)
        } else {
            _accent = State(initialValue: .accentColor)
        }
        if case .color(let cd) = journey.card.fill.kind {
            _fill = State(initialValue: cd.color)
        } else {
            _fill = State(initialValue: .blue.opacity(0.25))
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Accent") {
                    ColorPicker("Accent Color", selection: $accent, supportsOpacity: true)
                }
                Section("Fill") {
                    ColorPicker("Fill Color", selection: $fill, supportsOpacity: true)
                }
            }
            .navigationTitle("Style • \(title)")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                viewModel.setCardColors(for: journeyID, accent: accent, fill: fill)
            }
        }
    }
}
