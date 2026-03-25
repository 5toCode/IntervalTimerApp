import Combine
import Foundation

struct TimerTick: Equatable {
    let elapsed: TimeInterval
    let remaining: TimeInterval
    let currentEvent: TimelineEvent?
    let progress: Double
}

protocol TimerEngineProtocol {
    var state: TimerState { get }
    var elapsed: TimeInterval { get }
    var remaining: TimeInterval { get }
    var currentEvent: TimelineEvent? { get }

    var ticks: AnyPublisher<TimerTick, Never> { get }
    var stateChanges: AnyPublisher<TimerState, Never> { get }
    var cueEvents: AnyPublisher<CueEvent, Never> { get }

    func configure(script: [TimelineEvent], totalDuration: TimeInterval)
    func start()
    func pause()
    func resume()
    func reset()
    func skipToNextEvent()
}
