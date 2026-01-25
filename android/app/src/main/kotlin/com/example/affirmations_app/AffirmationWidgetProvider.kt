package com.example.affirmations_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class AffirmationWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.affirmation_widget).apply {
                val text = widgetData.getString("affirmation_text", "Open app to load affirmation")
                setTextViewText(R.id.appwidget_text, text)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
