import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js'
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { altDown } from './globals.js';

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

const buildWorkspacesChildren = (altIsDown, monitor) => {
    const thisMonitor = Hyprland.getMonitor(monitor)

    const workspaces = Hyprland.workspaces.filter((workspace) => workspace.monitor === thisMonitor.name).sort((a, b) => a.id - b.id)


    const active = workspace => thisMonitor.activeWorkspace.id === workspace.id && Hyprland.active.monitor == thisMonitor.name

    return workspaces.map(workspace => Widget.Box({
        className: altIsDown ? "ws-text" : `dot-${active(workspace) ? 'full' : 'empty'}`,
        children: altIsDown ? [Widget.Label({
            label: `${workspace.id}`
        })] : []
    }));
}


const Workspaces = (monitor) => Widget.Box({
    className: 'workspaces',
    connections: [
        [Hyprland.active.workspace, self => self.children = buildWorkspacesChildren(altDown.value, monitor)],
        [altDown, self => self.children = buildWorkspacesChildren(altDown.value, monitor)]
    ]
});


const BatteryBar = () => Widget.Box({
    class_name: 'blah',
    connections: [[Battery, self => {
        const children = []

        if (Battery.percent < 80) {
            children.push(Widget.Label({
                class_name: "battery-label",
                label: `${Battery.percent.toString()}%`
            }))
        }

        const batteries = [
            [99, "󰁹"],
            [90, "󰂂"],
            [80, "󰂁"],
            [70, "󰂀"],
            [60, "󰁿"],
            [50, "󰁾"],
            [40, "󰁽"],
            [30, "󰁼"],
            [20, "󰁻"],
            [10, "󰁺"],
            [0, "󱃍"]
        ]

        let selectedIcon = ""

        if (Battery.charging) {
            selectedIcon = "󰂄"
        } else {
            for (let [percent, icon] of batteries) {
                if (Battery.percent >= percent) {
                    selectedIcon = icon
                    break
                }
            }
        }

        children.push(Widget.Label({
            class_name: "battery-icon",
            label: selectedIcon
        }))


        self.children = children
    }]]
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
                    BatteryBar(),
                    Clock()
                ]

            })
        })
})
