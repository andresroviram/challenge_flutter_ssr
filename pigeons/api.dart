import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/native/pigeon_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/challenge_flutter_ssr/pigeon/PigeonApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.example.challenge_flutter_ssr.pigeon',
    ),
    swiftOut: 'ios/Runner/PigeonApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
class NotificationPayload {
  final String id;
  final String title;
  final String message;

  NotificationPayload({
    required this.id,
    required this.title,
    required this.message,
  });
}

/// Host API para comunicación Flutter -> Nativo
@HostApi()
abstract class NotificationApi {
  /// Muestra una notificación local en el dispositivo
  void showNotification(NotificationPayload payload);

  /// Solicita permisos de notificación (especialmente para iOS)
  @async
  bool requestNotificationPermissions();

  /// Abre la configuración del canal de notificaciones
  void openNotificationSettings();
}
