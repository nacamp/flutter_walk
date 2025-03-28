package com.example.flutter_walk

import android.app.*
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

class StepCounterService : Service(), SensorEventListener {
    private lateinit var sensorManager: SensorManager
    private var stepSensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        stepSensor?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
        }

//        // FlutterEngine 준비
//        val flutterEngine = FlutterEngine(this)
//        flutterEngine.dartExecutor.executeDartEntrypoint(
//            DartExecutor.DartEntrypoint.createDefault()
//        )
//
//        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "step_count_stream")
//            .setStreamHandler(object : EventChannel.StreamHandler {
//                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
//                    eventSink = sink
//                }
//
//                override fun onCancel(arguments: Any?) {
//                    eventSink = null
//                }
//            })

        startForegroundServiceWithNotification()
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_STEP_COUNTER) {
            Log.d("StepCounterService", "onSensorChanged: ${event.values[0]}")
            val steps = event.values[0].toInt()
//            eventSink?.success(steps)
//            if (eventSink != null) {
//                Log.d("StepCounterService", "✅ eventSink에 전달됨: $steps")
//            } else {
//                Log.w("StepCounterService", "❌ eventSink가 null입니다!")
//            }

            val intent = Intent("com.example.STEP_UPDATE")
            intent.putExtra("steps", steps)
            sendBroadcast(intent) // 이걸 통해 StreamHandler 쪽으로 전달
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        sensorManager.unregisterListener(this)
        super.onDestroy()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun startForegroundServiceWithNotification() {
        val channelId = "step_channel"
        val channelName = "Step Counter"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chan = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW)
            val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(chan)
        }

        val notification = Notification.Builder(this, channelId)
            .setContentTitle("걸음 수 추적 중")
            .setContentText("당신의 걸음 수를 추적하고 있어요.")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .build()

        startForeground(1, notification)
    }
}

