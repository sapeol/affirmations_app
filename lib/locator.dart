import 'package:get_it/get_it.dart';
import 'services/database_service.dart';
import 'services/affirmations_service.dart';
import 'services/streak_service.dart';
import 'services/notification_service.dart';
import 'services/receipt_service.dart';
import 'services/battery_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService());
  locator.registerLazySingleton<AffirmationsService>(() => AffirmationsService());
  locator.registerLazySingleton<StreakService>(() => StreakService());
  locator.registerLazySingleton<NotificationService>(() => NotificationService());
  locator.registerLazySingleton<ReceiptService>(() => ReceiptService());
  locator.registerLazySingleton<BatteryService>(() => BatteryService());
}
