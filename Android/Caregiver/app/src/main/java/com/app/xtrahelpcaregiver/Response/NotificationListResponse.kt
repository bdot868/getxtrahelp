package com.app.xtrahelpcaregiver.Response

data class NotificationListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var total_page: String
) {
    data class Data(
        var createdDate: String,
        var desc: String,
        var id: String,
        var model: String,
        var model_id: String,
        var send_from: String,
        var send_to: String,
        var senderImage: String,
        var senderName: String,
        var senderRole: String,
        var status: String,
        var thumbSenderImage: String,
        var time: String,
        var title: String,
        var updatedDate: String
    )
}