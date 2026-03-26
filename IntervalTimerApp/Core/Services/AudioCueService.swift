import AudioToolbox
import AVFoundation
import Foundation

protocol CueDispatching {
    func play(_ event: CueEvent)
}

final class AudioCueService: CueDispatching {
    private let settings: AppSettings
    private var countdownBeepPlayer: AVAudioPlayer?
    private var didConfigureSession = false

    init(settings: AppSettings) {
        self.settings = settings
        if let url = Bundle.main.url(forResource: "countdown_beep_47916", withExtension: "mp3") {
            countdownBeepPlayer = try? AVAudioPlayer(contentsOf: url)
            countdownBeepPlayer?.prepareToPlay()
        }
    }

    func play(_ event: CueEvent) {
        switch event {
        case .intervalStartLongBeep:
            AudioServicesPlaySystemSound(SystemSoundID(settings.startSoundID))
        case .countdown321, .intervalHalfway, .intervalFinal3:
            if settings.countdownSoundID == CountdownSoundOption.communityShortBeep47916.rawValue {
                playBundledCountdownBeep()
            } else {
                AudioServicesPlayAlertSound(SystemSoundID(settings.countdownSoundID))
            }
        }
    }

    private func playBundledCountdownBeep() {
        if !didConfigureSession {
            didConfigureSession = true
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try? session.setActive(true)
        }
        guard let player = countdownBeepPlayer else { return }
        player.stop()
        player.currentTime = 0
        player.play()
    }
}
