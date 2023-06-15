package com.app.xtrahelpcaregiver.Request

data class GetTicketRequest(
    val data: GetTicket
)

data class GetTicket(
    val langType: String,
    val token: String,
    val page: Int,
    val limit: String
)