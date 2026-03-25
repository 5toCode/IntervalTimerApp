import Foundation

struct AMRAPConfig: Codable, Equatable, Hashable {
    var intervalDurations: [TimeInterval]
    var restBetweenIntervals: TimeInterval?

    init(intervalDurations: [TimeInterval], restBetweenIntervals: TimeInterval? = nil) {
        self.intervalDurations = intervalDurations
        self.restBetweenIntervals = restBetweenIntervals
    }
}

struct EMOMConfig: Codable, Equatable, Hashable {
    var totalDuration: TimeInterval
    var intervalEvery: TimeInterval
}

struct ForTimeConfig: Codable, Equatable, Hashable {
    var targetDuration: TimeInterval?
    var capDuration: TimeInterval?
}

struct TabataConfig: Codable, Equatable, Hashable {
    var rounds: Int
    var workDuration: TimeInterval
    var restDuration: TimeInterval
    var prepDuration: TimeInterval?
}

struct CustomIntervalsConfig: Codable, Equatable, Hashable {
    var steps: [IntervalStep]
    var rounds: Int
}

enum TimerPresetConfig: Codable, Equatable, Hashable {
    case amrap(AMRAPConfig)
    case emom(EMOMConfig)
    case forTime(ForTimeConfig)
    case tabata(TabataConfig)
    case customIntervals(CustomIntervalsConfig)

    private enum CodingKeys: String, CodingKey {
        case type
        case amrap
        case emom
        case forTime
        case tabata
        case customIntervals
    }

    private enum ConfigType: String, Codable {
        case amrap
        case emom
        case forTime
        case tabata
        case customIntervals
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ConfigType.self, forKey: .type)
        switch type {
        case .amrap:
            self = .amrap(try container.decode(AMRAPConfig.self, forKey: .amrap))
        case .emom:
            self = .emom(try container.decode(EMOMConfig.self, forKey: .emom))
        case .forTime:
            self = .forTime(try container.decode(ForTimeConfig.self, forKey: .forTime))
        case .tabata:
            self = .tabata(try container.decode(TabataConfig.self, forKey: .tabata))
        case .customIntervals:
            self = .customIntervals(try container.decode(CustomIntervalsConfig.self, forKey: .customIntervals))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .amrap(let value):
            try container.encode(ConfigType.amrap, forKey: .type)
            try container.encode(value, forKey: .amrap)
        case .emom(let value):
            try container.encode(ConfigType.emom, forKey: .type)
            try container.encode(value, forKey: .emom)
        case .forTime(let value):
            try container.encode(ConfigType.forTime, forKey: .type)
            try container.encode(value, forKey: .forTime)
        case .tabata(let value):
            try container.encode(ConfigType.tabata, forKey: .type)
            try container.encode(value, forKey: .tabata)
        case .customIntervals(let value):
            try container.encode(ConfigType.customIntervals, forKey: .type)
            try container.encode(value, forKey: .customIntervals)
        }
    }
}

struct TimerPreset: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var mode: WorkoutMode
    var preStartCountdown: TimeInterval
    var config: TimerPresetConfig

    init(
        id: UUID = UUID(),
        name: String,
        mode: WorkoutMode,
        preStartCountdown: TimeInterval = 10,
        config: TimerPresetConfig
    ) {
        self.id = id
        self.name = name
        self.mode = mode
        self.preStartCountdown = preStartCountdown
        self.config = config
    }
}
