import SwiftUI
import MapKit

struct MainView: View {
    @State private var path: [Route] = []
    @StateObject private var journeyViewModel = JourneyViewModel()
    
    @State private var showingAddJourney = false
    @State private var showingAccount = false
    @State private var searchText = ""
    @Environment(\.isSearching) private var isSearching

    enum Route: Hashable { case map }

    var body: some View {
        NavigationStack(path: $path) {
            JourneyListView(viewModel: journeyViewModel)
                .navigationTitle("Journeys")
                .searchable(text: $searchText, placement: .toolbar, prompt: "Search")
                .navigationTitle("Journeys")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            path.append(.map)
                        } label: {
                            Image(systemName: "map").imageScale(.large)
                        }
                        .tint(.primary)
                        .accessibilityLabel("Open Map")
                        
                        Button { showingAddJourney = true } label: {
                            Image(systemName: "plus")
                        }
                        .tint(.primary)
                        .accessibilityLabel("Add Journey")
                        
                        Button { showingAccount = true } label: {
                            Image(systemName: "person.crop.circle").imageScale(.large)
                        }
                        .tint(.primary)
                        .accessibilityLabel("Account")
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .map:
                        AllJourneysMapView(journeyViewModel: journeyViewModel)
                            .navigationTitle("Map")
                    }
                }
                .onChange(of: searchText) { _, newValue in
                }
                .sheet(isPresented: $showingAccount) {
                    AccountSheet(viewModel: journeyViewModel)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $showingAddJourney) {
                    AddJourneyView(viewModel: journeyViewModel)
                        .background(Color(.systemGroupedBackground))
                }
        }
    }
}
