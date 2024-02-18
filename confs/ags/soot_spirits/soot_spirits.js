import Widget from 'resource:///com/github/Aylur/ags/widget.js'



export const SootSpirit = () => Widget.Window({
    layer: "bottom",
    anchor: ["top", "left"],
    margins: [20, 20],
    monitor: 0,
    className: "soot-spirit-bg",
    child: Widget.Box({
        className: "soot-spirit",
    })
})