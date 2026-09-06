package com.example.app_terjemahan

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.speech.RecognizerIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val SPEECH_CHANNEL = "com.example.app_terjemahan/speech"
    private val SPEECH_REQUEST_CODE = 9988
    private var pendingSpeechResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SPEECH_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startSpeechRecognition" -> {
                    val languageTag = call.argument<String>("locale") ?: "id-ID"
                    val prompt = call.argument<String>("prompt") ?: "Bicara sekarang..."

                    val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                        putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                        putExtra(RecognizerIntent.EXTRA_LANGUAGE, languageTag)
                        putExtra(RecognizerIntent.EXTRA_LANGUAGE_PREFERENCE, languageTag)
                        putExtra("android.speech.extra.EXTRA_ADDITIONAL_LANGUAGES", arrayOf(languageTag, "id-ID", "en-US"))
                        putExtra(RecognizerIntent.EXTRA_PROMPT, prompt)
                        putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)
                    }

                    try {
                        pendingSpeechResult = result
                        startActivityForResult(intent, SPEECH_REQUEST_CODE)
                    } catch (e: Exception) {
                        pendingSpeechResult = null
                        result.error("UNAVAILABLE", "Layanan pengenalan suara tidak tersedia: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SPEECH_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                val results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
                val recognizedText = results?.firstOrNull { it.isNotBlank() } ?: ""
                pendingSpeechResult?.success(recognizedText)
            } else {
                pendingSpeechResult?.success("")
            }
            pendingSpeechResult = null
        }
    }
}
