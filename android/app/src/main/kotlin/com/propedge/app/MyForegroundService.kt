package com.propedge.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.*
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import java.util.*
import java.util.concurrent.TimeUnit
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import android.content.pm.ServiceInfo
import android.graphics.Color
import com.propedge.app.AlarmUtils



class MyForegroundService : Service() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private var autoStopTimer: Timer? = null
    private var currentNotificationBuilder: NotificationCompat.Builder? = null
    private var lastLocationTimestamp: Long = 0
    private val idleWatchdogHandler = Handler(Looper.getMainLooper())
    private var wakeLock: PowerManager.WakeLock? = null

    companion object {
        private const val CHANNEL_ID = "MyForegroundServiceChannel"
        private const val IDLE_CHANNEL_ID = "IdleOrStoppedChannel"
        private const val NOTIFICATION_ID = 1001
        private const val IDLE_NOTIFICATION_ID = 1003
        private const val STOP_NOTIFICATION_ID = 1004
        private const val TAG = "MyForegroundService"
        private const val IDLE_TIMEOUT = 5 * 60 * 1000L // 5 minutes
        private var stopReason: String? = null

        fun isServiceRunning(context: Context): Boolean {
            val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            return manager.getRunningServices(Int.MAX_VALUE)
                    .any { it.service.className == MyForegroundService::class.java.name }
        }

        private fun hasRequiredPermissions(context: Context): Boolean {
            val hasLocationPermission = ActivityCompat.checkSelfPermission(
                    context,
                    android.Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED

            val hasForegroundPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                ActivityCompat.checkSelfPermission(
                        context,
                        android.Manifest.permission.FOREGROUND_SERVICE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
            } else true

            return hasLocationPermission && hasForegroundPermission
        }
    }

    override fun onCreate() {
        super.onCreate()

        if (!hasRequiredPermissions(this)) {
            Log.e(TAG, "Permissions not granted.")
            stopSelf()
            return
        }

        //acquireWakeLock()

        createNotificationChannels()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) { // Android 10 / API 29
            startForeground(NOTIFICATION_ID, createNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
        } else {
            startForeground(NOTIFICATION_ID, createNotification())
        }
        requestIgnoreBatteryOptimizations()
        startLocationUpdates()
        startIdleWatchdog()
        scheduleAutoStop()
        AlarmUtils.scheduleRestart(this)
        // scheduleServiceRestartAlarm()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        stopReason = intent?.getStringExtra("stopReason")
        Log.d(TAG, "Service started with stopReason: $stopReason")
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()

        stopLocationUpdates()
        idleWatchdogHandler.removeCallbacksAndMessages(null)
        autoStopTimer?.cancel()

        // Determine stop reason and log
        when (stopReason) {
            "manual" -> {
                Log.d(TAG, "onDestroy called: manual stop")
                AlarmUtils.cancelRestart(this) // Cancel restart alarm
                // Set manual stop flag
                getSharedPreferences("LocationServicePrefs", Context.MODE_PRIVATE)
                    .edit()
                    .putBoolean("wasManuallyStopped", true)
                    .apply()
            }
            "auto" -> {
                Log.d(TAG, "onDestroy called: auto stop at end of day")
                // Set manual stop flag for auto-stop
                getSharedPreferences("LocationServicePrefs", Context.MODE_PRIVATE)
                    .edit()
                    .putBoolean("wasManuallyStopped", true)
                    .apply()
            }
            else -> {
                Log.d(TAG, "onDestroy called: system stop")
                // Clear manual stop flag only for system stop
                getSharedPreferences("LocationServicePrefs", Context.MODE_PRIVATE)
                    .edit()
                    .putBoolean("wasManuallyStopped", false)
                    .apply()
                showStoppedNotification()
            }
        }

        Log.d(TAG, "Service destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? = null

    /* private fun acquireWakeLock() {
         val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
         wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "$packageName:LocationWakeLock")
         wakeLock?.acquire()
         Log.d(TAG, "WakeLock acquired")
     }

     private fun releaseWakeLock() {
         if (wakeLock?.isHeld == true) {
             wakeLock?.release()
             Log.d(TAG, "WakeLock released")
         }
     }*/

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    CHANNEL_ID, "Foreground Location", NotificationManager.IMPORTANCE_LOW
            )
            val idleChannel = NotificationChannel(
                    IDLE_CHANNEL_ID, "Idle or Stopped Notification", NotificationManager.IMPORTANCE_HIGH
            )

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
            manager.createNotificationChannel(idleChannel)
        }
    }

    private fun createNotification(latitude: Double? = null, longitude: Double? = null): Notification {
        val contentText = if (latitude != null && longitude != null) {
            "Location: $latitude, $longitude"
        } else {
            "Your location is being tracked"
        }
        currentNotificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Tracking Location")
                .setContentText(contentText)
                .setSmallIcon(android.R.drawable.ic_menu_mylocation)
                .setOngoing(true)
        return currentNotificationBuilder!!.build()
    }

    private fun updateNotification(latitude: Double, longitude: Double) {
        val notification = createNotification(latitude, longitude)
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, notification)
    }

    private fun showIdleNotification() {
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(this, 1, intent, PendingIntent.FLAG_IMMUTABLE)

        val notification = NotificationCompat.Builder(this, IDLE_CHANNEL_ID)
                .setContentTitle("Service is idle")
                .setContentText("Tap to start location tracking")
                .setSmallIcon(android.R.drawable.stat_sys_warning)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setColor(Color.parseColor("#0000FF")) // Blue color
                .build()

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(IDLE_NOTIFICATION_ID, notification)
    }

    private fun showStoppedNotification() {
        val restartIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("startFromNotification", true)
        }

        val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                restartIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, IDLE_CHANNEL_ID)
                .setContentTitle("Tracking stopped")
                .setContentText("Location tracking has been stopped")
                .setSmallIcon(android.R.drawable.ic_delete)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent) // <--- important
                .setColor(Color.parseColor("#FF0000")) // Red color
                .build()

        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(STOP_NOTIFICATION_ID, notification)
    }

    private fun startLocationUpdates() {
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        val request = LocationRequest.create().apply {
            interval = 60000
            fastestInterval = 60000
            priority = Priority.PRIORITY_HIGH_ACCURACY
        }
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                result.lastLocation?.let {
                    lastLocationTimestamp = System.currentTimeMillis()
                    sendLocationToFlutter(it.latitude, it.longitude, "")
                    updateNotification(it.latitude, it.longitude)
                }
            }
        }
        fusedLocationClient.requestLocationUpdates(request, locationCallback, mainLooper)
    }

    private fun stopLocationUpdates() {
        if (::fusedLocationClient.isInitialized) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
        }
    }

    private fun startIdleWatchdog() {
        idleWatchdogHandler.postDelayed(object : Runnable {
            override fun run() {
                val now = System.currentTimeMillis()
                if (now - lastLocationTimestamp > IDLE_TIMEOUT) {
                    Log.w(TAG, "Idle detected. Restarting updates and notifying user.")
                    stopLocationUpdates()
                    startLocationUpdates()
                    showIdleNotification()
                }
                idleWatchdogHandler.postDelayed(this, IDLE_TIMEOUT)
            }
        }, IDLE_TIMEOUT)
    }

    private fun scheduleAutoStop() {
        val calendar = Calendar.getInstance()
        val now = calendar.timeInMillis
        calendar.set(Calendar.HOUR_OF_DAY, 22)
        calendar.set(Calendar.MINUTE, 59)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        if (now > calendar.timeInMillis) calendar.add(Calendar.DAY_OF_YEAR, 1)

        val delay = calendar.timeInMillis - now
        Log.d(TAG, "Scheduling auto stop in ${TimeUnit.MILLISECONDS.toMinutes(delay)} minutes")
        autoStopTimer = Timer()
        autoStopTimer?.schedule(object : TimerTask() {
            override fun run() {
                fusedLocationClient.lastLocation.addOnSuccessListener { location ->
                    location?.let {
                        sendLocationToFlutter(it.latitude, it.longitude, "E")
                    }
                    stopReason = "manual"
                    stopSelfDelayed()
                }.addOnFailureListener {
                    stopReason = "manual"
                    stopSelfDelayed()
                }
            }
        }, delay)
    }

    private fun stopSelfDelayed() {
        Handler(Looper.getMainLooper()).postDelayed({ stopSelf() }, 1000)
    }

    private fun sendLocationToFlutter(latitude: Double, longitude: Double, trackStatus: String) {
        FlutterEngine(this).apply {
            dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            MethodChannel(dartExecutor.binaryMessenger, "com.propedge.app/location_service")
                    .invokeMethod("insertLocation", mapOf(
                            "latitude" to latitude,
                            "longitude" to longitude,
                            "trackStatus" to trackStatus
                    ))
        }
    }

    private fun requestIgnoreBatteryOptimizations() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = android.net.Uri.parse("package:$packageName")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                startActivity(intent)
            }
        }
    }


}