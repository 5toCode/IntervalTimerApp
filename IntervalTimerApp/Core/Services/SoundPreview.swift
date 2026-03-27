import AudioToolbox
import AVFoundation
import Foundation

enum SoundPreview {
    private static var players: [String: AVAudioPlayer] = [:]
    private static var didConfigurePlaybackSession = false

    private static func ensurePlaybackSession() {
        guard !didConfigurePlaybackSession else { return }
        didConfigurePlaybackSession = true
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
    }

    private static func bundledPlayer(resource: String, ext: String) -> AVAudioPlayer? {
        if let cached = players[resource] { return cached }
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else { return nil }
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        players[resource] = player
        return player
    }

    @discardableResult
    private static func playBundled(resource: String, ext: String) -> Bool {
        guard let player = bundledPlayer(resource: resource, ext: ext) else { return false }
        player.stop()
        player.currentTime = 0
        player.play()
        return true
    }

    static func playCountdownSound(id: Int) {
        ensurePlaybackSession()
        if id == CountdownSoundOption.communityShortBeep47916.rawValue {
            if !playBundled(resource: "countdown_beep_47916", ext: "mp3") {
                AudioServicesPlayAlertSound(SystemSoundID(CountdownSoundOption.electronic.rawValue))
            }
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(id))
        }
    }

    static func playStartSound(id: Int) {
        ensurePlaybackSession()
        AudioServicesPlaySystemSound(SystemSoundID(id))
    }
}
