import App from "resource:///com/github/Aylur/ags/app.js";
import { Bar } from "./bar/bar.js";
import "./launcher.js";
import "./menus.js";
import "./control/control.js";
import { NotificationBar } from "./notifications.js";
import { monitorWatcher } from "./utils.js";
import "./style.scss";

monitorWatcher(App, [Bar, NotificationBar]);

App.config({
	style: `${App.configDir}/style.css`,
});
