package com.example.challenge_flutter_ssr

import android.Manifest
import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

fun createNotificationChannel(context: Context, channelId: String) {
    val channelName = "Likes Notifications"
    val channelDescription = "Notifications for liked posts"
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val importance = NotificationManager.IMPORTANCE_MAX
        val channel = NotificationChannel(channelId, channelName, importance).apply {
            description = channelDescription
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 250, 250, 250)
            setShowBadge(true)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            enableLights(true)
        }

        val notificationManager: NotificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }
}
