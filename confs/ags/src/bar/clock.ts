import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import type Label from "types/widgets/label";

export const Clock = () =>
	Widget.Box({
		hpack: "end",
		children: [
			Widget.Label({
				className: "clock",
				connections: [
					[
						1000,
						(self: Label<unknown>) =>
							execAsync(["date", "+%A, %B %d %I:%M:%S %p"]).then((date) => {
								self.label = date;
							}),
					],
				],
			}),
		],
	});
