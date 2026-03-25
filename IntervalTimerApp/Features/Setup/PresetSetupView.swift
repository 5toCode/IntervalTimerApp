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
                    ForEach(Array(viewModel.amrapDurations.enumerated()), id: \.offset) { index, _ in
                        wheelPicker(
                            title: "Interval \(index + 1)",
                            selection: Binding(
                                get: { viewModel.amrapDurations[index] },
                                set: { viewModel.amrapDurations[index] = $0 }
                            ),
                            options: viewModel.amrapIntervalOptions
                        )
                        if viewModel.amrapDurations.count > 1 {
                            Button(role: .destructive) {
                                viewModel.removeAmrapInterval(at: index)
                            } label: {
                                Text("Remove interval \(index + 1)")
                            }
                        }
                    }
                    Button {
                        viewModel.addAmrapInterval()
                    } label: {
                        Label("Add interval", systemImage: "plus.circle.fill")
                    }
                case .forTime:
                    wheelPicker(title: "For", selection: $viewModel.totalDuration, options: viewModel.forTimeOptions)
                case .emom:
                    wheelPicker(title: "For", selection: $viewModel.totalDuration, options: viewModel.emomForOptions)
                    wheelPicker(title: "Every", selection: $viewModel.intervalEvery, options: viewModel.emomEveryOptions)
                case .tabata:
                    Stepper("Rounds: \(viewModel.rounds)", value: $viewModel.rounds, in: 1...50)
                    wheelPicker(title: "Work", selection: $viewModel.workDuration, options: viewModel.tabataWorkOptions)
                    wheelPicker(title: "Rest", selection: $viewModel.restDuration, options: viewModel.tabataRestOptions)
                case .customIntervals:
                    Stepper("Rounds: \(viewModel.rounds)", value: $viewModel.rounds, in: 1...20)
                    wheelPicker(title: "Work interval", selection: $viewModel.customSteps[0].duration, options: viewModel.customStepOptions)
                    wheelPicker(title: "Rest interval", selection: $viewModel.customSteps[1].duration, options: viewModel.customStepOptions)
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

    @ViewBuilder
    private func wheelPicker(title: String, selection: Binding<Double>, options: [Double]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(viewModel.label(for: option)).tag(option)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .clipped()
        }
    }
}
