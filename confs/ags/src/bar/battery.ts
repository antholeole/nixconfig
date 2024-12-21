import { battery as batteryService } from "resource:///com/github/Aylur/ags/service/battery.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import type { Connectable } from "types/service";

export type IBattery = {
	percent: number;
	charging: boolean;
} & Omit<Connectable, "disconnect">;

export const BATTERY_CONSTANTS = {
	SHOW_UNDER_PERCENT: 80,
	CHARGING_ICON: "󰂄",
	BATTERIES: [
		[99, "󰁹"],
		[90, "󰂂"],
		[80, "󰂁"],
		[70, "󰂀"],
		[60, "󰁿"],
		[50, "󰁾"],
		[40, "󰁽"],
		[30, "󰁼"],
		[20, "󰁻"],
		[10, "󰁺"],
		[0, "󱃍"],
	],
};

export const batteryProps = (
	battery: IBattery,
): {
	percentLabel?: string;
	icon: string;
} => {
	const ret: Partial<ReturnType<typeof batteryProps>> = {};

	if (battery.percent < BATTERY_CONSTANTS.SHOW_UNDER_PERCENT) {
		ret.percentLabel = `${battery.percent.toString()}`;
	}

	if (battery.charging) {
		ret.icon = BATTERY_CONSTANTS.CHARGING_ICON;
	} else {
		for (const [percent, icon] of BATTERY_CONSTANTS.BATTERIES) {
			if ((battery.percent as number) >= (percent as number)) {
				ret.icon = icon as string;
				break;
			}
		}
	}

	return ret as ReturnType<typeof batteryProps>;
};

export const BatteryBar = (battery: IBattery = batteryService) =>
	Widget.Box().hook(battery as unknown as Connectable, (self) => {
		battery;
		const { percentLabel, icon } = batteryProps(battery);

		const percentLabelWidget = percentLabel
			? [
					Widget.Label({
						class_name: "battery-label",
						label: `${battery.percent.toString()}%`,
					}),
				]
			: [];

		self.children = [
			...percentLabelWidget,
			Widget.Label({
				class_name: "battery-icon",
				label: icon,
			}),
		];
	});
