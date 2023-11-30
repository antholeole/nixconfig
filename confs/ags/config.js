import App from 'resource:///com/github/Aylur/ags/app.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Bar } from "./bar.js"
import "./powerbar.js"

let windows = [
    // always have bar 0
    Bar(0)
]

if (Hyprland.monitors.length > 1) {
    windows.push(Bar(1))
}

export default {
    style: App.configDir + "/style.css",
    windows
}