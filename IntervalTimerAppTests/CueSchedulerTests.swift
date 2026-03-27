import XCTest
@testable import IntervalTimerApp

final class CueSchedulerTests: XCTestCase {
    func testPrestartAndIntervalStartScheduling() {
        let script = [
            TimelineEvent(kind: .prestart, label: "Get Ready", startOffset: 0, duration: 10, supportsHalfwayCue: false, supportsFinal3Cue: false),
            TimelineEvent(kind: .work, label: "Work", startOffset: 10, duration: 60)
        ]

        let scheduled = CueScheduler.schedule(for: script)
        XCTAssertTrue(scheduled.contains(ScheduledCue(second: 7, event: .countdown321(second: 3))))
        XCTAssertTrue(scheduled.contains(ScheduledCue(second: 8, event: .countdown321(second: 2))))
        XCTAssertTrue(scheduled.contains(ScheduledCue(second: 9, event: .countdown321(second: 1))))
        XCTAssertTrue(scheduled.contains(ScheduledCue(second: 10, event: .intervalStart(kind: .work))))
    }

    func testShortIntervalOnlySchedulesValidFinalSeconds() {
        let script = [
            TimelineEvent(kind: .work, label: "Short", startOffset: 0, duration: 2, supportsHalfwayCue: true, supportsFinal3Cue: true)
        ]

        let scheduled = CueScheduler.schedule(for: script)
        XCTAssertFalse(scheduled.contains { $0.event == .intervalFinal3(second: 3) })
        XCTAssertTrue(scheduled.contains { $0.event == .intervalFinal3(second: 2) })
        XCTAssertTrue(scheduled.contains { $0.event == .intervalFinal3(second: 1) })
    }
}
