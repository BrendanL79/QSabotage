import QtQuick

Item {
    x: tx; y: ty
    visible: talive
    property bool retroMode: false

    // Parachute
    Item {
        visible: tchute
        // Canopy
        Rectangle {
            x: -10; y: -28; width: 24; height: 14
            color: retroMode ? "#ffffff" : tcolor
            radius: retroMode ? 0 : 12
            opacity: retroMode ? 1.0 : 0.85
        }
        // Lines (hidden in retro mode)
        Canvas {
            visible: !retroMode
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
        // Retro lines (single line from canopy center to body)
        Rectangle {
            visible: retroMode
            x: 1; y: -14; width: 1; height: 12
            color: "#ffffff"
        }
    }
    // Body (stick figure)
    Rectangle { x: 1; y: -4; width: 2; height: 8; color: retroMode ? tcolor : "#fff" }
    // Head
    Rectangle {
        x: -1; y: -8; width: 6; height: 5
        color: retroMode ? tcolor : "#fda"
        radius: retroMode ? 0 : 3
    }
    // Arms
    Rectangle { x: -4; y: -2; width: 12; height: 2; color: retroMode ? tcolor : "#fff" }
    // Legs
    Rectangle { x: -1; y: 4; width: 2; height: 6; color: retroMode ? tcolor : "#fff"; rotation: -15 }
    Rectangle { x: 3; y: 4; width: 2; height: 6; color: retroMode ? tcolor : "#fff"; rotation: 15 }
}
