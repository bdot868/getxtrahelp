package com.app.xtrahelpuser.Response

data class TicketDetailResponse(
    var `data`: Data,
    var message: String,
    var status: String
) {
    data class Data(
        var closedDate: String,
        var createdDate: String,
        var createdDateSimple: String,
        var description: String,
        var email: String,
        var id: String,
        var name: String,
        var priority: String,
        var reopenDate: String,
        var status: String,
        var title: String,
        var updatedDate: String,
        var userId: String
    )
}