import SwiftUI

let placeIcons = [
    "mappin",
    "tent.fill",
    "mountain.2.fill",
    "rainbow",
    "beach.umbrella.fill",
    "mecca"
]

let storageIcons = [
    "backpack.fill",
    "suitcase.fill",
    "suitcase.rolling.fill",
    "suitcase.rolling.and.suitcase.fill",
    "suitcase.rolling.and.film.fill",
    "basket.fill",
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
    "fossil.shell.fill",
    "fish.fill",
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
    "birthday.cake.fill",
    "balloon.fill",
    "snowboard.fill",
    "skis.fill",
    "figure.equestrian.sports",
    "calendar.and.person"
]

enum IconCategory: String, CaseIterable, Identifiable {
    case places = "Places"
    case storage = "Storage"
    case transportation = "Transportation"
    case nautical = "Nautical"
    case astro = "Astronomical"
    case other = "Other"

    var id: String { rawValue }

    static func forIcon(_ icon: String) -> IconCategory {
        if placeIcons.contains(icon) { return .places }
        if storageIcons.contains(icon) { return .storage }
        if transportationIcons.contains(icon) { return .transportation }
        if nauticalIcons.contains(icon) { return .nautical }
        if astroIcons.contains(icon) { return .astro }
        if otherIcons.contains(icon) { return .other }
        return .places
    }
}
