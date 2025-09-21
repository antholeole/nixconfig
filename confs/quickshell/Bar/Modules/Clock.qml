import Quickshell
import QtQuick
import qs.Theme

Row {
    id: root
    
    property var date: new Date()
    property string time: Qt.formatDateTime(root.date, "h:mm:ss")

    children: [
        Text {
            color: Theme.text
            
            text: root.time
        }
    ]

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: root.date = new Date()
    }
}
