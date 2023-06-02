package com.inceptrafay.family_expense_tracker

import com.inceptrafay.family_expense_tracker.WalletAdapter
import com.inceptrafay.family_expense_tracker.CategoryAdapter

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

import kotlinx.serialization.*
import kotlinx.serialization.json.*

@Serializable
data class Wallet(
    val balance: Double,
    val color: String,
    val name: String,
    val id: String,
    val description: String?,
    val is_enabled: Boolean
)

@Serializable
data class Category(
    val color: String,
    val name: String,
    val id: String,
    val is_enabled: Boolean
)

val json = Json { ignoreUnknownKeys = true }

class HomeScreenWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, widgetData: SharedPreferences) {

        // Get the remote views
        val views = RemoteViews(context.packageName, R.layout.home_widget_layout)

        val wallets = widgetData.getStringList("wallets", listOf()).map { json.decodeFromString<Wallet>(it) }

        val walletAdapter = WalletAdapter(context, android.R.layout.wallet_spinner_item, wallets)
        views.setRemoteAdapter(R.id.wallet_spinner, walletAdapter)

        val categories = widgetData.getStringList("categories", listOf()).map { json.decodeFromString<Category>(it) }
        val categoryAdapter = CategoryAdapter(context, android.R.layout.category_spinner_item, categories)
        views.setRemoteAdapter(R.id.category_spinner, categoryAdapter)

        // Set the default date for the date picker
        val calendar = Calendar.getInstance()
        views.setDate(R.id.date_picker, calendar.timeInMillis)

        // Implement a void callback for the save button
        val intent = Intent(context, HomeScreenWidgetProvider::class.java)
        intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(appWidgetId))
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        views.setOnClickPendingIntent(R.id.save_button, pendingIntent)
    }

    private fun showInputDialog(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, widgetData: SharedPreferences) {
        val builder = AlertDialog.Builder(context)
        builder.setTitle("Enter Amount")

        val dialogView = LayoutInflater.from(context).inflate(R.layout.dialog_layout, null)
        builder.setView(dialogView)

        val saveButton = dialogView.findViewById<Button>(R.id.save_button)

        saveButton.setOnClickListener {
            val dialogAmountField = dialogView.findViewById<EditText>(R.id.dialog_amount_field)
            val amount = dialogAmountField.text.toString().toDoubleOrNull() ?: 0.0

            val editor = widgetData.edit()
            editor.putFloat("amount", amount.toFloat())
            editor.apply()

            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
            dialog.dismiss()
        }

        val dialog = builder.create()
        dialog.show()
    }

}
