import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { altDown } from "../globals.js";
import { exec } from "resource:///com/github/Aylur/ags/utils.js";
import Hyprland, {
	hyprland,
} from "resource:///com/github/Aylur/ags/service/hyprland.js";
import type Box from "types/widgets/box.js";
import type { Workspace } from "types/service/hyprland.js";
import type { Connectable } from "types/service.js";

// a shim type for workspace or monitors with an id
type Id = {
	id: number;
};

const buildWsColor = (clazz: string | undefined) => {
	switch (clazz) {
		case "Alacritty":
			return "orange";
		case "org.qutebrowser.qutebrowser":
			return "yellow";
		case "google-chrome":
			return "pink";
		case "code-url-handler":
			return "blue";
	}

	return "plain";
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

	const buildClassName = (workspace: Workspace) => {
		const classPrefix = altIsDown ? "ws-text" : "dot";
		const classSuffix = active(workspace) ? "selected" : "not-selected";

		const client = Hyprland.clients.find(
			(client) => client.workspace.id === workspace.id,
		)?.class;

		const clazz = `${classPrefix} ${classSuffix} ws-item ${buildWsColor(client)}`;
		return clazz;
	};

	const workspaceDots = workspaces
		.filter((ws) => !ws.name.includes("notestab"))
		.map((workspace) => {
			return Widget.Box({
				className: buildClassName(workspace),
				children: altIsDown
					? [
							Widget.Label({
								label: `${workspace.id}`,
							}),
						]
					: [],
			});
		});

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
		setup: (self) =>
			self.hook(altDown, () => {
				self.children = buildWorkspacesChildren(altDown.value, monitor);
			}),
	})
		.hook(hyprland as unknown as Connectable, (self: Box<unknown, unknown>) => {
			self.children = buildWorkspacesChildren(altDown.value, monitor);
		})
