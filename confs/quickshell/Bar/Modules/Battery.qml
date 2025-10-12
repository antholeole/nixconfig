import QtQuick
import qs.Services
import qs.Common

DefaultText {
    text: `${BatteryService.getBatteryIcon()} ${BatteryService.batteryLevel.toString()}%`
}
