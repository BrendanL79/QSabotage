# QSabotage

QML remake of the classic 1981 Apple II arcade game "Sabotage". Defend your ground turret against waves of helicopters and paratroopers.

## Requirements

- Qt 6 with QtQuick and QtMultimedia modules
- Python 3 (only needed to generate placeholder sound effects)

## Running (no build step)

If you have the `qml` runtime installed:

```bash
python3 generate_sounds.py   # first time only — creates sounds/*.wav
qml main.qml
```

## Building a standalone binary

```bash
cmake -B build
cmake --build build
./build/QSabotage        # Linux/macOS
build\QSabotage.exe      # Windows
```

The CMake build automatically runs `generate_sounds.py` if any `.wav` files are missing.

## Controls

| Key | Action |
|-----|--------|
| Left / Right | Rotate turret |
| Space | Fire |
| Backtick (`` ` ``) | Toggle Apple ][ retro mode |

## Gameplay

- Shoot down helicopters (50 pts) and paratroopers/parachutes (25 pts)
- If 4 paratroopers land on either side of your turret, it's game over
- Difficulty increases as your score rises
