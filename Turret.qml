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
