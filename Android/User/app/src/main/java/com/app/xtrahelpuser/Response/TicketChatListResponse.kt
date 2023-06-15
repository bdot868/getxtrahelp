package com.app.xtrahelpuser.Response

data class TicketChatListResponse(
    var adminData: AdminData,
    var `data`: ArrayList<Data>,
    var hookMethod: String,
    var startDate: String
) {
    data class AdminData(
        var email: String,
        var id: String,
        var name: String,
        var profileImageThumbUrl: String,
        var profileImageUrl: String
    )

    data class Data(
        var createdDate: String,
        var createdDateMain: String,
        var description: String,
        var forReply: String,
        var foramted_date: String,
        var id: String,
        var profileimage: String,
        var replyType: String,
        var senderName: String,
        var status: String,
        var thumbprofileimage: String,
        var ticketId: String,
        var time: String
    )
}