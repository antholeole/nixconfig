import { $, argv, echo } from "zx";

const { nixChannel } = {
	nixChannel: "25.05",
};

type PromiseFunction = () => Promise<void>;

const findBrowser = async () => {
	const browserPriority = ["org.mozilla.firefox", "google-chrome"];

	const windows = await $`niri msg --json windows`.then((v) =>
		JSON.parse(v.stdout),
	);

	const browsers = new Map(
		windows
			.map((w: { app_id: string; id: string }) =>
				browserPriority.includes(w.app_id) ? [w.app_id, w.id] : undefined,
			)
			.filter((v: unknown) => v),
	);

	for (const browser of browserPriority) {
		if (browsers.has(browser)) {
			return browsers.get(browser);
		}
	}
};

const onSearch = async () => {
	const fuzzelInput: string =
		await $`fuzzel --lines 0 --prompt "search: " --dmenu`.then((v) =>
			v.stdout.trimEnd(),
		);

	let url: string;
	if (fuzzelInput.startsWith("!nix ")) {
		url = `https://search.nixos.org/packages?channel=${nixChannel}&from=0&size=50&sort=relevance&type=packages&query=${fuzzelInput.replace("!nix ", "")}`;
	} else if (fuzzelInput === "!d") {
		url = "https://draw.oleina.xyz";
	} else {
		url = `https://www.google.com/search?q=${fuzzelInput}`;
	}

	const browserId = await findBrowser();

	await Promise.all([
		$`niri msg action focus-window --id=${browserId}`,
		$({
			quote: (v) => v,
		})`xdg-open "${url}"`,
	]);
};

const processFunctions: Record<string, PromiseFunction> = {
	search: onSearch,
};

const fn =
	processFunctions[argv.command] ??
	(async () => {
		echo("other");
	});

await fn();
