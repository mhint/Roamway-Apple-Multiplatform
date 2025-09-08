import SwiftUI
import UIKit

@main
struct RoamwayApp: App {
    @AppStorage("accentColor") private var accentColorData: Data = try! NSKeyedArchiver.archivedData(withRootObject: UIColor.systemBlue, requiringSecureCoding: false)

    private func decodeAccentColor(data: Data) -> Color {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        } else {
            return Color.blue
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(decodeAccentColor(data: accentColorData))
        }
    }
}
