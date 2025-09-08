import SwiftUI

struct JourneyRowView: View {
    let journey: Journey
    let onDelete: () -> Void
    let onArchive: () -> Void
    let stampImage: Image = Image("StampImage_Airplane")

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(journey.card.fillStyle)
                    .frame(width: 60, height: 60)
                Image(systemName: journey.icon)
                    .font(.system(size: 27))
                    .foregroundStyle(journey.card.accentStyle)
            }
            .padding(.leading, 24)
            VStack(alignment: .leading) {
                Text(journey.title).font(.title2).bold()
                if let s = journey.startDate, let e = journey.endDate {
                    JourneyDateRangeView(startDate: s, endDate: e)
                        .font(.subheadline)
                }
                else {
                    Text("Flexible dates")
                        .font(.subheadline)
                        .opacity(0.8)
                }
            }
            Spacer()
        }
        .listRowBackground(Color.clear)
        .padding(.top, 18)
        .padding(.bottom, 56)
        .background(
            GeometryReader { proxy in
                TicketShape()
                    .fill(.ultraThinMaterial, style: FillStyle(eoFill: true))
                    .overlay(alignment: .bottomTrailing) {
                        HStack {
                            let stamp = stampImage
                                .resizable()
                                .scaledToFit()
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(journey.card.fillStyle)
                                .mask(stamp)
                                .mask(
                                    LinearGradient(
                                        colors: [
                                            .black.opacity(0.66),
                                            .black.opacity(0.33)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: proxy.size.height, height: proxy.size.height)
                                .allowsHitTesting(false)
                        }
                    }
            }
        )
        .overlay(
            ZStack(alignment: .bottomTrailing) {
                TicketShape()
                    .stroke(.secondary.opacity(0.25), lineWidth: 1)
            }
        )
        .clipShape(TicketShape())
//        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//        }
    }
}
