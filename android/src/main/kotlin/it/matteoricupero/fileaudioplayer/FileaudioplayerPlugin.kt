package it.matteoricupero.fileaudioplayer

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.Build.VERSION
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.IOException

public class FileaudioplayerPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var result: Result

  private var player: MediaPlayer? = null
  private var audioFocusRequest: AudioFocusRequest? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "fileaudioplayer")

    audioManager = flutterPluginBinding.applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    channel.setMethodCallHandler(this)
  }

  companion object {

    @JvmStatic var audioManager: AudioManager? = null

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "fileaudioplayer")

      audioManager = registrar.activeContext().getSystemService(Context.AUDIO_SERVICE) as AudioManager

      channel.setMethodCallHandler(FileaudioplayerPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    this.result = result

    val action = call.method

    when (action) {
      "start" -> {
        if (call.arguments != null) {
          val url = call.arguments.toString()
          initializePlayer(url)
          startPlayer()
        } else {
          result.error("no file", null, null)
        }
      }
      "stop" -> stopPlayer()
      "pause" -> pausePlayer()
      else -> resumePlayer()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun initializePlayer(url: String) {
    try {
      if (player != null) {
        player!!.stop()
        player!!.reset()
        player!!.release()
      }

      player = MediaPlayer()

      if (VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        player!!.setAudioAttributes(AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build())
      } else {
        player!!.setAudioStreamType(AudioManager.STREAM_SYSTEM)
      }

      player!!.setDataSource(url)

    } catch (e: IllegalArgumentException) {
      e.printStackTrace()
    } catch (e: IllegalStateException) {
      e.printStackTrace()
    } catch (e: IOException) {
      e.printStackTrace()
    }
  }

  private fun startPlayer() {
    try {
      if (player != null) {
        requestFocus()
        player!!.prepareAsync()
        player!!.setOnPreparedListener {
          try {
            player!!.start()
          } catch (e: IllegalStateException) {
            afterException(e)
          }
        }
        player!!.setOnCompletionListener {
          try {
            abandonFocus()
            result.success(true)
          } catch (e: Exception) {
            e.printStackTrace()
          }
        }
      } else {
        result.error("player null", null, null)
      }
    } catch (e: Exception) {
      afterException(e)
    }
  }

  private fun requestFocus() {
    if (VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      try {
        val mPlaybackAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                .build()
        audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                .setAudioAttributes(mPlaybackAttributes)
                .setOnAudioFocusChangeListener { }
                .build()
        audioManager?.requestAudioFocus(audioFocusRequest)
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }
  }

  private fun abandonFocus() {
    try {
      if (VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        audioManager?.abandonAudioFocusRequest(audioFocusRequest)
      }
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun stopPlayer() {
    try {
      if (player != null) {
        abandonFocus()
        player!!.stop()
        player!!.reset()
        player!!.release()
      }
      result.success(true)
    } catch (e: Exception) {
      afterException(e)
    }
  }

  private fun pausePlayer() {
    try {
      if (player!!.isPlaying) {
        abandonFocus()
        player!!.pause()
      }
      result.success(true)
    } catch (e: Exception) {
      afterException(e)
    }
  }

  private fun resumePlayer() {
    try {
      if (!player!!.isPlaying) {
        abandonFocus()
        player!!.start()
      }
      result.success(true)
    } catch (e: Exception) {
      afterException(e)
    }
  }

  private fun afterException(e: Exception) {
    e.printStackTrace()
    abandonFocus()
    result.error(e.message, e.message, e.cause)
  }
}
