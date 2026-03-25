import XCTest
@testable import IntervalTimerApp

final class TimerScriptBuilderTests: XCTestCase {
    private let builder = TimerScriptBuilder()

    func testAllModesIncludePrestartWhenConfigured() {
        let modes: [TimerPreset] = [
            TimerPreset(name: "A", mode: .amrap, preStartCountdown: 10, config: .amrap(AMRAPConfig(intervalDurations: [300, 420]))),
            TimerPreset(name: "E", mode: .emom, preStartCountdown: 10, config: .emom(EMOMConfig(totalDuration: 600, intervalEvery: 60))),
            TimerPreset(name: "F", mode: .forTime, preStartCountdown: 10, config: .forTime(ForTimeConfig(targetDuration: 500, capDuration: 600))),
            TimerPreset(name: "T", mode: .tabata, preStartCountdown: 10, config: .tabata(TabataConfig(rounds: 8, workDuration: 20, restDuration: 10, prepDuration: nil))),
            TimerPreset(name: "C", mode: .customIntervals, preStartCountdown: 10, config: .customIntervals(CustomIntervalsConfig(steps: [IntervalStep(label: "Work", kind: .work, duration: 30)], rounds: 2)))
        ]

        for preset in modes {
            let script = builder.buildScript(from: preset)
            XCTAssertEqual(script.first?.kind, .prestart)
            XCTAssertEqual(script.first?.duration, 10)
        }
    }

    func testAmrapDisablesHalfwayCuePolicy() {
        let preset = TimerPreset(name: "AMRAP", mode: .amrap, preStartCountdown: 10, config: .amrap(AMRAPConfig(intervalDurations: [300, 420])))
        let script = builder.buildScript(from: preset)
        XCTAssertEqual(script.dropFirst().first?.supportsHalfwayCue, false)
    }

    func testAmrapUsesCustomDurationsPerInterval() {
        let preset = TimerPreset(name: "AMRAP", mode: .amrap, preStartCountdown: 10, config: .amrap(AMRAPConfig(intervalDurations: [120, 180, 240])))
        let script = builder.buildScript(from: preset)
        let amrapEvents = script.filter { $0.kind == .work }
        XCTAssertEqual(amrapEvents.map(\.duration), [120, 180, 240])
    }
}
