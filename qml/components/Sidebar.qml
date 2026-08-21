import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Rectangle {
    id: root
    color: Theme.bgSidebar

    property int currentIndex: 0

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Theme.border
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 12
        spacing: 4

        Label {
            Layout.leftMargin: 16
            Layout.bottomMargin: 6
            text: qsTr("导航")
            color: Theme.textMuted
            font.pixelSize: 11
            font.bold: true
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            currentIndex: root.currentIndex
            spacing: 4
            model: [
                { title: "状态监控" },
                { title: "数字孪生" },
                { title: "电机设置" },
                { title: "设备设置" }
            ]

            delegate: ItemDelegate {
                id: del
                width: list.width - 16
                x: 8
                height: 40
                highlighted: list.currentIndex === index
                hoverEnabled: true

                contentItem: Text {
                    text: modelData.title
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 14
                    color: del.highlighted ? Theme.accent : Theme.textPrimary
                    font.pixelSize: 13
                    font.bold: del.highlighted
                }

                background: Rectangle {
                    radius: 8
                    color: {
                        if (del.highlighted)
                            return Theme.accentSoft
                        if (del.hovered)
                            return "#eef2f7"
                        return "transparent"
                    }

                    Rectangle {
                        visible: del.highlighted
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 3
                        height: parent.height - 12
                        radius: 2
                        color: Theme.accent
                    }

                    Behavior on color { ColorAnimation { duration: 100 } }
                }

                onClicked: {
                    list.currentIndex = index
                    root.currentIndex = index
                }
            }
        }
    }
}
