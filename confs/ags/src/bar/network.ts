import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import type Box from "types/widgets/box";

export const NetworkIndicator = () =>
	Widget.Box({
		class_name: "bar-section network-indicator",
		connections: [
			[
				Network,
				(self: Box<unknown, unknown>) => {
					const mkWidget = (status: string, icon: string) =>
						Widget.Box({
							class_name: `chip network-indicator ${status}`,
							children: [
								Widget.Label({
									label: icon,
								}),
							],
						});

					if (Network.connectivity === "none") {
						self.children = [mkWidget("error", "󰤫")];
					} else {
						self.children = [];
					}
				},
			],
		],
	});
