import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const Clock = () => Widget.Box({
    hpack: 'end',
    children: [Widget.Label({
        className: 'clock',
        connections: [
            [1000, self => execAsync(['date', '+%A, %B %d %I:%M:%S %p'])
                .then(date => self.label = date).catch(console.error)],
        ],
    })]
});


const Workspaces = (monitor) => Widget.Box({
    className: 'workspaces',
    connections: [[Hyprland.active.workspace, self => {
        const thisMonitor = Hyprland.getMonitor(monitor)
        const workspaces = Hyprland.workspaces.filter((workspace) => workspace.monitor === thisMonitor.name)

        const active = workspace => thisMonitor.activeWorkspace.id === workspace.id && Hyprland.active.monitor == thisMonitor.name
        const showText = false

        self.children = workspaces.map(workspace => Widget.Box({
            className: showText ? "ws-text" : `dot-${active(workspace) ? 'full' : 'empty'}`,
            children: showText ? [Widget.Label({
                label: `${workspace.id}`
            })] : []
        }));
    }]],
});

export const Bar = (monitor) => Widget.Window({
    name: `bar-${monitor}`,
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child:
        Widget.CenterBox({
            className: 'bar',
            startWidget: Workspaces(monitor),
            endWidget: Widget.Box({
                hpack: 'end',
                children: [
                    Clock()
                ]

            })
        })
})
