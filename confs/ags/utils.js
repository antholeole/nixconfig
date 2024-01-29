import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'

import { exec } from 'resource:///com/github/Aylur/ags/utils.js'

// windowBuilders is a list of functions that take
// a monitor number and output a window
export const monitorWatcher = (app, windowBuilders) => {
    const windows = []

    const clearWindows = () => {
        while (windows.length) {
            app.removeWindow(windows.pop())
        }
    }

    const populateWindows = (monitors) => {
        for (const windowBuilder of windowBuilders) {
            for (const monitor of monitors) { 
                const window = windowBuilder(monitor.id)
                app.addWindow(window)
                windows.push(window)
            }
        }   
    }

    const refreshWindows = () => {
        clearWindows()
        populateWindows(Hyprland.monitors)
    }


    Hyprland.connect("monitor-added", refreshWindows)
    Hyprland.connect("monitor-removed", refreshWindows)


    // the inital load of ags does't have access to the 
    // hypland monitors accessor, so we need to shim it.
    const numMonitors = JSON.parse(exec("hyprctl monitors -j")).length
    const shimMonitors = []

    for (var i = 0; i < numMonitors; i++) {
        shimMonitors.push({ id: i })
    }

    populateWindows(shimMonitors)
}
