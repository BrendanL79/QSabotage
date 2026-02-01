# QSabotage

QML remake of the classic 1981 Apple II arcade game "Sabotage". Player controls a ground turret to shoot down helicopters and paratroopers.

## Tech Stack

- **Pure QML/Qt Quick 2.15** — no C++ backend
- Orchestrator: `main.qml` (~451 lines) + 4 component files
- 60 FPS timer-based game loop with AABB collision detection
- Entity management via QML ListModels + Repeaters

## Architecture

### Component files

| File | Description |
|------|-------------|
| `Turret.qml` | Turret base and barrel rendering |
| `Helicopter.qml` | Helicopter body, cockpit, tail, animated rotor |
| `Paratrooper.qml` | Stick figure with parachute canopy and lines |
| `Explosion.qml` | 8-particle expanding explosion effect |

### main.qml sections

| Lines | Section |
|-------|---------|
| 1-18 | Window setup, game state properties |
| 20-51 | Background (sky gradient, stars, ground) |
| 53-57 | Turret component instance |
| 59-98 | Turret aiming control, keyboard input |
| 100-103 | Data models (bullets, helicopters, troopers, explosions) |
| 105-138 | Bullet system + rendering |
| 140-143 | Helicopter Repeater (delegate: Helicopter.qml) |
| 145-148 | Paratrooper Repeater (delegate: Paratrooper.qml) |
| 150-175 | Landed troopers (left + right side) |
| 177-180 | Explosion Repeater (delegate: Explosion.qml) |
| 182-312 | Main game loop (physics, collisions, spawning) |
| 314-333 | Helicopter spawner with difficulty scaling |
| 335-342 | Game restart function |
| 344-357 | HUD (score, landed count) |
| 359-403 | Title screen |
| 405-449 | Game over screen |

## Game Mechanics

- **Controls**: Left/Right arrows rotate turret, Space fires
- **Enemies**: Helicopters fly across screen, drop paratroopers
- **Scoring**: Helicopter kill = 50pts, trooper/chute hit = 25pts
- **Lose condition**: 4 paratroopers land on either side of turret
- **Difficulty**: Scales with score — `1.0 + (score / 500) * 0.3`
- **Note**: `lives` property is defined but unused

## Conventions

- Co-authored with Claude; include `Co-Authored-By` in commits
- Development happens on feature branches off `main`
- No build system — run directly with `qml main.qml` or `qmlscene main.qml`

## Roadmap (priority order)

1. ~~**Component modularization**~~ ✓ Done — Turret.qml, Helicopter.qml, Paratrooper.qml, Explosion.qml extracted.
2. **Sound effects** — Firing, explosions, helicopter hum, trooper splat. Use Qt Multimedia / SoundEffect QML type.
3. **Apple ][ Mode** — Recreates the graphics of the original game (lo-res color palette, chunky pixels, black background).
4. **High score persistence** — Save/load top scores via Qt.labs.settings or LocalStorage.
5. **Difficulty selection** — Easy/Medium/Hard presets on title screen. Wire up the unused `lives` property.
6. **Power-ups / weapon variety** — Rapid fire, spread shot, bomber helicopters. Adds gameplay depth.
