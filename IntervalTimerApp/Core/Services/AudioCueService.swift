import AudioToolbox
import AVFoundation
import Foundation

protocol CueDispatching {
    func play(_ event: CueEvent)
}

final class AudioCueService: CueDispatching {
    private let settings: AppSettings
    private var players: [String: AVAudioPlayer] = [:]
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var didConfigureSession = false

    init(settings: AppSettings) {
        self.settings = settings
    }

    func play(_ event: CueEvent) {
        switch event {
        case .intervalStart(let kind):
            playStartCue()
            speakIntervalStartIfEnabled(kind: kind)
        case .countdown321(let second):
            playCountdownCue()
            speakCountdownIfEnabled(second: second)
        case .intervalHalfway:
            playCountdownCue()
        case .intervalFinal3(let second):
            playCountdownCue()
            speakCountdownIfEnabled(second: second)
        case .intervalTick:
            playTickIfEnabled()
        }
    }

    private func configureSessionIfNeeded() {
        if !didConfigureSession {
            didConfigureSession = true
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try? session.setActive(true)
        }
    }

    private func bundledPlayer(resource: String, ext: String) -> AVAudioPlayer? {
        if let cached = players[resource] { return cached }
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else { return nil }
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        players[resource] = player
        return player
    }

    private func playPlayer(resource: String, ext: String) -> Bool {
        configureSessionIfNeeded()
        guard let player = bundledPlayer(resource: resource, ext: ext) else { return false }
        player.stop()
        player.currentTime = 0
        player.play()
        return true
    }

    private func playCountdownCue() {
        switch CountdownSoundOption(rawValue: settings.countdownSoundID) {
        case .communityShortBeep47916:
            if !playPlayer(resource: "countdown_beep_47916", ext: "mp3") {
                AudioServicesPlayAlertSound(SystemSoundID(CountdownSoundOption.warning.rawValue))
            }
        case .gymHighBeep:
            if !playPlayer(resource: "gym_beep_high_short", ext: "wav") {
                AudioServicesPlayAlertSound(SystemSoundID(CountdownSoundOption.warning.rawValue))
            }
        case .none:
            AudioServicesPlayAlertSound(SystemSoundID(settings.countdownSoundID))
        }
    }

    private func playStartCue() {
        switch StartSoundOption(rawValue: settings.startSoundID) {
        case .gymGong:
            if !playPlayer(resource: "gym_gong_round_start", ext: "wav") {
                AudioServicesPlaySystemSound(SystemSoundID(StartSoundOption.boxingBell.rawValue))
            }
        case .gymWhistle:
            if !playPlayer(resource: "gym_whistle_referee", ext: "wav") {
                AudioServicesPlaySystemSound(SystemSoundID(StartSoundOption.boxingBell.rawValue))
            }
        case .none:
            AudioServicesPlaySystemSound(SystemSoundID(settings.startSoundID))
        }
    }

    private func playTickIfEnabled() {
        guard settings.tickingEnabled else { return }
        switch TickingSoundOption(rawValue: settings.tickingSoundID) {
        case .gymAnalogTick:
            _ = playPlayer(resource: "gym_tick_analog", ext: "wav")
        case .none:
            return
        }
    }

    private func speakIntervalStartIfEnabled(kind: TimelineEventKind) {
        guard settings.voiceAlertsEnabled else { return }
        let phrase: String
        switch kind {
        case .work:
            phrase = "Go"
        case .rest:
            phrase = "Rest"
        case .transition:
            phrase = "Transition"
        case .prestart:
            return
        }
        speak(phrase)
    }

    private func speakCountdownIfEnabled(second: Int) {
        guard settings.voiceAlertsEnabled else { return }
        speak(String(second))
    }

    private func speak(_ text: String) {
        configureSessionIfNeeded()
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.volume = 1.0
        speechSynthesizer.speak(utterance)
    }
}
