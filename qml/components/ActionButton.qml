import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import ".."

Button {
    id: root

    property color accentColor: Theme.btnEnable
    property color accentHover: Theme.btnEnableHover

    Material.elevation: enabled ? 2 : 0

    implicitWidth: 84
    implicitHeight: 36
    font.pixelSize: 13
    font.bold: true
    hoverEnabled: true

    contentItem: Text {
        text: root.text
        font: root.font
        color: root.enabled ? "#ffffff" : Theme.disabledText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 18
        color: {
            if (!root.enabled)
                return Theme.disabledBg
            if (root.down)
                return Qt.darker(root.accentColor, 1.18)
            if (root.hovered)
                return root.accentHover
            return root.accentColor
        }
        Behavior on color { ColorAnimation { duration: 100 } }
    }

    scale: root.down && root.enabled ? 0.96 : 1.0
    Behavior on scale { NumberAnimation { duration: 70; easing.type: Easing.OutCubic } }
}
