import SwiftUI

struct AddJourneyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: JourneyViewModel

    @State private var title = ""
    @State private var icon = "tent"
    @State private var iconCategory: IconCategory = .objects
    @State private var isFlexible = true
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var itinerary: [ItineraryItem] = []
    
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
                        Text("Title")
                            .font(.headline)
                            .padding(.leading, 0)
                        TextField("Outing to Magnolia Park", text: $title)
                            .focused($isNameFieldFocused)
                            .padding(.leading, 0)
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Create Journey")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.primary)

                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addJourney(title: title, icon: icon, isFlexible: isFlexible, startDate: isFlexible ? nil : startDate, endDate: isFlexible ? nil : endDate, itinerary: itinerary)
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
    AddJourneyView(viewModel: JourneyViewModel())
}
