package com.example.challenge_flutter_ssr

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.challenge_flutter_ssr.pigeon.NotificationApi
import com.example.challenge_flutter_ssr.pigeon.NotificationPayload
import com.example.challenge_flutter_ssr.notification.NotificationHandler
import com.example.challenge_flutter_ssr.notification.createNotificationChannel

class MainActivity : FlutterActivity() {
    private val channelId = "likes_channel"
    private val NOTIFICATION_PERMISSION_CODE = 1001
    private lateinit var notificationHandler: NotificationHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        notificationHandler = NotificationHandler(this, channelId, NOTIFICATION_PERMISSION_CODE)
        NotificationApi.setUp(flutterEngine.dartExecutor.binaryMessenger, notificationHandler)
        createNotificationChannel(this, channelId)
    }
}
