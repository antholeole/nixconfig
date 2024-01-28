import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const Clock = () => Widget.Box({
    hpack: 'end',
    children: [Widget.Label({
        className: 'clock',
        connections: [
            [1000, self => execAsync(['date', '+%A, %B %d %I:%M:%S %p'])
                .then(date => self.label = date).catch(console.error)],
        ],
    })]
});
