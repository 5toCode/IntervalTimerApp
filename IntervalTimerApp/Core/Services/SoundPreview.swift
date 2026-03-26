import AudioToolbox
import AVFoundation
import Foundation

enum SoundPreview {
    private static var countdownBeepPlayer: AVAudioPlayer?
    private static var didConfigurePlaybackSession = false

    private static func ensurePlaybackSession() {
        guard !didConfigurePlaybackSession else { return }
        didConfigurePlaybackSession = true
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
    }

    private static func bundledCountdownPlayer() -> AVAudioPlayer? {
        if countdownBeepPlayer == nil, let url = Bundle.main.url(forResource: "countdown_beep_47916", withExtension: "mp3") {
            countdownBeepPlayer = try? AVAudioPlayer(contentsOf: url)
            countdownBeepPlayer?.prepareToPlay()
        }
        return countdownBeepPlayer
    }

    static func playCountdownSound(id: Int) {
        ensurePlaybackSession()
        if id == CountdownSoundOption.communityShortBeep47916.rawValue {
            guard let player = bundledCountdownPlayer() else { return }
            player.stop()
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(id))
        }
    }

    static func playStartSound(id: Int) {
        ensurePlaybackSession()
        AudioServicesPlaySystemSound(SystemSoundID(id))
    }
}
