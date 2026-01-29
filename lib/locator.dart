import 'package:get_it/get_it.dart';
import 'services/affirmations_service.dart';
import 'services/streak_service.dart';
import 'services/notification_service.dart';
import 'services/receipt_service.dart';
import 'services/battery_service.dart';
import 'services/auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AffirmationsService>(() => AffirmationsService());
  locator.registerLazySingleton<StreakService>(() => StreakService());
  locator.registerLazySingleton<NotificationService>(() => NotificationService());
  locator.registerLazySingleton<ReceiptService>(() => ReceiptService());
  locator.registerLazySingleton<BatteryService>(() => BatteryService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
}
