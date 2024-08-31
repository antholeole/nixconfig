import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import type { Variable as VarT } from "types/variable.js";
import { addToggleableWindow, downEmitter, upEmitter } from "../globals.js";
import type LabelT from "types/widgets/label.js";

const { Box, Slider, Label, CenterBox } = Widget;

const selectedElementIndex = Variable(0);

upEmitter.register(() => {
	selectedElementIndex.value = Math.min(
		elements.length,
		selectedElementIndex.value + 1,
	);
});
downEmitter.register(() => {
	selectedElementIndex.value = Math.max(0, selectedElementIndex.value - 1);
});

const elements = ["volume", "brightness"];

const CustomSlider = (name: string, selectedElementIndex: VarT<number>) => {
	const selected = name === elements[selectedElementIndex.value];
	const buildLabelText = () => (selected ? `> ${name}` : name);

	return Box({
		vertical: true,
		className: "slider-container",
		children: [
			CenterBox({
				className: "max-width",
				startWidget: Label({
					label: buildLabelText(),
					hpack: "start",
					className: `label ${selected ? "selected" : ""}`,

					connections: [
						[
							selectedElementIndex,
							(self: LabelT<unknown>) => {
								self.label = buildLabelText();
							},
						],
					],
				}),
				endWidget: Label({
					label: "20%",
					hpack: "end",
					className: "label",
				}),
			}),
			Slider({
				className: "slider",
				onChange: ({ value }) => print(value),
				value: 50,
				min: 0,
				max: 100,
			}),
		],
	});
};

export const SetupControl = () => {
	selectedElementIndex.value = 0;

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
				CustomSlider("volume", selectedElementIndex),
				CustomSlider("brightness", selectedElementIndex),
			],
		}),
	});
};

addToggleableWindow("Control", SetupControl, false);
