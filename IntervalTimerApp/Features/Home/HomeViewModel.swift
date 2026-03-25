import SwiftUI

final class HomeViewModel: ObservableObject {
    let modes: [WorkoutMode] = WorkoutMode.allCases
}
