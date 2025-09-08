import Foundation
import CoreLocation

struct CodableCoordinate: Codable {
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

struct ItineraryItem: Identifiable, Codable, Equatable {
    static func == (lhs: ItineraryItem, rhs: ItineraryItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: UUID
    var title: String
    var time: Date?
    var location: CodableCoordinate?
    var notes: String?
    var type: ItemType
    
    init(id: UUID = UUID(), title: String, time: Date? = nil, location: CodableCoordinate? = nil, notes: String? = nil, type: ItemType) {
        self.id = id
        self.title = title
        self.time = time
        self.location = location
        self.notes = notes
        self.type = type
    }
}

enum ItemType: String, Codable, CaseIterable {
    case activity
    case meal
    case flight
    case lodging
    case transport
    case other
}
