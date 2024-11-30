package com.example.later_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.later_app/share_handler"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure FlutterEngine is available
        flutterEngine?.let { engine ->
            // Set up Method Channel
            MethodChannel(
                engine.dartExecutor.binaryMessenger,
                CHANNEL
            ).setMethodCallHandler { call, result ->
                when (call.method) {
                    "preventClose" -> {
                        // Simply acknowledge the method call
                        result.success(true)
                    }
                    "closeApp" -> {
                        // Close the app
                        finish()
                        result.success(true)
                    }
                    else -> {
                        // Handle unknown methods
                        result.notImplemented()
                    }
                }
            }
        }

        // Handle share intent if app opened from share
        handleShareIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleShareIntent(intent)
    }

    private fun handleShareIntent(intent: Intent?) {
        if (isOpenedFromShareIntent(intent)) {
            // You can add additional logic here if needed
        }
    }

    private fun isOpenedFromShareIntent(intent: Intent?): Boolean {
        return intent?.action == Intent.ACTION_SEND &&
                (intent.hasExtra(Intent.EXTRA_TEXT) ||
                        intent.hasExtra(Intent.EXTRA_STREAM))
    }
}