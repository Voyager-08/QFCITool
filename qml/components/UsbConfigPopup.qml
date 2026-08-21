import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import ".."

Popup {
    id: popup
    width: 320
    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 16

    background: Rectangle {
        color: Theme.bgSurface
        border.color: Theme.border
        border.width: 1
        radius: 10
    }

    onOpened: appController.refreshPorts()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Label {
            text: qsTr("USB 串口")
            font.bold: true
            font.pixelSize: 14
            color: Theme.textPrimary
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            ComboBox {
                id: portCombo
                Layout.fillWidth: true
                model: appController.availablePorts
                displayText: count > 0 ? currentText : qsTr("(No devices found)")
            }

            ToolButton {
                text: "↻"
                implicitWidth: 34
                implicitHeight: 34
                onClicked: appController.refreshPorts()
                background: Rectangle {
                    radius: 6
                    color: parent.hovered ? Theme.bgApp : "transparent"
                    border.color: Theme.border
                    border.width: 1
                }
            }
        }

        Button {
            Layout.fillWidth: true
            implicitHeight: 34
            text: appController.connected ? qsTr("Close Port") : qsTr("Open Port")
            onClicked: appController.toggleConnection(portCombo.currentText)

            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: 6
                color: parent.down ? Theme.accentHover
                     : (parent.hovered ? Theme.btnDragHover : Theme.accent)
            }
        }

        Label {
            Layout.fillWidth: true
            text: appController.connectionStatus
            color: appController.connected ? Theme.success : Theme.textSecondary
            font.pixelSize: 12
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.border
            Layout.topMargin: 4
            Layout.bottomMargin: 2
        }

        Label {
            text: qsTr("固件升级")
            font.bold: true
            font.pixelSize: 14
            color: Theme.textPrimary
        }

        Label {
            Layout.fillWidth: true
            text: appController.firmwareFileName
            elide: Text.ElideMiddle
            color: Theme.textSecondary
            font.pixelSize: 12
        }

        Button {
            Layout.fillWidth: true
            implicitHeight: 32
            text: qsTr("Browse...")
            onClicked: fileDialog.open()
            background: Rectangle {
                radius: 6
                color: parent.hovered ? Theme.bgApp : Theme.bgSurface
                border.color: Theme.border
                border.width: 1
            }
        }

        Button {
            Layout.fillWidth: true
            implicitHeight: 34
            text: appController.flashing ? qsTr("Cancel") : qsTr("Start Flash")
            enabled: appController.connected && (appController.flashing
                     || appController.firmwareFileName !== "No firmware selected")
            onClicked: appController.startOrCancelFlash()

            contentItem: Text {
                text: parent.text
                color: parent.enabled ? "#ffffff" : Theme.disabledText
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: 6
                color: !parent.enabled ? Theme.disabledBg
                     : (parent.down ? Qt.darker(Theme.btnEnable, 1.1)
                     : (parent.hovered ? Theme.btnEnableHover : Theme.btnEnable))
            }
        }

        ProgressBar {
            id: flashBar
            Layout.fillWidth: true
            from: 0
            to: 1
            value: appController.flashProgress
            background: Rectangle {
                implicitHeight: 8
                radius: 4
                color: Theme.bgApp
            }
            contentItem: Item {
                implicitHeight: 8
                Rectangle {
                    width: flashBar.visualPosition * parent.width
                    height: parent.height
                    radius: 4
                    color: Theme.btnEnable
                }
            }
        }

        Label {
            text: Math.round(appController.flashProgress * 100) + "%"
            color: Theme.textMuted
            font.pixelSize: 11
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Select Firmware Image")
        nameFilters: ["Firmware Images (*.bin)", "All Files (*)"]
        onAccepted: {
            const path = selectedFile.toString().replace("file:///", "")
            appController.setFirmwarePath(path)
        }
    }
}
