package com.app.xtrahelpcaregiver.Response

data class FaqResponse(
    val status: String,
    val message: String,
    val totalPages: String,
    val data: ArrayList<Faq>,
    val activeSupportTicketCount: String
)

data class Faq(
    val id: String,
    val type: String,
    val name: String,
    val description: String,
    val createdDate: String,
    val status: String,
)