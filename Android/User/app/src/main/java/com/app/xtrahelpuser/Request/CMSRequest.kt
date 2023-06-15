package com.app.xtrahelpuser.Request

data class CMSRequest(val data: CMSData)

data class CMSData(val langType: String, val pageId: String)