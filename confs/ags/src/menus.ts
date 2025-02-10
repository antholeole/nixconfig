import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { addToggleableWindow } from "./globals.js";

interface Command {

	
	text: string;
	hotkey: string;
}

const PromptBar = (name: string, commands: Command[]) =>
	Widget.Window({
		name,
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
	PromptBar("Powerbar", [
		{ text: "", hotkey: "q" },
		{ text: "󰍃", hotkey: "l" },
		{ text: "", hotkey: "r" },
		{ text: "󰤆", hotkey: "s" },
	]),
);
addToggleableWindow("Screenshots", () =>
	PromptBar("Screenshots", [
		{ text: "", hotkey: "s" },
		{ text: "", hotkey: "e" },
		// { text: "", hotkey: "r" },
		// { text: "", hotkey: "f" },
	]),
);
addToggleableWindow("Floaters", () =>
	PromptBar("Floaters", [
		{ text: "", hotkey: "w" },
		{ text: "", hotkey: "n" },
		{ text: "", hotkey: "b" },
		{ text: "", hotkey: "t" },
	]),
);
