import { readFile, execAsync } from 'resource:///com/github/Aylur/ags/utils.js'
import { addToggleableWindow } from './globals.js'
import App from 'resource:///com/github/Aylur/ags/app.js'

import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'



export const Launcher = (
    name,
    launcherData,
    variable
) => {
    const launcherText = Variable("")
    return Widget.Window({
        name: name,
        class_name: 'window',
        anchor: ["top", "left"],
        focusable: true,
        child: Widget.Box({
            vertical: true,
            class_name: 'container launcher',
            children: [
                Widget.Overlay({
                    child: Widget.Box({
                        class_name: 'search-container',
                    }),
                    overlays: [
                        Widget.Icon({
                            class_name: 'cat-image',
                            icon: `${App.configDir}/images/cat.png`
                        }),
                        Widget.Box({
                            class_name: "input-stack",
                            children: [
                                Widget.Label({
                                    class_name: 'search-icon',
                                    label: " :"
                                }),
                                Widget.Entry({
                                    class_name: 'input',
                                    onChange: ({ text }) => launcherText.value = text,
                                    onAccept: ({ text }) => {
                                        const selected = launcherData.filter(({ data }) => data.toLowerCase().includes(text))[0]

                                        if (selected !== undefined && selected.exec !== undefined) {
                                            execAsync(['bash', '-c', selected.exec])
                                            console.log(selected.exec)
                                        }

                                        launcherText.value = "";
                                        variable.value = false;
                                    },
                                }),
                            ]
                        })

                    ]
                }),
                Widget.Scrollable({
                    hscroll: 'never',
                    vscroll: 'always',
                    class_name: 'results',
                    child: Widget.Box({
                        vertical: true,
                        connections: [
                            [launcherText,
                                self => self.children = launcherData.filter(
                                    ({ data }) => data.toLowerCase().includes(launcherText.value)
                                ).map(({ data }, i) => Widget.Label({
                                    label: data,
                                    justification: 'left',
                                    class_name: "launcher-text" + (i === 0 ? " first" : "")
                                }))]
                        ]
                    })
                })
            ]
        })
    })
}


addToggleableWindow("Forgot", ((v) => Launcher(
    "Forgot",
    readFile(`${App.configDir}/assets/often_forgotten.md`).split("\n").map((v) => (
        { data: v }
    )),
    v
)))

addToggleableWindow("Launcher", ((v) => {
    const json = JSON.parse(readFile(`${App.configDir}/../data/launcher.json`))
    const formatted = Object.entries(json).map(([data, exec]) => ({
        data, exec
    }))

    return Launcher("Launcher", formatted, v)
}))
