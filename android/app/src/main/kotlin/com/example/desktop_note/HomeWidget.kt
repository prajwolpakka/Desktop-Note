package com.example.desktop_note

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class LightWidget : HomeWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.light_layout).apply {
                //Open App on Widget Click
                setOnClickPendingIntent(R.id.widget_container,PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java), 0))
                setTextViewText(R.id.widget_message, widgetData.getString("note", null)?: "1. Create a Note !")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
class DarkWidget : HomeWidgetProvider() {
    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.dark_layout).apply {
                //Open App on Widget Click
                setOnClickPendingIntent(R.id.widget_container,PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java), 0))
                setTextViewText(R.id.widget_message, widgetData.getString("note", null)?: "1. Create a Note !")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}