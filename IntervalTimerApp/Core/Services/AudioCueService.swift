import AudioToolbox
import Foundation

protocol CueDispatching {
    func play(_ event: CueEvent)
}

final class AudioCueService: CueDispatching {
    private let warningBeepSoundID: SystemSoundID = 1006
    private let startDingSoundID: SystemSoundID = 1054

    func play(_ event: CueEvent) {
        switch event {
        case .intervalStartLongBeep:
            AudioServicesPlaySystemSound(startDingSoundID)
        case .countdown321, .intervalHalfway, .intervalFinal3:
            AudioServicesPlayAlertSound(warningBeepSoundID)
        }
    }
}
