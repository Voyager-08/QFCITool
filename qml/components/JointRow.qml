import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

RowLayout {
    id: root
    spacing: 12

    property string axisName: "J1"
    property real angle: 0
    property real torque: 0
    property real temp: -100

    Rectangle {
        Layout.preferredWidth: 48
        Layout.preferredHeight: 28
        radius: 6
        color: Theme.bgApp
        border.color: Theme.border

        Label {
            anchors.centerIn: parent
            text: root.axisName
            font.pixelSize: 12
            font.bold: true
            color: Theme.textPrimary
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        spacing: 8

        Label {
            text: root.angle.toFixed(1) + "°"
            Layout.preferredWidth: 52
            font.pixelSize: 12
            font.family: "Consolas"
            color: Theme.textPrimary
        }
        Slider {
            Layout.fillWidth: true
            from: -180
            to: 180
            value: root.angle
            enabled: false
            background: Rectangle {
                x: parent.leftPadding
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: parent.availableWidth
                height: implicitHeight
                radius: 3
                color: "#e2e8f0"

                Rectangle {
                    width: parent.parent.visualPosition * parent.width
                    height: parent.height
                    radius: 3
                    color: Theme.accent
                }
            }
            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                width: 12
                height: 12
                radius: 6
                color: "#ffffff"
                border.color: Theme.accent
                border.width: 2
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        spacing: 8

        Label {
            text: root.torque.toFixed(2)
            Layout.preferredWidth: 48
            font.pixelSize: 12
            font.family: "Consolas"
            color: Theme.textPrimary
        }
        Slider {
            Layout.fillWidth: true
            from: -20
            to: 20
            value: root.torque
            enabled: false
            background: Rectangle {
                x: parent.leftPadding
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: parent.availableWidth
                height: implicitHeight
                radius: 3
                color: "#e2e8f0"

                Rectangle {
                    width: parent.parent.visualPosition * parent.width
                    height: parent.height
                    radius: 3
                    color: Theme.warning
                }
            }
            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                width: 12
                height: 12
                radius: 6
                color: "#ffffff"
                border.color: Theme.warning
                border.width: 2
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        spacing: 8

        Label {
            text: root.temp < -50 ? "--℃" : (Math.round(root.temp) + "℃")
            Layout.preferredWidth: 44
            font.pixelSize: 12
            font.family: "Consolas"
            color: Theme.textPrimary
        }

        ProgressBar {
            id: tempBar
            Layout.fillWidth: true
            from: 20
            to: 100
            value: root.temp < -50 ? 20 : root.temp
            background: Rectangle {
                implicitHeight: 8
                radius: 4
                color: "#e2e8f0"
            }
            contentItem: Item {
                implicitHeight: 8
                Rectangle {
                    width: tempBar.visualPosition * parent.width
                    height: parent.height
                    radius: 4
                    color: {
                        if (root.temp < -50)
                            return Theme.textMuted
                        if (root.temp >= 70)
                            return Theme.danger
                        if (root.temp >= 50)
                            return Theme.warning
                        return Theme.success
                    }
                }
            }
        }
    }
}
