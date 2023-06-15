package com.app.xtrahelpuser.Response

data class MyFeedBackResponse(val status:String,val message:String,val data:FeedBack)

data class FeedBack(
    val id:String,
    val userId:String,
    val rating:String,
    val feedback:String,
    val updatedDate:String,
    val createdDate:String,
    val status:String,
    )