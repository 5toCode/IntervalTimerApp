import SwiftUI

@main
struct IntervalTimerAppApp: App {
    var body: some Scene {
        WindowGroup {
            AppRouter()
                .preferredColorScheme(.dark)
        }
    }
}
