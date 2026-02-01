import QtQuick

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
