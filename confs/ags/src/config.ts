import App from 'resource:///com/github/Aylur/ags/app.js'
import { Bar } from "./bar/bar.js"
import "./launcher.js"
import "./powerbar.js"
import "./control/control.js"
import { NotificationBar } from './notifications.js'
import { monitorWatcher } from "./utils.js"
import "./style.scss"

monitorWatcher(App, [
    Bar, 
    NotificationBar,
])

export default {
    style: `${App.configDir}/style.css`,
}