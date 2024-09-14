/// <reference types="vitest" />

import { defineConfig } from "vite";
import externalize from "vite-plugin-externalize-dependencies";
import html from "@rollup/plugin-html";
import { exec, execSync, spawn } from "node:child_process";
import { resolve } from "node:path";

// holds the child process
let process = null;
const external = (moduleName) => moduleName.includes("Aylur/ags");

export default defineConfig((mode) => ({
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

					if (process !== null) {
						execSync(`ags -b ${busName} --quit`);
					}

					process = spawn("ags", ["-c", configPath, "-b", busName]);
					process.stderr.on("data", (data) => {
						console.log(`ags: ${data.toString()}`);
					});
				}
			},
		},
	],

	root: "./",

	test: {
		alias: {
      		'@/': `${__dirname}/src/`,
	    }
	},

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
}));
