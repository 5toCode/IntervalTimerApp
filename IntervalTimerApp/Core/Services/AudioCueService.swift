import AudioToolbox
import Foundation

protocol CueDispatching {
    func play(_ event: CueEvent)
}

final class AudioCueService: CueDispatching {
    func play(_ event: CueEvent) {
        switch event {
        case .intervalStartLongBeep:
            AudioServicesPlaySystemSoundWithCompletion(1013, nil)
        case .countdown321, .intervalHalfway, .intervalFinal3:
            AudioServicesPlaySystemSoundWithCompletion(1104, nil)
        }
    }
}
