import Quickshell
import QtQuick
import qs.Theme
import qs.Common
import qs.Services

Row {
    spacing: 8

    children: [
        Row {
            spacing: 5

            children: [
                Repeater {
                    id: wsRoot

                    model: NiriService.allWorkspaces
                    property int workspaceCircumference: 15
                    property list<string> colors: ["#fe8019", "#fabd2f", "#8ec07c", "#b8bb26", "#b8bb26"]

                    Rectangle {
                        width: wsRoot.workspaceCircumference
                        height: wsRoot.workspaceCircumference

                        color: modelData.is_active ? wsRoot.colors[modelData.idx - 1] : "transparent"
                        border.color: wsRoot.colors[modelData.idx - 1]
                        border.width: 1.3

                        radius: width / 2

                        Connections {
                            target: NiriService
                            function workspacesChanged() {
                                console.log("HI");
                            }
                        }
                    }
                }
            ]
        },
        DefaultText {
            color: Theme.textMuted
            text: NiriService.focusedWorkspaceIndex + 1
        }
    ]
}
