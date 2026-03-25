import SwiftUI

final class PresetSetupViewModel: ObservableObject {
    let mode: WorkoutMode
    private let settings: AppSettings

    @Published var name: String
    @Published var totalDuration: Double = 1200
    @Published var intervalEvery: Double = 60
    @Published var amrapIntervalDuration: Double = 300
    @Published var amrapIntervals: Int = 1
    @Published var rounds: Int = 8
    @Published var workDuration: Double = 20
    @Published var restDuration: Double = 10
    @Published var customSteps: [IntervalStep] = [
        IntervalStep(label: "Work", kind: .work, duration: 30, colorToken: "orange", supportsHalfwayCue: true, supportsFinal3Cue: true),
        IntervalStep(label: "Rest", kind: .rest, duration: 15, colorToken: "blue", supportsHalfwayCue: true, supportsFinal3Cue: true)
    ]

    let emomEveryOptions: [Double] = [
        15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 240, 300,
        360, 420, 480, 540, 600, 660, 720
    ]
    let forTimeOptions: [Double] = Array(stride(from: 120.0, through: 3600.0, by: 120.0))
    let amrapIntervalOptions: [Double] = Array(stride(from: 120.0, through: 3600.0, by: 60.0))
    let tabataWorkOptions: [Double] = Array(stride(from: 10.0, through: 180.0, by: 5.0))
    let tabataRestOptions: [Double] = Array(stride(from: 5.0, through: 120.0, by: 5.0))
    let customStepOptions: [Double] = Array(stride(from: 10.0, through: 300.0, by: 5.0))

    init(mode: WorkoutMode, settings: AppSettings) {
        self.mode = mode
        self.settings = settings
        self.name = mode.title
    }

    func makePreset() -> TimerPreset {
        let config: TimerPresetConfig
        switch mode {
        case .amrap:
            config = .amrap(AMRAPConfig(intervalDuration: amrapIntervalDuration, intervals: amrapIntervals))
        case .emom:
            config = .emom(EMOMConfig(totalDuration: totalDuration, intervalEvery: intervalEvery))
        case .forTime:
            config = .forTime(ForTimeConfig(targetDuration: totalDuration, capDuration: totalDuration))
        case .tabata:
            config = .tabata(
                TabataConfig(
                    rounds: rounds,
                    workDuration: workDuration,
                    restDuration: restDuration,
                    prepDuration: nil
                )
            )
        case .customIntervals:
            config = .customIntervals(CustomIntervalsConfig(steps: customSteps, rounds: rounds))
        }

        return TimerPreset(name: name, mode: mode, preStartCountdown: Double(settings.defaultCountdownSeconds), config: config)
    }

    func label(for seconds: Double) -> String {
        let total = Int(seconds)
        let minutes = total / 60
        let remainder = total % 60
        if minutes == 0 {
            return "\(total) sec"
        }
        if remainder == 0 {
            return "\(minutes) min"
        }
        return "\(minutes):" + String(format: "%02d", remainder)
    }
}
