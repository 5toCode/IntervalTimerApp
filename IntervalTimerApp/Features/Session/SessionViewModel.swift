import Combine
import Foundation

final class SessionViewModel: ObservableObject {
    @Published var remainingText: String = "00:00"
    @Published var countdownText: String?
    @Published var currentLabel: String = "Ready"
    @Published var state: TimerState = .idle
    @Published var cueLegend: String = "Cues: 3-2-1, long start, halfway, final 3"

    private let preset: TimerPreset
    private let scriptBuilder: TimerScriptBuilderProtocol
    private let engine: TimerEngineProtocol
    private let cueDispatcher: CueDispatching
    private let settings: AppSettings
    private var script: [TimelineEvent] = []
    private var cancellables: Set<AnyCancellable> = []

    init(
        preset: TimerPreset,
        settings: AppSettings,
        scriptBuilder: TimerScriptBuilderProtocol = TimerScriptBuilder(),
        engine: TimerEngineProtocol = TimerEngine()
    ) {
        self.preset = preset
        self.scriptBuilder = scriptBuilder
        self.engine = engine
        self.settings = settings
        self.cueDispatcher = AudioCueService(settings: settings)
        configure()
        bind()
    }

    func primaryAction() {
        if state == .running {
            engine.pause()
            return
        }
        startOrResume()
    }

    func startOrResume() {
        if state == .paused {
            engine.resume()
        } else {
            engine.start()
        }
    }

    func pause() { engine.pause() }
    func reset() { engine.reset() }
    func skip() { engine.skipToNextEvent() }

    private func configure() {
        script = scriptBuilder.buildScript(from: preset)
        let totalDuration = script.last.map(\.endOffset) ?? 0
        engine.configure(script: script, totalDuration: totalDuration)
    }

    private func bind() {
        engine.stateChanges
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.state = $0 }
            .store(in: &cancellables)

        engine.ticks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tick in
                guard let self else { return }
                self.currentLabel = tick.currentEvent?.label ?? "Complete"
                self.updateTimerDisplay(from: tick)
            }
            .store(in: &cancellables)

        engine.cueEvents
            .sink { [weak self] event in
                guard let self, self.settings.audibleCuesEnabled else { return }
                self.cueDispatcher.play(event)
            }
            .store(in: &cancellables)
    }

    private static func format(seconds: TimeInterval) -> String {
        let total = max(0, Int(seconds))
        let minutes = total / 60
        let secs = total % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    private func updateTimerDisplay(from tick: TimerTick) {
        guard let event = tick.currentEvent else {
            countdownText = nil
            remainingText = "00:00"
            return
        }

        let eventRemaining = max(0, event.endOffset - tick.elapsed)

        if event.kind == .prestart {
            countdownText = Self.format(seconds: eventRemaining)
            if let firstInterval = script.first(where: { $0.kind != .prestart }) {
                remainingText = Self.format(seconds: firstInterval.duration)
            } else {
                remainingText = "00:00"
            }
        } else {
            countdownText = nil
            remainingText = Self.format(seconds: eventRemaining)
        }
    }
}
