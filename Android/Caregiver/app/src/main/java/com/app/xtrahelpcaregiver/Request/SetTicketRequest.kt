package com.app.xtrahelpcaregiver.Request

data class SetTicketRequest(
    var data: SetTicketData
)

data class SetTicketData(
    var langType: String,
    var token: String,
    var title: String,
    var description: String
)
