import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import type { Variable as VarT } from "types/variable.js";
import type { ControlElement } from "./control.js";

const { Box, Slider, Label, CenterBox } = Widget;

const percentToDouble = (s: string) =>
	Number.parseFloat(s.trim().replace("%", ""));

const modifyPercentage = (
	delta: number,
	variable: VarT<null | number>,
	command: (percent: string) => string,
) => {
	let newValue = (variable.value || 0) + delta;

	if (newValue < 0) {
		newValue = 0;
	} else if (newValue > 100) {
		newValue = 100;
	}

	const processedValue = `${newValue}%`;

	Utils.execAsync(command(processedValue));
	variable.value = newValue;
};

const CustomSlider = (
	name: string,
	trackerVar: VarT<null | number>,
	isSelected: VarT<boolean>,
) => {
	return Box({
		vertical: true,
		className: "slider-container",
		children: [
			CenterBox({
				className: "max-width",
				startWidget: Label({
					hpack: "start",
					label: isSelected
						.bind()
						.as((selected) => (selected ? `> ${name}` : name)),
					className: isSelected
						.bind()
						.as((selected) => `label ${selected ? "selected" : ""}`),
				}),
				endWidget: Label({
					label: trackerVar.bind().as((v) => (v ? `${v}%` : "loading...")),
					hpack: "end",
					className: "label",
				}),
			}),
			Slider({
				className: "slider",
				value: trackerVar.bind().as((n) => n || 0),
				min: 0,
				max: 100,
			}),
		],
	});
};

const percentControlElement = (
	name: string,
	buildModifyCommand: (newPercent: string) => string,
	initCmd: [string, (res: string) => number],
): ControlElement => {
	const currentValue = Variable<null | number>(null);

	const [initSh, initCmdTxn] = initCmd;
	Utils.execAsync(initSh).then((v) => {
		currentValue.value = initCmdTxn(v);
	});

	return {
		name,
		onDecrement: () => modifyPercentage(-5, currentValue, buildModifyCommand),
		onIncrement: () => modifyPercentage(5, currentValue, buildModifyCommand),
		build: (selected) => CustomSlider(name, currentValue, selected),
	};
};

export const volumeSlider = percentControlElement(
	"volume",
	(percent) => `pactl set-sink-volume @DEFAULT_SINK@ ${percent}`,
	[
		"pactl get-sink-volume @DEFAULT_SINK@",
		(v) => percentToDouble(v.split("/")[1]),
	],
);
export const brightnessSlider = percentControlElement(
	"brightness",
	(percent) => `brightnessctl set ${percent}`,
	["brightnessctl info -m", (v) => percentToDouble(v.split(",")[3])],
);
