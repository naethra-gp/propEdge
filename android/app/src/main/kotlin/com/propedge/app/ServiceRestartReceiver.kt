package com.propedge.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.propedge.app.AlarmUtils


class ServiceRestartReceiver : BroadcastReceiver() {

    companion object {
        const val CHANNEL_ID = "SERVICE_RESTART_CHANNEL"
        const val NOTIFICATION_ID = 2001
    }

   override fun onReceive(context: Context, intent: Intent?) {
    Log.d("ServiceRestartReceiver", "Alarm triggered, checking service...")

    val isRunning = MyForegroundService.isServiceRunning(context)
    if (!isRunning) {
       // Log.d("ServiceRestartReceiver", "Service not running. Showing restart notification.")
        
       // val serviceIntent = Intent(context, MyForegroundService::class.java)
      //  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        //    context.startForegroundService(serviceIntent)
       // } else {
         //   context.startService(serviceIntent)
        //}

        // Optional: show a notification if needed
        showNotificationToRestart(context)
    } else {
        Log.d("ServiceRestartReceiver", "Service is already running.")
    }

    // Reschedule the alarm for next check
    AlarmUtils.scheduleRestart(context)
}


    private fun showNotificationToRestart(context: Context) {
        // Intent to open MainActivity
        val mainIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("startFromNotification", true)
        }

        val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                mainIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        // Notification Manager
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Notification Channel for Android 8+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                    CHANNEL_ID,
                    "Restart Location Service",
                    NotificationManager.IMPORTANCE_HIGH
            )
            channel.description = "Tap to restart the location tracking service"
            channel.enableLights(true)
            channel.lightColor = Color.RED
            channel.enableVibration(true)
            notificationManager.createNotificationChannel(channel)
        }

        // Build and show notification
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_menu_mylocation)
                .setContentTitle("Location Service Stopped")
                .setContentText("Tap to open app and restart tracking")
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setColor(Color.RED)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .build()

        notificationManager.notify(NOTIFICATION_ID, notification)
    }
}
