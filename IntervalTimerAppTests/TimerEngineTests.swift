import Combine
import XCTest
@testable import IntervalTimerApp

final class TimerEngineTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testNoDuplicateCuesAfterPauseResume() {
        let engine = TimerEngine()
        let script = [
            TimelineEvent(kind: .prestart, label: "Get Ready", startOffset: 0, duration: 4, supportsHalfwayCue: false, supportsFinal3Cue: false),
            TimelineEvent(kind: .work, label: "Work", startOffset: 4, duration: 5, supportsHalfwayCue: true, supportsFinal3Cue: true)
        ]
        engine.configure(script: script, totalDuration: 9)

        let expectation = expectation(description: "collect cues")
        expectation.expectedFulfillmentCount = 1

        var received: [CueEvent] = []
        engine.cueEvents
            .sink { cue in
                received.append(cue)
                if cue == .intervalFinal3(second: 1) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        engine.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            engine.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                engine.resume()
            }
        }

        waitForExpectations(timeout: 12)
        XCTAssertEqual(received.count, Set(received.map(String.init(describing:))).count)
    }
}
