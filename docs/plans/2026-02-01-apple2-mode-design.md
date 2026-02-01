# Apple ][ Mode Design

## Overview

A toggleable retro visual mode that reskins the game to match the original 1981 Apple II hi-res (280x192) aesthetic. Purely cosmetic — no gameplay changes. Toggled live from anywhere via the backtick/tilde key.

## Mode Toggle & State

A single `property bool retroMode: false` on the root Window. Toggled by backtick/tilde key from any state (title screen, gameplay, game over). All visual components read this property to switch rendering.

When `retroMode` is true:
- Black background (no sky gradient, no stars)
- Ground becomes a 2-3px bright green line at ground level
- HUD score and landed count hidden
- Score displayed on the turret base instead
- Title/game-over screens restyle (green/white text on black)

No gameplay values change — speeds, hitboxes, spawn rates, positions, collision boxes all remain identical.

## Component Reskinning

Each component receives `retroMode` as a property. Visual properties are ternary-switched.

### Turret (retro)
- Large white rectangular base (no rounded corners)
- Orange/brown stepped structure on top
- Score text rendered directly on the white base in dark text
- Barrel: plain white rectangle
- Proportions match the original's prominent turret

### Helicopter (retro)
- All white — no colored variants
- White body rectangles, white tail
- No cockpit tint
- Rotor: white line

### Paratrooper (retro)
- White body, colored suit (using existing `tcolor`)
- Chute canopy: simple white rectangle/arc
- Chute lines: removed or simplified to single white lines

### Explosion (retro)
Two distinct styles:
- **Helicopter explosion:** colored debris (orange, green, dark red), larger particles
- **Trooper/chute explosion:** white dots only, smaller, simpler

### Bullets (retro)
- Single small white dot, no glow ring

### Landed troopers (retro)
- Simplified to small white/colored blocks at ground level

## Title Screen (retro)
- Black background (no semi-transparent overlay)
- "S A B O T A G E" in white
- Controls text in white
- "PRESS SPACE TO START" blinking
- No flavor text

## Game Over Screen (retro)
- Black background (no overlay)
- "GAME OVER" in white
- Score in green
- "PRESS R TO RESTART" blinking
- No flavor text

## Both Modes
- Small hint at bottom of title screen: "` to toggle Apple ][ mode"
- Visible in both modes so player knows it exists
