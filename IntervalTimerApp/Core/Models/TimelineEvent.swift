import Foundation

enum TimelineEventKind: Equatable {
    case prestart
    case work
    case rest
    case transition
}

struct TimelineEvent: Identifiable, Equatable {
    let id: UUID
    let kind: TimelineEventKind
    let label: String
    let startOffset: TimeInterval
    let duration: TimeInterval
    let supportsHalfwayCue: Bool
    let supportsFinal3Cue: Bool

    init(
        id: UUID = UUID(),
        kind: TimelineEventKind,
        label: String,
        startOffset: TimeInterval,
        duration: TimeInterval,
        supportsHalfwayCue: Bool = true,
        supportsFinal3Cue: Bool = true
    ) {
        self.id = id
        self.kind = kind
        self.label = label
        self.startOffset = startOffset
        self.duration = duration
        self.supportsHalfwayCue = supportsHalfwayCue
        self.supportsFinal3Cue = supportsFinal3Cue
    }

    var endOffset: TimeInterval { startOffset + duration }
}
