import Foundation

enum LocationType: String, Codable {
    case home
    case work
    case favorite
    case other
}

struct SavedLocation: Identifiable, Codable {
    var id = UUID()
    var name: String
    var coordinate: CodableCoordinate
    var notes: String?
    var type: LocationType
    var address: String? // Optional formatted address
}
