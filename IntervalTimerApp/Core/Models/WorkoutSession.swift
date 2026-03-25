import Foundation

struct WorkoutSessionResult: Equatable {
    var completed: Bool
    var totalElapsed: TimeInterval
}

struct WorkoutSession: Identifiable, Equatable {
    let id: UUID
    var preset: TimerPreset
    var script: [TimelineEvent]
    var startedAt: Date?
    var endedAt: Date?
    var result: WorkoutSessionResult?

    init(
        id: UUID = UUID(),
        preset: TimerPreset,
        script: [TimelineEvent] = [],
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        result: WorkoutSessionResult? = nil
    ) {
        self.id = id
        self.preset = preset
        self.script = script
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.result = result
    }
}
