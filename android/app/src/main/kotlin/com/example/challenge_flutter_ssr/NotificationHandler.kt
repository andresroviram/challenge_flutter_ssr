package com.example.challenge_flutter_ssr

import com.example.challenge_flutter_ssr.pigeon.NotificationApi
import com.example.challenge_flutter_ssr.pigeon.NotificationPayload
import android.content.Context

class NotificationHandler(
    private val context: Context,
    private val channelId: String,
    private val notificationPermissionCode: Int
) : NotificationApi {
    override fun showNotification(payload: NotificationPayload) {
        NotificationHelper.showNotification(context, payload, channelId, notificationPermissionCode)
    }

    override fun requestNotificationPermissions(callback: (Result<Boolean>) -> Unit) {
        NotificationHelper.requestNotificationPermissions(context, callback, notificationPermissionCode)
    }

    override fun openNotificationSettings() {
        NotificationHelper.openNotificationSettings(context, channelId)
    }
}