import { argv, fs, echo, chalk, $, cd, syncProcessCwd } from "zx";
import { spawn } from "node:child_process";

syncProcessCwd(true);
const spawnPwd = await $`pwd`;

let deep = false;
if (argv.deep) {
	deep = true;
}

let keep = false;
if (argv.keep) {
	keep = true;
}

const [username, repo, branch = "main"] = argv._;

if (!username || !repo) {
	echo`Usage: ${chalk.bold("ghbrowse [--keep] [--deep] <username> <repository> [branch]")}`;
	process.exit(1);
}

const githubUrl = `https://github.com/${username}/${repo}.git`;
const tempDir = await $`mktemp -d`;

const gitCloneArgs = ["clone"];
if (!deep) {
	gitCloneArgs.push("--depth=1");
}

gitCloneArgs.push("--branch", branch, githubUrl, tempDir.stdout.trim());

try {
	await $({
		quote: (s) => s,
	})`git ${gitCloneArgs}`;
} catch (error) {
	echo(chalk.red("Failed to clone the repository."));
	await fs.remove(tempDir.stdout.trim());
	process.exit(1);
}

cd(tempDir.stdout.trim());
echo`opening editor...`;

const editor = spawn(process.env.EDITOR || "hx", ["."], {
	stdio: "inherit",
	detached: true,
});

editor.on("error", (err) => {
	console.error("Failed to start editor:");
	console.error(err);
});

editor.on("data", (data) => {
	process.stdout.pipe(data);
});

await new Promise((resolve) => {
	editor.on("close", resolve);
});

if (keep) {
	echo`--keep flag passed, not deleting.`;
} else {
	cd(spawnPwd);
	await fs.remove(tempDir.stdout.trim());
}
