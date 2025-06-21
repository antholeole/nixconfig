import { $, argv, echo } from "zx";

type PromiseFunction = () => Promise<void>;

const onSearch = async () => {
	const fuzzelInput: string =
		await $`fuzzel --lines 0 --prompt "search: " --dmenu`.then((v) => v.stdout);

	let url: string;
	if (fuzzelInput.startsWith("!nix ")) {
		url = `https://search.nixos.org/packages?channel=25.05&from=0&size=50&sort=relevance&type=packages&query=${fuzzelInput.replace("!nix ", "")}`;
	} else {
		url = `https://www.google.com/search?q=${fuzzelInput}`;
	}

	const windows = await $`niri msg --json windows`.then((v) =>
		JSON.parse(v.stdout),
	);
	const chromeId = windows.find(
		(w: { app_id: string }) => w.app_id === "google-chrome",
	).id;

	await Promise.all([
		$`niri msg action focus-window --id=${chromeId}`,
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
