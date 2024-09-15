// there are a ton of other properties, but this is all we care about

const validStates = [
	"negotiating",
	"running",
	"idle",
	"suspended",
	"active",
	"paused",
] as const;
export interface PwAction {
	name: string;
	state: (typeof validStates)[number] | string;
	id: string;
}

// some elements won't stop yapping
const ignoreKeys = ["alsa", "xdg-desktop-portal-wlr"];

// todo enable pw-mon
export class ScreenshareService {
	private inStructId: string | null = null;
	private knownActions: Map<string, PwAction> = new Map();

	getRunning(): PwAction[] {
		const ret: PwAction[] = [];

		other: for (const action of this.knownActions.values()) {
			// not fully built yet, leave
			if (
				action.name === undefined ||
				action.id === undefined ||
				action.state === undefined
			) {
				continue;
			}

			for (const ignore of ignoreKeys) {
				if (action.name.includes(ignore)) {
					continue other;
				}
			}

			if (action.state === "running" && !ignoreKeys.includes(action.name)) {
				ret.push(action);
			}
		}
		return ret;
	}

	debugDump() {
		if (this.knownActions.size === 0) {
			console.log("no known actions!");
		}

		for (const [name, action] of this.knownActions.entries()) {
			console.log(`${name}: ${JSON.stringify(action)}`);
		}
	}

	parseLine(rawLine: string) {
		let line = rawLine;
		if (rawLine.startsWith("*")) {
			line = rawLine.substring(1);
			line.trim();
		}

		// importantly, the global ID has a couple spaces suffixing it. There
		// are other fields that start with the same prefix that do not.
		const idPrefix = "id: ";
		if (line.startsWith(idPrefix)) {
			this.inStructId = line.replace(idPrefix, "");
			return;
		}

		const updateField = (v: (a: PwAction) => PwAction) => {
			const id = this.inStructId;
			if (id === null) {
				throw Error(`got instructId === null but got line: ${line}`);
			}

			const oldOrDefaultAction = this.knownActions.get(id) ?? {
				id,
				name: "<unknown>",
				state: "idle",
			};

			this.knownActions.set(id, v(oldOrDefaultAction));
		};

		const statePrefix = "state: ";
		if (line.includes(statePrefix)) {
			const state = line
				.replace(statePrefix, "")
				.replace("*", "")
				.replaceAll('"', "")
				.trim();

			if (!(validStates as unknown as string[]).includes(state)) {
				throw Error(`got unknown state ${state}`);
			}

			updateField((a) => ({ ...a, state }));
			return;
		}

		const namePrefix = 'node.name = "';
		if (line.startsWith(namePrefix)) {
			const name = line.replace(namePrefix, "").replace('"', "");

			updateField((a) => ({ ...a, name }));
			return;
		}
	}
}
