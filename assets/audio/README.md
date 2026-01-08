# Innerverse Ambient Audio Assets

## Required Audio Files

All audio files should be royalty-free, loopable, and optimized for mobile playback (128kbps MP3 or AAC).

### Space Ambient Sounds

| File | Space | Description | Duration |
|------|-------|-------------|----------|
| `sanctuary_ambient.mp3` | The Sanctuary | Peaceful, meditative, soft tones | 3-5 min loop |
| `void_ambient.mp3` | The Void | Deep, quiet, subtle drone | 3-5 min loop |
| `storm_ambient.mp3` | The Storm Room | Rain, thunder, wind | 3-5 min loop |
| `garden_ambient.mp3` | Dream Garden | Birds, gentle breeze, nature | 3-5 min loop |
| `palace_ambient.mp3` | Memory Palace | Echoing, architectural reverb | 3-5 min loop |
| `shore_ambient.mp3` | The Shore | Waves, ocean, distant seagulls | 3-5 min loop |

### UI Sound Effects

| File | Usage | Description |
|------|-------|-------------|
| `typing_soft.mp3` | Typing | Soft keyboard click (optional) |
| `message_sent.mp3` | Message send | Subtle whoosh or confirmation |
| `capsule_unlock.mp3` | Time capsule unlock | Magical unlock/reveal sound |
| `burn_effect.mp3` | Burn animation | Fire crackling (Storm Room) |

## Recommended Sources

- [Freesound.org](https://freesound.org/) - Creative Commons audio
- [Pixabay](https://pixabay.com/sound-effects/) - Royalty-free sounds
- [ZapSplat](https://www.zapsplat.com/) - Free sound effects
- [Epidemic Sound](https://www.epidemicsound.com/) - Premium (subscription)

## Audio Specifications

- **Format:** MP3 or AAC
- **Bitrate:** 128-192 kbps
- **Sample Rate:** 44.1 kHz
- **Channels:** Stereo or Mono
- **Looping:** Seamless loop points for ambient tracks
- **Volume:** Normalized to -14 LUFS

## Implementation Notes

1. Ambient sounds should fade in/out smoothly (500ms)
2. All sounds respect the user's ambient sounds setting
3. Audio pauses when app goes to background
4. Audio resumes with proper state when app returns to foreground
