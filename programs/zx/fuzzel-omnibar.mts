import { $, argv, echo } from "zx";

const { nixChannel } = {
	nixChannel: "25.11",
};

type PromiseFunction = () => Promise<void>;

const findBrowser = async () => {
	const browserPriority = ["org.mozilla.firefox", "google-chrome"];

	const windows = await $`niri msg --json windows`.then(
		(v: { stdout: string }) => JSON.parse(v.stdout),
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
		await $`fuzzel --lines 0 --prompt "search: " --dmenu`.then(
			(v: { stdout: string }) => v.stdout.trimEnd(),
		);

	let url: string;
	if (fuzzelInput.startsWith("!nix")) {
		url = `https://search.nixos.org/packages?channel=${nixChannel}&from=0&size=50&sort=relevance&type=packages&query=${fuzzelInput.replace("!nix ", "")}`;
	} else if (fuzzelInput === "!d") {
		url = "https://draw.oleina.xyz";
	} else if (fuzzelInput.startsWith("!home")) {
		url = `https://home-manager-options.extranix.com/?query=${fuzzelInput.replace("!home ", "")}&release=release-25.05`;
	} else if (fuzzelInput.startsWith("!gh")) {
		let remainingFuzzelInput = fuzzelInput.replace("!gh ", "");
		let extensionSuffix = "";

		if (fuzzelInput.includes("e:")) {
			const extensionQuery = remainingFuzzelInput
				.split(" ")
				.find((word) => word.startsWith("e:"));

			remainingFuzzelInput = remainingFuzzelInput.replace(extensionQuery, "");
			extensionSuffix = `+path%3A*.${extensionQuery.substring(2)}`;
		}

		url = `https://github.com/search?q=%22${remainingFuzzelInput}%22${extensionSuffix}&type=code`;
	} else {
		url = `https://www.google.com/search?q=${fuzzelInput}`;
	}

	const browserId = await findBrowser();

	await Promise.all([
		$`niri msg action focus-window --id=${browserId}`,
		$({
			quote: (v: string) => v,
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
