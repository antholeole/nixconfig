import Battery from 'resource:///com/github/Aylur/ags/service/battery.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import type Box from 'types/widgets/box';
import type Label from 'types/widgets/label';

type IBattery = {
    percent: number,
    charging: boolean,
};

export const BatteryBar = (battery: IBattery = Battery) => Widget.Box({
    connections: [[battery, (self: Box<unknown, unknown>) => {
        const children: Label<unknown>[] = []

        if (battery.percent < 80) {
            children.push(Widget.Label({
                class_name: "battery-label",
                label: `${battery.percent.toString()}%`
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

        if (battery.charging) {
            selectedIcon = "󰂄"
        } else {
            for (const [percent, icon] of batteries) {
                if (battery.percent as number >= (percent as number)) {
                    selectedIcon = icon as string
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
