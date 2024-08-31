import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import type { App } from 'types/app'
import type Window from 'types/widgets/window'

// biome-ignore lint/suspicious/noExplicitAny: <explanation>
type AnyWindow = Window<any, any>

// windowBuilders is a list of functions that take
// a monitor number and output a window
export const monitorWatcher = (app: App, windowBuilders: Array<(monitorIdx: number) => AnyWindow>) => {
    const windows: AnyWindow[] = []

    const clearWindows = () => {
        while (windows.length) {
            app.removeWindow(windows.pop())
        }
    }

    const populateWindows = (monitors) => {
        if (windows.length > 0) {
            throw Error("We should always clear before population.")
        }

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
    const shimMonitors: { id: number }[] = []

    for (let i = 0; i < numMonitors; i++) {
        shimMonitors.push({ id: i })
    }

    populateWindows(shimMonitors)
}

// An emitter allows you to register callbacks that will
// be invoked by hyprland. For instance, the HJKL keys
// are all registered to emitters since they have different
// uses in different contexts.
//
// Do not create multiple emitters with the same name;
// this will overwrite the older emitters.
export const createEmitter = (name: string) => {
    const onEmitCallback: Map<string, () => void> = new Map()

    const emitter = {
        // register a callback that will be invoked when this 
        // emitter is invoked.
        register: (emit: () => void) => {
            const randId = (Math.random() + 1).toString(36).substring(7)
            onEmitCallback.set(randId, emit)
            return randId
        },

        deregister: (id: string) => {
            onEmitCallback.delete(id)
        },
    }

    globalThis[name] = () => {
        for (const [_, emit] of onEmitCallback) {
            emit();
        }
    }
    return emitter
}