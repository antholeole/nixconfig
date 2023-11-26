import App from 'resource:///com/github/Aylur/ags/app.js';
import Powerbar from "./powerbar.js"

export default {
    style: App.configDir + "/style.css",
    windows: [
        Powerbar(0)
    ]
}