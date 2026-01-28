import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pigeon_api.g.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi();
});
