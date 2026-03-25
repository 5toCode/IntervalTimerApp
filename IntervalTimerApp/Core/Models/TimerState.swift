import Foundation

enum TimerState: Equatable {
    case idle
    case ready
    case running
    case paused
    case completed
}
