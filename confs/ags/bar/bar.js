import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import { BatteryBar } from "./battery.js"
import { Clock } from "./clock.js"
import { Workspaces } from "./workspaces.js"
import { NetworkIndicator } from "./network.js"

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
                    NetworkIndicator(),
                    Clock(),
                    BatteryBar(),
                ]
            })
        })
})
