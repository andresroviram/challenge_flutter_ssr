import 'package:flutter/material.dart';

class NotificationSettingsAndroidContent extends StatelessWidget {
  const NotificationSettingsAndroidContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Para ver las notificaciones en primer plano:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text('1. Toca "Abrir configuración"'),
        SizedBox(height: 8),
        Text('2. Busca "Pop on screen"'),
        SizedBox(height: 8),
        Text('3. Activa la opción'),
        SizedBox(height: 12),
        Text(
          '⚠️ Esta configuración debe activarse manualmente por seguridad.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
