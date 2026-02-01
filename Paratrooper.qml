import QtQuick

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
