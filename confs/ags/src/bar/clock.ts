import Widget from "resource:///com/github/Aylur/ags/widget.js";

const time = Variable<string>("", {
	poll: [1000, "date '+%A, %B %d %I:%M:%S %p'"],
});

export const Clock = () => {
	return Widget.Box({
		hpack: "end",
		children: [
			Widget.Label({
				className: "clock",
			}).hook(time, (self) => {
				self.label = time.value;
			}),
		],
	});
};
