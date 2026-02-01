# Component Modularization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Split the monolithic `main.qml` into separate QML component files so each entity type is independently editable.

**Architecture:** Extract four visual components (Turret, Helicopter, Paratrooper, Explosion) into their own QML files as inline-component delegates. The game loop, state, models, and screens stay in `main.qml` since they orchestrate everything. Each component receives data via model roles and references `root` properties where needed.

**Tech Stack:** Pure QML/Qt Quick 2.15 — no C++ or build system changes.

---

## Important Notes

- **No automated tests exist.** QML has no built-in unit test runner for visual components without C++. Testing is manual: run `qml main.qml`, play the game, verify each entity renders and behaves identically.
- **Manual verification protocol:** After each task, run `qml main.qml` and confirm: (1) visual rendering matches before, (2) gameplay works — shoot helis, troopers drop, chutes detach, explosions animate, landing/game-over triggers.
- **QML component rules:** A file like `Helicopter.qml` in the same directory is auto-available by name. The root item of the component becomes the component type. Model roles are auto-injected into Repeater delegates.

---

### Task 1: Extract Helicopter component

**Files:**
- Create: `Helicopter.qml`
- Modify: `main.qml:162-203`

**Step 1: Create `Helicopter.qml`**

Create `Helicopter.qml` with the helicopter delegate contents. The Repeater injects model roles (`hx`, `hy`, `halive`, `hcolor`, `hdir`) automatically:

```qml
import QtQuick 2.15

Item {
    x: hx; y: hy
    visible: halive
    // Body
    Rectangle {
        x: 0; y: 8; width: 40; height: 12
        color: hcolor
        radius: 6
    }
    // Cockpit
    Rectangle {
        x: hdir > 0 ? 32 : -2; y: 6; width: 10; height: 10
        color: "#88ccff"
        radius: 5
        opacity: 0.7
    }
    // Tail
    Rectangle {
        x: hdir > 0 ? -12 : 40; y: 5; width: 14; height: 4
        color: hcolor
    }
    Rectangle {
        x: hdir > 0 ? -14 : 50; y: 0; width: 4; height: 10
        color: hcolor
    }
    // Rotor
    Rectangle {
        x: 10; y: 6; width: 30; height: 2
        color: "#ddd"
        transformOrigin: Item.Center
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { to: 180; duration: 100 }
            NumberAnimation { to: 360; duration: 100 }
        }
    }
}
```

**Step 2: Replace inline delegate in `main.qml`**

Replace lines 162-203 (the Helicopters Repeater) with:

```qml
    // Helicopters
    Repeater {
        model: heliModel
        Helicopter {}
    }
```

**Step 3: Manual test**

Run: `qml main.qml`
Verify: Helicopters render with bodies, cockpits, tails, animated rotors. They fly across screen. They can be shot and explode.

**Step 4: Commit**

```bash
git add Helicopter.qml main.qml
git commit -m "refactor: extract Helicopter component to separate QML file"
```

---

### Task 2: Extract Paratrooper component

**Files:**
- Create: `Paratrooper.qml`
- Modify: `main.qml:205-246` (line numbers after Task 1 edits — the trooperModel Repeater)

**Step 1: Create `Paratrooper.qml`**

```qml
import QtQuick 2.15

Item {
    x: tx; y: ty
    visible: talive
    // Parachute
    Item {
        visible: tchute
        // Canopy
        Rectangle {
            x: -10; y: -28; width: 24; height: 14
            color: tcolor
            radius: 12
            opacity: 0.85
        }
        // Lines
        Canvas {
            x: -10; y: -16; width: 24; height: 18
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = "#aaa"
                ctx.lineWidth = 1
                ctx.beginPath()
                ctx.moveTo(0, 0); ctx.lineTo(12, 18)
                ctx.moveTo(12, 0); ctx.lineTo(12, 18)
                ctx.moveTo(24, 0); ctx.lineTo(12, 18)
                ctx.stroke()
            }
        }
    }
    // Body (stick figure)
    Rectangle { x: 1; y: -4; width: 2; height: 8; color: "#fff" }
    // Head
    Rectangle { x: -1; y: -8; width: 6; height: 5; color: "#fda"; radius: 3 }
    // Arms
    Rectangle { x: -4; y: -2; width: 12; height: 2; color: "#fff" }
    // Legs
    Rectangle { x: -1; y: 4; width: 2; height: 6; color: "#fff"; rotation: -15 }
    Rectangle { x: 3; y: 4; width: 2; height: 6; color: "#fff"; rotation: 15 }
}
```

