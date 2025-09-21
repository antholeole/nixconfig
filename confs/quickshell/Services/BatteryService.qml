pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property string preferredBatteryOverride: Quickshell.env("DMS_PREFERRED_BATTERY")

    readonly property UPowerDevice device: {
        var preferredDev;
        if (preferredBatteryOverride && preferredBatteryOverride.length > 0) {
            preferredDev = UPower.devices.values.find(dev => dev.nativePath.toLowerCase().includes(preferredBatteryOverride.toLowerCase()));
        }
        return preferredDev || UPower.devices.values.find(dev => dev.isLaptopBattery) || null;
    }
    readonly property bool batteryAvailable: device && device.ready
    readonly property real batteryLevel: batteryAvailable ? Math.round(device.percentage * 100) : 0
    readonly property bool isCharging: batteryAvailable && device.state === UPowerDeviceState.Charging && device.changeRate > 0
    readonly property bool isPluggedIn: batteryAvailable && (device.state !== UPowerDeviceState.Discharging && device.state !== UPowerDeviceState.Empty)
    readonly property bool isLowBattery: batteryAvailable && batteryLevel <= 20
    readonly property string batteryHealth: {
        if (!batteryAvailable) {
            return "N/A";
        }

        if (device.healthSupported && device.healthPercentage > 0) {
            return `${Math.round(device.healthPercentage)}%`;
        }

        return "N/A";
    }
    readonly property real batteryCapacity: batteryAvailable && device.energyCapacity > 0 ? device.energyCapacity : 0
    readonly property string batteryStatus: {
        if (!batteryAvailable) {
            return "No Battery";
        }

        if (device.state === UPowerDeviceState.Charging && device.changeRate <= 0) {
            return "Plugged In";
        }

        return UPowerDeviceState.toString(device.state);
    }
    readonly property bool suggestPowerSaver: batteryAvailable && isLowBattery && UPower.onBattery && (typeof PowerProfiles !== "undefined" && PowerProfiles.profile !== PowerProfile.PowerSaver)

    function getBatteryIcon() {
        if (!batteryAvailable) {
            return "power";
        }

        if (isCharging) {
            return "";
        }

        const batteryIcons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
        const numIcons = batteryIcons.length;
        const maxIndex = numIcons - 1;

        if (batteryLevel >= 95) {
            return batteryIcons[batteryIcons.length - 1];
        }

        const numSteps = numIcons - 1;
        const index = Math.floor(batteryLevel / (batteryIcons.length - 1));
        return batteryIcons[index];
    }
}
