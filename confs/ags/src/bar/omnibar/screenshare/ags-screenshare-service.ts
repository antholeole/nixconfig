import { type PwAction, ScreenshareService } from "./screenshare-service";
import { Box } from "resource:///com/github/Aylur/ags/widget.js";

export const Blah = (monitor: number) =>
	Widget.Window({
		monitor,
		name: `blah-${monitor}`,
		child: Box({}).hook(screenshareService, () => {
			console.log(
				`name: ${screenshareService.active?.name} state: ${screenshareService.active?.state}`,
			);
		}),
	});

export class AgsScreenshareService extends Service {
	private service: ScreenshareService;
	private prevActive: null | PwAction;

	static {
		Service.register(
			// biome-ignore lint/complexity/noThisInStatic: docs say do it like this
			this,
			{},
			{
				"recording-state": ["boolean"],
				"recording-name": ["string"],
			},
		);
	}

	constructor() {
		super();

		this.service = new ScreenshareService();
		this.prevActive = null;
		Utils.subprocess("pw-mon", (s) => this.service.parseLine(s));

		// update if changed on an interval.
		setInterval(() => this.notifyIfChanged(), 5 * 100);
	}

	get recording_state() {
		return this.recording_state !== null;
	}

	get recording_name() {
		if (this.prevActive !== null) {
			return this.prevActive.name;
		}

		return null;
	}

	get active() {
		return this.prevActive;
	}

	notifyIfChanged() {
		const running = this.service.getRunning();
		if (running.length < 1) {
			if (this.prevActive != null) {
				this.prevActive = null;
				this.emit("changed");
				return;
			}

			return;
		}

		const firstRunning = running[0];
		if (this.prevActive === null) {
			this.prevActive = firstRunning;
			this.emit("changed");
			return;
		}

		if (this.prevActive.id === firstRunning.id) {
			return;
		}

		this.prevActive = firstRunning;
		this.changed("recording-state");
	}
}

export const screenshareService = new AgsScreenshareService();
