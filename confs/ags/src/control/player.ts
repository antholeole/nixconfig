import { mpris } from "resource:///com/github/Aylur/ags/service/mpris.js";
import type { ControlElement } from "./control";
import type { Variable as VarT } from "types/variable.js";
import type { MprisPlayer } from "types/service/mpris";

const filterPlayer = (players: MprisPlayer[]) => {
	const player = players.filter((player) => player.name === "mpd");
	if (player.length === 0) {
		return null;
	}

	return player[0];
};

const buildPlayer = (selected: VarT<boolean>, player: MprisPlayer) => {
	const buildLabelClass = selected
		.bind()
		.as((selected) => (selected ? "text" : "text faded"));

	return Widget.Box({
		className: "mpd",
		hexpand: true,
		vertical: true,
		children: [
			Widget.Box({ className: "divider" }),
			Widget.Label({
				truncate: 'end',
				maxWidthChars: 24,
				className: selected.bind().as((s) => (s ? "bold" : "faded")),
				label: player.bind("track_title"),
			}),
			Widget.CenterBox({
				startWidget: Widget.Label({
					className: buildLabelClass,
					label: "󰒮",
				}),
				centerWidget: Widget.Label({
					className: buildLabelClass,
					label: player.bind("play_back_status").as((p) => {
						if (p === "Paused") {
							return "󰏤";
						}

						return "󰐊";
					}),
				}),
				endWidget: Widget.Label({
					className: buildLabelClass,
					label: "󰒭",
				}),
			}),
		],
	});
};

const setupPlayer = async () => {
	let commands = [
		Utils.execAsync("mpc single off"),
		Utils.execAsync("mpc consume off"),
		Utils.execAsync("mpc shuffle"),
	];

	if ((await Utils.execAsync("mpc playlist")).split("\n").length < 2) {
		const allSongs = (await Utils.execAsync("mpc listall")).split("\n");
		commands = [
			...commands,
			...allSongs.map((song) => Utils.execAsync(`mpc add "${song}"`)),
		];
	}

	await Promise.all(commands);
};

const doIfMpdPlayer = (cb: (p: MprisPlayer) => void) => {
	const player = filterPlayer(mpris.players);
	if (player === null) return;
	cb(player);
};

export const player: ControlElement = {
	name: "player",
	build: (selected) =>
		Widget.Box({
			children: mpris.bind("players").as((players) => {
				const p = filterPlayer(players);
				if (p === null) {
					return [];
				}

				return [buildPlayer(selected, p)];
			}),
		}),
	onSetup: setupPlayer,

	onSpace: () =>
		doIfMpdPlayer((p) => {
			p.playPause();
		}),
	onDecrement: () =>
		doIfMpdPlayer((p) => {
			p.previous();
		}),
	onIncrement: () =>
		doIfMpdPlayer((p) => {
			p.next();
		}),
};
