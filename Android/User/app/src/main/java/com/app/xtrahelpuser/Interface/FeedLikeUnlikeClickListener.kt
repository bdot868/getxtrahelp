package com.app.xtrahelpuser.Interface

interface FeedLikeUnlikeClickListener {
    fun onFeedLikeUnlikeClick(feedId: String,pos:Int,isLike:Boolean)
}