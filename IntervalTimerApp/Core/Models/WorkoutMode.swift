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
