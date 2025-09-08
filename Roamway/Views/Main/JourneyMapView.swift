import SwiftUI
import PhotosUI

struct JourneyMapView: View {
    @ObservedObject var viewModel: JourneyViewModel
    @State private var showingAddJourney = false
    @State private var itinerary: [ItineraryItem]
    @State private var pickerItem: PhotosPickerItem? = nil
    @Environment(\.dismiss) private var dismiss
    
    let journey: Journey

    init(journey: Journey, viewModel: JourneyViewModel) {
        self.journey = journey
        self.viewModel = viewModel
        _itinerary = State(initialValue: journey.itinerary)
    }

    enum JourneyAction { case archive, delete }

    private func perform(_ action: JourneyAction) {
        if let idx = viewModel.activeJourneys.firstIndex(where: { $0.id == journey.id }) {
            _ = IndexSet(integer: idx)
            withAnimation(.snappy(duration: 0.45)) {
                switch action {
                case .archive: viewModel.archiveJourney(journey)
                case .delete:  viewModel.deleteJourney(journey)
                }
            }
        }
        dismiss()
    }

    private func deleteItineraryItems(at offsets: IndexSet) {
        itinerary.remove(atOffsets: offsets)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(journey.title)
                .font(.largeTitle.bold())
                .lineLimit(2)

            if let startDate = journey.startDate, let endDate = journey.endDate {
                JourneyDateRangeView(startDate: startDate, endDate: endDate)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .sheet(isPresented: $showingAddJourney) {
            EditJourneyView(journey: journey, viewModel: viewModel)
                .background(Color(.systemGroupedBackground))
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "text.line.magnify").imageScale(.large)
                }
                .tint(.primary)
                .accessibilityLabel("Back to Itinerary")

                Menu {
                    Button { showingAddJourney = true } label: {
                        Label("Edit details", systemImage: "pencil")
                    }
                    
                    Button { perform(.archive) } label: {
                        Label("Archive", systemImage: "archivebox")
                    }

                    Button(role: .destructive) { perform(.delete) } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                } label: {
                    Image(systemName: "ellipsis").imageScale(.large)
                }
                .tint(.primary)
                .accessibilityLabel("More")
            }

            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                AddItineraryView(itinerary: $itinerary)
            }
        }
    }
}
