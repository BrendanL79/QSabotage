import QtQuick
import QtQuick.Window
import QtMultimedia

Window {
    id: root
    width: 800; height: 600
    visible: true
    title: "Sabotage!"
    color: "#1a1a2e"

    property int score: 0
    property int lives: 3
    property bool gameOver: false
    property bool gameStarted: false
    property real difficulty: 1.0
    property int landedLeft: 0
    property int landedRight: 0
    property int maxLanded: 4

    // Sound effects
    SoundEffect { id: fireSound; source: "sounds/fire.wav" }
    SoundEffect { id: explosionSound; source: "sounds/explosion.wav" }
    SoundEffect {
        id: heliHumSound
        source: "sounds/heli_hum.wav"
        loops: SoundEffect.Infinite
        volume: 0.7
    }
    SoundEffect { id: splatSound; source: "sounds/splat.wav" }

    // Heli hum control — plays when helis exist during active game
    property bool _heliHumShouldPlay: heliModel.count > 0 && gameStarted && !gameOver
    on_HeliHumShouldPlayChanged: {
        if (_heliHumShouldPlay)
            heliHumSound.play()
        else
            heliHumSound.stop()
    }

    // Sky gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0f0c29" }
            GradientStop { position: 0.5; color: "#302b63" }
            GradientStop { position: 0.85; color: "#24243e" }
            GradientStop { position: 0.85; color: "#2d5016" }
            GradientStop { position: 1.0; color: "#1a3a0a" }
        }
    }

    // Stars
    Repeater {
        model: 60
        Rectangle {
            x: Math.random() * root.width
            y: Math.random() * root.height * 0.5
            width: Math.random() < 0.3 ? 2 : 1
            height: width
            color: Qt.rgba(1, 1, 1, 0.3 + Math.random() * 0.7)
            radius: width / 2
        }
    }

    // Ground
    Rectangle {
        id: ground
        x: 0; y: root.height * 0.85
        width: root.width; height: root.height * 0.15
        color: "transparent"
    }

    Turret {
        id: turret
        anchors.fill: parent
        angle: turretControl.angle
        groundY: root.height * 0.85
    }

    // Turret aiming control
    Item {
        id: turretControl
        property real angle: 0
        property bool firingLeft: false
        property bool firingRight: false

        Timer {
            running: gameStarted && !gameOver
            interval: 16; repeat: true
            onTriggered: {
                if (turretControl.firingLeft && turretControl.angle > -80)
                    turretControl.angle -= 3
                if (turretControl.firingRight && turretControl.angle < 80)
                    turretControl.angle += 3
            }
        }
    }

    Item {
        id: keyHandler
        anchors.fill: parent
        focus: true
        Keys.onPressed: function(event) {
            if (gameOver && event.key === Qt.Key_R) {
                restartGame()
                event.accepted = true
                return
            }
            if (!gameStarted && event.key === Qt.Key_Space) {
                gameStarted = true
                event.accepted = true
                return
            }
            if (gameOver) return
            if (event.key === Qt.Key_Left) turretControl.firingLeft = true
            if (event.key === Qt.Key_Right) turretControl.firingRight = true
            if (event.key === Qt.Key_Space && !event.isAutoRepeat) fireBullet()
        }
        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_Left) turretControl.firingLeft = false
            if (event.key === Qt.Key_Right) turretControl.firingRight = false
        }
    }

    // Bullet manager
    ListModel { id: bulletModel }
    ListModel { id: heliModel }
    ListModel { id: trooperModel }
    ListModel { id: explosionModel }

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

    // Bullets
    Repeater {
        model: bulletModel
        Rectangle {
            x: bx - 2; y: by - 2
            width: 4; height: 4
            radius: 2
            color: "#ffff00"
            Rectangle {
                x: -1; y: -1
                width: 6; height: 6; radius: 3
                color: "transparent"
                border.color: "#ffaa00"
                border.width: 1
                opacity: 0.5
            }
        }
    }

    // Helicopters
    Repeater {
        model: heliModel
        Helicopter {}
    }

    // Paratroopers
    Repeater {
        model: trooperModel
        Paratrooper {}
    }

    // Landed troopers (left side)
    Repeater {
        model: landedLeft
        Item {
            x: root.width / 2 - 40 - index * 14
            y: root.height * 0.85 - 12
            Rectangle { x: 1; y: 0; width: 2; height: 8; color: "#fff" }
            Rectangle { x: -1; y: -4; width: 6; height: 5; color: "#fda"; radius: 3 }
            Rectangle { x: -3; y: 2; width: 10; height: 2; color: "#fff" }
            Rectangle { x: -1; y: 8; width: 2; height: 5; color: "#fff"; rotation: -10 }
            Rectangle { x: 3; y: 8; width: 2; height: 5; color: "#fff"; rotation: 10 }
        }
    }

    // Landed troopers (right side)
    Repeater {
        model: landedRight
        Item {
            x: root.width / 2 + 30 + index * 14
            y: root.height * 0.85 - 12
            Rectangle { x: 1; y: 0; width: 2; height: 8; color: "#fff" }
            Rectangle { x: -1; y: -4; width: 6; height: 5; color: "#fda"; radius: 3 }
            Rectangle { x: -3; y: 2; width: 10; height: 2; color: "#fff" }
            Rectangle { x: -1; y: 8; width: 2; height: 5; color: "#fff"; rotation: -10 }
            Rectangle { x: 3; y: 8; width: 2; height: 5; color: "#fff"; rotation: 10 }
        }
    }

    // Explosions
    Repeater {
        model: explosionModel
        Explosion {}
    }

    function spawnExplosion(x, y) {
        explosionSound.play()
        explosionModel.append({ ex: x, ey: y, eframe: 0 })
    }

    // Main game timer
    Timer {
        id: gameTimer
        running: gameStarted && !gameOver
        interval: 16; repeat: true
        onTriggered: {
            // Update bullets
            for (var i = bulletModel.count - 1; i >= 0; i--) {
                var b = bulletModel.get(i)
                var nx = b.bx + b.bvx
                var ny = b.by + b.bvy
                if (nx < 0 || nx > root.width || ny < 0 || ny > root.height) {
                    bulletModel.remove(i)
                    continue
                }
                bulletModel.set(i, { bx: nx, by: ny, bvx: b.bvx, bvy: b.bvy })

                // Check heli collisions
                var hitSomething = false
                for (var h = heliModel.count - 1; h >= 0; h--) {
                    var heli = heliModel.get(h)
                    if (!heli.halive) continue
                    if (nx > heli.hx - 5 && nx < heli.hx + 45 && ny > heli.hy && ny < heli.hy + 25) {
                        heliModel.set(h, { hx: heli.hx, hy: heli.hy, hvx: heli.hvx,
                            hdir: heli.hdir, halive: false, hcolor: heli.hcolor,
                            hdropTimer: heli.hdropTimer, hdropInterval: heli.hdropInterval })
                        spawnExplosion(heli.hx + 20, heli.hy + 10)
                        score += 50
                        bulletModel.remove(i)
                        hitSomething = true
                        break
                    }
                }
                if (hitSomething) continue

                // Check trooper collisions
                for (var t = trooperModel.count - 1; t >= 0; t--) {
                    var tr = trooperModel.get(t)
                    if (!tr.talive) continue
                    // Hit chute
                    if (tr.tchute && nx > tr.tx - 12 && nx < tr.tx + 16 && ny > tr.ty - 30 && ny < tr.ty - 14) {
                        trooperModel.setProperty(t, "tchute", false)
                        trooperModel.setProperty(t, "tvy", 5)
                        score += 25
                        bulletModel.remove(i)
                        hitSomething = true
                        break
                    }
                    // Hit body
                    if (nx > tr.tx - 5 && nx < tr.tx + 8 && ny > tr.ty - 8 && ny < tr.ty + 12) {
                        trooperModel.setProperty(t, "talive", false)
                        spawnExplosion(tr.tx, tr.ty)
                        score += 25
                        bulletModel.remove(i)
                        hitSomething = true
                        break
                    }
                }
            }

            // Update helis
            for (var h2 = heliModel.count - 1; h2 >= 0; h2--) {
                var he = heliModel.get(h2)
                if (!he.halive) { heliModel.remove(h2); continue }
                var hnx = he.hx + he.hvx
                if (hnx < -60 || hnx > root.width + 60) {
                    heliModel.remove(h2); continue
                }
                var newDrop = he.hdropTimer - 1
                if (newDrop <= 0 && hnx > 50 && hnx < root.width - 50) {
                    // Drop trooper
                    var colors = ["#e74c3c", "#3498db", "#2ecc71", "#f39c12", "#9b59b6"]
                    trooperModel.append({
                        tx: hnx + 20, ty: he.hy + 20,
                        tvx: he.hvx * 0.3, tvy: 0.8,
                        talive: true, tchute: true, tlanded: false,
                        tcolor: colors[Math.floor(Math.random() * colors.length)]
                    })
                    newDrop = he.hdropInterval
                }
                heliModel.set(h2, { hx: hnx, hy: he.hy, hvx: he.hvx,
                    hdir: he.hdir, halive: true, hcolor: he.hcolor,
                    hdropTimer: newDrop, hdropInterval: he.hdropInterval })
            }

            // Update troopers
            for (var t2 = trooperModel.count - 1; t2 >= 0; t2--) {
                var tp = trooperModel.get(t2)
                if (!tp.talive) { trooperModel.remove(t2); continue }
                var tny = tp.ty + tp.tvy
                var tnx = tp.tx + tp.tvx

                if (tny >= root.height * 0.85 - 10) {
                    // Landed
                    if (tp.tchute) {
                        // Safe landing
                        if (tnx < root.width / 2) landedLeft++
                        else landedRight++
                        if (landedLeft >= maxLanded || landedRight >= maxLanded) {
                            gameOver = true
                        }
                    } else {
                        // Splat - no chute
                        splatSound.play()
                        spawnExplosion(tnx, root.height * 0.85 - 10)
                    }
                    trooperModel.remove(t2)
                    continue
                }
                trooperModel.set(t2, { tx: tnx, ty: tny, tvx: tp.tvx, tvy: tp.tvy,
                    talive: tp.talive, tchute: tp.tchute, tlanded: tp.tlanded,
                    tcolor: tp.tcolor })
            }

            // Update explosions
            for (var e = explosionModel.count - 1; e >= 0; e--) {
                var exp = explosionModel.get(e)
                if (exp.eframe > 10) { explosionModel.remove(e); continue }
                explosionModel.set(e, { ex: exp.ex, ey: exp.ey, eframe: exp.eframe + 1 })
            }

            // Increase difficulty
            difficulty = 1.0 + score / 500 * 0.3
        }
    }

    // Helicopter spawner
    Timer {
        running: gameStarted && !gameOver
        interval: Math.max(1000, 3000 / difficulty)
        repeat: true
        onTriggered: {
            var dir = Math.random() < 0.5 ? 1 : -1
            var sx = dir > 0 ? -50 : root.width + 50
            var speed = (1.5 + Math.random() * 1.5) * dir * difficulty
            var colors = ["#c0392b", "#27ae60", "#2980b9", "#8e44ad", "#d35400"]
            var dropInt = Math.floor(80 + Math.random() * 120 / difficulty)
            heliModel.append({
                hx: sx, hy: 40 + Math.random() * 200,
                hvx: speed, hdir: dir, halive: true,
                hcolor: colors[Math.floor(Math.random() * colors.length)],
                hdropTimer: Math.floor(dropInt / 2),
                hdropInterval: dropInt
            })
        }
    }

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

    // HUD
    Text {
        x: 10; y: 10
        text: "SCORE: " + score
        color: "#0f0"; font.pixelSize: 20; font.bold: true
        font.family: "Courier"
    }

    Text {
        x: root.width - 200; y: 10
        text: "LANDED: " + landedLeft + " | " + landedRight + " / " + maxLanded
        color: (landedLeft >= maxLanded - 1 || landedRight >= maxLanded - 1) ? "#f00" : "#ff0"
        font.pixelSize: 16; font.bold: true; font.family: "Courier"
    }

    // Title screen
    Rectangle {
        anchors.fill: parent
        color: "#000000aa"
        visible: !gameStarted
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "S A B O T A G E"
                color: "#ff4444"
                font.pixelSize: 48; font.bold: true; font.family: "Courier"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "← → Aim    SPACE Fire"
                color: "#aaa"
                font.pixelSize: 18; font.family: "Courier"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Shoot helicopters & paratroopers!"
                color: "#888"
                font.pixelSize: 14; font.family: "Courier"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Don't let " + maxLanded + " troopers land on either side!"
                color: "#888"
                font.pixelSize: 14; font.family: "Courier"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "[ PRESS SPACE TO START ]"
                color: "#fff"
                font.pixelSize: 22; font.family: "Courier"
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }
        }
    }

    // Game over screen
    Rectangle {
        anchors.fill: parent
        color: "#000000cc"
        visible: gameOver
        Column {
            anchors.centerIn: parent
            spacing: 16
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "GAME OVER"
                color: "#ff0000"
                font.pixelSize: 48; font.bold: true; font.family: "Courier"
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.4; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "FINAL SCORE: " + score
                color: "#0f0"
                font.pixelSize: 28; font.family: "Courier"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "The paratroopers have overrun your position!"
                color: "#aaa"
                font.pixelSize: 16; font.family: "Courier"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "[ PRESS R TO RESTART ]"
                color: "#fff"
                font.pixelSize: 20; font.family: "Courier"
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }
        }
    }
}
