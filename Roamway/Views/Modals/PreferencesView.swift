import SwiftUI

struct PreferencesView: View {
    @AppStorage("accentColor") private var accentColorData: Data = try! NSKeyedArchiver.archivedData(withRootObject: UIColor.systemBlue, requiringSecureCoding: false)
    @State private var color: Color = .blue
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("App Appearance")) {
                    ColorPicker("Accent Color", selection: $color, supportsOpacity: false)
                        .onChange(of: color) { oldColor, newColor in
                            storeAccentColor(newColor)
                        }
                }
            }
            .onAppear(perform: loadStoredColor)
            .navigationTitle("Preferences")
        }
    }
    
    private func storeAccentColor(_ color: Color) {
        let uiColor = UIColor(color)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            accentColorData = data
        }
    }
    
    private func loadStoredColor() {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: accentColorData) {
            color = Color(uiColor)
        }
    }
}
