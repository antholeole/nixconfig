import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js'

const { Box } = Widget;

const timeAgo = (timestamp) => {
    const delta = new Date() - new Date(timestamp * 1000)
    const seconds = Math.floor(delta / 1000)
    const minutes = Math.floor(seconds / 60)

    return minutes ? `${minutes}m ${seconds % 60}s ago` : `${seconds}s ago`
}

const Notification = (n) => {
    let icon = "      "
    switch (n.urgency) {
        case "normal":
            icon = "";
            break
        case "critical":
            icon = "";
    }

    return Widget.EventBox({
        onPrimaryClick: () => n.close(),
        child: Widget.Box({
            className: "container notification",
            vertical: false,
            children: [
                Widget.Label({
                    className: `notification-icon ${n.urgency}`,
                    label: icon,
                }),
                Widget.Box({
                    vertical: true,
                    children: [
                        Widget.Label({
                            hpack: "start",
                            className: `title ${n.urgency}`,
                            label: n.summary
                        }),
                        Widget.Label({
                            hpack: "start",
                            className: "subtext small mb-2",
                            label: timeAgo(n.time),
                            connections: [
                                [1000, self => self.label = timeAgo(n.time)]
                            ]
                        }),
                        Widget.Label({
                            wrap: true,
                            justification: "left",
                            hpack: "start",
                            label: n.body,
                        })
                    ]
                })
            ]
        })
    })
}

export const NotificationBar = (monitor) => Widget.Window({
    className: 'window',
    layer: "overlay",
    name: `notification-center-${monitor}`,
    anchor: ['top', 'right'],
    margins: [0, 15],
    child: Box({
        className: 'list',
        css: 'padding: 1px;', // so it shows up (WTF?)
        vertical: true,
        connections: [[Notifications, box => {
            box.children = Array.from(Notifications.popups.values())
                .map(n => Notification(n));
        }]],
    })
});