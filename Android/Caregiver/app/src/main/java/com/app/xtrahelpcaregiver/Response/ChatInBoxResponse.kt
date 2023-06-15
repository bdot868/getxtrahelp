package com.app.xtrahelpcaregiver.Response

data class ChatInBoxResponse(
    var `data`: ArrayList<Data>,
    var hookMethod: String
) {
    data class Data(
        var friendUserId: String,
        var groupType: String,
        var id: String,
        var image: String,
        var isOnline: String,
        var message: String,
        var messageDate: String,
        var messageId: String,
        var messageStatus: String,
        var name: String,
        var sender: String,
        var thumbImage: String,
        var time: String,
        var type: String,
        var unreadMessages: String
    )
}