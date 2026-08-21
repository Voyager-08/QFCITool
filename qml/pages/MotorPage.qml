import QtQuick
import QtQuick.Controls
import ".."

Rectangle {
    color: Theme.bgApp

    Label {
        anchors.centerIn: parent
        text: qsTr("电机设置")
        font.pixelSize: 18
        color: Theme.textMuted
    }
}
