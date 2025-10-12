import QtQuick
import qs.Services
import qs.Common

DefaultText {
    text: BatteryService.batteryAvailable ? `${BatteryService.getBatteryIcon()} ${BatteryService.batteryLevel.toString()}%` : ``
}
