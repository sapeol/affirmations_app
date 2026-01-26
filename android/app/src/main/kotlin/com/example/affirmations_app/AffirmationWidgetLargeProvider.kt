package com.example.affirmations_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.Shader
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class AffirmationWidgetLargeProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.affirmation_widget_large).apply {
                val text = widgetData.getString("affirmation_text", "Open app to load affirmation")
                val persona = widgetData.getString("persona_name", "DELUSIONS")
                val statusMsg = when(persona?.lowercase()) {
                    "overthinker" -> "ANALYZING VOID..."
                    "adhd brain" -> "SQUIRREL DETECTED."
                    "burnt out" -> "CRITICAL FAILURE."
                    "builder" -> "SHIPPING BUGS..."
                    "striver" -> "CHASING GHOSTS."
                    else -> "STAY DELUSIONAL"
                }
                
                setTextViewText(R.id.appwidget_text, text)
                setTextViewText(R.id.appwidget_persona, "FROM $persona")
                setTextViewText(R.id.appwidget_footer, statusMsg)
                
                try {
                    val textColor = Color.parseColor(textColorStr)
                    val colorStart = Color.parseColor(colorStartStr)
                    val colorEnd = Color.parseColor(colorEndStr)

                    setTextColor(R.id.appwidget_text, textColor)
                    setTextColor(R.id.appwidget_persona, textColor)
                    setTextColor(R.id.appwidget_footer, textColor)
                    
                    // Create background bitmap
                    val width = 600
                    val height = 600
                    val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                    val canvas = Canvas(bitmap)
                    val paint = Paint(Paint.ANTI_ALIAS_FLAG)
                    
                    if (themeName == "brutalist") {
                        paint.color = textColor
                        canvas.drawRect(0f, 0f, width.toFloat(), height.toFloat(), paint)
                        
                        paint.color = colorStart
                        canvas.drawRect(12f, 12f, width.toFloat() - 12f, height.toFloat() - 12f, paint)
                    } else {
                        val shader = LinearGradient(
                            0f, 0f, width.toFloat(), height.toFloat(),
                            colorStart, colorEnd,
                            Shader.TileMode.CLAMP
                        )
                        paint.shader = shader
                        val rect = RectF(0f, 0f, width.toFloat(), height.toFloat())
                        canvas.drawRoundRect(rect, 60f, 60f, paint)
                    }
                    
                    setImageViewBitmap(R.id.appwidget_background, bitmap)
                } catch (e: Exception) {
                    // Fallback
                }
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}