import Quickshell
import Quickshell.Io
import QtQuick
import qs.Theme
import qs.Bar.Modules

Scope {
    id: rootScope

    PanelWindow {
        color: Theme.bg

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 33

        Row {
            children: [
                Clock {}
            ]
        }
    }
}
