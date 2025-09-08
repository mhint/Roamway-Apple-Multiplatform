import SwiftUI

struct AddItineraryView: View {
    @Binding var itinerary: [ItineraryItem]

    var body: some View {
        Menu {
            Button {
                itinerary.append(ItineraryItem(title: "New Activity", type: .activity))
            } label: { Label("Activity", systemImage: "figure.walk") }

            Button {
                itinerary.append(ItineraryItem(title: "New Meal", type: .meal))
            } label: { Label("Meal", systemImage: "fork.knife") }

            Button {
                itinerary.append(ItineraryItem(title: "New Flight", type: .flight))
            } label: { Label("Flight", systemImage: "airplane") }

            Button {
                itinerary.append(ItineraryItem(title: "New Lodging", type: .lodging))
            } label: { Label("Lodging", systemImage: "bed.double") }

            Button {
                itinerary.append(ItineraryItem(title: "New Transport", type: .transport))
            } label: { Label("Transport", systemImage: "car") }

            Button {
                itinerary.append(ItineraryItem(title: "New Other", type: .other))
            } label: { Label("Other", systemImage: "ellipsis") }
        } label: {
            Label("Add", systemImage: "plus")
                .imageScale(.large)
        }
        .tint(.primary)
        .accessibilityLabel("Add")
    }
}
