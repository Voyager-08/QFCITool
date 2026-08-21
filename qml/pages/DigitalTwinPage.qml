import QtQuick
import QtQuick.Controls
import ".."

Rectangle {
    color: Theme.bgApp

    Column {
        anchors.centerIn: parent
        spacing: 12

        Rectangle {
            width: 300
            height: 190
            radius: 12
            color: "#0f172a"
            border.color: "#334155"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Digital Twin\n(MuJoCo placeholder)"
                color: "#94a3b8"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 15
            }
        }

        Label {
            text: qsTr("数字孪生视图（后续可接入 MuJoCo / OpenGL）")
            color: Theme.textSecondary
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
