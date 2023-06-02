import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.TextView

class CategoryAdapter(context: Context, resource: Int, items: List<Category>) : ArrayAdapter<Category>(context, resource, items) {

    // Override the getView method to display the category name in the spinner view
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        // Get the category object at the current position
        val category = getItem(position)

        // Inflate the custom layout for the spinner item if needed
        val view = convertView ?: LayoutInflater.from(context).inflate(R.layout.category_spinner_item, parent, false)

        // Get the text view from the custom layout
        val textView = view.findViewById<TextView>(R.id.category_spinner_text)

        // Set the text view with the category name
        textView.text = category?.name

        // Return the custom view
        return view
    }

    // Override the getDropDownView method to display the category name and other details in the drop down list
    override fun getDropDownView(position: Int, convertView: View?, parent: ViewGroup): View {
        // Get the category object at the current position
        val category = getItem(position)

        // Inflate the custom layout for the drop down item if needed
        val view = convertView ?: LayoutInflater.from(context).inflate(R.layout.category_spinner_dropdown_item, parent, false)

        // Get the views from the custom layout
        val imageView = view.findViewById<ImageView>(R.id.category_spinner_image)
        val nameView = view.findViewById<TextView>(R.id.category_spinner_name)

        // Set the views with the category details
        imageView.setBackgroundColor(Color.parseColor(category?.color)) // Set the image view background color with the category color
        nameView.text = category?.name // Set the name view with the category name

        // Return the custom view
        return view
    }
}
