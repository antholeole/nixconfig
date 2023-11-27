import App from 'resource:///com/github/Aylur/ags/app.js';
import Powerbar from "./powerbar.js"
import Bar from "./bar.js"


export default {
    style: App.configDir + "/style.css",
    windows: [
        Powerbar(0),
        Bar(0)
    ]
}