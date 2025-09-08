import SwiftUI
import PhotosUI

private struct ItineraryRow: View {
    let item: ItineraryItem
    var body: some View {
        HStack {
            Text(item.title)
            Spacer()
            Text(item.type.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct JourneyItineraryView: View {
    @ObservedObject var viewModel: JourneyViewModel
    @State private var showingAddJourney = false
    @State private var showingMap = false
    @State private var showingPhotoPicker = false
    @State private var itinerary: [ItineraryItem]
    @State private var wallpaperImage: Image? = nil
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
        ZStack {
            WallpaperBackground(image: wallpaperImage, fallbackAsset: "JourneyWallpaper")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                Text(journey.title)
                    .font(.largeTitle.bold())
                    .lineLimit(2)

                if let startDate = journey.startDate, let endDate = journey.endDate {
                    JourneyDateRangeView(startDate: startDate, endDate: endDate)
                        .font(.headline)
                }

                List {
                    ForEach(itinerary) { item in
                        ItineraryRow(item: item)
                    }
                    .onDelete(perform: deleteItineraryItems)
                }
                .listRowSeparator(.hidden)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .sheet(isPresented: $showingAddJourney) {
            EditorSheetView(journey: journey, viewModel: viewModel)
                .background(Color(.systemGroupedBackground))
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showingMap = true
                } label: {
                    Image(systemName: "map").imageScale(.large)
                }
                .tint(.primary)
                .accessibilityLabel("Map")

                Menu {
                    Button { showingAddJourney = true } label: {
                        Label("Edit details", systemImage: "pencil")
                    }
                    
                    Button { showingPhotoPicker = true } label: {
                        Label("Add wallpaper", systemImage: "photo.badge.plus")
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
        .navigationDestination(isPresented: $showingMap) {
            JourneyMapView(journey: journey, viewModel: viewModel)
        }
        .photosPicker(isPresented: $showingPhotoPicker,
                      selection: $pickerItem,
                      matching: .images)
        .onChange(of: pickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    wallpaperImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}

