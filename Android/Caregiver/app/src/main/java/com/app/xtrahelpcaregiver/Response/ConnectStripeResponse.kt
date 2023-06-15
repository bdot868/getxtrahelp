package com.app.xtrahelpcaregiver.Response

data class ConnectStripeResponse(
    var status:String,
    var message:String,
    var accId:String,
    var url:String)