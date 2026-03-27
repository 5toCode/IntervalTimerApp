import SwiftUI

struct SessionControlsView: View {
    let isRunning: Bool
    let onPrimary: () -> Void
    let onReset: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(isRunning ? "Pause" : "Start") { onPrimary() }
                .font(.title.weight(.bold))
                .frame(maxWidth: .infinity)
                .frame(height: 74)
                .buttonStyle(.borderedProminent)
            HStack {
                Button("Skip") { onSkip() }
                Button("Reset") { onReset() }
            }
            .buttonStyle(.bordered)
        }
    }
}
