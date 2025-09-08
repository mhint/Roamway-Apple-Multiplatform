import SwiftUI
import MapKit
import CoreLocation

struct JourneyAnnotation: Identifiable {
    let id = UUID()
    let journey: Journey
    let coordinate: CLLocationCoordinate2D
}

struct AllJourneysMapView: View {
    @ObservedObject var journeyViewModel: JourneyViewModel

    // Replace coordinateRegion with MapCameraPosition in iOS 17+
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var mapStyle: MapStyle = .standard
    @State private var storedStyle: MapStyleOption = .standard
    @State private var showStyleSheet = false

    var journeysWithCoords: [JourneyAnnotation] {
        journeyViewModel.activeJourneys.flatMap { journey in
            journey.itinerary.compactMap { item in
                item.location.map { JourneyAnnotation(journey: journey, coordinate: $0.coordinate) }
            }
        }
    }

    var body: some View {
        Map(position: $cameraPosition) {
            // User location dot (replaces showsUserLocation: true)
            UserAnnotation()

            // Your journey annotations
            ForEach(journeysWithCoords) { annotation in
                Annotation("", coordinate: annotation.coordinate) {
                    ZStack {
                        Circle().fill(Color.black).frame(width: 40, height: 40)
                        Image(systemName: annotation.journey.icon)
                            .foregroundStyle(.white)
                            .font(.system(size: 22, weight: .bold))
                    }
                }
            }
        }
//        .tint(.blue)
        .mapStyle(mapStyle)
        .mapControls {
            MapUserLocationButton()
                .symbolRenderingMode(.monochrome)
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .onAppear { applyStoredStyle(storedStyle) }
        .onMapCameraChange { context in
            // You can still use region-based logic with the new API
            let threshold: CLLocationDegrees = 0.015
            switch storedStyle {
            case .standard, .realistic:
                if context.region.span.latitudeDelta < threshold {
                    mapStyle = .standard(elevation: .realistic)
                } else {
                    mapStyle = .standard
                }
            case .imagery:
                mapStyle = .imagery
            case .hybrid:
                mapStyle = .hybrid
            }
        }
        .sheet(isPresented: $showStyleSheet) {
            MapStyleSheet(selected: $storedStyle)
                .presentationDetents([.height(280), .medium])
                .presentationBackground(.regularMaterial)
        }
    }

    private func applyStoredStyle(_ style: MapStyleOption) {
        switch style {
        case .standard:  mapStyle = .standard
        case .realistic: mapStyle = .standard(elevation: .realistic)
        case .imagery:   mapStyle = .imagery
        case .hybrid:    mapStyle = .hybrid
        }
    }
}

// MARK: - Style model

enum MapStyleOption: String, CaseIterable, Codable, Identifiable {
    case standard, realistic, imagery, hybrid
    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard:  return "Standard"
        case .realistic: return "Realistic"
        case .imagery:   return "Imagery"
        case .hybrid:    return "Hybrid"
        }
    }

    var subtitle: String {
        switch self {
        case .standard:  return "Clear map view"
        case .realistic: return "3D elevation"
        case .imagery:   return "Satellite"
        case .hybrid:    return "Satellite + labels"
        }
    }

    var symbol: String {
        switch self {
        case .standard:  return "map"
        case .realistic: return "mountain.2"
        case .imagery:   return "photo"
        case .hybrid:    return "map.fill"
        }
    }
}

// MARK: - Apple-like sheet UI

struct MapStyleSheet: View {
    @Binding var selected: MapStyleOption
    @Environment(\.dismiss) private var dismiss

    // 2 columns like Apple’s tiles
    private let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Map Styles")
                    .font(.headline)
                Spacer()
                Button("Done") { dismiss() }
                    .font(.body.weight(.semibold))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            ScrollView {
                LazyVGrid(columns: cols, spacing: 12) {
                    ForEach(MapStyleOption.allCases) { option in
                        StyleTile(option: option, isSelected: option == selected)
                            .onTapGesture {
                                selected = option
                                #if os(iOS)
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                #endif
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .padding(.top, 4)
    }
}

struct StyleTile: View {
    let option: MapStyleOption
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // “Thumbnail” placeholder—swap with your own mini preview if you like
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.thinMaterial)
                    .frame(height: 90)
                Image(systemName: option.symbol)
                    .font(.system(size: 28, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(option.title)
                        .font(.body.weight(.semibold))
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.medium)
                    }
                }
                Text(option.subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(radius: 2, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isSelected ? .primary.opacity(0.25) : Color.clear, lineWidth: 1)
        )
    }
}

struct OnChangeCompat<Value: Equatable>: ViewModifier {
    let value: Value
    let action: (_ oldValue: Value, _ newValue: Value) -> Void

    @State private var lastValue: Value

    init(of value: Value, action: @escaping (_ oldValue: Value, _ newValue: Value) -> Void) {
        self.value = value
        self.action = action
        self._lastValue = State(initialValue: value)
    }

    func body(content: Content) -> some View {
        content.onChange(of: value, initial: false) { oldValue, newValue in
            action(oldValue, newValue)
        }
    }
}
