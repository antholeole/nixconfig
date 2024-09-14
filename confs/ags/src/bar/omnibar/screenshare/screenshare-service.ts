import { Box } from "resource:///com/github/Aylur/ags/widget.js";
import { i } from "vite/dist/node/types.d-aGj9QkWt";

// there are a ton of other properties, but this is all we care about
interface PwAction {
	name: string;
	state: "running" | "idle";
	id: string;
}


export const Blah = (monitor: number) =>
	Widget.Window({
		monitor,
		name: `blah-${monitor}`,
		child: Box({}),
		// .hook(pwProc, () => {
		//     console.log("hi from hook1")

		// })
	});


// todo enable pw-mon
export class ScreenshareService {
	private inStructId: string | null = null;
	private knownActions: Map<string, PwAction> = new Map();

    getRunning(): PwAction | null {
        for (const action of this.knownActions.values()) {
            if (action.state === "running") {
                return action
            }
        }

        return null;
    }

    debugDump() {
        if (this.knownActions.size === 0) {
            console.log("no known actions!")
        }

        for (const [name, action] of this.knownActions.entries()) {
            console.log(`${name}: ${JSON.stringify(action)}`)
        }
    }

	parseLine(line: string) {
		const idPrefix = "        id: ";
		if (line.startsWith(idPrefix)) {
			this.inStructId = line.replace(idPrefix, "");
			return;
		}

		const updateField = (v: (a: PwAction) => PwAction) => {
			const id = this.inStructId;
			if (id === null) {
				throw Error(`got instructId === null but got line: ${line}`);
			}

			const oldOrDefaultAction = this.knownActions.get(idPrefix) ?? {
				id,
				name: "<unknown>",
				state: "idle",
			};

			this.knownActions[id] = v(oldOrDefaultAction);
		};

		const statePrefix = "       state: ";
		if (line.includes(statePrefix)) {
			const state = line
				.replace(statePrefix, "")
				.replace("*", "")
				.replaceAll('"', "");

			if (state !== "idle" && state !== "running") {
				throw Error(`got unknown state ${state}`);
			}

			updateField((a) => ({ ...a, state }));
            return;
		}

		const namePrefix = '                node.name = "';
		if (line.startsWith(namePrefix)) {
			const name = line.replace(namePrefix, "").replace('"', "");

			updateField((a) => ({ ...a, name }));
            return;
		}
	}
}
