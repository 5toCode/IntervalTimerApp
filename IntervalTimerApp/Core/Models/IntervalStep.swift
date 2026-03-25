import Foundation

enum IntervalStepKind: String, Codable {
    case work
    case rest
    case transition
}

struct IntervalStep: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var label: String
    var kind: IntervalStepKind
    var duration: TimeInterval
    var colorToken: String
    var supportsHalfwayCue: Bool
    var supportsFinal3Cue: Bool

    init(
        id: UUID = UUID(),
        label: String,
        kind: IntervalStepKind,
        duration: TimeInterval,
        colorToken: String = "default",
        supportsHalfwayCue: Bool = true,
        supportsFinal3Cue: Bool = true
    ) {
        self.id = id
        self.label = label
        self.kind = kind
        self.duration = duration
        self.colorToken = colorToken
        self.supportsHalfwayCue = supportsHalfwayCue
        self.supportsFinal3Cue = supportsFinal3Cue
    }
}
