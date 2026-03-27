import Foundation

enum CueEvent: Equatable {
    case countdown321(second: Int)
    case intervalStart(kind: TimelineEventKind)
    case intervalHalfway
    case intervalFinal3(second: Int)
    case intervalTick(second: Int)
}
