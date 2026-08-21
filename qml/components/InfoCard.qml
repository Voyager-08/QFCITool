import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    spacing: 0

    property string title: ""
    property string value: "---"

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 78
        radius: 10
        color: "#ffffff"
        border.color: "#e2e8f0"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 6

            Label {
                text: root.title
                color: "#64748b"
                font.pixelSize: 12
            }

            Label {
                text: root.value
                font.pixelSize: 22
                font.bold: true
                color: "#0f172a"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }
}
