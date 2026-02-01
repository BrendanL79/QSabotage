import QtQuick

Item {
    x: ex; y: ey
    property bool retroMode: false

    // Modern explosion
    Repeater {
        model: !retroMode ? 8 : 0
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

    // Retro heli explosion — colored debris, larger
    Repeater {
        model: retroMode && etype === "heli" ? 8 : 0
        Rectangle {
            property real angle: index * 45 * Math.PI / 180
            property real dist: eframe * 3.5
            property var colors: ["#ff6600", "#00cc00", "#cc0000", "#ff6600", "#ffffff", "#00cc00", "#cc0000", "#ffffff"]
            x: Math.cos(angle) * dist
            y: Math.sin(angle) * dist
            width: Math.max(2, 5 - eframe * 0.4)
            height: width
            color: colors[index]
            opacity: Math.max(0, 1 - eframe / 10)
        }
    }

    // Retro trooper explosion — white dots, smaller
    Repeater {
        model: retroMode && etype === "trooper" ? 6 : 0
        Rectangle {
            property real angle: index * 60 * Math.PI / 180
            property real dist: eframe * 2.5
            x: Math.cos(angle) * dist
            y: Math.sin(angle) * dist
            width: Math.max(1, 3 - eframe * 0.3)
            height: width
            color: "#ffffff"
            opacity: Math.max(0, 1 - eframe / 10)
        }
    }
}
