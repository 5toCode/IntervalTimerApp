import UIKit

protocol HapticsProviding {
    func notifyCue()
}

final class HapticsService: HapticsProviding {
    private let generator = UINotificationFeedbackGenerator()

    func notifyCue() {
        generator.notificationOccurred(.warning)
    }
}
