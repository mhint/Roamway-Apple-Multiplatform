import SwiftUI

struct EditJourneyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: JourneyViewModel
    let journey: Journey

    @State private var title: String
    @State private var icon: String
    @State private var iconCategory: IconCategory
    @State private var isFlexible: Bool
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var itinerary: [ItineraryItem]
    
    @FocusState private var isNameFieldFocused: Bool
    
    private let placeholderName = "Untitled Journey"
    
    private var currentIcons: [String] {
        switch iconCategory {
        case .objects: objectIcons
        case .transportation: transportationIcons
        case .activity: activityIcons
        }
    }
    
    private var selectedStartDate: Date { startDate ?? Date() }
    private var selectedEndDate: Date { endDate ?? Date() }

    var isFormValid: Bool {
        !title.isEmpty && (isFlexible || (startDate != nil && endDate != nil))
    }
    
    init(journey: Journey, viewModel: JourneyViewModel) {
        self.journey = journey
        self.viewModel = viewModel
        _title = State(initialValue: journey.title)
        _icon = State(initialValue: journey.icon)
        
        _iconCategory = State(initialValue: IconCategory.forIcon(journey.icon))
        
        _isFlexible = State(initialValue: journey.isFlexible)
        _startDate = State(initialValue: journey.startDate)
        _endDate = State(initialValue: journey.endDate)
        _itinerary = State(initialValue: journey.itinerary)
    }
    
    private func saveJourney() {
        guard let index = viewModel.journeys.firstIndex(where: { $0.id == journey.id }) else {
            return
        }
        let updatedJourney = Journey(
            id: journey.id,
            title: title,
            icon: icon,
            isFlexible: isFlexible,
            startDate: isFlexible ? nil : startDate,
            endDate: isFlexible ? nil : endDate,
            itinerary: itinerary
        )
        viewModel.journeys[index] = updatedJourney
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section() {
                        Toggle("Dates", isOn: $isFlexible.animation())
                            .font(.headline)
                            .padding(.leading, 0)
                            .onChange(of: isFlexible) { oldValue, newValue in
                                if newValue == false {
                                    if startDate == nil { startDate = Date() }
                                    if endDate == nil { endDate = Date() }
                                } else {
                                    startDate = nil
                                    endDate = nil
                                }
                            }
                        if !isFlexible {
                            DatePicker("Start Date", selection: Binding(
                                get: { selectedStartDate },
                                set: { startDate = $0 }
                            ), displayedComponents: .date)
                            DatePicker("End Date", selection: Binding(
                                get: { selectedEndDate },
                                set: { endDate = $0 }
                            ), in: selectedStartDate..., displayedComponents: .date)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icon and Name")
                            .font(.headline)
                            .padding(.leading, 0)
                        Picker("Category", selection: $iconCategory) {
                            ForEach(IconCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 6)
                        Picker("Icon", selection: $icon) {
                            ForEach(currentIcons, id: \.self) { iconName in
                                Label {
                                } icon: {
                                    Image(systemName: iconName)
                                }
                                .tag(iconName)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("", text: $title)
                            .focused($isNameFieldFocused)
                            .padding(.leading, 0)
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Edit Journey")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.primary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveJourney()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isNameFieldFocused = true
                }
            }
        }
    }
}

#Preview {
    let sampleJourney = Journey(
        id: UUID(),
        title: "Sample Journey",
        icon: "tent",
        isFlexible: true,
        startDate: nil,
        endDate: nil,
        itinerary: []
    )
    EditJourneyView(journey: sampleJourney, viewModel: JourneyViewModel())
}
