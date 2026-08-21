import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Window
import "components"
import "pages"
import "."

ApplicationWindow {
    id: root
    width: 1100
    height: 720
    minimumWidth: 960
    minimumHeight: 600
    visible: true
    title: qsTr("FCITool - Industrial Host Controller")
    color: Theme.bgApp

    Material.theme: Material.Light
    Material.accent: Material.Blue
    Material.primary: Material.BlueGrey
    Material.background: Theme.bgApp
    Material.foreground: Theme.textPrimary

    font.family: "Segoe UI"
    font.pixelSize: 13

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 52
        }

        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal
            handle: Rectangle {
                implicitWidth: 1
                color: Theme.border
            }

            Sidebar {
                id: sidebar
                SplitView.preferredWidth: 168
                SplitView.minimumWidth: 140
                SplitView.maximumWidth: 240
            }

            ColumnLayout {
                SplitView.fillWidth: true
                spacing: 0

                ControlBar {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: sidebar.currentIndex

                    MonitorView {}
                    DigitalTwinPage {}
                    MotorPage {}
                    DevicePage {}
                }
            }
        }
    }
}
