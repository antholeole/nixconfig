import { expect, test } from "vitest";
import {
	BATTERY_CONSTANTS,
	batteryProps,
	type IBattery,
} from "../../src/bar/battery.js";

const mockIBattery = (percent: number, charging: boolean): IBattery => ({
	charging,
	percent,
	connect: () => 0,
});

test("should show charging when under percent", () => {
	const props = batteryProps(mockIBattery(10, true));
	expect(props.icon).to.equal(BATTERY_CONSTANTS.CHARGING_ICON);
});

test("should show percent under percent", () => {
	const percent = BATTERY_CONSTANTS.SHOW_UNDER_PERCENT - 20;
	const props = batteryProps(mockIBattery(percent, true));
	expect(props.percentLabel).to.include(percent);
});

test("should not show percent above percent", () => {
	const percent = BATTERY_CONSTANTS.SHOW_UNDER_PERCENT + 10;
	const props = batteryProps(mockIBattery(percent, true));
	expect(props.percentLabel).to.be.undefined;
});
