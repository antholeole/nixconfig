import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import { notifications } from 'resource:///com/github/Aylur/ags/service/notifications.js';


const Notification = (n) => {
    let icon = "      "
    switch (n.urgency) {
        case "normal":
            icon = "";
            break
        case "critical":
            icon = "";
    }

    return Widget.Box({
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
                    Widget.Box({
                        vertical: false,
                        hpack: "fill",
                        hexpand: true,
                        children: [
                            Widget.Label({
                                hpack: "start",
                                className: `title ${n.urgency}`,
                                label: n.summary
                            }),
                            Widget.Label({
                                hexpand: true,
                                hpack: "end",
                                label: ""
                            }),
                        ]
                    }),
                    Widget.Label({
                        hpack: "start",
                        className: "subtext small",
                        label: "1s ago"
                    }),
                    Widget.Label({
                        max_width_chars: 40,
                        wrap: true,
                        hpack: "start",
                        label: n.body,
                    })
                ]
            })
        ]
    })
}

export const NotificationBar = (monitor) => {
    return Widget.Window({
        monitor,
        className: 'window',
        layer: "overlay",
        name: `notification-center-${monitor}`,
        anchor: ['top', 'right'],
        margins: [15, 15],

        child: Widget.Box({
            vertical: true,
            children: notifications.bind('popups').transform(popups => {
                return popups.map(Notification);
            }),
        })
    })
}