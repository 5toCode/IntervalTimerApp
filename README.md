# IntervalIQ (IntervalTimerApp)

![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-0A84FF)
![Swift](https://img.shields.io/badge/Swift-5.10-F05138)
![UI](https://img.shields.io/badge/UI-SwiftUI-111111)
![Project](https://img.shields.io/badge/Project-XcodeGen-6E40C9)
![Tests](https://img.shields.io/badge/Tests-XCTest-34C759)

IntervalIQ is a native iOS interval timer app built with SwiftUI. It supports multiple workout timer modes (AMRAP, EMOM, For Time, Tabata, and Custom Intervals), configurable countdown/start cues, and mode-specific setup flows.

## Tech Stack

- Swift 5.10
- SwiftUI
- iOS deployment target: 17.0
- Xcode project generation via XcodeGen (`project.yml`)
- Unit tests with XCTest

## Project Structure

- `IntervalTimerApp/App`: app entry point, navigation routing, theming
- `IntervalTimerApp/Core/Models`: timer presets, timeline/cue models, workout mode types
- `IntervalTimerApp/Core/Engine`: timer engine, script builder, cue scheduling
- `IntervalTimerApp/Core/Services`: settings persistence, haptics/audio cue services
- `IntervalTimerApp/Features`: feature UI/view models (`Home`, `Setup`, `Session`, `Settings`)
- `IntervalTimerAppTests`: unit tests for core timing and scheduling logic

## Features

- Multiple timer modes:
  - AMRAP
  - EMOM
  - For Time
  - Tabata
  - Custom Intervals (multi-step + rounds)
- Session engine with timeline-driven events and cue dispatching
- Audio + haptic cue support
- Configurable default countdown and cue sounds
- Mode-specific setup with persisted selection defaults

## Screenshots

Add screenshots to `docs/screenshots/` and keep the file names below for automatic README rendering:

- Home: `docs/screenshots/home.png`
- Setup: `docs/screenshots/setup.png`
- Session: `docs/screenshots/session.png`
- Settings: `docs/screenshots/settings.png`

![Home screen](docs/screenshots/home.png)
![Setup screen](docs/screenshots/setup.png)
![Session screen](docs/screenshots/session.png)
![Settings screen](docs/screenshots/settings.png)

## Prerequisites

- macOS with Xcode 15+ (recommended for Swift 5.10 / iOS 17 SDK)
- Command line tools installed (`xcode-select --install`)
- Optional: [XcodeGen](https://github.com/yonaskolb/XcodeGen) if you want to regenerate the project from `project.yml`

## Getting Started

### 1) Clone and open

```bash
git clone <your-repo-url>
cd IntervalTimerApp
open IntervalTimerApp.xcodeproj
```

### 2) Run in Xcode

1. Select the `IntervalTimerApp` scheme.
2. Choose an iOS Simulator (or device).
3. Press Run.

## Regenerating the Xcode Project

This repo includes `project.yml` as the source of truth for project configuration.

If you modify targets/settings/sources, regenerate:

```bash
xcodegen generate
```

If you do not have XcodeGen:

```bash
brew install xcodegen
```

## Running Tests

### In Xcode

- Product -> Test (or `Cmd+U`) with the `IntervalTimerApp` scheme selected.

### From command line

```bash
xcodebuild test \
  -project IntervalTimerApp.xcodeproj \
  -scheme IntervalTimerApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Notes for Contributors

- Prefer updating `project.yml` for project-level changes, then regenerate the Xcode project.
- Keep timing behavior changes covered by tests in `IntervalTimerAppTests`.
- Preserve app naming:
  - Internal target/product: `IntervalTimerApp`
  - Display name: `IntervalIQ`

## Roadmap

- Add saved, user-manageable preset library (create, edit, duplicate, delete)
- Add richer cue customization (per-mode sound/haptic profiles)
- Add optional voice cues and larger accessibility controls
- Improve session analytics (round history, completion trends)
- Expand test coverage around edge cases in long-running sessions

## Known Issues

- No in-app screenshot assets are included yet; README image links are placeholders until added.
- No import/export flow for presets yet, so settings are device-local only.
- Very short interval configurations may feel tight on slower simulators.
- No localization support yet (English-only UI labels at present).

## License

This project is licensed under the MIT License.

See the full license text in `LICENSE`.
