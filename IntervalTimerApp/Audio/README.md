# Gym Audio Asset Checklist

Add the following files to this folder to enable all gym-focused cue options:

- `gym_beep_high_short.wav` (countdown beeps)
- `gym_gong_round_start.wav` (round start/end gong)
- `gym_whistle_referee.wav` (referee-style whistle)
- `gym_tick_analog.wav` (analog ticking for final countdown)

Recommended format:

- WAV, mono or stereo
- 44.1 kHz or 48 kHz
- 16-bit PCM
- Keep files short for low-latency playback

Notes:

- The app falls back to built-in iOS system sounds if bundled files are missing for countdown/start.
- Tick playback only occurs when `Final ticks` is enabled in Settings.
