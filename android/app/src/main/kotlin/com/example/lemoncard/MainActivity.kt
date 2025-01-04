package com.example.lemoncard

import android.speech.tts.TextToSpeech
import android.speech.tts.TextToSpeech.OnInitListener
import androidx.annotation.NonNull
import android.speech.tts.TextToSpeech.SUCCESS
import android.speech.tts.TextToSpeech.LANG_MISSING_DATA
import android.speech.tts.TextToSpeech.LANG_NOT_SUPPORTED
import android.speech.tts.TextToSpeech.QUEUE_FLUSH
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity: FlutterActivity(), OnInitListener {
    private lateinit var tts: TextToSpeech
    private var ttsInitialized = false
    
    companion object {
        private const val CHANNEL = "com.example.lemoncard/tts"
    }
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        tts = TextToSpeech(this, this)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    val text = call.argument<String>("text")
                    if (text != null) {
                        speakText(text, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Text cannot be null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
    
    private fun speakText(text: String, result: MethodChannel.Result) {
        if (!ttsInitialized) {
            result.error("TTS_NOT_INITIALIZED", "Text-to-speech is not initialized", null)
            return
        }
        
        tts.speak(text, QUEUE_FLUSH, null, null)
        result.success(null)
    }
    
    override fun onInit(status: Int) {
        if (status == SUCCESS) {
            val result = tts.setLanguage(Locale.getDefault())
            if (result == LANG_MISSING_DATA || result == LANG_NOT_SUPPORTED) {
                ttsInitialized = false
            } else {
                ttsInitialized = true
            }
        } else {
            ttsInitialized = false
        }
    }
    
    override fun onDestroy() {
        if (::tts.isInitialized) {
            tts.stop()
            tts.shutdown()
        }
        super.onDestroy()
    }

    private lateinit var tts: TextToSpeech
    private var ttsInitialized = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Initialize TTS
        tts = TextToSpeech(this, this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    if (!ttsInitialized) {
                        result.error("TTS_NOT_READY", "Text to speech engine is not initialized", null)
                        return@setMethodCallHandler
                    }
                    val text = call.argument<String>("text") ?: ""
                    speakText(text)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            val result = tts.setLanguage(Locale.US)
            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                ttsInitialized = false
            } else {
                ttsInitialized = true
            }
        } else {
            ttsInitialized = false
        }
    }

    private fun speakText(text: String) {
        tts.speak(text, TextToSpeech.QUEUE_FLUSH, null, "LemonTTS1")
    }

    override fun onDestroy() {
        // Cleanup TTS resources
        if (::tts.isInitialized) {
            tts.stop()
            tts.shutdown()
        }
        super.onDestroy()
    }
}
