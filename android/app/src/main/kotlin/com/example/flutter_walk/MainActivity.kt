package com.example.flutter_walk

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL = "step_control"
    private val EVENT_CHANNEL = "step_count_stream"

    private var stepStreamHandler: StepStreamHandler? = null

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ MethodChannel: start/stop service
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        Log.d("MainActivity", "startService start")
                        val intent = Intent(this, StepCounterService::class.java)
                        startForegroundService(intent)
                        result.success(true)
                        Log.d("MainActivity", "startService end")
                    }
                    "stopService" -> {
                        val intent = Intent(this, StepCounterService::class.java)
                        stopService(intent)
                        result.success(false)
                    }
                    else -> result.notImplemented()
                }
            }

        // ✅ EventChannel: stream step count to Flutter
        stepStreamHandler = StepStreamHandler(this)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(stepStreamHandler)
    }

    override fun onDestroy() {
        super.onDestroy()
        stepStreamHandler?.stopListening()
    }
}
