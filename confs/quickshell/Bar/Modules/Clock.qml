import Quickshell
import QtQuick
import qs.Theme
import qs.Common

Row {
    id: root
    
    property var date: new Date()

    property string time: Qt.formatDateTime(root.date, "hh:mm:ss AP  MMM dd")
    property string timeUtc: `(${root.date.getUTCHours()} UTC)`

    spacing: 5

    children: [
        DefaultText {            
            text: root.time
        },

        DefaultText {
            color: Theme.textMuted
            text: root.timeUtc
        }
    ]

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: root.date = new Date()
    }
}
