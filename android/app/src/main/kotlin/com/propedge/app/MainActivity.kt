package com.propedge.app
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*
import android.os.Build
import android.provider.Settings
import android.net.Uri


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.propedge.app/location_service"
    private var methodChannel: MethodChannel? = null

    companion object {
        private const val PREFS_NAME = "LocationServicePrefs"
        private const val KEY_MANUAL_STOP = "wasManuallyStopped"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startForegroundService" -> {
                    // Clear manual stop flag when starting service
                    getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                        .edit()
                        .putBoolean(KEY_MANUAL_STOP, false)
                        .apply()
                    val intent = Intent(this, MyForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success("Service Started")
                }
                "stopForegroundService" -> {
                    // Set manual stop flag when stopping service
                    getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                        .edit()
                        .putBoolean(KEY_MANUAL_STOP, true)
                        .apply()
                    val stopIntent = Intent(this, MyForegroundService::class.java).apply {
                        putExtra("stopReason", "manual")
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(stopIntent)
                    } else {
                        startService(stopIntent)
                    }
                    Handler(Looper.getMainLooper()).postDelayed({
                        stopService(stopIntent)
                    }, 200)
                    result.success("Service Stopped with reason: manual")
                }
                "isServiceRunning" -> {
                    val isRunning = MyForegroundService.isServiceRunning(this)
                    result.success(isRunning)
                }
                "requestExactAlarmPermission" -> {
                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                 val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
                if (!alarmManager.canScheduleExactAlarms()) {
                 val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = Uri.parse("package:$packageName")
                    }
                    startActivity(intent)
                 }
             }
    result.success(null)
}
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    Log.d("MainActivity", "onCreate - App launched")

    // Start service if it's not running and wasn't manually stopped
    val wasManuallyStopped = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        .getBoolean(KEY_MANUAL_STOP, false)

    if (!MyForegroundService.isServiceRunning(this) && !wasManuallyStopped) {
        Log.d("MainActivity", "Starting service on app launch")
        val intent = Intent(this, MyForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    // Start service if launched from notification tap
    if (intent?.getBooleanExtra("startFromNotification", false) == true) {
        Log.d("MainActivity", "Starting service from notification tap")
        val intentService = Intent(this, MyForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intentService)
        } else {
            startService(intentService)
        }
    }
}

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        Log.d("MainActivity", "onNewIntent - App resumed with new intent")
        val fromAutoLogout = intent.getBooleanExtra("fromAutoLogout", false)
        if (fromAutoLogout) {
            Log.d("MainActivity", "onNewIntent - Auto logout triggered by alarm")
            Handler(Looper.getMainLooper()).postDelayed({
                methodChannel?.invokeMethod("autoLogoutTriggered", null)
            }, 1000)
        }
    }
    private fun scheduleDailyLogoutAlarm() {
        if (isAlarmAlreadyScheduled(this)) {
            Log.d("MainActivity", "Daily auto-logout alarm already scheduled. Skipping setup.")
            return
        }
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, AutoLogoutReceiver::class.java).apply {
            putExtra("fromAutoLogout", true)
        }
        val pendingIntent = PendingIntent.getBroadcast(
                this,
                10,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 23) // 13:22 = 1:22 PM
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            if (timeInMillis < System.currentTimeMillis()) {
                add(Calendar.DAY_OF_YEAR, 1)
            }
        }
        alarmManager.setRepeating(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                AlarmManager.INTERVAL_DAY,
                pendingIntent
        )
        Log.d("MainActivity", "Daily auto-logout alarm scheduled at 13:22")
    }
    private fun isAlarmAlreadyScheduled(context: Context): Boolean {
        val intent = Intent(context, AutoLogoutReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
                context,
                10,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        return pendingIntent != null
    }
}

