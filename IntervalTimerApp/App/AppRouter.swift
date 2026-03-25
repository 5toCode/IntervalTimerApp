import SwiftUI

enum AppRoute: Hashable {
    case setup(WorkoutMode)
    case session(TimerPreset)
    case settings
}

struct AppRouter: View {
    @State private var path: [AppRoute] = []
    @StateObject private var settings = AppSettings()

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                onSelectMode: { selectedMode in
                    path.append(.setup(selectedMode))
                },
                onSettings: {
                    path.append(.settings)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .setup(let mode):
                    PresetSetupView(mode: mode, settings: settings) { preset in
                        path.append(.session(preset))
                    }
                case .session(let preset):
                    SessionView(preset: preset, settings: settings)
                case .settings:
                    SettingsView(settings: settings)
                }
            }
        }
    }
}
