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
                Picker("Countdown sound", selection: $settings.countdownSoundID) {
                    ForEach(CountdownSoundOption.allCases) { option in
                        Text(option.title).tag(option.rawValue)
                    }
                }
                Picker("Start sound", selection: $settings.startSoundID) {
                    ForEach(StartSoundOption.allCases) { option in
                        Text(option.title).tag(option.rawValue)
                    }
                }
                Toggle("Voice alerts", isOn: $settings.voiceAlertsEnabled)
            }
        }
        .onChange(of: settings.defaultCountdownSeconds, initial: false) { _, _ in
            settings.persist()
        }
        .onChange(of: settings.audibleCuesEnabled, initial: false) { _, _ in
            settings.persist()
        }
        .onChange(of: settings.countdownSoundID, initial: false) { _, newValue in
            SoundPreview.playCountdownSound(id: newValue)
            settings.persist()
        }
        .onChange(of: settings.startSoundID, initial: false) { _, newValue in
            SoundPreview.playStartSound(id: newValue)
            settings.persist()
        }
        .onChange(of: settings.voiceAlertsEnabled, initial: false) { _, _ in
            settings.persist()
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Settings")
        .toolbarTitleDisplayMode(.inline)
    }
}
