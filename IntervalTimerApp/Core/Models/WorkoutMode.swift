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
        case .forTime: return "Finish as fast as possible before time cap"
        case .tabata: return "Alternating high-intensity work and rest"
        case .customIntervals: return "Build your own work and rest intervals"
        }
    }

    var accentColor: Color {
        switch self {
        case .amrap: return Color(red: 0.95, green: 0.42, blue: 0.24)
        case .emom: return Color(red: 0.64, green: 0.28, blue: 0.92)
        case .forTime: return Color(red: 0.27, green: 0.50, blue: 0.93)
        case .tabata: return Color(red: 0.13, green: 0.74, blue: 0.62)
        case .customIntervals: return Color(red: 0.35, green: 0.38, blue: 0.44)
        }
    }
}
