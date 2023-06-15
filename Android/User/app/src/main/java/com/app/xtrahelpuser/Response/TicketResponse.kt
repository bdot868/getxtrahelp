package com.app.xtrahelpuser.Response

data class TicketResponse(
    val data: ArrayList<Ticket>,
    val message: String,
    val status: String,
    val totalPages: String
)

data class Ticket(
    val closedDate: String,
    val createdDate: String,
    val createdDateSimple: String,
    val description: String,
    val email: String,
    val id: String,
    val lastMsgTime: String,
    val lastReplay: String,
    val name: String,
    val priority: String,
    val reopenDate: String,
    val status: String,
    val title: String,
    val updatedDate: String,
    val userId: String
)