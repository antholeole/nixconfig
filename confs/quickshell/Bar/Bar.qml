import Quickshell
import Quickshell.Io
import QtQuick
import qs.Theme
import qs.Bar.Modules

Variants {
    model: Quickshell.screens

    PanelWindow {
        color: Theme.bg

        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 36

        Item {
            id: barTop

            property int horizontalPadding: 20

            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter

            children: [
                Row {
                    anchors.left: barTop.left
                    leftPadding: barTop.horizontalPadding
                    anchors.verticalCenter: parent.verticalCenter

                    children: [
                        Niri {}
                    ]
                },
                Row {
                    anchors.right: barTop.right
                    anchors.verticalCenter: parent.verticalCenter
                    rightPadding: barTop.horizontalPadding

                    spacing: 8

                    children: [
                        Battery {},
                        Clock {}
                    ]
                }
            ]
        }
    }
}
