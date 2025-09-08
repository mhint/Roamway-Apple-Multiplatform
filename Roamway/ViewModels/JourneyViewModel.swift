import SwiftUI
import Combine

class JourneyViewModel: ObservableObject {
    @Published var journeys: [Journey] = []
    
    func addJourney(title: String, icon: String, isFlexible: Bool, startDate: Date?, endDate: Date?, itinerary: [ItineraryItem]) {
        let newJourney = Journey(title: title, icon: icon, isFlexible: isFlexible, startDate: startDate, endDate: endDate, itinerary: itinerary)
        journeys.append(newJourney)
    }
    
    func deleteJourney(_ journey: Journey) {
        if let index = journeys.firstIndex(where: { $0.id == journey.id }) {
            journeys.remove(at: index)
        }
    }
    
    func archiveJourney(_ journey: Journey) {
        if let index = journeys.firstIndex(where: { $0.id == journey.id }) {
            journeys[index].isArchived = true
        }
    }
    
    func unarchiveJourney(_ journey: Journey) {
        if let index = journeys.firstIndex(where: { $0.id == journey.id }) {
            journeys[index].isArchived = false
        }
    }
    
    var archivedJourneys: [Journey] {
        journeys.filter { $0.isArchived }
    }
    
    var activeJourneys: [Journey] {
        journeys.filter { !$0.isArchived }
    }
    
    func setCardColors(for journeyID: UUID, accent: Color, fill: Color) {
        guard let idx = journeys.firstIndex(where: { $0.id == journeyID }) else { return }
        journeys[idx].card.accent = .color(accent)
        journeys[idx].card.fill   = .color(fill)
    }
}
