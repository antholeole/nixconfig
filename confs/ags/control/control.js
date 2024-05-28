import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js'

const { Box, Slider, Label, CenterBox } = Widget;

const CustomSlider = (name) =>
    Box({
        vertical: true,
        className: "slider-container",
        children: [
            CenterBox({
                className: "max-width",
                startWidget: Label({
                    label: name,
                    hpack: "start",
                    className: "label"
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
                marks: [0, 50, 100]
            })
        ]
    })

export const Control = (monitor) => Widget.Window({
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
            CustomSlider("volume")
        ]
    })
});
