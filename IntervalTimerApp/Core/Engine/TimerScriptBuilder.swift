import Foundation

protocol TimerScriptBuilderProtocol {
    func buildScript(from preset: TimerPreset) -> [TimelineEvent]
}

struct TimerScriptBuilder: TimerScriptBuilderProtocol {
    func buildScript(from preset: TimerPreset) -> [TimelineEvent] {
        var events: [TimelineEvent] = []
        var cursor: TimeInterval = 0

        if preset.preStartCountdown > 0 {
            events.append(
                TimelineEvent(
                    kind: .prestart,
                    label: "Get Ready",
                    startOffset: cursor,
                    duration: preset.preStartCountdown,
                    supportsHalfwayCue: false,
                    supportsFinal3Cue: false
                )
            )
            cursor += preset.preStartCountdown
        }

        switch preset.config {
        case .amrap(let config):
            let intervals = config.intervalDurations.isEmpty ? [300.0] : config.intervalDurations
            for (index, intervalDuration) in intervals.enumerated() {
                events.append(
                    TimelineEvent(
                        kind: .work,
                        label: "AMRAP \(index + 1)",
                        startOffset: cursor,
                        duration: intervalDuration,
                        supportsHalfwayCue: false,
                        supportsFinal3Cue: true
                    )
                )
                cursor += intervalDuration
            }
            return events
        case .emom(let config):
            let count = max(1, Int(config.totalDuration / config.intervalEvery))
            for index in 0..<count {
                events.append(
                    TimelineEvent(
                        kind: .work,
                        label: "Minute \(index + 1)",
                        startOffset: cursor,
                        duration: config.intervalEvery
                    )
                )
                cursor += config.intervalEvery
            }
            return events
        case .forTime(let config):
            let duration = config.capDuration ?? config.targetDuration ?? 0
            events.append(TimelineEvent(kind: .work, label: "For Time", startOffset: cursor, duration: duration))
        case .tabata(let config):
            for round in 0..<max(1, config.rounds) {
                events.append(TimelineEvent(kind: .work, label: "Work \(round + 1)", startOffset: cursor, duration: config.workDuration))
                cursor += config.workDuration
                events.append(TimelineEvent(kind: .rest, label: "Rest \(round + 1)", startOffset: cursor, duration: config.restDuration))
                cursor += config.restDuration
            }
            return events
        case .customIntervals(let config):
            let rounds = max(1, config.rounds)
            for round in 0..<rounds {
                for step in config.steps {
                    events.append(
                        TimelineEvent(
                            kind: map(step.kind),
                            label: "\(step.label) R\(round + 1)",
                            startOffset: cursor,
                            duration: step.duration,
                            supportsHalfwayCue: step.supportsHalfwayCue,
                            supportsFinal3Cue: step.supportsFinal3Cue
                        )
                    )
                    cursor += step.duration
                }
            }
            return events
        }

        return events
    }

    private func map(_ kind: IntervalStepKind) -> TimelineEventKind {
        switch kind {
        case .work: return .work
        case .rest: return .rest
        case .transition: return .transition
        }
    }
}
