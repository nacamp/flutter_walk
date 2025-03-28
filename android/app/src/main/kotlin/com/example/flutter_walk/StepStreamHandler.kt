package com.example.flutter_walk

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel

class StepStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events

        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val steps = intent?.getIntExtra("steps", -1) ?: -1
                if (steps >= 0) {
                    Log.d("StepStreamHandler", "📥 Received step: $steps")
                    eventSink?.success(steps)
                }
            }
        }

        val filter = IntentFilter("com.example.STEP_UPDATE")
        ContextCompat.registerReceiver(
            context,
            receiver,
            filter,
            ContextCompat.RECEIVER_NOT_EXPORTED
        )
    }

    override fun onCancel(arguments: Any?) {
        stopListening()
    }

    fun stopListening() {
        receiver?.let {
            context.unregisterReceiver(it)
        }
        receiver = null
        eventSink = null
    }
}