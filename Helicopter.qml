import QtQuick

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
