# Sound Effects Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add sound effects for firing, explosions, helicopter hum, and trooper splat using QML SoundEffect with programmatically generated placeholder .wav files.

**Architecture:** A Python script generates 4 placeholder .wav files into `sounds/`. All `SoundEffect` instances are declared in `main.qml`. Trigger points are the existing `fireBullet()`, `spawnExplosion()`, and game loop landing logic. The helicopter hum loops globally, controlled by a binding on heli count and game state. All sounds stop on game over.

**Tech Stack:** QML SoundEffect (import QtMultimedia), Python `wave`+`struct` modules for .wav generation.

---

### Task 1: Generate placeholder sound files

**Files:**
- Create: `generate_sounds.py`
- Create: `sounds/fire.wav`
- Create: `sounds/explosion.wav`
- Create: `sounds/heli_hum.wav`
- Create: `sounds/splat.wav`

**Step 1: Create `generate_sounds.py`**

```python
#!/usr/bin/env python3
"""Generate placeholder WAV sound effects for QSabotage."""
import wave
import struct
import math
import os
import random

SAMPLE_RATE = 44100

def write_wav(filename, samples, sample_rate=SAMPLE_RATE):
    """Write 16-bit mono WAV file from float samples (-1.0 to 1.0)."""
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with wave.open(filename, 'w') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sample_rate)
        for s in samples:
            clamped = max(-1.0, min(1.0, s))
            w.writeframes(struct.pack('<h', int(clamped * 32767)))

def generate_fire():
    """Short high-frequency zap (~50ms)."""
    duration = 0.05
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        env = 1.0 - (i / n)
        freq = 1800 - (i / n) * 1200  # descending pitch
        samples.append(env * math.sin(2 * math.pi * freq * t) * 0.8)
    return samples

def generate_explosion():
    """White noise burst with decay (~200ms)."""
    duration = 0.2
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        env = 1.0 - (i / n)
        noise = random.uniform(-1.0, 1.0)
        # Mix noise with low rumble
        t = i / SAMPLE_RATE
        rumble = math.sin(2 * math.pi * 80 * t) * 0.5
        samples.append(env * (noise * 0.6 + rumble * 0.4) * 0.9)
    return samples

def generate_heli_hum():
    """Low-frequency drone loop (~500ms, seamless loop)."""
    duration = 0.5
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        t = i / SAMPLE_RATE
        # Fundamental + harmonics for choppy drone
        s = (math.sin(2 * math.pi * 85 * t) * 0.5 +
             math.sin(2 * math.pi * 170 * t) * 0.3 +
             math.sin(2 * math.pi * 40 * t) * 0.2)
        # Amplitude modulation for "chop" effect
        chop = 0.5 + 0.5 * math.sin(2 * math.pi * 12 * t)
        samples.append(s * chop * 0.4)
    return samples

def generate_splat():
    """Quick noise thud (~100ms)."""
    duration = 0.1
    n = int(SAMPLE_RATE * duration)
    samples = []
    for i in range(n):
        env = 1.0 - (i / n) ** 0.5
        t = i / SAMPLE_RATE
        noise = random.uniform(-1.0, 1.0)
        thud = math.sin(2 * math.pi * 120 * t)
        samples.append(env * (noise * 0.4 + thud * 0.6) * 0.7)
    return samples

if __name__ == '__main__':
    random.seed(42)  # Reproducible output
    write_wav('sounds/fire.wav', generate_fire())
    write_wav('sounds/explosion.wav', generate_explosion())
    write_wav('sounds/heli_hum.wav', generate_heli_hum())
    write_wav('sounds/splat.wav', generate_splat())
    print("Generated sound files in sounds/")
```

**Step 2: Run the script**

Run: `cd /home/brendanl/src/QSabotage && python3 generate_sounds.py`
Expected: "Generated sound files in sounds/" and 4 .wav files created in `sounds/`.

**Step 3: Verify files exist**

Run: `ls -la sounds/`
Expected: `fire.wav`, `explosion.wav`, `heli_hum.wav`, `splat.wav` — all non-zero size.

**Step 4: Commit**

```bash
git add generate_sounds.py sounds/
git commit -m "feat: add placeholder sound effect generator and wav files"
```

---

### Task 2: Update QML imports to versionless

**Files:**
- Modify: `main.qml:1-2`
- Modify: `Turret.qml:1`
- Modify: `Helicopter.qml:1`
- Modify: `Paratrooper.qml:1`
- Modify: `Explosion.qml:1`

**Step 1: Update `main.qml` imports**

Change lines 1-2 from:
```qml
import QtQuick 2.15
import QtQuick.Window 2.15
```
To:
```qml
import QtQuick
import QtQuick.Window
```

**Step 2: Update `Turret.qml` import**

Change line 1 from `import QtQuick 2.15` to `import QtQuick`.

**Step 3: Update `Helicopter.qml` import**

Change line 1 from `import QtQuick 2.15` to `import QtQuick`.

**Step 4: Update `Paratrooper.qml` import**

Change line 1 from `import QtQuick 2.15` to `import QtQuick`.

**Step 5: Update `Explosion.qml` import**

Change line 1 from `import QtQuick 2.15` to `import QtQuick`.

**Step 6: Manual test**

Run: `qml main.qml`
Verify: Game launches and plays identically to before. No import errors in console.

**Step 7: Commit**

```bash
git add main.qml Turret.qml Helicopter.qml Paratrooper.qml Explosion.qml
git commit -m "refactor: update all QML imports to versionless Qt6 style"
```

---

### Task 3: Add SoundEffect declarations and fire sound

