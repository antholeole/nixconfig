import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { capsDown } from "../globals.js";
import type { Network } from "types/service/network";

const network = Variable<null | Network>(null);
Service.import("network").then((n) => {
	network.value = n;
});

const buildChip = (text: string, urgency: "error" | "warning") => {
	return Widget.Box({
		class_name: ["chip", urgency].join(" "),
		children: [
			Widget.Label({
				label: text,
			}),
		],
	});
};

export const CapsIndicator = () => {
	return Widget.Box({
		child: capsDown
			.bind()
			.as((down) => (down ? buildChip("󰘲", "warning") : Widget.Box())),
	});
};

export const NetworkIndicator = () =>
	Widget.Box({
		class_name: "bar-section network-indicator",
		child: network.bind().as((network) => {
			if (network == null) {
				return Widget.Box();
			}

			return Widget.Box({
				child: network.bind("connectivity").as((conn) => {
					if (conn === "none") {
						console.log("building chip");
						return buildChip("󰤫", "error");
					}

					return Widget.Box();
				}),
			});
		}),
	});
