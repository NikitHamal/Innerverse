package com.inner.verse

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val securityChannel = "com.inner.verse/security"
    private var isScreenshotBlockingEnabled = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, securityChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableScreenshotBlocking" -> {
                    enableScreenshotBlocking()
                    result.success(true)
                }
                "disableScreenshotBlocking" -> {
                    disableScreenshotBlocking()
                    result.success(true)
                }
                "isScreenshotBlockingEnabled" -> {
                    result.success(isScreenshotBlockingEnabled)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Start with secure mode disabled by default
        // User can enable via settings
    }

    private fun enableScreenshotBlocking() {
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
        isScreenshotBlockingEnabled = true
    }

    private fun disableScreenshotBlocking() {
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        isScreenshotBlockingEnabled = false
    }
}
