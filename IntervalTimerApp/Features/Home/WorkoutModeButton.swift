import SwiftUI

struct WorkoutModeButton: View {
    let mode: WorkoutMode
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(mode.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(mode.accentColor)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
