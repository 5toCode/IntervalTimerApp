import SwiftUI

struct SessionControlsView: View {
    let isPaused: Bool
    let onPrimary: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(isPaused ? "Resume" : "Start") { onPrimary() }
                .buttonStyle(.borderedProminent)
            HStack {
                Button("Pause") { onPause() }
                Button("Skip") { onSkip() }
                Button("Reset") { onReset() }
            }
            .buttonStyle(.bordered)
        }
    }
}
