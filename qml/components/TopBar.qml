import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".."

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.bgTopBar
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Theme.border
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 12
        spacing: 12

        Row {
            spacing: 10
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                width: 10
                height: 10
                radius: 5
                anchors.verticalCenter: parent.verticalCenter
                color: appController.connected ? Theme.success : Theme.textMuted
            }

            Column {
                spacing: 1
                Label {
                    text: "FCITool"
                    font.pixelSize: 17
                    font.bold: true
                    color: Theme.textPrimary
                }
                Label {
                    text: qsTr("Industrial Host Controller")
                    font.pixelSize: 10
                    color: Theme.textMuted
                }
            }
        }

        Item { Layout.fillWidth: true }

        ToolButton {
            id: usbButton
            Layout.preferredWidth: 38
            Layout.preferredHeight: 38
            hoverEnabled: true
            ToolTip.visible: hovered
            ToolTip.delay: 400
            ToolTip.text: appController.connected
                          ? qsTr("Connected: %1").arg(appController.connectedPort)
                          : qsTr("Configure USB device")

            contentItem: Image {
                source: "qrc:/assets/icons/usb.svg"
                sourceSize.width: 20
                sourceSize.height: 20
                opacity: appController.connected ? 1.0 : 0.45
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }

            background: Rectangle {
                radius: 8
                color: {
                    if (usbButton.down)
                        return Theme.accentSoft
                    if (usbButton.hovered)
                        return "#f1f5f9"
                    return appController.connected ? Theme.successSoft : "transparent"
                }
                border.width: appController.connected || usbButton.hovered ? 1 : 0
                border.color: appController.connected ? "#6ee7b7" : Theme.border
            }

            onClicked: usbPopup.open()
        }
    }

    UsbConfigPopup {
        id: usbPopup
        x: root.width - width - 12
        y: root.height - 2
    }
}
