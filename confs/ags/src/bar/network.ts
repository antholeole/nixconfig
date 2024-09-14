import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import type Box from "types/widgets/box";
import type { Connectable } from "types/service";

export type INetwork = {
	connectivity: string;
} & Connectable;

export const NETWORK_CONSTANTS = {
	NO_NETWORK_WIDGET: "󰤫",
};

export const networkProps = (
	network: INetwork,
):
	| {
			status: string;
			icon: string;
	  }
	| undefined => {
	if (network.connectivity === "none") {
		return {
			icon: NETWORK_CONSTANTS.NO_NETWORK_WIDGET,
			status: "error",
		};
	}

	return undefined;
};

export const NetworkIndicator = (network: INetwork = Network) =>
	Widget.Box({
		class_name: "bar-section network-indicator",
	}).hook(network, (self) => {
		const props = networkProps(network);

		self.children =
			props === undefined
				? []
				: [
						Widget.Box({
							class_name: `chip network-indicator ${props.status}`,
							children: [
								Widget.Label({
									label: props.icon,
								}),
							],
						}),
					];
	});
