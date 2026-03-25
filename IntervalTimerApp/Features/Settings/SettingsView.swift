import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings

    var body: some View {
        Form {
            Section("Defaults") {
                Picker("Timer countdown", selection: $settings.defaultCountdownSeconds) {
                    ForEach(0...30, id: \.self) { value in
                        Text("\(value) sec").tag(value)
                    }
                }
            }

            Section("Audio") {
                Toggle("Audible cues", isOn: $settings.audibleCuesEnabled)
            }
        }
        .onChange(of: settings.defaultCountdownSeconds, initial: false) { _, _ in
            settings.persist()
        }
        .onChange(of: settings.audibleCuesEnabled, initial: false) { _, _ in
            settings.persist()
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Settings")
        .toolbarTitleDisplayMode(.inline)
    }
}
