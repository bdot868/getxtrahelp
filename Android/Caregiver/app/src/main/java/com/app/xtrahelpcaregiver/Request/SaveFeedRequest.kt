package com.app.xtrahelpcaregiver.Request

data class SaveFeedRequest(
    var `data`: Data
) {
    data class Data(
        var langType: String,
        var token: String,
        var description: String,
        var media: ArrayList<Media>,
        var userFeedId: String
    )
}
data class Media(
    var mediaName: String,
    var videoImage: String,
)