import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import App from 'resource:///com/github/Aylur/ags/app.js'
import {createEmitter} from "./utils.js"

export const altDown = Variable(false)
globalThis.altDown = altDown

export const addToggleableWindow = (windowName, windowBuilder, defaultOn = false) => {
    showWindow = Variable(false)
    globalThis[`show${windowName}`] = showWindow
    let window = defaultOn ? windowBuilder(showWindow) : undefined
    showWindow.connect('changed', ({ value }) => {
        if (value) {
            if (window === undefined) {
                window = windowBuilder(showWindow)
                App.addWindow(window)
            } else {
                App.openWindow(window.name)
            }
        } else if (window !== undefined) {
            App.closeWindow(window.name)
        }
    })

    return showWindow
}

export const counter = {
    variable: "hi"
}

export const leftEmitter = createEmitter("left")
export const rightEmitter = createEmitter("right")
export const upEmitter = createEmitter("up")
export const downEmitter = createEmitter("down")
