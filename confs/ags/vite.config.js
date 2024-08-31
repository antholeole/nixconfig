import { defineConfig } from "vite";
import externalize from "vite-plugin-externalize-dependencies";

export default defineConfig({
	plugins: [
		externalize({
			externals: [
				(moduleName) => moduleName.includes("ags"), // Externalize all modules containing "external",
			],
		}),
	],
	build: {
		outDir: "dist/",
		rollupOptions: {
			input: "src/config.js",
		},
	},
});
