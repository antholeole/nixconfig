import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import type { Variable as VarT } from "types/variable.js";
import {
	addToggleableWindow,
	downEmitter,
	leftEmitter,
	rightEmitter,
	spaceEmitter,
	upEmitter,
} from "../globals.js";
import { brightnessSlider, volumeSlider } from "./sliders.js";
import { player } from "./player.js";

const selectedElementIndex = Variable(0);

export interface ControlElement {
	name: string;

	onDecrement?: () => void;
	onIncrement?: () => void;
	onSpace?: () => void;
	onSetup?: () => Promise<void>;

	// biome-ignore lint/suspicious/noExplicitAny: the type is ill defined; supposed to be gtk.widget, but doesn't exist.
	build: (selected: VarT<boolean>) => any;
}

const elements: ControlElement[] = [volumeSlider, brightnessSlider, player];

export const SetupControl = () => {
	selectedElementIndex.value = 0;

	return Widget.Window({
		className: "window",
		layer: "overlay",
		name: "control",
		anchor: ["top", "right"],
		margins: [0, 15],
		child: Widget.Box({
			className: "container menu",
			vertical: true,
			children: elements.map((element, idx) =>
				element.build(
					Utils.derive(
						[selectedElementIndex],
						(selectedIdx) => idx === selectedIdx,
					),
				),
			),
		}),
	});
};

const windowShown = addToggleableWindow("Control", SetupControl, false);

const callUpdateOnElement = (
	callback: (element: ControlElement) => (() => void) | undefined,
): boolean => {
	if (!windowShown.value) {
		return false;
	}

	const cb = callback(elements[selectedElementIndex.value]);
	if (cb) {
		cb();
		return true;
	}

	return false;
};

leftEmitter.register(() => callUpdateOnElement((e) => e.onDecrement));
rightEmitter.register(() => callUpdateOnElement((e) => e.onIncrement));
spaceEmitter.register(() => {
	const didDo = callUpdateOnElement((e) => e.onSpace);

	if (!didDo) {
		const fn = elements.find((v) => v.name === "player");

		if (fn === undefined ||fn.onSpace === undefined) {
			throw Error("could not find the player element!");
		}

		fn.onSpace();
	}
});
upEmitter.register(() => {
	selectedElementIndex.value = Math.max(0, selectedElementIndex.value - 1);
});
downEmitter.register(() => {
	selectedElementIndex.value = Math.min(
		elements.length - 1,
		selectedElementIndex.value + 1,
	);
});
for (const element of elements) {
	if (element.onSetup) {
		element.onSetup();
	}
}
