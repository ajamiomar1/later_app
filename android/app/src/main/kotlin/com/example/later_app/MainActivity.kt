package com.example.later_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if the app was opened via a share action
        if (isOpenedFromShareIntent(intent)) {
            // If opened from share intent, close the app immediately
//            finish()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Update the current intent
        setIntent(intent)

        // Check if the app was opened via a share action
        if (isOpenedFromShareIntent(intent)) {
            // If opened from share intent, close the app immediately
//            finish()
        }
    }

    /**
     * Helper function to check if the intent was triggered by a share action.
     */
    private fun isOpenedFromShareIntent(intent: Intent?): Boolean {
        // Check for a share action (ACTION_SEND) and ensure it has an extra (EXTRA_TEXT)
        return intent?.action == Intent.ACTION_SEND && intent.hasExtra(Intent.EXTRA_TEXT)
    }
}
