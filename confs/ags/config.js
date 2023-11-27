import App from 'resource:///com/github/Aylur/ags/app.js';
import Powerbar from "./powerbar.js"
import { Bar } from "./bar.js"

const Blah = () => {
    return "asdja"
}


export default {
    style: App.configDir + "/style.css",

    windows: [
        // Powerbar(0),
        Bar(0),
        Bar(1)
    ]
}