import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    let onSelectMode: (WorkoutMode) -> Void
    let onSettings: () -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 18) {
                Spacer()
                HStack(spacing: 0) {
                    Text("Interval")
                        .foregroundStyle(Theme.primaryText)
                    Text("IQ")
                        .foregroundStyle(Color.cyan)
                }
                .font(.system(size: 52, weight: .bold, design: .rounded))
                Text("TIMER")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Theme.secondaryText)

                Spacer()
                ForEach(viewModel.modes) { mode in
                    WorkoutModeButton(mode: mode) {
                        onSelectMode(mode)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onSettings) {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
