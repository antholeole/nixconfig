import App from 'resource:///com/github/Aylur/ags/app.js'
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { Bar } from "./bar.js"
import "./launcher.js"
import"./powerbar.js"

let windows = [
    // always have bar 0
    Bar(0)
]

// Hyprland does not populate here so syscall instead
const monitors = JSON.parse(exec("hyprctl monitors -j"))
if (monitors.length > 1) {
    windows.push(Bar(1))
}

export default {
    style: App.configDir + "/style.css",
    windows
}