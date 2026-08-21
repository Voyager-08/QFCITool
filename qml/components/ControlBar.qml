import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".."

Rectangle {
    id: root
    color: Theme.bgControl

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 14
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 8

        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            ActionButton {
                text: qsTr("使能")
                enabled: appController.enableEnabled
                accentColor: Theme.btnEnable
                accentHover: Theme.btnEnableHover
                onClicked: appController.enableArm()
            }
            ActionButton {
                text: qsTr("拖动")
                enabled: appController.dragEnabled
                accentColor: Theme.btnDrag
                accentHover: Theme.btnDragHover
                onClicked: appController.dragArm()
            }
            ActionButton {
                text: qsTr("失能")
                enabled: appController.disableEnabled
                accentColor: Theme.btnDisable
                accentHover: Theme.btnDisableHover
                onClicked: appController.disableArm()
            }
            ActionButton {
                text: qsTr("回零")
                enabled: appController.homeEnabled
                accentColor: Theme.btnHome
                accentHover: Theme.btnHomeHover
                onClicked: appController.homeArm()
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 22
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            color: Theme.borderStrong
            radius: 1
        }

        Label {
            text: qsTr("末端坐标")
            color: Theme.textSecondary
            font.pixelSize: 12
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            radius: 6
            color: Theme.bgApp
            border.color: Theme.border

            Label {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                text: appController.poseText.length > 0
                      ? appController.poseText
                      : qsTr("等待连接…")
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                color: appController.poseText.length > 0 ? Theme.textPrimary : Theme.textMuted
                font.pixelSize: 12
                font.family: "Consolas"
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 22
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            color: Theme.borderStrong
            radius: 1
        }

        Label {
            text: qsTr("总线")
            color: Theme.textSecondary
            font.pixelSize: 12
            font.bold: true
        }

        Rectangle {
            Layout.preferredWidth: Math.max(busLabel.implicitWidth + 20, 72)
            Layout.preferredHeight: 28
            radius: 14
            color: {
                if (!appController.connected)
                    return "#f1f5f9"
                return appController.busHealthy ? Theme.successSoft : Theme.dangerSoft
            }
            border.color: {
                if (!appController.connected)
                    return Theme.border
                return appController.busHealthy ? "#6ee7b7" : "#fca5a5"
            }

            Row {
                id: busLabel
                anchors.centerIn: parent
                spacing: 6

                Rectangle {
                    width: 7
                    height: 7
                    radius: 3.5
                    anchors.verticalCenter: parent.verticalCenter
                    color: {
                        if (!appController.connected)
                            return Theme.textMuted
                        return appController.busHealthy ? Theme.success : Theme.danger
                    }
                }

                Label {
                    text: appController.busStatusText
                    font.pixelSize: 12
                    font.bold: true
                    color: {
                        if (!appController.connected)
                            return Theme.textSecondary
                        return appController.busHealthy ? Theme.success : Theme.danger
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Theme.border
    }
}
