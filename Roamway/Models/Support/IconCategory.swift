let objectIcons = [
    "backpack", "suitcase", "suitcase.rolling", "basket", "tent", "mountain.2", "beach.umbrella"
]

let transportationIcons = [
    "airplane", "car", "bus", "tram", "ferry", "sailboat", "bicycle"
]

let activityIcons = [
    "figure.walk", "figure.run", "figure.roll", "figure.hiking", "figure.archery", "figure.hunting", "ellipsis"
]

enum IconCategory: String, CaseIterable, Identifiable {
    case objects = "Objects"
    case transportation = "Transportation"
    case activity = "Activity"
    var id: String { rawValue }
    
    static func forIcon(_ icon: String) -> IconCategory {
        if objectIcons.contains(icon) {
            return .objects
        } else if transportationIcons.contains(icon) {
            return .transportation
        } else if activityIcons.contains(icon) {
            return .activity
        } else {
            return .objects
        }
    }
}
