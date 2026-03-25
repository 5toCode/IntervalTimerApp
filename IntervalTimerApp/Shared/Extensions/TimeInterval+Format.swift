import Foundation

extension TimeInterval {
    var mmss: String {
        let total = max(0, Int(self))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
