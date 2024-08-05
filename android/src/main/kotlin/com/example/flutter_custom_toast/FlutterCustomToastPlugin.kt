package com.example.flutter_custom_toast


import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.ShapeDrawable
import android.graphics.drawable.shapes.RoundRectShape
import android.util.Base64
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.logging.Handler

/** FlutterCustomToastPlugin */
class FlutterCustomToastPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_toast_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "showCustomToast" -> {
        val message = call.argument<String>("message")
        val fontSize = call.argument<Double>("fontSize")?.toFloat()
        val backgroundColor = call.argument<Long>("backgroundColor")
        val textColor = call.argument<Long>("textColor")
        val fontFamily = call.argument<String>("fontFamily")
        val imageResourceName = call.argument<String>("imageResourceName") ?: "ic_launcher"
        val showImage = call.argument<Boolean>("showImage") ?: true
        val base64Image = call.argument<String>("base64Image")
        val duration = call.argument<Int>("duration")?.toInt()
        val maxLines = call.argument<Int>("maxLines")

        if (message != null) {
          showCustomToast(
            message,
            fontSize,
            maxLines,
            backgroundColor,
            showImage,
            base64Image,
            imageResourceName,
            textColor,
            fontFamily,
            duration
          )
          result.success(null)
        } else {
          result.error("INVALID_ARGUMENT", "Message argument is required", null)
        }
      }

      else -> {
        result.notImplemented()
      }
    }
  }

  private fun showCustomToast(
    message: String?,
    fontSize: Float?,
    maxLines: Int?,
    backgroundColor: Long?,
    showImage: Boolean,
    base64Image: String?,
    imageResourceName: String?,
    textColor: Long?,
    fontFamily: String?,
    duration: Int?
  ) {
    // Log the actual values
    Log.e("Toast", "Showing custom toast with message: $message, showImage: $showImage")

    val inflater = LayoutInflater.from(context)
    val layout = inflater.inflate(R.layout.custom_toast, null)

    val textView: TextView = layout.findViewById(R.id.toast_message)
    textView.text = message
    fontFamily?.let {
      textView.typeface = Typeface.create(it, Typeface.NORMAL)
    }
    fontSize?.let { textView.textSize = it }
    textView.maxLines = maxLines ?: 2
    textColor?.let { textView.setTextColor(it.toInt()) } ?: textView.setTextColor(Color.BLACK)

    val imageView: ImageView = layout.findViewById(R.id.toast_image)
    if (showImage) {
      if (!base64Image.isNullOrEmpty()) {
        val bitmap = decodeBase64ToBitmap(base64Image)
        if (bitmap != null) {
          imageView.setImageBitmap(bitmap)
          imageView.visibility = View.VISIBLE
        } else {
          Log.e("Toast error", "Failed to decode base64 image")
          imageView.visibility = View.GONE
        }
      } else {
        val imageResId = context.resources.getIdentifier(imageResourceName, "mipmap", context.packageName)
        if (imageResId != 0) {
          imageView.setImageResource(imageResId)
          imageView.visibility = View.VISIBLE
        } else {
          Log.e("Toast error", "Drawable for '$imageResourceName' not found")
          imageView.visibility = View.GONE
        }
      }
    } else {
      imageView.visibility = View.GONE
    }

    backgroundColor?.let {
      val radius = 16f // You can adjust this as needed
      val drawable = ShapeDrawable(
        RoundRectShape(
          floatArrayOf(radius, radius, radius, radius, radius, radius, radius, radius), null, null
        )
      )
      drawable.paint.color = it.toInt()
      layout.background = drawable
    }

    // Show toast for custom duration

    // Show toast for custom duration

    val toast = Toast(context)
    toast.duration = duration ?: Toast.LENGTH_SHORT
    toast.view = layout

    // Show toast
    toast.show()
  }


  private fun decodeBase64ToBitmap(base64String: String): Bitmap? {
    return try {
      val decodedBytes = Base64.decode(base64String, Base64.DEFAULT)
      BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
