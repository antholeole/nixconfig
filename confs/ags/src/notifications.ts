import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import type Label from "types/widgets/label";
import type BoxT from "types/widgets/box";

const { Box } = Widget;

interface ReducedNotification {
	urgency: string;
	close: VoidFunction;
	summary: string;
	body: string;
	time: number;
}

// since we can't subscribe to notifications more than once,
// we shim it through this so we can have the notifications pop up on both screens.
const shimNotifications = Variable<ReducedNotification[]>([]);
Notifications.connect("notified", () => {
	shimNotifications.setValue(Notifications.popups);
});

Notifications.connect("dismissed", () => {
	shimNotifications.setValue(Notifications.popups);
});

Notifications.connect("closed", () => {
	shimNotifications.setValue(Notifications.popups);
});

const timeAgo = (timestamp: number) => {
	const delta = new Date().getTime() - new Date(timestamp * 1000).getTime();
	const seconds = Math.floor(delta / 1000);
	const minutes = Math.floor(seconds / 60);

	return minutes ? `${minutes}m ${seconds % 60}s ago` : `${seconds}s ago`;
};

const Notification = (n: ReducedNotification) => {
	let icon = "      ";
	switch (n.urgency) {
		case "normal":
			icon = "";
			break;
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
							label: n.summary,
						}),
						Widget.Label({
							hpack: "start",
							className: "subtext small mb-2",
							label: timeAgo(n.time),
							connections: [
								[
									1000,
									(self: Label<unknown>) => {
										self.label = timeAgo(n.time);
									},
								],
							],
						}),
						Widget.Label({
							wrap: true,
							justification: "left",
							hpack: "start",
							label: n.body,
						}),
					],
				}),
			],
		}),
	});
};

export const NotificationBar = (monitor: number) =>
	Widget.Window({
		monitor: monitor,
		className: "window",
		layer: "overlay",
		name: `notification-center-${monitor}`,
		anchor: ["top", "right"],
		margins: [0, 15],
		child: Box({
			className: "list",
			css: "padding: 1px;", // so it shows up (WTF?)
			vertical: true,
			connections: [
				[
					shimNotifications,
					(box: BoxT<unknown, unknown>) => {
						box.children = shimNotifications.value.map((n) => Notification(n));
					},
				],
			],
		}),
	});
