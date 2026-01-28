import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pigeon_api.g.dart';

class NotificationService {
  final NotificationApi _notificationApi;

  NotificationService(this._notificationApi);

  Future<void> requestPermissions() async {
    try {
      await _notificationApi.requestNotificationPermissions();
    } catch (e) {
      // Handle error silently or log
    }
  }

  void showNotification({
    required String id,
    required String title,
    required String message,
  }) {
    try {
      final payload = NotificationPayload(
        id: id,
        title: title,
        message: message,
      );
      _notificationApi.showNotification(payload);
    } catch (e) {
      // Handle error silently or log
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(NotificationApi());
});
