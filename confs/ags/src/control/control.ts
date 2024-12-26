import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import type { Variable as VarT } from "types/variable.js";
import {
	addToggleableWindow,
	downEmitter,
	leftEmitter,
	rightEmitter,
	upEmitter,
} from "../globals.js";
import type LabelT from "types/widgets/label.js";
import type { Connectable } from "types/service.js";

const { Box, Slider, Label, CenterBox } = Widget;

const selectedElementIndex = Variable(0);

const currentVolume = Variable<null | number>(null);
const currentBrightness = Variable<null | number>(null);

upEmitter.register(() => {
	selectedElementIndex.value = Math.max(0, selectedElementIndex.value - 1);
});
downEmitter.register(() => {
	selectedElementIndex.value = Math.min(
		elements.length - 1,
		selectedElementIndex.value + 1,
	);
});

const elements = ["volume", "brightness"];

const modify = (
	value: number,
	asPecent: boolean,
	variable: VarT<null | number>,
	command: (s: string | number) => string,
) => {
	// if this is null it won't matter since it will update soon anyway
	let newValue = asPecent ? (variable.value || 0) + value : value;

	if (newValue < 0) {
		newValue = 0;
	} else if (newValue > 100) {
		newValue = 100;
	}

	const processedValue = asPecent ? `${newValue}%` : newValue;

	Utils.execAsync(command(processedValue));
	variable.value = newValue;
};

const CustomSlider = (
	name: string,
	selectedElementIndex: VarT<number>,
	trackerVar: VarT<null | number>,
) => {
	const isSelected = () => name === elements[selectedElementIndex.value];

	const buildLabelText = (selected: boolean) => (selected ? `> ${name}` : name);
	const buildClassName = (selected: boolean) =>
		`label ${selected ? "selected" : ""}`;

	return Box({
		vertical: true,
		className: "slider-container",
		children: [
			CenterBox({
				className: "max-width",
				startWidget: Label({
					label: buildLabelText(isSelected()),
					hpack: "start",
					className: buildClassName(isSelected()),
				}).hook(
					selectedElementIndex as unknown as Connectable,
					(self: LabelT<unknown>) => {
						const selected = isSelected();

						self.label = buildLabelText(selected);
						self.class_name = buildClassName(selected);
					},
				),
				endWidget: Label({
					label: "loading...",
					hpack: "end",
					className: "label",
				}).hook(trackerVar as unknown as Connectable, (self) => {
					self.label = trackerVar.value ? `${trackerVar.value}%` : "loading...";
				}),
			}),
			Slider({
				className: "slider",
				onChange: ({ value }) => print(value),
				value: 0,
				min: 0,
				max: 100,
			}).hook(trackerVar as unknown as Connectable, (self) => {
				self.value = trackerVar.value || 0;
			}),
		],
	});
};

const percentToDouble = (s: string) =>
	Number.parseFloat(s.trim().replace("%", ""));

export const SetupControl = () => {
	selectedElementIndex.value = 0;

	// if this is too slow may need to be async
	Utils.execAsync("pactl get-sink-volume @DEFAULT_SINK@").then((v) => {
		currentVolume.value = percentToDouble(v.split("/")[1]);
	});

	Utils.execAsync("brightnessctl info -m").then((v) => {
		// there might be multiple but just use the first - i only ever look at
		// one screen anyway
		currentBrightness.value = percentToDouble(v.split(",")[3]);
	});

	return Widget.Window({
		className: "window",
		layer: "overlay",
		name: "control",
		anchor: ["top", "right"],
		margins: [0, 15],
		child: Box({
			className: "container menu",
			vertical: true,
			children: [
				CustomSlider("volume", selectedElementIndex, currentVolume),
				CustomSlider("brightness", selectedElementIndex, currentBrightness),
			],
		}),
	});
};

const windowShown = addToggleableWindow("Control", SetupControl, false);

const volumeCmd = (s: string | number) =>
	`pactl set-sink-volume @DEFAULT_SINK@ ${s}`;
const brightnessCmd = (s: string | number) => `brightnessctl set ${s}`;

const onUpdate = (delta: number) => {
	if (!windowShown.value) {
		return;
	}

	switch (elements[selectedElementIndex.value]) {
		case "volume":
			modify(delta, true, currentVolume, volumeCmd);
			break;
		case "brightness":
			modify(delta, true, currentBrightness, brightnessCmd);
			break;
	}
};

leftEmitter.register(() => onUpdate(-5));
rightEmitter.register(() => onUpdate(5));
