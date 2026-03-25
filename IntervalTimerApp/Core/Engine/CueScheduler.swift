import Foundation

struct ScheduledCue: Equatable {
    let second: Int
    let event: CueEvent
}

enum CueScheduler {
    static func schedule(for script: [TimelineEvent]) -> [ScheduledCue] {
        var cues: [ScheduledCue] = []

        for event in script {
            cues.append(contentsOf: prestartCues(for: event))
            cues.append(contentsOf: intervalCues(for: event))
        }

        return cues.sorted { $0.second < $1.second }
    }

    private static func prestartCues(for event: TimelineEvent) -> [ScheduledCue] {
        guard event.kind == .prestart else { return [] }
        let end = Int(event.endOffset)
        let start = Int(event.startOffset)
        var cues: [ScheduledCue] = []

        for remaining in [3, 2, 1] {
            let atSecond = end - remaining
            if atSecond >= start {
                cues.append(ScheduledCue(second: atSecond, event: .countdown321(second: remaining)))
            }
        }

        cues.append(ScheduledCue(second: end, event: .intervalStartLongBeep))
        return cues
    }

    private static func intervalCues(for event: TimelineEvent) -> [ScheduledCue] {
        guard event.kind != .prestart else { return [] }
        let duration = Int(event.duration.rounded(.down))
        guard duration > 0 else { return [] }

        let eventStart = Int(event.startOffset)
        let eventEnd = Int(event.endOffset)
        var cues: [ScheduledCue] = []

        if event.supportsHalfwayCue, duration >= 2 {
            let halfwayOffset = duration / 2
            cues.append(ScheduledCue(second: eventStart + halfwayOffset, event: .intervalHalfway))
        }

        if event.supportsFinal3Cue {
            for remaining in [3, 2, 1] {
                let atSecond = eventEnd - remaining
                if atSecond >= eventStart {
                    cues.append(ScheduledCue(second: atSecond, event: .intervalFinal3(second: remaining)))
                }
            }
        }

        return cues
    }
}
