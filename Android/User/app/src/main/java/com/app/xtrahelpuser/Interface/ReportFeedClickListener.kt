package com.app.xtrahelpuser.Interface

interface ReportFeedClickListener {
    fun reportClick(feedId: String)
    fun deleteFeedClick(feedId: String, pos: Int)
}