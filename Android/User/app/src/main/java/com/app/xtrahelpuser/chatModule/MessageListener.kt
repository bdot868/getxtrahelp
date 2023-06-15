package com.app.xtrahelpuser.chatModule

interface MessageListener {
    fun onConnectSuccess()
    fun onConnectFailed()
    fun onClose()
    fun onMessage(text: String?)
}