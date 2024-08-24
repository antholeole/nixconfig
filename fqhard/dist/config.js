import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import { execAsync, exec, readFile } from "resource:///com/github/Aylur/ags/utils.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
const BatteryBar = (battery = Battery) => Widget.Box({
  connections: [[battery, (self) => {
    const children = [];
    if (battery.percent < 80) {
      children.push(Widget.Label({
        class_name: "battery-label",
        label: `${battery.percent.toString()}%`
      }));
    }
    const batteries = [
      [99, "󰁹"],
      [90, "󰂂"],
      [80, "󰂁"],
      [70, "󰂀"],
      [60, "󰁿"],
      [50, "󰁾"],
      [40, "󰁽"],
      [30, "󰁼"],
      [20, "󰁻"],
      [10, "󰁺"],
      [0, "󱃍"]
    ];
    let selectedIcon = "";
    if (battery.charging) {
      selectedIcon = "󰂄";
    } else {
      for (const [percent, icon] of batteries) {
        if (battery.percent >= percent) {
          selectedIcon = icon;
          break;
        }
      }
    }
    children.push(Widget.Label({
      class_name: "battery-icon",
      label: selectedIcon
    }));
    self.children = children;
  }]]
});
const Clock = () => Widget.Box({
  hpack: "end",
  children: [
    Widget.Label({
      className: "clock",
      connections: [
        [
          1e3,
          (self) => execAsync(["date", "+%A, %B %d %I:%M:%S %p"]).then((date) => {
            self.label = date;
          })
        ]
      ]
    })
  ]
});
const monitorWatcher = (app, windowBuilders) => {
  const windows = [];
  const clearWindows = () => {
    while (windows.length) {
      app.removeWindow(windows.pop());
    }
  };
  const populateWindows = (monitors) => {
    if (windows.length > 0) {
      throw Error("We should always clear before population.");
    }
    for (const windowBuilder of windowBuilders) {
      for (const monitor of monitors) {
        const window = windowBuilder(monitor.id);
        app.addWindow(window);
        windows.push(window);
      }
    }
  };
  const refreshWindows = () => {
    clearWindows();
    populateWindows(Hyprland.monitors);
  };
  Hyprland.connect("monitor-added", refreshWindows);
  Hyprland.connect("monitor-removed", refreshWindows);
  const numMonitors = JSON.parse(exec("hyprctl monitors -j")).length;
  const shimMonitors = [];
  for (let i = 0; i < numMonitors; i++) {
    shimMonitors.push({ id: i });
  }
  populateWindows(shimMonitors);
};
const createEmitter = (name) => {
  const onEmitCallback = /* @__PURE__ */ new Map();
  const emitter = {
    // register a callback that will be invoked when this 
    // emitter is invoked.
    register: (emit) => {
      const randId = (Math.random() + 1).toString(36).substring(7);
      onEmitCallback.set(randId, emit);
      return randId;
    },
    deregister: (id) => {
      onEmitCallback.delete(id);
    }
  };
  globalThis[name] = () => {
    for (const [_, emit] of onEmitCallback) {
      emit();
    }
  };
  return emitter;
};
const altDown = Variable(false);
globalThis.altDown = altDown;
const addToggleableWindow = (windowName, windowBuilder, defaultOn = false) => {
  const showWindow = Variable(false);
  globalThis[`show${windowName}`] = showWindow;
  let window = defaultOn ? windowBuilder(showWindow) : void 0;
  showWindow.connect("changed", ({ value }) => {
    if (value) {
      if (window === void 0) {
        window = windowBuilder(showWindow);
        App.addWindow(window);
      } else {
        App.openWindow(window.name);
      }
    } else if (window !== void 0) {
      App.closeWindow(window.name);
    }
  });
  return showWindow;
};
createEmitter("left");
createEmitter("right");
const upEmitter = createEmitter("up");
const downEmitter = createEmitter("down");
const buildWorkspacesChildren = (altIsDown, monitor) => {
  const thisMonitor = JSON.parse(exec("hyprctl monitors -j")).find(
    (hMonitor) => hMonitor.id === monitor
  );
  const workspaces = Hyprland.workspaces.filter((workspace) => workspace.monitor === thisMonitor.name).sort((a, b) => a.id - b.id);
  const active = (workspace) => thisMonitor.activeWorkspace.id === workspace.id && Hyprland.active.monitor === thisMonitor.name;
  const buildClassName = (workspace) => {
    const classPrefix = altIsDown ? "ws-text" : "dot";
    const classSuffix = active(workspace) ? "selected" : "not-selected";
    return `${classPrefix}-${classSuffix}`;
  };
  const workspaceDots = workspaces.map(
    (workspace) => Widget.Box({
      className: buildClassName(workspace),
      children: altIsDown ? [
        Widget.Label({
          label: `${workspace.id}`
        })
      ] : []
    })
  );
  return [
    ...workspaceDots,
    Widget.Label({
      className: "active-workspace-text",
      label: `${thisMonitor.activeWorkspace.id}`
    })
  ];
};
const Workspaces = (monitor) => Widget.Box({
  className: "workspaces",
  connections: [
    [
      Hyprland.active.workspace,
      (self) => {
        self.children = buildWorkspacesChildren(altDown.value, monitor);
      }
    ],
    [
      altDown,
      (self) => {
        self.children = buildWorkspacesChildren(altDown.value, monitor);
      }
    ]
  ]
});
const NetworkIndicator = () => Widget.Box({
  class_name: "bar-section network-indicator",
  connections: [[Network, (self) => {
    const mkWidget = (status, icon) => Widget.Box({
      class_name: `chip network-indicator ${status}`,
      children: [Widget.Label({
        label: icon
      })]
    });
    if (Network.connectivity === "none") {
      self.children = [
        mkWidget("error", "󰤫")
      ];
    } else {
      self.children = [];
    }
  }]]
});
const Bar = (monitor) => Widget.Window({
  name: `bar-${monitor}`,
  monitor,
  anchor: ["top", "left", "right"],
  exclusivity: "exclusive",
  child: Widget.CenterBox({
    className: "bar",
    startWidget: Workspaces(monitor),
    endWidget: Widget.Box({
      hpack: "end",
      children: [
        NetworkIndicator(),
        BatteryBar(),
        Clock()
      ]
    })
  })
});
const filterInput = (launcherData, launcherText) => {
  const out = exec(
    `bash -c 'echo "${launcherData.join(
      "\n"
    )}" | fzf --filter "${launcherText}"'`
  );
  return out.split("\n");
};
const Launcher = (name, launcherData, show) => {
  const launcherText = Variable("");
  return Widget.Window({
    name,
    class_name: "window",
    anchor: ["top", "left"],
    focusable: true,
    child: Widget.Box({
      vertical: true,
      class_name: "container launcher",
      children: [
        Widget.Overlay({
          child: Widget.Box({
            class_name: "search-container"
          }),
          overlays: [
            Widget.Icon({
              class_name: "cat-image",
              icon: `${App.configDir}/images/cat.png`
            }),
            Widget.Box({
              class_name: "input-stack",
              children: [
                Widget.Label({
                  class_name: "search-icon",
                  label: " :"
                }),
                Widget.Entry({
                  class_name: "input",
                  onChange: ({ text }) => {
                    launcherText.value = text;
                  },
                  onAccept: ({ text }) => {
                    const selectedKey = filterInput(
                      launcherData.map((v) => v.data),
                      text
                    )[0];
                    if (selectedKey === void 0) {
                      launcherText.value = "";
                      show.value = false;
                      return;
                    }
                    const toExec = launcherData.filter(
                      (v) => v.data === selectedKey
                    )[0].exec;
                    if (toExec !== void 0) {
                      const command = `hyprctl dispatch -- exec "${toExec}"`;
                      exec(command);
                    }
                    launcherText.value = "";
                    show.value = false;
                  },
                  connections: [
                    [
                      show,
                      (self) => {
                        if (!show.value) {
                          self.text = "";
                        }
                      }
                    ]
                  ]
                })
              ]
            })
          ]
        }),
        Widget.Scrollable({
          hscroll: "never",
          vscroll: "always",
          class_name: "results",
          child: Widget.Box({
            vertical: true,
            connections: [
              [
                launcherText,
                (self) => {
                  self.children = filterInput(
                    launcherData.map((v) => v.data),
                    launcherText.value
                  ).map(
                    (data, i) => Widget.Label({
                      label: data,
                      justification: "left",
                      class_name: `launcher-text${i === 0 ? " first" : ""}`
                    })
                  );
                }
              ]
            ]
          })
        })
      ]
    })
  });
};
addToggleableWindow(
  "Forgot",
  (v) => Launcher(
    "Forgot",
    readFile(`${App.configDir}/assets/often_forgotten.md`).split("\n").map((v2) => ({ data: v2 })),
    v
  )
);
addToggleableWindow("Launcher", (v) => {
  const json = JSON.parse(readFile("/home/oleina/.config/data/launcher.json"));
  const formatted = Object.entries(json).map(([data, exec2]) => ({
    data,
    exec: exec2
  }));
  return Launcher("Launcher", formatted, v);
});
const commands = [
  { text: "", hotkey: "q" },
  { text: "󰍃", hotkey: "l" },
  { text: "", hotkey: "r" },
  { text: "󰤆", hotkey: "s" }
];
const Powerbar = () => Widget.Window({
  name: "powerbar",
  class_name: "window",
  anchor: ["right"],
  margins: [0, 40],
  child: Widget.Box({
    vertical: true,
    class_name: "container",
    children: commands.map(({ text, hotkey }) => Widget.Box({
      class_name: "command-button",
      vertical: true,
      children: [
        Widget.Label({
          label: text,
          class_name: "icon"
        }),
        Widget.Label({
          label: `(${hotkey})`,
          class_name: "subtext"
        })
      ]
    }))
  })
});
addToggleableWindow("Powerbar", Powerbar);
const { Box: Box$1, Slider, Label, CenterBox } = Widget;
const selectedElementIndex = Variable(0);
upEmitter.register(() => {
  selectedElementIndex.value = Math.min(
    elements.length,
    selectedElementIndex.value + 1
  );
});
downEmitter.register(() => {
  selectedElementIndex.value = Math.max(0, selectedElementIndex.value - 1);
});
const elements = ["volume", "brightness"];
const CustomSlider = (name, selectedElementIndex2) => {
  const selected = name === elements[selectedElementIndex2.value];
  const buildLabelText = () => selected ? `> ${name}` : name;
  return Box$1({
    vertical: true,
    className: "slider-container",
    children: [
      CenterBox({
        className: "max-width",
        startWidget: Label({
          label: buildLabelText(),
          hpack: "start",
          className: `label ${selected ? "selected" : ""}`,
          connections: [
            [
              selectedElementIndex2,
              (self) => {
                self.label = buildLabelText();
              }
            ]
          ]
        }),
        endWidget: Label({
          label: "20%",
          hpack: "end",
          className: "label"
        })
      }),
      Slider({
        className: "slider",
        onChange: ({ value }) => print(value),
        value: 50,
        min: 0,
        max: 100
      })
    ]
  });
};
const SetupControl = () => {
  selectedElementIndex.value = 0;
  return Widget.Window({
    className: "window",
    layer: "overlay",
    name: "control",
    anchor: ["top", "right"],
    margins: [0, 15],
    child: Box$1({
      className: "container menu",
      vertical: true,
      children: [
        CustomSlider("volume", selectedElementIndex),
        CustomSlider("brightness", selectedElementIndex)
      ]
    })
  });
};
addToggleableWindow("Control", SetupControl, false);
const { Box } = Widget;
const shimNotifications = Variable([]);
Notifications.connect("notified", () => {
  shimNotifications.setValue(Notifications.popups);
});
Notifications.connect("dismissed", () => {
  shimNotifications.setValue(Notifications.popups);
});
Notifications.connect("closed", () => {
  shimNotifications.setValue(Notifications.popups);
});
const timeAgo = (timestamp) => {
  const delta = (/* @__PURE__ */ new Date()).getTime() - new Date(timestamp * 1e3).getTime();
  const seconds = Math.floor(delta / 1e3);
  const minutes = Math.floor(seconds / 60);
  return minutes ? `${minutes}m ${seconds % 60}s ago` : `${seconds}s ago`;
};
const Notification = (n) => {
  let icon = "      ";
  switch (n.urgency) {
    case "normal":
      icon = "";
      break;
    case "critical":
      icon = "";
  }
  return Widget.EventBox({
    onPrimaryClick: () => n.close(),
    child: Widget.Box({
      className: "container notification",
      vertical: false,
      children: [
        Widget.Label({
          className: `notification-icon ${n.urgency}`,
          label: icon
        }),
        Widget.Box({
          vertical: true,
          children: [
            Widget.Label({
              hpack: "start",
              className: `title ${n.urgency}`,
              label: n.summary
            }),
            Widget.Label({
              hpack: "start",
              className: "subtext small mb-2",
              label: timeAgo(n.time),
              connections: [
                [
                  1e3,
                  (self) => {
                    self.label = timeAgo(n.time);
                  }
                ]
              ]
            }),
            Widget.Label({
              wrap: true,
              justification: "left",
              hpack: "start",
              label: n.body
            })
          ]
        })
      ]
    })
  });
};
const NotificationBar = (monitor) => Widget.Window({
  monitor,
  className: "window",
  layer: "overlay",
  name: `notification-center-${monitor}`,
  anchor: ["top", "right"],
  margins: [0, 15],
  child: Box({
    className: "list",
    css: "padding: 1px;",
    // so it shows up (WTF?)
    vertical: true,
    connections: [
      [
        shimNotifications,
        (box) => {
          box.children = shimNotifications.value.map((n) => Notification(n));
        }
      ]
    ]
  })
});
monitorWatcher(App, [
  Bar,
  NotificationBar
]);
const config = {
  style: `${App.configDir}/style.css`
};
export {
  config as default
};
