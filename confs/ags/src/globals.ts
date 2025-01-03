import Variable from "resource:///com/github/Aylur/ags/variable.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import { createEmitter } from "./utils.js";
import type { Variable as VarT } from "types/variable.js";

type GtkWindow = Parameters<typeof App.addWindow>[0];

export const altDown = Variable(false);
globalThis.altDown = altDown;

export const capsDown = Variable(false);
globalThis.capsDown = capsDown;

export const addToggleableWindow = (
	windowName: string,
	windowBuilder: (show: VarT<boolean>) => GtkWindow,
	defaultOn = false,
) => {
	const showWindow = Variable(defaultOn);
	globalThis[`show${windowName}`] = showWindow;
	let window = defaultOn ? windowBuilder(showWindow) : undefined;
	showWindow.connect("changed", ({ value }) => {
		if (value) {
			if (window === undefined) {
				window = windowBuilder(showWindow);
				App.addWindow(window);
			} else {
				App.openWindow(window.name);
			}
		} else if (window !== undefined) {
			App.closeWindow(window.name);
		}
	});

	return showWindow;
};

export const leftEmitter = createEmitter("left");
export const rightEmitter = createEmitter("right");
export const upEmitter = createEmitter("up");
export const downEmitter = createEmitter("down");
export const spaceEmitter = createEmitter("space");
