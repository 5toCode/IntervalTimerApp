import AudioToolbox
import Foundation

protocol CueDispatching {
    func play(_ event: CueEvent)
}

final class AudioCueService: CueDispatching {
    private let settings: AppSettings

    init(settings: AppSettings) {
        self.settings = settings
    }

    func play(_ event: CueEvent) {
        switch event {
        case .intervalStartLongBeep:
            AudioServicesPlaySystemSound(SystemSoundID(settings.startSoundID))
        case .countdown321, .intervalHalfway, .intervalFinal3:
            AudioServicesPlayAlertSound(SystemSoundID(settings.countdownSoundID))
        }
    }
}
