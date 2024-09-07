/// <reference types="vitest" />

import { defineConfig } from "vite";
import externalize from "vite-plugin-externalize-dependencies";
import html from "@rollup/plugin-html";
import { exec, execSync } from "node:child_process";
import { resolve } from "node:path";

// holds the child process
let process = null;
const external = (moduleName) => moduleName.includes("Aylur/ags")

export default defineConfig({
	plugins: [
		html(),
		externalize({
			externals: [
				external
			],
		}),

		{
      		name: 'postbuild-commands', // the name of your custom plugin. Could be anything.
		    closeBundle: async () => {
				// first, kill the previous ags run if it existsg
				const configPath = resolve(__dirname, "dist/config.js");
				const busName = "devags";

				if (process !== null) {
					execSync(`ags -b ${busName} --quit`)
				}

				process = exec(`ags -c ${configPath} -b ${busName}`)
		    }
    },
	],

	root: "./",
	test: {

	},
	build: {
		lib: {
			entry: resolve(__dirname, 'lib/main.js'),
			name: "oleinags",
			fileName: "config"
		},

		outDir: "dist",
		minify: false,
		rollupOptions: {
			output: {
				globals: (id) => {
					const name = id.split("/").at(-1).split(".").at(0)
					return name
				},
			},
			external,
			input: "src/config.ts",
			plugins: [html()]
		},
	},
});
