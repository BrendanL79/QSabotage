# QSabotage

QML remake of the classic 1981 Apple II arcade game "Sabotage". Player controls a ground turret to shoot down helicopters and paratroopers.

## Tech Stack

- **Pure QML/Qt Quick 2.15** — no C++ backend
- Single-file game: `main.qml` (~561 lines)
- 60 FPS timer-based game loop with AABB collision detection
- Entity management via QML ListModels + Repeaters

## Architecture

Currently a monolith in `main.qml`, organized in sections:

| Lines | Section |
|-------|---------|
| 1-19 | Window setup, game state properties |
| 20-51 | Background (sky gradient, stars, ground) |
| 53-79 | Turret rendering |
| 82-124 | Keyboard input handling |
| 126-131 | Data models (bullets, helicopters, troopers, explosions) |
| 132-160 | Bullet system |
| 162-203 | Helicopter rendering (animated rotors) |
| 205-274 | Paratrooper rendering (chute/no-chute/landed) |
| 276-299 | Explosion particle system |
| 301-424 | Main game loop (physics, collisions, spawning) |
| 426-445 | Helicopter spawner with difficulty scaling |
| 447-454 | Game restart function |
| 456-469 | HUD (score, landed count) |
| 471-515 | Title screen |
| 517-560 | Game over screen |

## Game Mechanics

- **Controls**: Left/Right arrows rotate turret, Space fires
- **Enemies**: Helicopters fly across screen, drop paratroopers
- **Scoring**: Helicopter kill = 50pts, trooper/chute hit = 25pts
- **Lose condition**: 4 paratroopers land on either side of turret
- **Difficulty**: Scales with score — `1.0 + (score / 500) * 0.3`
- **Note**: `lives` property is defined but unused

## Conventions

- Co-authored with Claude; include `Co-Authored-By` in commits
- Branch `improvements1` is the active dev branch (ahead of `main`)
- No build system — run directly with `qml main.qml` or `qmlscene main.qml`

## Roadmap (priority order)

1. **Component modularization** — Split main.qml into separate QML files (Turret.qml, Helicopter.qml, Paratrooper.qml, Explosion.qml). This unblocks easier work on all subsequent features.
2. **Sound effects** — Firing, explosions, helicopter hum, trooper splat. Use Qt Multimedia / SoundEffect QML type.
3. **Apple ][ Mode** — Recreates the graphics of the original game (lo-res color palette, chunky pixels, black background).
4. **High score persistence** — Save/load top scores via Qt.labs.settings or LocalStorage.
5. **Difficulty selection** — Easy/Medium/Hard presets on title screen. Wire up the unused `lives` property.
6. **Power-ups / weapon variety** — Rapid fire, spread shot, bomber helicopters. Adds gameplay depth.
