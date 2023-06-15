package com.app.xtrahelpcaregiver.Ui

import android.content.ContentValues
import android.content.DialogInterface
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import com.app.xtrahelpcaregiver.Adapter.MessageListAdapter
import com.app.xtrahelpcaregiver.Interface.RemoveClick
import com.app.xtrahelpcaregiver.R
import com.app.xtrahelpcaregiver.Response.ChatInBoxResponse
import com.app.xtrahelpcaregiver.Response.ChatListResponse
import com.app.xtrahelpcaregiver.Utils.Const
import com.app.xtrahelpcaregiver.Utils.JsonUtils
import com.app.xtrahelpcaregiver.chatModule.WebSocketManager
import com.bumptech.glide.Glide
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_chatting.*

import kotlinx.android.synthetic.main.activity_message.*
import kotlinx.android.synthetic.main.activity_message.etSearch
import kotlinx.android.synthetic.main.activity_message.recyclerMessage
import kotlinx.android.synthetic.main.fragment_my_job.*
import kotlinx.android.synthetic.main.header.*
import kotlinx.android.synthetic.main.header.arrowBack
import kotlinx.android.synthetic.main.header.txtTitle
import org.json.JSONObject
import java.lang.Exception

class MessageActivity : BaseActivity(), RemoveClick {

    lateinit var messageAdapter: MessageListAdapter

    var chatInBoxList: ArrayList<ChatInBoxResponse.Data> = ArrayList()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_message)
        init()
    }

    private fun init() {
        arrowBack.setOnClickListener(this)
        txtTitle.text = "Messages"

        messageAdapter = MessageListAdapter(activity, chatInBoxList)
        recyclerMessage.layoutManager = LinearLayoutManager(activity)
        recyclerMessage.isNestedScrollingEnabled = false
        recyclerMessage.adapter = messageAdapter
        messageAdapter.setOnRemoveClick(this)

        etSearch.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable) {
                if (TextUtils.isEmpty(s.toString().trim { it <= ' ' })) {
                    chatinboxList(etSearch.text.toString().trim())
                }
            }
        })

        etSearch.setOnEditorActionListener(TextView.OnEditorActionListener { v, i, event ->
            if (i == EditorInfo.IME_ACTION_SEARCH) {
                utils.hideKeyBoardFromView(activity)
                chatinboxList(etSearch.text.toString().trim())
                return@OnEditorActionListener true
            }
            false
        })
        

    }

    override fun onResume() {
        super.onResume()
        chatinboxList("")
    }
    override fun onClick(v: View?) {
        super.onClick(v)
        when (v?.id) {
            R.id.arrowBack -> onBackPressed()
        }
    }

    private fun chatinboxList(search: String) {
        utils.showProgress(activity)
        val user = JSONObject().apply {
            put(Const.hookMethod, Const.chatinbox)
            put("type", "1")
            put("search", search)
        }
        Log.e(ContentValues.TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))
    }

    private fun removechatmessagelist(id: String) {
//        utils.showProgress(activity)
        val user = JSONObject().apply {
            put(Const.hookMethod, Const.removechatmessagelist)
            put("id", id)
        }
        Log.e(ContentValues.TAG, "123: $user")
        WebSocketManager.sendMessage(JsonUtils.toJson(user))
    }

    override fun onMessage(text: String?) {
        try {
            val jsonObject = JSONObject(text)
            Log.e(ContentValues.TAG, "onMessage: $jsonObject")

            if (jsonObject.getString(Const.hookMethod).equals(Const.chatinbox)) {
                val chatInboxList = Gson().fromJson(text, ChatInBoxResponse::class.java)
                runOnUiThread(Runnable {
                    if (chatInboxList.data.isEmpty()) {
                        txtDataNotFound.visibility = View.VISIBLE
                        txtDataNotFound.text = "No chat found"
                        recyclerMessage.visibility = View.GONE
                    } else {
                        txtDataNotFound.visibility = View.GONE
                        recyclerMessage.visibility = View.VISIBLE
                    }

                    chatInBoxList.clear()
                    chatInBoxList.addAll(chatInboxList.data)
                    messageAdapter.notifyDataSetChanged()

                    utils.dismissProgress()
                })
            } else if (jsonObject.getString(Const.hookMethod).equals(Const.removechatmessagelist)) {
                runOnUiThread(Runnable {
                    chatinboxList("")
                })
            }
        } catch (e: Exception) {
            Log.e(ContentValues.TAG, "onMessage: $e")
        }
    }

    override fun onRemoveClick(pos: Int) {

    }

    override fun onRemoveDisabilityClick(id: String?) {
        MaterialAlertDialogBuilder(this)
            .setCancelable(false)
            .setMessage("Are you sure you want to delete this conversation?")
            .setPositiveButton(
                "Yes"
            ) { dialogInterface: DialogInterface?, i: Int ->
                removechatmessagelist(id!!)
            }
            .setNegativeButton(
                "No"
            ) { dialogInterface: DialogInterface, i: Int -> dialogInterface.dismiss() }
            .show()
    }


}