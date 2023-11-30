import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import App from 'resource:///com/github/Aylur/ags/app.js'

const commands = [
    { text: "", hotkey: "q" },
    { text: "󰍃", hotkey: "l" },
    { text: "", hotkey: "r" },
    { text: "󰤆", hotkey: "s" },
]


const showPowerbar = Variable(false)
globalThis.showPowerbar = showPowerbar

export const Powerbar = () => Widget.Window({
    name: `powerbar`,
    class_name: 'window',
    anchor: ['right'],
    margins: [0, 40],
    child: Widget.Box({
        vertical: true,
        class_name: 'container',
        children: commands.map(({ text, hotkey }) => Widget.Box({
            class_name: 'command-button',
            vertical: true,
            children: [
                Widget.Label({
                    label: text,
                    class_name: "icon"
                }),
                Widget.Label({
                    label: `(${hotkey})`,
                    class_name: "subtext"
                })
            ]
        })),
    })
})

var window = undefined
showPowerbar.connect('changed', ({ value }) => {
    if (value) {
        if (window === undefined) {
            window = Powerbar()
            App.addWindow(window)
        } else {
            App.openWindow(window.name)
        }
    } else {
        App.closeWindow(window.name)
    }
})