**Files:**
- Modify: `main.qml:1-2` (add import)
- Modify: `main.qml` (add SoundEffect items after imports, before Window properties)
- Modify: `main.qml` `fireBullet()` function

**Step 1: Add QtMultimedia import**

After the existing imports in `main.qml`, add:
```qml
import QtMultimedia
```

So the top of the file reads:
```qml
import QtQuick
import QtQuick.Window
import QtMultimedia
```

**Step 2: Add SoundEffect declarations inside the Window block**

Add after line 18 (the `property int maxLanded: 4` line), before the sky gradient:

```qml
    // Sound effects
    SoundEffect { id: fireSound; source: "sounds/fire.wav" }
    SoundEffect { id: explosionSound; source: "sounds/explosion.wav" }
    SoundEffect {
        id: heliHumSound
        source: "sounds/heli_hum.wav"
        loops: SoundEffect.Infinite
        volume: 0.4
    }
    SoundEffect { id: splatSound; source: "sounds/splat.wav" }
```

**Step 3: Add fire sound to `fireBullet()`**

In the `fireBullet()` function, add `fireSound.play()` as the first line:

```qml
    function fireBullet() {
        fireSound.play()
        var rad = (turretControl.angle - 90) * Math.PI / 180
        var speed = 10
        bulletModel.append({
            bx: root.width / 2,
            by: root.height * 0.85 - 18,
            bvx: Math.cos(rad) * speed,
            bvy: Math.sin(rad) * speed
        })
    }
```

**Step 4: Manual test**

Run: `qml main.qml`
Verify: Press Space to fire — you hear the zap sound. No console errors about QtMultimedia.

**Step 5: Commit**

```bash
git add main.qml
git commit -m "feat: add fire sound effect on bullet shot"
```

---

### Task 4: Add explosion and splat sounds

**Files:**
- Modify: `main.qml` `spawnExplosion()` function
- Modify: `main.qml` game loop trooper landing logic

**Step 1: Add explosion sound to `spawnExplosion()`**

```qml
    function spawnExplosion(x, y) {
        explosionSound.play()
        explosionModel.append({ ex: x, ey: y, eframe: 0 })
    }
```

**Step 2: Add splat sound to no-chute landing**

In the main game timer, in the trooper update section, find the `// Splat - no chute` comment and add `splatSound.play()`:

```qml
                    } else {
                        // Splat - no chute
                        splatSound.play()
                        spawnExplosion(tnx, root.height * 0.85 - 10)
                    }
```

**Step 3: Manual test**

Run: `qml main.qml`
Verify: Shooting a helicopter plays explosion sound. Shooting a paratrooper's chute then watching them fall plays splat + explosion on impact. Shooting a trooper directly plays explosion.

**Step 4: Commit**

```bash
git add main.qml
git commit -m "feat: add explosion and splat sound effects"
```

---

### Task 5: Add helicopter hum and game-over silence

**Files:**
- Modify: `main.qml` (heli hum binding + restartGame)

**Step 1: Add heli hum control binding**

Add a `Connections` block or a simple property binding. The cleanest approach: add a helper property and a handler. Place this right after the SoundEffect declarations:

```qml
    // Heli hum control — plays when helis exist during active game
    property bool _heliHumShouldPlay: heliModel.count > 0 && gameStarted && !gameOver
    on_HeliHumShouldPlayChanged: {
        if (_heliHumShouldPlay)
            heliHumSound.play()
        else
            heliHumSound.stop()
    }
```

**Step 2: Stop all sounds on game over**

The hum already stops via the binding above when `gameOver` becomes `true`. But we also want to stop any in-progress fire/explosion/splat sounds. Add to `restartGame()`:

```qml
    function restartGame() {
        fireSound.stop()
        explosionSound.stop()
        splatSound.stop()
        heliHumSound.stop()
        score = 0; lives = 3; gameOver = false; difficulty = 1.0
        landedLeft = 0; landedRight = 0
        bulletModel.clear(); heliModel.clear()
        trooperModel.clear(); explosionModel.clear()
        turretControl.angle = 0
        gameStarted = true
    }
```

**Step 3: Manual test**

Run: `qml main.qml`
Verify:
1. Start game — no hum initially (no helis yet).
2. First helicopter spawns — hum begins.
3. Shoot all helicopters — hum stops.
4. New helicopter spawns — hum resumes.
5. Let troopers land until game over — all sounds stop immediately.
6. Press R to restart — sounds work normally again.

**Step 4: Commit**

```bash
git add main.qml
git commit -m "feat: add helicopter hum loop and stop all sounds on game over"
```

---

### Task 6: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Update architecture and roadmap**

Update the tech stack to mention QtMultimedia. Add `sounds/` and `generate_sounds.py` to the architecture notes. Mark sound effects as done in the roadmap.

In the Tech Stack section, change:
```
- **Pure QML/Qt Quick 2.15** — no C++ backend
```
to:
```
- **Pure QML/Qt6 Quick** — no C++ backend, uses QtMultimedia for sound
```

Add to the Component files table:
```
| `generate_sounds.py` | Python script to generate placeholder .wav files |
| `sounds/*.wav` | Placeholder sound effects (fire, explosion, heli_hum, splat) |
```

In the roadmap, change:
```
2. **Sound effects** — Firing, explosions, helicopter hum, trooper splat. Use Qt Multimedia / SoundEffect QML type.
```
to:
```
2. ~~**Sound effects**~~ ✓ Done — fire, explosion, heli hum, splat via SoundEffect + generated placeholders. Replace sounds/*.wav with real assets anytime.
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for sound effects feature"
```
