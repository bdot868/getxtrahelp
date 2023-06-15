package com.app.xtrahelpcaregiver.Response

data class CaregiverRelatedResponse(
    var `data`: ArrayList<Job>,
    var message: String,
    var status: String,
    var totalPages: String,
    var totalWorkTime: String
)