import SwiftUI

enum WorkoutMode: String, CaseIterable, Identifiable, Codable {
    case amrap
    case emom
    case forTime
    case tabata
    case customIntervals

    var id: String { rawValue }

    var title: String {
        switch self {
        case .amrap: return "AMRAP"
        case .emom: return "EMOM"
        case .forTime: return "FOR TIME"
        case .tabata: return "TABATA"
        case .customIntervals: return "CUSTOM"
        }
    }

    var workoutDescription: String {
        switch self {
        case .amrap: return "As many rounds as possible"
        case .emom: return "Every minute on the minute"
        case .forTime: return "Complete the work as fast as possible"
        case .tabata: return "Alternating high-intensity work and rest"
        case .customIntervals: return "Build your own work and rest intervals"
        }
    }

    var accentColor: Color {
        switch self {
        case .amrap: return Color.orange
        case .emom: return Color.purple
        case .forTime: return Color.blue
        case .tabata: return Color.green
        case .customIntervals: return Color.gray
        }
    }
}
