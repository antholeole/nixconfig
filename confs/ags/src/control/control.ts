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

const modifyVolume = (value: number, asPecent: boolean) => {
	// if this is null it won't matter since it will update soon anyway
	let newValue = asPecent ? (currentVolume.value || 0) + value : value;

	if (newValue < 0) {
		newValue = 0;
	} else if (newValue > 100) {
		newValue = 100;
	}

	const processedValue = asPecent ? `${newValue}%` : newValue;

	Utils.execAsync(`pactl set-sink-volume @DEFAULT_SINK@ ${processedValue}`);
	currentVolume.value = newValue;
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
					self.label = `${trackerVar.value}%` || "loading...";
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

export const SetupControl = () => {
	selectedElementIndex.value = 0;

	// if this is too slow may need to be async
	Utils.execAsync("pactl get-sink-volume @DEFAULT_SINK@").then((v) => {
		currentVolume.value = Number.parseFloat(
			v.split("/")[1].trim().replace("%", ""),
		);
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
				CustomSlider(
					"brightness",
					selectedElementIndex,
					Variable<number | null>(null),
				),
			],
		}),
	});
};

const windowShown = addToggleableWindow("Control", SetupControl, false);

leftEmitter.register(() => {
	if (!windowShown.value) {
		return;
	}

	if (elements[selectedElementIndex.value] === "volume") {
		modifyVolume(-5, true);
	}
});

rightEmitter.register(() => {
	if (!windowShown.value) {
		return;
	}

	if (elements[selectedElementIndex.value] === "volume") {
		modifyVolume(5, true);
	}
});
