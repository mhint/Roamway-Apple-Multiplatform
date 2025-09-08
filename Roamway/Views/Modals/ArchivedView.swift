import SwiftUI

struct ArchivedView: View {
    @ObservedObject var viewModel: JourneyViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.archivedJourneys.isEmpty {
                    VStack {
                        Spacer()
                        Text("Archived Journeys will appear here")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.archivedJourneys) { journey in
                            HStack {
                                Image(systemName: journey.icon)
                                Text(journey.title)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    viewModel.unarchiveJourney(journey)
                                } label: {
                                    VStack(spacing: 4) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width: 60, height: 60)
                                            Image(systemName: "arrow.uturn.left")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 27))
                                        }
                                        Text("Restore")
                                            .font(.caption)
                                            .foregroundStyle(.primary)
                                    }
                                    .frame(width: 60)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Archived")
        }
    }
}
