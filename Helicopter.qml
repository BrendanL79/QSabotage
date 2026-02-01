import QtQuick

Item {
    x: hx; y: retroMode ? Math.round(hy / 3) * 3 : hy
    visible: halive
    property bool retroMode: false

    // Body
    Rectangle {
        x: 0; y: 8; width: 40; height: 12
        color: retroMode ? "#ffffff" : hcolor
        radius: retroMode ? 0 : 6
    }
    // Cockpit
    Rectangle {
        x: hdir > 0 ? 32 : -2; y: 6; width: 10; height: 10
        color: retroMode ? "#ffffff" : "#88ccff"
        radius: retroMode ? 0 : 5
        opacity: retroMode ? 1.0 : 0.7
    }
    // Tail
    Rectangle {
        x: hdir > 0 ? -12 : 40; y: 5; width: 14; height: 4
        color: retroMode ? "#ffffff" : hcolor
    }
    Rectangle {
        x: hdir > 0 ? -14 : 50; y: 0; width: 4; height: 10
        color: retroMode ? "#ffffff" : hcolor
    }
    // Rotor
    Rectangle {
        x: 10; y: 6; width: 30; height: 2
        color: retroMode ? "#ffffff" : "#ddd"
        transformOrigin: Item.Center
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { to: 180; duration: 100 }
            NumberAnimation { to: 360; duration: 100 }
        }
    }
}
