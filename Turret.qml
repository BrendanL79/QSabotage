import QtQuick

Item {
    id: turret
    property real angle: 0
    property real groundY: 0
    property bool retroMode: false
    property int score: 0

    // Modern base
    Rectangle {
        visible: !retroMode
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

    // Modern barrel
    Rectangle {
        visible: !retroMode
        x: turret.width / 2 - 2
        y: groundY - 48
        width: 4; height: 30
        color: "#ccc"
        antialiasing: true
        transformOrigin: Item.Bottom
        rotation: turret.angle
    }

    // Retro base — white platform with score
    Rectangle {
        visible: retroMode
        x: turret.width / 2 - 40; y: groundY - 20
        width: 80; height: 20
        color: "#ffffff"

        Text {
            anchors.centerIn: parent
            text: turret.score
            color: "#000000"
            font.pixelSize: 14; font.bold: true; font.family: "Courier"
        }
    }

    // Retro stepped structure (orange)
    Rectangle {
        visible: retroMode
        x: turret.width / 2 - 20; y: groundY - 36
        width: 40; height: 16
        color: "#cc6600"
    }
    Rectangle {
        visible: retroMode
        x: turret.width / 2 - 12; y: groundY - 48
        width: 24; height: 12
        color: "#cc6600"
    }

    // Retro barrel
    Rectangle {
        visible: retroMode
        x: turret.width / 2 - 2
        y: groundY - 78
        width: 4; height: 30
        color: "#ffffff"
        antialiasing: true
        transformOrigin: Item.Bottom
        rotation: turret.angle
    }
}
