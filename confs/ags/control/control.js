import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import { addToggleableWindow } from '../globals.js'
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js'

const { Box, Slider, Label, CenterBox } = Widget;

const elements = [
    "volume",
    "brightness"
]

const CustomSlider = (name, selectedElementIndex) => {
    const buildLabelText = () => name === elements[selectedElementIndex.value] ? `> ${name}` : name

    return Box({
        vertical: true,
        className: "slider-container",
        children: [
            CenterBox({
                className: "max-width",
                startWidget: Label({
                    label: buildLabelText(),
                    hpack: "start",
                    className: "label",

                    connections: [
                        [selectedElementIndex,
                            self => self.label = buildLabelText()]
                    ],
                }),
                endWidget: Label({
                    label: "20%",
                    hpack: "end",
                    className: "label"
                }),
            }),
            Slider({
                className: "slider",
                onChange: ({ value }) => print(value),
                value: 50,
                min: 0,
                max: 100,
            })
        ]
    })
}

export const SetupControl = (monitor) => {
    const selectedElementIndex = Variable(0)

    return Widget.Window({
        monitor: monitor,
        className: 'window',
        layer: "overlay",
        name: `control-${monitor}`,
        anchor: ['top', 'right'],
        margins: [0, 15],
        child: Box({
            className: 'container menu',
            vertical: true,
            children: [
                CustomSlider("volume", selectedElementIndex),
                CustomSlider("brightness", selectedElementIndex)
            ]
        })
    });
}

addToggleableWindow("Control", SetupControl, true)
