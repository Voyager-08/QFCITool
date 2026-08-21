import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."
import ".."

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.bgApp
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            InfoCard {
                Layout.fillWidth: true
                title: qsTr("设备名称")
                value: appController.boardName
            }
            InfoCard {
                Layout.fillWidth: true
                title: qsTr("固件版本")
                value: appController.firmwareVersion
            }
            InfoCard {
                Layout.fillWidth: true
                title: qsTr("协议版本")
                value: appController.protocolVersion
            }
            InfoCard {
                Layout.fillWidth: true
                title: qsTr("在线时长")
                value: appController.uptime
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: Theme.bgSurface
            border.color: Theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Label {
                    text: qsTr("关节状态")
                    font.pixelSize: 14
                    font.bold: true
                    color: Theme.textPrimary
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.border
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Label {
                        text: qsTr("轴号")
                        font.bold: true
                        font.pixelSize: 12
                        color: Theme.textSecondary
                        Layout.preferredWidth: 48
                    }
                    Label {
                        text: qsTr("角度 (°)")
                        font.bold: true
                        font.pixelSize: 12
                        color: Theme.textSecondary
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }
                    Label {
                        text: qsTr("扭矩 (Nm)")
                        font.bold: true
                        font.pixelSize: 12
                        color: Theme.textSecondary
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }
                    Label {
                        text: qsTr("温度 (℃)")
                        font.bold: true
                        font.pixelSize: 12
                        color: Theme.textSecondary
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                    }
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: jointCol.height
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    ColumnLayout {
                        id: jointCol
                        width: parent.width
                        spacing: 10

                        Repeater {
                            model: appController.joints
                            delegate: JointRow {
                                Layout.fillWidth: true
                                axisName: modelData.name
                                angle: modelData.angle
                                torque: modelData.torque
                                temp: modelData.temp
                            }
                        }
                    }
                }
            }
        }
    }
}
