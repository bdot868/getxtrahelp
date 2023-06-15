package com.app.xtrahelpuser.Request

data class ReopenRequest(
    var data: ReopenData
)

data class ReopenData(
    var langType: String,
    var token: String,
    var ticketId: String
)