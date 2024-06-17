import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import { addToggleableWindow, downEmitter, upEmitter } from '../globals.js'

const { Box, Slider, Label, CenterBox } = Widget;


const selectedElementIndex = Variable(0)

upEmitter.register(() => selectedElementIndex.value = Math.min(elements.length, selectedElementIndex.value + 1))
downEmitter.register(() => selectedElementIndex.value = Math.max(0, selectedElementIndex.value - 1))

const elements = [
    "volume",
    "brightness"
]

const CustomSlider = (name, selectedElementIndex) => {
    const selected = name === elements[selectedElementIndex.value]
    const buildLabelText = () => selected ? `> ${name}` : name

    return Box({
        vertical: true,
        className: "slider-container",
        children: [
            CenterBox({
                className: "max-width",
                startWidget: Label({
                    label: buildLabelText(),
                    hpack: "start",
                    className: `label ${selected ? "selected" : ""}`,

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
    selectedElementIndex.value = 0

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

addToggleableWindow("Control", SetupControl, false)
