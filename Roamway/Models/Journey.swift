import Foundation
import SwiftUI

struct ColorData: Codable, Equatable {
    var r: Double, g: Double, b: Double, a: Double
    init(_ c: Color) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        UIColor(c).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        r = .init(red); g = .init(green); b = .init(blue); a = .init(alpha)
    }
    var color: Color { Color(red: r, green: g, blue: b).opacity(a) }
}

enum MaterialKind: String, CaseIterable, Codable, Equatable {
    case ultraThin, thin, regular, thick, ultraThick, bar
    var material: Material {
        switch self {
        case .ultraThin: return .ultraThinMaterial
        case .thin:      return .thinMaterial
        case .regular:   return .regularMaterial
        case .thick:     return .thickMaterial
        case .ultraThick:return .ultraThickMaterial
        case .bar:       return .bar
        }
    }
}

struct CardStyle: Codable, Equatable {
    enum Kind: Codable, Equatable {
        case color(ColorData)
        case material(MaterialKind)
        case tint
    }
    var kind: Kind

    var anyShapeStyle: AnyShapeStyle {
        switch kind {
        case .color(let c):      return AnyShapeStyle(c.color)
        case .material(let m):   return AnyShapeStyle(m.material)
        case .tint:              return AnyShapeStyle(.tint)
        }
    }

    static func color(_ c: Color) -> CardStyle { .init(kind: .color(ColorData(c))) }
    static func material(_ m: MaterialKind) -> CardStyle { .init(kind: .material(m)) }
    static var tint: CardStyle { .init(kind: .tint) }
}

extension Journey.Card {
    static let `default` = Self(accent: .tint, fill: .material(.ultraThick))
}

struct Journey: Identifiable, Codable, Equatable {
    var id = UUID()
    var creationDate: Date = Date()
    var title: String
    var icon: String
    
    struct Card: Codable, Equatable {
        var accent: CardStyle = .init(kind: .tint)
        var fill:   CardStyle = .material(.ultraThick)

        var accentStyle: AnyShapeStyle { accent.anyShapeStyle }
        var fillStyle: AnyShapeStyle { fill.anyShapeStyle }
    }
    var card: Card = .default
    
    var isFlexible: Bool = true
    var startDate: Date?
    var endDate: Date?
    
    var itinerary: [ItineraryItem] = []
    var isArchived: Bool = false
}
