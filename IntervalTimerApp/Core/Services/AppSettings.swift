import SwiftUI

final class AppSettings: ObservableObject {
    private enum Keys {
        static let defaultCountdownSeconds = "defaultCountdownSeconds"
        static let audibleCuesEnabled = "audibleCuesEnabled"
    }

    @Published var defaultCountdownSeconds: Int
    @Published var audibleCuesEnabled: Bool

    init() {
        let defaults = UserDefaults.standard
        let storedCountdown = defaults.object(forKey: Keys.defaultCountdownSeconds) as? Int ?? 10
        let storedAudible = defaults.object(forKey: Keys.audibleCuesEnabled) as? Bool ?? true
        self.defaultCountdownSeconds = storedCountdown
        self.audibleCuesEnabled = storedAudible
    }

    func persist() {
        let defaults = UserDefaults.standard
        defaults.set(defaultCountdownSeconds, forKey: Keys.defaultCountdownSeconds)
        defaults.set(audibleCuesEnabled, forKey: Keys.audibleCuesEnabled)
    }
}
