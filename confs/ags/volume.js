import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import { addToggleableWindow } from './globals.js'

export const Volbar = () => Widget.Window({
    name: `volbar`,
    class_name: 'window',
    anchor: ['right'],
    margins: [0, 40],
    child: Widget.Box({
        vertical: true,
        class_name: 'container',
        children: commands.map(({ text, hotkey }) => Widget.Box({
            class_name: 'volslider-container',
            vertical: true,
            children: [
                Widget.Slider({
                    label: text,
                    class_name: "icon"
                }),
            ]
        })),
    })
})


addToggleableWindow("volbar", Volbar)

