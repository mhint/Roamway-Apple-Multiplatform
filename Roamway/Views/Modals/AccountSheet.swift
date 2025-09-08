import SwiftUI

struct AccountSheet: View {
    @State private var showingPreferences = false
    @State private var showingArchived = false
    @Environment(\.dismiss) private var dismiss
    
    let viewModel: JourneyViewModel

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Spacer()
                    Circle()
                        .foregroundStyle(.tint)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 42))
                        )
                        .padding(.top, 20)
                    
                    Text("Tap to Sign In")
                        .font(.headline)
                    Spacer()
                }
            }
            
            List {
                Section {
                    Button {
                        showingArchived = true
                    } label: {
                        Label("Archived", systemImage: "archivebox.fill")
                    }
                    .tint(.primary)

                    Button {
                        showingPreferences = true
                    } label: {
                        Label("Preferences", systemImage: "switch.2")
                    }
                    .tint(.primary)
                }

                Section {
                    Button {
                        
                    } label: {
                        Label("Send Feedback", systemImage: "paperplane.fill")
                    }
                    .tint(.primary)
                }
            }
        }
        .scrollDisabled(true)
        .listSectionSpacing(.compact)
        .sheet(isPresented: $showingArchived) {
            ArchivedView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingPreferences) {
            PreferencesView()
                .presentationDetents([.medium, .large])
        }
    }
}