**Step 2: Replace inline delegate in `main.qml`**

Replace the Paratroopers Repeater (currently the `trooperModel` Repeater with the full inline Item delegate) with:

```qml
    // Paratroopers
    Repeater {
        model: trooperModel
        Paratrooper {}
    }
```

**Step 3: Manual test**

Run: `qml main.qml`
Verify: Troopers drop from helis with colored chutes, chutes detach when shot, stick figures fall and splat, safe landings count.

**Step 4: Commit**

```bash
git add Paratrooper.qml main.qml
git commit -m "refactor: extract Paratrooper component to separate QML file"
```

---

### Task 3: Extract Explosion component

**Files:**
- Create: `Explosion.qml`
- Modify: `main.qml` (the explosionModel Repeater)

**Step 1: Create `Explosion.qml`**

```qml
import QtQuick 2.15

Item {
    x: ex; y: ey
    Repeater {
        model: 8
        Rectangle {
            property real angle: index * 45 * Math.PI / 180
            property real dist: eframe * 3
            x: Math.cos(angle) * dist
            y: Math.sin(angle) * dist
            width: Math.max(1, 6 - eframe)
            height: width; radius: width/2
            color: eframe < 3 ? "#ffff00" : (eframe < 6 ? "#ff8800" : "#ff4400")
            opacity: Math.max(0, 1 - eframe / 10)
        }
    }
}
```

**Step 2: Replace inline delegate in `main.qml`**

Replace the Explosions Repeater with:

```qml
    // Explosions
    Repeater {
        model: explosionModel
        Explosion {}
    }
```

**Step 3: Manual test**

Run: `qml main.qml`
Verify: Explosions animate with expanding colored particles when helis/troopers are hit.

**Step 4: Commit**

```bash
git add Explosion.qml main.qml
git commit -m "refactor: extract Explosion component to separate QML file"
```

---

### Task 4: Extract Turret component

**Files:**
- Create: `Turret.qml`
- Modify: `main.qml` (turret base + barrel, lines ~53-79 after prior edits)

**Step 1: Create `Turret.qml`**

The turret needs `angle` passed in and references `root.width`/`root.height` for positioning. Use properties:

```qml
import QtQuick 2.15

Item {
    id: turret
    property real angle: 0
    property real groundY: 0

    // Base
    Rectangle {
        id: turretBase
        x: turret.width / 2 - 20; y: groundY - 10
        width: 40; height: 14
        color: "#888"
        radius: 3
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            width: 20; height: 8
            color: "#aaa"
            radius: 4
        }
    }

    // Barrel
    Rectangle {
        id: barrel
        x: turret.width / 2 - 2
        y: groundY - 48
        width: 4; height: 30
        color: "#ccc"
        antialiasing: true
        transformOrigin: Item.Bottom
        rotation: turret.angle
    }
}
```

**Step 2: Replace inline turret in `main.qml`**

Replace the turret base and barrel (the two Rectangle blocks for `turretBase` and `barrel`) with:

```qml
    Turret {
        id: turret
        anchors.fill: parent
        angle: turretControl.angle
        groundY: root.height * 0.85
    }
```

**Step 3: Manual test**

Run: `qml main.qml`
Verify: Turret renders at bottom center, barrel rotates with left/right keys, bullets fire from barrel tip.

**Step 4: Commit**

```bash
git add Turret.qml main.qml
git commit -m "refactor: extract Turret component to separate QML file"
```

---

### Task 5: Update CLAUDE.md architecture table

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Update the Architecture section**

Update the line count table to reflect the new file structure and reduced `main.qml` size. Add a note listing the new component files.

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md architecture for modularized components"
```
