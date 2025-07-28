import 'package:disable_battery_optimization/disable_battery_optimization.dart';

class CommonFunctions {
  // REMOVE NULL VALUES
  removeNull(String value) {
    if (value.toString().toLowerCase() == 'null') {
      return '';
    }
    return value.toString().trim();
  }

  checkBatteryOptimization() async {
    bool? isOptimize =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if (!isOptimize!) {
      await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }
}
