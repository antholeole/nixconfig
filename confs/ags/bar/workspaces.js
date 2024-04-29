import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { altDown } from '../globals.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'

const buildWorkspacesChildren = (altIsDown, monitor) => {
    // This is more consistent than the builtin :()
    const thisMonitor = JSON.parse(exec("hyprctl monitors -j")).find(hMonitor => hMonitor.id === monitor)

    const workspaces = Hyprland.workspaces.filter((workspace) => workspace.monitor === thisMonitor.name).sort((a, b) => a.id - b.id)
    const active = workspace => thisMonitor.activeWorkspace.id === workspace.id && Hyprland.active.monitor == thisMonitor.name

    const buildClassName = (workspace) => {
        const classPrefix = altIsDown ? `ws-text` : `dot`
        const classSuffix = active(workspace) ? `selected` : `not-selected`
        return `${classPrefix}-${classSuffix}`
    }

    return workspaces.map(workspace => Widget.Box({
        className: buildClassName(workspace),
        children: altIsDown ? [Widget.Label({
            label: `${workspace.id}`
        })] : []
    }));
}


export const Workspaces = (monitor) => Widget.Box({
    className: 'workspaces',
    connections: [
        [Hyprland.active.workspace, self => self.children = buildWorkspacesChildren(altDown.value, monitor)],
        [altDown, self => self.children = buildWorkspacesChildren(altDown.value, monitor)]
    ]
});
