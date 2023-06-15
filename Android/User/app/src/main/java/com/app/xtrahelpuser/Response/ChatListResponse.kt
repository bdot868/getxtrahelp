package com.app.xtrahelpuser.Response

import com.google.gson.JsonElement

data class ChatListResponse(
    var `data`: List<Data>,
    var group: Group,
    var hookMethod: String,
    var startDate: String,
    var total_page: String
) {
    data class Data(
        var attachmentRealName: String,
        var createdDate: String,
        var date: String,
        var groupId: String,
        var id: String,
        var message: String,
        var readStatus: String,
        var sender: String,
        var senderImage: String,
        var senderName: String,
        var status: String,
        var suggestedProvider: JsonElement,
        var time: String,
        var type: String
    )

    data class suggestedProvider(
        var id:String,
        var firstName:String,
        var lastName:String,
        var fullName:String,
        var email:String,
        var profileImageUrl:String,
        var profileImageThumbUrl:String,
        var categoryNames:String,
        var ratingAverage:String,
        var status:String,
        var totalJobCompleted:String
    )

    data class Group(
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
        var type: String,
        var unreadMessages: String
    )
}