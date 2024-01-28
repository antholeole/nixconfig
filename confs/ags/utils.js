import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'

import { exec } from 'resource:///com/github/Aylur/ags/utils.js'

// windowBuilders is a list of functions that take
// a monitor number and output a window
export const monitorWatcher = (app, windowBuilders) => {
    // map of shape windowBuildersIndex => [monitor 1 window, monitor 2 window...]
    const windows = new Map()

    for (var i = 0; i < windowBuilders.length; i++) {
        windows.set(i, [])
    }
    
    const addMonitor = (monitorIndex) => {
        windowBuilders.map((builder, widgetIndex) => {
            const window = builder(monitorIndex)
            app.addWindow(window)
            
            windows.get(widgetIndex)[monitorIndex - 1] = window
        })
    }

    const removeMonitor = (monitorIndex) => {
        windowBuilders.map((_, widgetIndex) => {
            const window = windows.get(widgetIndex)[monitorIndex - 1]
            app.reomveWindow(window)

            // remove it so that we can just construct a new one later.
            windows.get(widgetIndex)[monitorIndex - 1] = undefined
        })
    }


    // the inital load of ags does't have access to the 
    // hypland monitors accessor.
    //
    // Note that this is the number of monitors we have,
    // not the latest monitorIndex.
    var numMonitors = JSON.parse(exec("hyprctl monitors -j")).length

    const onMonitorAdded = () => {
        addMonitor(numMonitors)
        numMonitors++
    }

    const onMonitorRemoved = () => {
        numMonitohyplandrs--
        removeMonitor(numMonitors)
    }


    Hyprland.connect("monitor-added", onMonitorAdded)
    Hyprland.connect("monitor-removed", onMonitorRemoved)

    // on the inital load, we should catch the world up to speed.
    for (var i = 0; i < numMonitors; i++) {
        addMonitor(i)
    }
}
