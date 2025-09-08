import SwiftUI

struct CardStyleSheetView: View {
    @ObservedObject var viewModel: JourneyViewModel
    @State private var icon: String
    @State private var iconCategory: IconCategory
    @State private var accent: Color
    @State private var fill: Color
    let journey: Journey

    private var currentIcons: [String] {
        switch iconCategory {
        case .places:
            placeIcons
        case .storage:
            storageIcons
        case .transportation:
            transportationIcons
        case .nautical:
            nauticalIcons
        case .astro:
            astroIcons
        case .other:
            otherIcons
        }
    }
    
    init(journey: Journey, viewModel: JourneyViewModel) {
        self.journey = journey
        self.viewModel = viewModel

        _icon = State(initialValue: journey.icon)
        _iconCategory = State(initialValue: IconCategory.forIcon(journey.icon))

        if case .color(let cd) = journey.card.accent.kind {
            _accent = State(initialValue: cd.color)
        } else {
            _accent = State(initialValue: .primary)
        }

        if case .color(let cd) = journey.card.fill.kind {
            _fill = State(initialValue: cd.color)
        } else {
            _fill = State(initialValue: .blue)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Category", selection: $iconCategory) {
                    ForEach(IconCategory.allCases) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 6)

                Picker("Icon", selection: $icon) {
                    ForEach(currentIcons, id: \.self) { iconName in
                        Image(systemName: iconName)
                            .tag(iconName)
                    }
                }
                .pickerStyle(.segmented)

                Section("Colors") {
                    ColorPicker("Icon Color", selection: $accent, supportsOpacity: true)
                    ColorPicker("Fill Color", selection: $fill, supportsOpacity: true)
                }
            }
            .navigationTitle("Icon and Style")
            .onDisappear {
                viewModel.setCardColors(for: journey.id, accent: accent, fill: fill)
                viewModel.setIcon(for: journey.id, icon: icon)
            }
        }
    }
}
