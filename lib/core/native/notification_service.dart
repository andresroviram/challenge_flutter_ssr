import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pigeon_api.g.dart';

class NotificationService {
  final NotificationApi _notificationApi;

  NotificationService(this._notificationApi);

  Future<bool> requestPermissions() async {
    try {
      final granted = await _notificationApi.requestNotificationPermissions();
      return granted;
    } catch (e) {
      return false;
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
      // Handle error silently
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(NotificationApi());
});
