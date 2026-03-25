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
                Text("IntervalIQ")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(Theme.primaryText)
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
