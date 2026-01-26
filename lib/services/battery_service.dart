import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> get batteryLevel async {
    try {
      return await _battery.batteryLevel;
    } catch (_) {
      return 100; // Default if check fails
    }
  }

  Future<bool> get isLowBattery async {
    final level = await batteryLevel;
    return level <= 20;
  }
}
