import SwiftUI

let placeIcons = [
    "mappin",
    "tent.fill",
    "mountain.2.fill",
    "person.bust.fill",
    "beach.umbrella.fill",
    "mecca"
]

let luggageIcons = [
    "backpack.fill",
    "suitcase.fill",
    "suitcase.rolling.fill",
    "suitcase.rolling.and.suitcase.fill",
    "duffle.bag.fill",
    "briefcase.fill",
]

let transportationIcons = [
    "airplane",
    "car.fill",
    "bus.fill",
    "tram.fill",
    "train.side.front.car",
    "bicycle"
]

let nauticalIcons = [
    "ferry.fill",
    "sailboat.fill",
    "oar.2.crossed",
    "fossil.shell.fill",
    "lifepreserver",
    "surfboard.fill"
]

let astroIcons = [
    "sun.max.fill",
    "moon.stars",
    "globe.europe.africa.fill",
    "globe.americas.fill",
    "globe.central.south.asia.fill",
    "globe.asia.australia.fill"
]

let otherIcons = [
    "balloon.fill",
    "basket.fill",
    "rainbow",
    "snowboard.fill",
    "skis.fill",
    "film.fill"
]

enum IconCategory: String, CaseIterable, Identifiable {
    case places = "Places"
    case luggage = "Luggage"
    case transportation = "Transportation"
    case nautical = "Nautical"
    case astro = "Astronomical"
    case other = "Other"

    var id: String { rawValue }

    static func forIcon(_ icon: String) -> IconCategory {
        if placeIcons.contains(icon) { return .places }
        if luggageIcons.contains(icon) { return .luggage }
        if transportationIcons.contains(icon) { return .transportation }
        if nauticalIcons.contains(icon) { return .nautical }
        if astroIcons.contains(icon) { return .astro }
        if otherIcons.contains(icon) { return .other }
        return .places
    }
}
