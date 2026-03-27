import SwiftUI

enum CountdownSoundOption: Int, CaseIterable, Identifiable {
    /// Bundled MP3 (Freesound community short beep); not a system sound ID.
    case communityShortBeep47916 = 20_000
    case electronic = 1110
    case pulse = 1113

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .communityShortBeep47916: return "Long Pulse"
        case .electronic: return "Electronic"
        case .pulse: return "Short Pulse"
        }
    }
}

enum StartSoundOption: Int, CaseIterable, Identifiable {
    case boxingBell = 1054
    case chime = 1013

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .boxingBell: return "Short Bell"
        case .chime: return "Long Bell"
        }
    }
}

struct ModeTimerSelection: Codable {
    var totalDuration: Double
    var intervalEvery: Double
    var amrapDurations: [Double]
    var amrapRestBetweenIntervals: Double
    var rounds: Int
    var workDuration: Double
    var restDuration: Double
    var customSteps: [IntervalStep]
}

final class AppSettings: ObservableObject {
    private enum Keys {
        static let defaultCountdownSeconds = "defaultCountdownSeconds"
        static let audibleCuesEnabled = "audibleCuesEnabled"
        static let countdownSoundID = "countdownSoundID"
        static let startSoundID = "startSoundID"
        static let voiceAlertsEnabled = "voiceAlertsEnabled"
        static let modeSelectionPrefix = "modeSelection."
    }

    @Published var defaultCountdownSeconds: Int
    @Published var audibleCuesEnabled: Bool
    @Published var countdownSoundID: Int
    @Published var startSoundID: Int
    @Published var voiceAlertsEnabled: Bool

    init() {
        let defaults = UserDefaults.standard
        let storedCountdown = defaults.object(forKey: Keys.defaultCountdownSeconds) as? Int ?? 10
        let storedAudible = defaults.object(forKey: Keys.audibleCuesEnabled) as? Bool ?? true
        let storedCountdownSound = defaults.object(forKey: Keys.countdownSoundID) as? Int ?? CountdownSoundOption.communityShortBeep47916.rawValue
        let storedStartSound = defaults.object(forKey: Keys.startSoundID) as? Int ?? StartSoundOption.boxingBell.rawValue
        let storedVoiceAlerts = defaults.object(forKey: Keys.voiceAlertsEnabled) as? Bool ?? false
        self.defaultCountdownSeconds = storedCountdown
        self.audibleCuesEnabled = storedAudible
        self.countdownSoundID = CountdownSoundOption(rawValue: storedCountdownSound)?.rawValue ?? CountdownSoundOption.communityShortBeep47916.rawValue
        self.startSoundID = StartSoundOption(rawValue: storedStartSound)?.rawValue ?? StartSoundOption.boxingBell.rawValue
        self.voiceAlertsEnabled = storedVoiceAlerts
    }

    func persist() {
        let defaults = UserDefaults.standard
        defaults.set(defaultCountdownSeconds, forKey: Keys.defaultCountdownSeconds)
        defaults.set(audibleCuesEnabled, forKey: Keys.audibleCuesEnabled)
        defaults.set(countdownSoundID, forKey: Keys.countdownSoundID)
        defaults.set(startSoundID, forKey: Keys.startSoundID)
        defaults.set(voiceAlertsEnabled, forKey: Keys.voiceAlertsEnabled)
    }

    func loadSelection(for mode: WorkoutMode) -> ModeTimerSelection? {
        let key = Keys.modeSelectionPrefix + mode.rawValue
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(ModeTimerSelection.self, from: data)
    }

    func saveSelection(_ selection: ModeTimerSelection, for mode: WorkoutMode) {
        let key = Keys.modeSelectionPrefix + mode.rawValue
        guard let data = try? JSONEncoder().encode(selection) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
