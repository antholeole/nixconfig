import { readFile, exec } from "resource:///com/github/Aylur/ags/utils.js";
import { addToggleableWindow } from "./globals.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import type { Variable as VarT } from "types/variable.js";
import type { Connectable } from "types/service.js";

type LauncherData = {
	data: string;
	exec?: string;
};

const filterInput = (launcherData: string[], launcherText: string) => {
	const out = exec(
		`bash -c 'echo "${launcherData.join(
			"\n",
		)}" | fzf --filter "${launcherText}"'`,
	);
	return out.split("\n");
};

export const Launcher = (
	name: string,
	launcherData: LauncherData[],
	show: VarT<boolean>,
	launchText: string,
) => {
	const launcherText = Variable("");

	const label = Widget.Box({
		class_name: "label",
		child: Widget.Label(launchText),
	});

	const entry = Widget.Entry({
		hexpand: true,
		class_name: "input",
		onChange: ({ text }) => {
			launcherText.value = text;
		},
		onAccept: ({ text }) => {
			const selectedKey = filterInput(
				launcherData.map((v) => v.data),
				text,
			)[0];

			if (selectedKey === undefined) {
				launcherText.value = "";
				show.value = false;
				return;
			}

			const toExec = launcherData.filter((v) => v.data === selectedKey)[0].exec;
			if (toExec !== undefined) {
				const command = `hyprctl dispatch -- exec "${toExec}"`;
				exec(command);
			}

			launcherText.value = "";
			show.value = false;
		},
	}).hook(show as unknown as Connectable, (self) => {
		if (!show.value) {
			(self as unknown as { text: string }).text = "";
		}
	});

	const searchResults = Widget.Scrollable({
		hscroll: "never",
		vscroll: "always",
		class_name: "results",
		child: Widget.Box({
			vertical: true,
		}).hook(launcherText as unknown as Connectable, (self) => {
			self.children = filterInput(
				launcherData.map((v) => v.data),
				launcherText.value,
			).map((data, i) =>
				Widget.Box({
					children: [
						Widget.Label({
							justification: "left",
							xalign: 0,
							label: ` ${data}`,
						}),
					],
					class_name: `launcher-text${i === 0 ? " first" : ""}`,
				}),
			);
		}),
	});

	return Widget.Window({
		name: name,
		class_name: "window",
		anchor: ["top", "left"],
		keymode: import.meta.env.MODE === "dev" ? "none" : "exclusive",
		child: Widget.Box({
			class_name: "container launcher",
			children: [
				Widget.Box({
					children: [
						Widget.Box({
							vertical: true,
							hpack: "start",
							children: [label, Widget.Box({ hexpand: true })],
						}),
						Widget.Box({
							hpack: "fill",
							hexpand: true,
							vertical: true,
							children: [entry, searchResults],
						}),
					],
				}),
			],
		}),
	});
};

addToggleableWindow("Forgot", (v) =>
	Launcher(
		"Forgot",
		readFile(`${App.configDir}/assets/often_forgotten.md`)
			.split("\n")
			.map((v) => ({ data: v })),
		v,
		"remind",
	),
);

addToggleableWindow("Launcher", (v) => {
	const json = JSON.parse(readFile("/home/oleina/.config/data/launcher.json"));
	const formatted = Object.entries(json).map(([data, exec]) => ({
		data,
		exec: exec as string,
	}));

	return Launcher("Launcher", formatted, v, "run");
});
