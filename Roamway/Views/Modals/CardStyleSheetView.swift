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
        case .luggage:
            luggageIcons
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

        switch journey.card.accent.kind {
        case .color:
            _accent = State(initialValue: journey.card.accent.colorData?.color ?? .white)
        case .material, .tint:
            _accent = State(initialValue: .white)
        }

        switch journey.card.fill.kind {
        case .color:
            _fill = State(initialValue: journey.card.fill.colorData?.color ?? .accentColor)
        case .material, .tint:
            _fill = State(initialValue: .accentColor)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Icon") {
                    Picker("Category", selection: $iconCategory) {
                        ForEach(IconCategory.allCases) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.vertical, 6)

                    Picker("Icon", selection: $icon) {
                        ForEach(currentIcons, id: \.self) { iconName in
                            Image(systemName: iconName)
                                .tag(iconName)
                        }
                    }
                    .pickerStyle(.segmented)
                    .sensoryFeedback(.selection, trigger: icon)
                }

                Section("Colors") {
                    ColorPicker("Card theme", selection: $fill, supportsOpacity: false)
                }
            }
            .navigationTitle("Card Style")
            .onDisappear {
                viewModel.setCardColors(for: journey.id, accent: accent, fill: fill)
                viewModel.setIcon(for: journey.id, icon: icon)
            }
        }
    }
}
