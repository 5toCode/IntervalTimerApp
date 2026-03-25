import SwiftUI

struct PresetSetupView: View {
    @StateObject private var viewModel: PresetSetupViewModel
    let onStart: (TimerPreset) -> Void

    init(mode: WorkoutMode, settings: AppSettings, onStart: @escaping (TimerPreset) -> Void) {
        _viewModel = StateObject(wrappedValue: PresetSetupViewModel(mode: mode, settings: settings))
        self.onStart = onStart
    }

    var body: some View {
        Form {
            Section("Workout") {
                TextField("Name", text: $viewModel.name)
            }

            Section("Timer config") {
                switch viewModel.mode {
                case .amrap:
                    Picker("Interval length", selection: $viewModel.amrapIntervalDuration) {
                        ForEach(viewModel.amrapIntervalOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                    Picker("Intervals", selection: $viewModel.amrapIntervals) {
                        ForEach(1...20, id: \.self) { count in
                            Text("\(count)").tag(count)
                        }
                    }
                case .forTime:
                    Picker("For", selection: $viewModel.totalDuration) {
                        ForEach(viewModel.forTimeOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                case .emom:
                    Picker("For", selection: $viewModel.totalDuration) {
                        ForEach(viewModel.forTimeOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                    Picker("Every", selection: $viewModel.intervalEvery) {
                        ForEach(viewModel.emomEveryOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                case .tabata:
                    Stepper("Rounds: \(viewModel.rounds)", value: $viewModel.rounds, in: 1...50)
                    Picker("Work", selection: $viewModel.workDuration) {
                        ForEach(viewModel.tabataWorkOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                    Picker("Rest", selection: $viewModel.restDuration) {
                        ForEach(viewModel.tabataRestOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                case .customIntervals:
                    Stepper("Rounds: \(viewModel.rounds)", value: $viewModel.rounds, in: 1...20)
                    Picker("Work interval", selection: $viewModel.customSteps[0].duration) {
                        ForEach(viewModel.customStepOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                    Picker("Rest interval", selection: $viewModel.customSteps[1].duration) {
                        ForEach(viewModel.customStepOptions, id: \.self) { option in
                            Text(viewModel.label(for: option)).tag(option)
                        }
                    }
                }
            }

            Section {
                Button("Start Workout") {
                    onStart(viewModel.makePreset())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle(viewModel.mode.title)
        .toolbarTitleDisplayMode(.inline)
    }
}
