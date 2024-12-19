/// <reference types="vitest" />

import { defineConfig, loadEnv } from "vite";
import externalize from "vite-plugin-externalize-dependencies";
import html from "@rollup/plugin-html";
import { exec, execSync, spawn } from "node:child_process";
import { resolve, join } from "node:path";
import { readFileSync } from "node:fs";

// holds the child process
let agsPs = null;
const external = (moduleName) => moduleName.includes("Aylur/ags");

export default defineConfig((mode) => {
	const env = loadEnv(mode, process.cwd(), "");
	console.log(env.COLOR_SCHEME_PATH);
	const colors = readFileSync(env.COLOR_SCHEME_PATH).toString();

	return {
		plugins: [
			html(),
			externalize({
				externals: [external],
			}),

			{
				name: "postbuild-commands",
				closeBundle: async () => {
					if (mode.mode === "dev") {
						// first, kill the previous ags run if it exists
						const configPath = resolve(__dirname, "dist/config.js");
						const busName = "devags";

						if (agsPs !== null) {
							execSync(`ags -b ${busName} --quit`);
						}

						agsPs = spawn("ags", ["-c", configPath, "-b", busName]);
						agsPs.stderr.on("data", (data) => {
							console.log(`ags: ${data.toString()}`);
						});
					}
				},
			},
		],

		css: {
			preprocessorOptions: {
				scss: {
					additionalData: colors,
				},
			},
		},

		root: "./",
		test: {},
		build: {
			lib: {
				entry: resolve(__dirname, "lib/main.js"),
				name: "oleinags",
				fileName: "config",
			},

			outDir: "dist",
			minify: false,
			rollupOptions: {
				output: {
					globals: (id) => {
						const name = id.split("/").at(-1).split(".").at(0);
						return name;
					},
				},
				external,
				input: "src/config.ts",
				plugins: [html()],
			},
		},
	};
});
