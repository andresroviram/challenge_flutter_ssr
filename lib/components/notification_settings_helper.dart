import 'package:flutter/material.dart';
import 'dart:io';
import 'notification_settings_android_content.dart';
import 'notification_settings_ios_content.dart';

class NotificationSettingsHelper {
  static Future<void> showPopOnScreenGuide(
    BuildContext context, {
    required VoidCallback onOpenSettings,
  }) async {
    if (!context.mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        Widget content;
        if (Platform.isAndroid) {
          content = const NotificationSettingsAndroidContent();
        } else if (Platform.isIOS) {
          content = const NotificationSettingsIOSContent();
        } else {
          content = const Text(
            'Esta función solo está disponible en Android o iOS.',
          );
        }

        return AlertDialog(
          title: const Text('Activar notificaciones emergentes'),
          content: content,
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Abrir configuración'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == true) {
      onOpenSettings();
    }
  }

  static Widget buildSettingsButton(
    BuildContext context, {
    required VoidCallback onOpenSettings,
  }) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.notifications_active),
      label: const Text('Activar notificaciones emergentes'),
      onPressed: () =>
          showPopOnScreenGuide(context, onOpenSettings: onOpenSettings),
    );
  }
}
