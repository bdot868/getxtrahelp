package com.app.xtrahelpuser.Response

data class FaqResponse(
    val status: String,
    val message: String,
    val totalPages: String,
    val activeSupportTicketCount: String,
    val data: ArrayList<Faq>
)

data class Faq(
    val id: String,
    val type: String,
    val name: String,
    val description: String,
    val createdDate: String,
    val status: String,
)