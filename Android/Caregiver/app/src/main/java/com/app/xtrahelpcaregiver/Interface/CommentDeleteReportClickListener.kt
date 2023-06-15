package com.app.xtrahelpcaregiver.Interface

interface CommentDeleteReportClickListener {
    fun reportCommentClick(feedCommentId: String)
    fun deleteCommentClick(userFeedId: String, pos: Int)
}