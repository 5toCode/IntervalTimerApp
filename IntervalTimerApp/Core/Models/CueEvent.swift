import Foundation

enum CueEvent: Equatable {
    case countdown321(second: Int)
    case intervalStartLongBeep
    case intervalHalfway
    case intervalFinal3(second: Int)
}
