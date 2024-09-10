import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { altDown } from "../globals.js";
import { exec } from "resource:///com/github/Aylur/ags/utils.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import type Box from "types/widgets/box.js";

// a shim type for workspace or monitors with an id
type Id = {
	id: number;
};

const buildWorkspacesChildren = (altIsDown: boolean, monitor: number) => {
	// This is more consistent than the builtin :()
	const thisMonitor = JSON.parse(exec("hyprctl monitors -j")).find(
		(hMonitor: { id: number }) => hMonitor.id === monitor,
	);

	const workspaces = Hyprland.workspaces
		.filter((workspace) => workspace.monitor === thisMonitor.name)
		.sort((a, b) => a.id - b.id);
	const active = (workspace: Id) =>
		thisMonitor.activeWorkspace.id === workspace.id &&
		Hyprland.active.monitor.name === thisMonitor.name;

	const buildClassName = (workspace: Id) => {
		const classPrefix = altIsDown ? "ws-text" : "dot";
		const classSuffix = active(workspace) ? "selected" : "not-selected";
		return `${classPrefix}-${classSuffix}`;
	};

	const workspaceDots = workspaces.map((workspace) =>
		Widget.Box({
			className: buildClassName(workspace),
			children: altIsDown
				? [
						Widget.Label({
							label: `${workspace.id}`,
						}),
					]
				: [],
		}),
	);

	return [
		...workspaceDots,
		Widget.Label({
			className: "active-workspace-text",
			label: `${thisMonitor.activeWorkspace.id}`,
		}),
	];
};

export const Workspaces = (monitor: number) =>
	Widget.Box({
		className: "workspaces",
		connections: [
			[
				Hyprland.active.workspace,
				(self: Box<unknown, unknown>) => {
					self.children = buildWorkspacesChildren(altDown.value, monitor);
				},
			],
			[
				altDown,
				(self: Box<unknown, unknown>) => {
					self.children = buildWorkspacesChildren(altDown.value, monitor);
				},
			],
		],
	});
