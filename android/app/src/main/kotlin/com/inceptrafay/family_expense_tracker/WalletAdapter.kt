import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.TextView

class WalletAdapter(context: Context, resource: Int, items: List<Wallet>) : ArrayAdapter<Wallet>(context, resource, items) {

    // Override the getView method to display the wallet name in the spinner view
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        // Get the wallet object at the current position
        val wallet = getItem(position)

        // Inflate the custom layout for the spinner item if needed
        val view = convertView ?: LayoutInflater.from(context).inflate(R.layout.wallet_spinner_item, parent, false)

        // Get the text view from the custom layout
        val textView = view.findViewById<TextView>(R.id.wallet_spinner_text)

        // Set the text view with the wallet name
        textView.text = wallet?.name

        // Return the custom view
        return view
    }

    // Override the getDropDownView method to display the wallet name and other details in the drop down list
    override fun getDropDownView(position: Int, convertView: View?, parent: ViewGroup): View {
        // Get the wallet object at the current position
        val wallet = getItem(position)

        // Inflate the custom layout for the drop down item if needed
        val view = convertView ?: LayoutInflater.from(context).inflate(R.layout.wallet_spinner_dropdown_item, parent, false)

        // Get the views from the custom layout
        val imageView = view.findViewById<ImageView>(R.id.wallet_spinner_image)
        val nameView = view.findViewById<TextView>(R.id.wallet_spinner_name)
        val balanceView = view.findViewById<TextView>(R.id.wallet_spinner_balance)

        // Set the views with the wallet details
        imageView.setBackgroundColor(Color.parseColor(wallet?.color)) // Set the image view background color with the wallet color
        nameView.text = wallet?.name // Set the name view with the wallet name
        balanceView.text = wallet?.balance.toString() // Set the balance view with the wallet balance

        // Return the custom view
        return view
    }
}
