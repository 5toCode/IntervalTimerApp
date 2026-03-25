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
                Text(viewModel.currentLabel)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Theme.secondaryText)

                Text(viewModel.remainingText)
                    .font(.system(size: 74, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primaryText)

                Text(viewModel.cueLegend)
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)

                SessionControlsView(
                    isPaused: viewModel.state == .paused,
                    onPrimary: viewModel.startOrResume,
                    onPause: viewModel.pause,
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
