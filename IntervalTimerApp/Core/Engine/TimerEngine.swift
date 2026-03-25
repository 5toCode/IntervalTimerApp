import Combine
import Foundation

final class TimerEngine: TimerEngineProtocol {
    private(set) var state: TimerState = .idle {
        didSet { stateSubject.send(state) }
    }
    private(set) var elapsed: TimeInterval = 0
    private(set) var remaining: TimeInterval = 0
    private(set) var currentEvent: TimelineEvent?

    var ticks: AnyPublisher<TimerTick, Never> { tickSubject.eraseToAnyPublisher() }
    var stateChanges: AnyPublisher<TimerState, Never> { stateSubject.eraseToAnyPublisher() }
    var cueEvents: AnyPublisher<CueEvent, Never> { cueSubject.eraseToAnyPublisher() }

    private let tickSubject = PassthroughSubject<TimerTick, Never>()
    private let stateSubject = PassthroughSubject<TimerState, Never>()
    private let cueSubject = PassthroughSubject<CueEvent, Never>()

    private var timerCancellable: AnyCancellable?
    private var script: [TimelineEvent] = []
    private var totalDuration: TimeInterval = 0
    private var cueSchedule: [ScheduledCue] = []
    private var emittedCueKeys = Set<String>()
    private var pausedAt: Date?
    private var startedAt: Date?
    private var accumulatedPause: TimeInterval = 0

    func configure(script: [TimelineEvent], totalDuration: TimeInterval) {
        self.script = script
        self.totalDuration = totalDuration
        self.remaining = totalDuration
        self.elapsed = 0
        self.currentEvent = script.first
        self.cueSchedule = CueScheduler.schedule(for: script)
        self.emittedCueKeys.removeAll()
        self.startedAt = nil
        self.pausedAt = nil
        self.accumulatedPause = 0
        state = .ready
        publishTick()
    }

    func start() {
        guard state == .ready || state == .idle else { return }
        startedAt = Date()
        accumulatedPause = 0
        emittedCueKeys.removeAll()
        state = .running
        attachTimer()
    }

    func pause() {
        guard state == .running else { return }
        pausedAt = Date()
        timerCancellable?.cancel()
        timerCancellable = nil
        state = .paused
    }

    func resume() {
        guard state == .paused, let pausedAt else { return }
        accumulatedPause += Date().timeIntervalSince(pausedAt)
        self.pausedAt = nil
        state = .running
        attachTimer()
    }

    func reset() {
        timerCancellable?.cancel()
        timerCancellable = nil
        elapsed = 0
        remaining = totalDuration
        currentEvent = script.first
        emittedCueKeys.removeAll()
        startedAt = nil
        pausedAt = nil
        accumulatedPause = 0
        state = .ready
        publishTick()
    }

    func skipToNextEvent() {
        guard let event = currentEvent else { return }
        elapsed = min(totalDuration, event.endOffset)
        remaining = max(0, totalDuration - elapsed)
        currentEvent = script.first(where: { elapsed >= $0.startOffset && elapsed < $0.endOffset }) ??
            script.first(where: { $0.startOffset >= elapsed })
        dispatchCues()
        completeIfNeeded()
        publishTick()
    }

    private func attachTimer() {
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.onTick()
            }
    }

    private func onTick() {
        guard let startedAt else { return }
        elapsed = max(0, Date().timeIntervalSince(startedAt) - accumulatedPause)
        if elapsed > totalDuration { elapsed = totalDuration }
        remaining = max(0, totalDuration - elapsed)
        currentEvent = script.first(where: { elapsed >= $0.startOffset && elapsed < $0.endOffset })
        dispatchCues()
        completeIfNeeded()
        publishTick()
    }

    private func dispatchCues() {
        let currentSecond = Int(floor(elapsed))
        for cue in cueSchedule {
            let key = "\(cue.second)-\(String(describing: cue.event))"
            guard cue.second <= currentSecond, !emittedCueKeys.contains(key) else { continue }
            cueSubject.send(cue.event)
            emittedCueKeys.insert(key)
        }
    }

    private func completeIfNeeded() {
        if elapsed >= totalDuration && state == .running {
            timerCancellable?.cancel()
            timerCancellable = nil
            currentEvent = nil
            state = .completed
        }
    }

    private func publishTick() {
        let progress: Double = {
            guard let currentEvent, currentEvent.duration > 0 else { return 0 }
            let eventElapsed = max(0, min(currentEvent.duration, elapsed - currentEvent.startOffset))
            return eventElapsed / currentEvent.duration
        }()
        tickSubject.send(TimerTick(elapsed: elapsed, remaining: remaining, currentEvent: currentEvent, progress: progress))
    }
}
