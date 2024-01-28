import Battery from 'resource:///com/github/Aylur/ags/service/battery.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const BatteryBar = () => Widget.Box({
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
