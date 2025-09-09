import SwiftUI

struct IdentifiableUUID: Identifiable, Equatable {
    let id: UUID
    init(id: UUID) { self.id = id }
}

struct JourneyListView: View {
    @ObservedObject var viewModel: JourneyViewModel
    @State private var showingMore: Bool = false
    @State private var styleTarget: Journey? = nil

    private let overlap: CGFloat = 100
    private let revealWidth: CGFloat = 150

    var body: some View {
        OverlapListView(data: viewModel.activeJourneys, overlap: overlap) { journey in
            SwipeableRowView(maxReveal: revealWidth) {
                NavigationLink {
                    JourneyItineraryView(journey: journey, viewModel: viewModel)
                } label: {
                    JourneyRowView(
                        journey: journey,
                        onDelete: {
                            viewModel.deleteJourney(journey)
                        },
                        onArchive: {
                            viewModel.archiveJourney(journey)
                        }
                    )
                    .contentShape(Rectangle())
                    .shadow(radius: 8, y: 6)
                }
                .buttonStyle(.plain)
            } actions: {
                HStack(spacing: 12) {
                    Button {
                        styleTarget = journey
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "ellipsis.circle.fill")
                                    .foregroundStyle(.white)
                            }
                            Text("More")
                                .font(.system(size: 13))
                                .opacity(0.6)
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        viewModel.archiveJourney(journey)
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(Color.purple)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "archivebox.fill")
                                    .foregroundStyle(.white)
                            }
                            Text("Archive")
                                .font(.system(size: 13))
                                .opacity(0.6)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
            }
            .transition(.flyOutLeft())
        }
        .sheet(item: $styleTarget) { journey in
            CardStyleSheetView(journey: journey, viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
}
