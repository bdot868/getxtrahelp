package com.app.xtrahelpuser.Adapter

import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.TextView
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.app.xtrahelpcaregiver.Response.LovedCategory
import com.app.xtrahelpcaregiver.Response.LovedDisabilitiesType
import com.app.xtrahelpcaregiver.Response.LovedSpecialities
import com.app.xtrahelpuser.Interface.*
import com.app.xtrahelpuser.R
import com.app.xtrahelpuser.Request.LovedOne
import com.app.xtrahelpuser.Ui.AboutLovedOneActivity

class LovedOneAdapter(
    private val context: Context,
    val lovedOneList: ArrayList<LovedOne>,
    val lovedDisabilitiesTypeList: ArrayList<LovedDisabilitiesType>,
    val lovedCategoryList: ArrayList<LovedCategory>,
    val lovedSpecialitiesList: ArrayList<LovedSpecialities>
) :
    RecyclerView.Adapter<LovedOneAdapter.ViewHolder>(), SpecialitiesClass, LovedCategoryClick {
    var selectedCategoryList: ArrayList<String> = ArrayList()

    lateinit var categoryAdapter: CategoriesLovedAdapter
    lateinit var specialitiesAdapter: SpecialitiesAdapter
    lateinit var selectDisabilitiesClick: SelectDisabilitiesClick
    lateinit var selectBehaviorVerbalClick: SelectBehaviorVerbalClick

    lateinit var addCategoryInClass: AddCategoryInClass
    lateinit var specialitiesClass: SpecialitiesClass

    lateinit var etType: EditText

    lateinit var holder: ViewHolder
    var mainPos: Int = -1
    var isAdd: Boolean = false
    var categoryId: String = ""

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtDisabilities: TextView = view.findViewById(R.id.txtDisabilities)
        val txtTitle: TextView = view.findViewById(R.id.txtTitle)
        val etDescription: EditText = view.findViewById(R.id.etDescription)
        val recyclerCategories: RecyclerView = view.findViewById(R.id.recyclerCategories)
        val etType: EditText = view.findViewById(R.id.etType)
        val txtBehavioral: TextView = view.findViewById(R.id.txtBehavioral)
        val txtNonBehavioral: TextView = view.findViewById(R.id.txtNonBehavioral)
        val txtVerbal: TextView = view.findViewById(R.id.txtVerbal)
        val txtYes: TextView = view.findViewById(R.id.txtYes)
        val txtNo: TextView = view.findViewById(R.id.txtNo)
        val txtNonVerbal: TextView = view.findViewById(R.id.txtNonVerbal)
        val etAllergies: EditText = view.findViewById(R.id.etAllergies)
        val recyclerSpecialities: RecyclerView = view.findViewById(R.id.recyclerSpecialities)


    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LovedOneAdapter.ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.adapter_loved_one, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        this.holder = holder

        if (lovedOneList[position].lovedCategory.contains("")) {
            holder.etType.visibility = View.VISIBLE
        } else {
            holder.etType.setText("")
            AboutLovedOneActivity.lovedOneList[position].lovedOtherCategoryText = ""
            holder.etType.visibility = View.GONE
        }

        holder.etDescription.setText(lovedOneList[position].lovedAboutDesc)
        holder.etAllergies.setText(lovedOneList[position].allergies)
        holder.etType.setText(lovedOneList[position].lovedOtherCategoryText)

        if (lovedOneList[position].isLovedOne) {
            selectAllergies(holder.txtYes, holder)
            holder.etAllergies.visibility = View.VISIBLE
            AboutLovedOneActivity.lovedOneList[position].isLovedOne = true
        } else {
            holder.etAllergies.setText("")
            selectAllergies(holder.txtNo, holder)
            holder.etAllergies.visibility = View.GONE
            AboutLovedOneActivity.lovedOneList[position].isLovedOne = false
        }
        
        categoryAdapter =
            CategoriesLovedAdapter(
                context,
                lovedCategoryList,
                selectedCategoryList,
                lovedOneList,
                holder
            )
        holder.recyclerCategories.layoutManager = LinearLayoutManager(context)
        holder.recyclerCategories.isNestedScrollingEnabled = false
        holder.recyclerCategories.adapter = categoryAdapter
        categoryAdapter.lovedCategoryClick(this)

        specialitiesAdapter =
            SpecialitiesAdapter(context, lovedSpecialitiesList, lovedOneList, holder)
        holder.recyclerSpecialities.layoutManager = GridLayoutManager(context, 2)
        holder.recyclerSpecialities.isNestedScrollingEnabled = false
        holder.recyclerSpecialities.adapter = specialitiesAdapter
        specialitiesAdapter.specialitiesClass(this)


        holder.txtTitle.text = "Recipient " + (position + 1).toString()

        holder.etType.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                AboutLovedOneActivity.lovedOneList[position].lovedOtherCategoryText =
                    holder.etType.text.toString().trim()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
//                addCategoryInClass.onAddCategoryClass(
//                    mainPos,
//                    "",
//                    isAdd,
//                    holder.etType.text.toString().trim()
//                )
            }
        })

        holder.etDescription.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                AboutLovedOneActivity.lovedOneList[position].lovedAboutDesc =
                    holder.etDescription.text.toString().trim()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })

        holder.etAllergies.addTextChangedListener(object : TextWatcher {
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
                AboutLovedOneActivity.lovedOneList[position].allergies =
                    holder.etAllergies.text.toString().trim()
            }

            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun afterTextChanged(s: Editable) {
            }
        })


        for (i in lovedDisabilitiesTypeList.indices) {
            if (lovedDisabilitiesTypeList[i].lovedDisabilitiesTypeId == lovedOneList[position].lovedDisabilitiesTypeId) {
                holder.txtDisabilities.text = lovedDisabilitiesTypeList[i].name
            }
        }

        if (lovedOneList[position].lovedBehavioral == "1" || lovedOneList[position].lovedBehavioral == "") {
            selectBehavioral(holder.txtBehavioral, holder)
        } else {
            selectBehavioral(holder.txtNonBehavioral, holder)
        }

        if (lovedOneList[position].lovedVerbal == "1" || lovedOneList[position].lovedVerbal == "") {
            selectVerbal(holder.txtVerbal, holder)
        } else {
            selectVerbal(holder.txtNonVerbal, holder)
        }

        holder.txtDisabilities.setOnClickListener {
            selectDisabilitiesClick.onDisabilitiesClick(position)
        }

        holder.txtBehavioral.setOnClickListener {
            selectBehavioral(holder.txtBehavioral, holder)
            selectBehaviorVerbalClick.behaviorVerbalClick(position, "behavioral", true)
        }

        holder.txtNonBehavioral.setOnClickListener {
            selectBehavioral(holder.txtNonBehavioral, holder)
            selectBehaviorVerbalClick.behaviorVerbalClick(position, "behavioral", false)
        }

        holder.txtVerbal.setOnClickListener {
            selectVerbal(holder.txtVerbal, holder)
            selectBehaviorVerbalClick.behaviorVerbalClick(position, "verbal", true)
        }

        holder.txtNonVerbal.setOnClickListener {
            selectVerbal(holder.txtNonVerbal, holder)
            selectBehaviorVerbalClick.behaviorVerbalClick(position, "verbal", false)
        }


        holder.txtYes.setOnClickListener {
            selectAllergies(holder.txtYes, holder)
            holder.etAllergies.visibility = View.VISIBLE
            AboutLovedOneActivity.lovedOneList[position].isLovedOne = true
        }

        holder.txtNo.setOnClickListener {
            holder.etAllergies.setText("")
            selectAllergies(holder.txtNo, holder)
            holder.etAllergies.visibility = View.GONE
            AboutLovedOneActivity.lovedOneList[position].isLovedOne = false
        }
    }

    private fun selectBehavioral(text: TextView, viewHolder: ViewHolder) {
        viewHolder.txtBehavioral.setTextColor(context.resources.getColor(R.color.txtLightPurple))
        viewHolder.txtBehavioral.background = context.resources.getDrawable(R.drawable.unselect_bg)
        viewHolder.txtNonBehavioral.setTextColor(context.resources.getColor(R.color.txtLightPurple))
        viewHolder.txtNonBehavioral.background =
            context.resources.getDrawable(R.drawable.unselect_bg)

        text.setTextColor(context.resources.getColor(R.color.txtOrange))
        text.background = context.resources.getDrawable(R.drawable.select_bg)
    }

    private fun selectVerbal(text: TextView, viewHolder: ViewHolder) {
        viewHolder.txtVerbal.setTextColor(context.resources.getColor(R.color.txtLightPurple))
        viewHolder.txtVerbal.background = context.resources.getDrawable(R.drawable.unselect_bg)
        viewHolder.txtNonVerbal.setTextColor(context.resources.getColor(R.color.txtLightPurple))
        viewHolder.txtNonVerbal.background = context.resources.getDrawable(R.drawable.unselect_bg)

        text.setTextColor(context.resources.getColor(R.color.txtOrange))
        text.background = context.resources.getDrawable(R.drawable.select_bg)
    }

    private fun selectAllergies(text: TextView, viewHolder: ViewHolder) {
        viewHolder.txtYes.setTextColor(context.resources.getColor(R.color.txtLightPurple))
        viewHolder.txtYes.background = context.resources.getDrawable(R.drawable.unselect_bg)
        viewHolder.txtNo.setTextColor(context.resources.getColor(R.color.txtLightPurple))
        viewHolder.txtNo.background = context.resources.getDrawable(R.drawable.unselect_bg)

        text.setTextColor(context.resources.getColor(R.color.txtOrange))
        text.background = context.resources.getDrawable(R.drawable.select_bg)
    }

    override fun getItemCount(): Int {
        return lovedOneList.size
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    fun selectDisabilitiesClick(selectDisabilitiesClick: SelectDisabilitiesClick) {
        this.selectDisabilitiesClick = selectDisabilitiesClick
    }

    fun selectBehaviorVerbalClick(selectBehaviorVerbalClick: SelectBehaviorVerbalClick) {
        this.selectBehaviorVerbalClick = selectBehaviorVerbalClick
    }

    fun addCategoryInClass(addCategoryInClass: AddCategoryInClass) {
        this.addCategoryInClass = addCategoryInClass
    }

    fun specialitiesClass(specialitiesClass: SpecialitiesClass) {
        this.specialitiesClass = specialitiesClass
    }

    override fun onLovedCategoryClick(pos: Int, mainPos: Int, categoryId: String, isAdd: Boolean) {
        this.mainPos = mainPos
        this.isAdd = isAdd
        if (categoryId.isEmpty()) {
            notifyItemChanged(mainPos)
        }
        addCategoryInClass.onAddCategoryClass(
            mainPos,
            categoryId,
            isAdd,
            holder.etType.text.toString().trim()
        )
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun onAddSpecialitiesClass(mainPos: Int, selectedCategory: String?, isAdd: Boolean) {
        specialitiesClass.onAddSpecialitiesClass(mainPos, selectedCategory, isAdd)
    }


}