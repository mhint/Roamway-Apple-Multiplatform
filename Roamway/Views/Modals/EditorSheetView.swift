import SwiftUI

struct EditorSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JourneyViewModel
    let existingJourney: Journey?

    @State private var title: String
    @State private var isFlexible: Bool
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var itinerary: [ItineraryItem]
    @FocusState private var isNameFieldFocused: Bool

    private var isEditing: Bool { existingJourney != nil }

    init(journey: Journey? = nil, viewModel: JourneyViewModel) {
        self.existingJourney = journey
        self.viewModel = viewModel
        if let j = journey {
            _title = State(initialValue: j.title)
            _isFlexible = State(initialValue: j.isFlexible)
            _startDate = State(initialValue: j.startDate)
            _endDate = State(initialValue: j.endDate)
            _itinerary = State(initialValue: j.itinerary)
        } else {
            _title = State(initialValue: "")
            _isFlexible = State(initialValue: true)
            _startDate = State(initialValue: nil)
            _endDate = State(initialValue: nil)
            _itinerary = State(initialValue: [])
        }
    }

    private func save() {
        let safeTitle = title.isEmpty ? "Untitled Journey" : title

        if let j = existingJourney,
           let i = viewModel.journeys.firstIndex(where: { $0.id == j.id }) {
            viewModel.journeys[i] = Journey(
                id: j.id,
                title: safeTitle,
                icon: j.icon,
                isFlexible: isFlexible,
                startDate: isFlexible ? nil : startDate,
                endDate: isFlexible ? nil : endDate,
                itinerary: itinerary
            )
        } else {
            viewModel.addJourney(
                title: safeTitle,
                icon: "mappin",
                isFlexible: isFlexible,
                startDate: isFlexible ? nil : startDate,
                endDate: isFlexible ? nil : endDate,
                itinerary: itinerary
            )
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Dates", isOn: $isFlexible.animation())
                        .onChange(of: isFlexible) { _, on in
                            if on {
                                startDate = nil; endDate = nil
                            } else {
                                startDate = startDate ?? Date()
                                endDate = endDate ?? Date()
                            }
                        }
                    if !isFlexible {
                        DatePicker(
                            "Start Date",
                            selection: Binding(
                                get: { startDate ?? Date() },
                                set: { startDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        DatePicker(
                            "End Date",
                            selection: Binding(
                                get: { endDate ?? (startDate ?? Date()) },
                                set: { endDate = $0 }
                            ),
                            in: (startDate ?? Date())...,
                            displayedComponents: .date
                        )
                    }
                }
                Section("Name") {
                    TextField("Outing to Magnolia Park", text: $title)
                        .focused($isNameFieldFocused)
                }
            }
            .navigationTitle(isEditing ? "Edit Journey" : "Add Journey")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.tint(.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        save()
                        dismiss()
                    }
                    .disabled(title.isEmpty || (!isFlexible && (startDate == nil || endDate == nil)))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { isNameFieldFocused = true }
            }
        }
    }
}
