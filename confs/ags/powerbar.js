import Widget from 'resource:///com/github/Aylur/ags/widget.js';

const commands = [
    { text: "", hotkey: "q"},
    { text: "󰍃", hotkey: "l"},
    { text: "", hotkey: "r"},
    { text: "󰤆", hotkey: "s"},
]

export default (monitor) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    class_name: 'container',
    anchor: ['right'],
    margins: [0, 40],
    child: Widget.Box({
        vertical: true,
        children: commands.map(({text, hotkey}) => Widget.Box({
            class_name: 'command-button',
            vertical: true,
            children: [
                Widget.Label(text),
                Widget.Label(`(${hotkey})`)
            ]
        }))
    })
})