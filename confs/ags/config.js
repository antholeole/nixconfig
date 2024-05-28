import App from 'resource:///com/github/Aylur/ags/app.js'
import { Bar } from "./bar/bar.js"
import { Control } from "./control/control.js"
import "./launcher.js"
import "./powerbar.js"
import { NotificationBar } from './notifications.js'

import { monitorWatcher } from "./utils.js"

monitorWatcher(App, [
    Bar, 
    NotificationBar,
    Control
])

export default {
    style: App.configDir + "/style.css",
}