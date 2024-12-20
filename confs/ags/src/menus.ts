import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { addToggleableWindow } from "./globals.js";

interface Command {
	text: string;
	hotkey: string;
}

const PromptBar = (commands: Command[]) =>
	Widget.Window({
		name: "powerbar",
		class_name: "window",
		margins: [0, 40],
		child: Widget.Box({
			class_name: "container",
			children: commands.map(({ text, hotkey }) =>
				Widget.Box({
					class_name: "command-button",
					vertical: true,
					children: [
						Widget.Label({
							label: text,
							class_name: "icon",
						}),
						Widget.Label({
							label: `(${hotkey})`,
							class_name: "subtext",
						}),
					],
				}),
			),
		}),
	});

addToggleableWindow("Powerbar", () =>
	PromptBar([
		{ text: "", hotkey: "q" },
		{ text: "󰍃", hotkey: "l" },
		{ text: "", hotkey: "r" },
		{ text: "󰤆", hotkey: "s" },
	]),
);
addToggleableWindow("Screenshots", () =>
	PromptBar([
		{ text: "", hotkey: "s" },
		{ text: "", hotkey: "e" },
		// { text: "", hotkey: "r" },
		// { text: "", hotkey: "f" },
	]),
);
addToggleableWindow("Floaters", () =>
	PromptBar([
		{ text: "", hotkey: "w" },
		{ text: "", hotkey: "n" },
		{ text: "", hotkey: "b" },
		{ text: "", hotkey: "t" },
	]),
);
