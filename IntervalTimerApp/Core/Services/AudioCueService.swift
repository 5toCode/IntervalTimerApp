import AudioToolbox
import Foundation

protocol CueDispatching {
    func play(_ event: CueEvent)
}

final class AudioCueService: CueDispatching {
    private let shortBeepSoundID: SystemSoundID = 1005
    private let longBeepSoundID: SystemSoundID = 1016

    func play(_ event: CueEvent) {
        switch event {
        case .intervalStartLongBeep:
            AudioServicesPlayAlertSound(longBeepSoundID)
        case .countdown321, .intervalHalfway, .intervalFinal3:
            AudioServicesPlayAlertSound(shortBeepSoundID)
        }
    }
}
