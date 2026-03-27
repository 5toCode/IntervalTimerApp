import SwiftUI

enum CountdownSoundOption: Int, CaseIterable, Identifiable {
    /// Bundled MP3 (Freesound community short beep); not a system sound ID.
    case communityShortBeep47916 = 20_000
    case gymHighBeep = 20_001
    case warning = 1006
    case mediumBeep = 1007
    case alert = 1053
    case electronic = 1110
    case pulse = 1113

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .communityShortBeep47916: return "Community Beep"
        case .gymHighBeep: return "Gym High Beep"
        case .warning: return "Warning Beep"
        case .mediumBeep: return "Medium Beep (Long)"
        case .alert: return "Alert Ping"
        case .electronic: return "Electronic"
        case .pulse: return "Pulse Beep"
        }
    }
}

enum StartSoundOption: Int, CaseIterable, Identifiable {
    /// Bundled low-frequency gong sample; not a system sound ID.
    case gymGong = 20_100
    /// Bundled referee whistle sample; not a system sound ID.
    case gymWhistle = 20_101
    case boxingBell = 1054
    case ding = 1005
    case chime = 1013
    case tone = 1022
    case signal = 1114
    case rise = 1111

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .gymGong: return "Gym Gong"
        case .gymWhistle: return "Referee Whistle"
        case .boxingBell: return "Boxing Bell"
        case .ding: return "Ding"
        case .chime: return "Chime"
        case .tone: return "Tone"
        case .signal: return "Signal"
        case .rise: return "Rise Tone"
        }
    }
}

enum TickingSoundOption: Int, CaseIterable, Identifiable {
    /// Bundled analog-style tick sample; not a system sound ID.
    case gymAnalogTick = 20_200
    case none = 0

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .gymAnalogTick: return "Analog Tick"
        case .none: return "Off"
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
        static let tickingEnabled = "tickingEnabled"
        static let tickingSoundID = "tickingSoundID"
        static let modeSelectionPrefix = "modeSelection."
    }

    @Published var defaultCountdownSeconds: Int
    @Published var audibleCuesEnabled: Bool
    @Published var countdownSoundID: Int
    @Published var startSoundID: Int
    @Published var voiceAlertsEnabled: Bool
    @Published var tickingEnabled: Bool
    @Published var tickingSoundID: Int

    init() {
        let defaults = UserDefaults.standard
        let storedCountdown = defaults.object(forKey: Keys.defaultCountdownSeconds) as? Int ?? 10
        let storedAudible = defaults.object(forKey: Keys.audibleCuesEnabled) as? Bool ?? true
        let storedCountdownSound = defaults.object(forKey: Keys.countdownSoundID) as? Int ?? CountdownSoundOption.communityShortBeep47916.rawValue
        let storedStartSound = defaults.object(forKey: Keys.startSoundID) as? Int ?? StartSoundOption.boxingBell.rawValue
        let storedVoiceAlerts = defaults.object(forKey: Keys.voiceAlertsEnabled) as? Bool ?? false
        let storedTicking = defaults.object(forKey: Keys.tickingEnabled) as? Bool ?? false
        let storedTickingSound = defaults.object(forKey: Keys.tickingSoundID) as? Int ?? TickingSoundOption.gymAnalogTick.rawValue
        self.defaultCountdownSeconds = storedCountdown
        self.audibleCuesEnabled = storedAudible
        self.countdownSoundID = CountdownSoundOption(rawValue: storedCountdownSound)?.rawValue ?? CountdownSoundOption.communityShortBeep47916.rawValue
        self.startSoundID = StartSoundOption(rawValue: storedStartSound)?.rawValue ?? StartSoundOption.boxingBell.rawValue
        self.voiceAlertsEnabled = storedVoiceAlerts
        self.tickingEnabled = storedTicking
        self.tickingSoundID = TickingSoundOption(rawValue: storedTickingSound)?.rawValue ?? TickingSoundOption.gymAnalogTick.rawValue
    }

    func persist() {
        let defaults = UserDefaults.standard
        defaults.set(defaultCountdownSeconds, forKey: Keys.defaultCountdownSeconds)
        defaults.set(audibleCuesEnabled, forKey: Keys.audibleCuesEnabled)
        defaults.set(countdownSoundID, forKey: Keys.countdownSoundID)
        defaults.set(startSoundID, forKey: Keys.startSoundID)
        defaults.set(voiceAlertsEnabled, forKey: Keys.voiceAlertsEnabled)
        defaults.set(tickingEnabled, forKey: Keys.tickingEnabled)
        defaults.set(tickingSoundID, forKey: Keys.tickingSoundID)
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
