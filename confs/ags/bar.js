import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const Clock = () => Widget.Box({
    hpack: 'end',
    children: [Widget.Label({
        className: 'clock',
        connections: [
            [1000, self => execAsync(['date', '+%A, %B %d %I:%M:%S %p'])
                .then(date => self.label = date).catch(console.error)],
        ],
    })]
});



export default (monitor) => Widget.Window({
    name: `bar-${monitor}`,
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child:
        Widget.CenterBox({
            className: 'bar',
            startWidget: Widget.Label("temp"),
            endWidget: Clock()
        })
})
