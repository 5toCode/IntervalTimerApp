import SwiftUI

struct SessionView: View {
    @StateObject private var viewModel: SessionViewModel

    init(preset: TimerPreset, settings: AppSettings) {
        _viewModel = StateObject(wrappedValue: SessionViewModel(preset: preset, settings: settings))
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                if let countdown = viewModel.countdownText {
                    VStack(spacing: 6) {
                        Text("Starting In")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(Theme.secondaryText)
                        Text(countdown)
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .foregroundStyle(.orange)
                    }
                }

                Text(viewModel.currentLabel)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Theme.secondaryText)

                Text(viewModel.remainingText)
                    .font(.system(size: 119, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryText)

                SessionControlsView(
                    isRunning: viewModel.state == .running,
                    onPrimary: viewModel.primaryAction,
                    onReset: viewModel.reset,
                    onSkip: viewModel.skip
                )
            }
            .padding()
        }
        .navigationTitle("Session")
        .toolbarTitleDisplayMode(.inline)
    }
}
