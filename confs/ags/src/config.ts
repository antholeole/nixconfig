import App from 'resource:///com/github/Aylur/ags/app.js'
import { Bar } from "./bar/bar.js"
import "./launcher.js"
import "./powerbar.js"
import "./control/control.js"
import { NotificationBar } from './notifications.js'
import { monitorWatcher } from "./utils.js"
import "./style.scss"
import { Blah } from "./bar/omnibar/screenshare/ags-screenshare-service.js"

monitorWatcher(App, [
    Bar, 
    NotificationBar,
    Blah
])

App.config({
    style: `${App.configDir}/style.css`,
})
