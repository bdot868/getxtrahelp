package com.app.xtrahelpcaregiver.Response

import android.os.Parcelable

data class FeedListResponse(
    var `data`: ArrayList<Data>,
    var message: String,
    var status: String,
    var totalPages: String
) {
    data class Data(
        var createdDate: String,
        var createdTime: String,
        var description: String,
        var media: ArrayList<Media>,
        var profileImageThumbUrl: String,
        var profileImageUrl: String,
        var totalFeedComment: String,
        var totalFeedLike: String,
        var isLike: String,
        var userFeedId: String,
        var userFullName: String,
        var userId: String
    ) {
        data class Media(
            var isVideo: String,
            var mediaName: String,
            var mediaNameThumbUrl: String,
            var mediaNameUrl: String,
            var userFeedId: String,
            var userFeedMediaId: String,
            var videoImage: String,
            var videoImageThumbUrl: String,
            var videoImageUrl: String
        ) : Parcelable {
            constructor(parcel: android.os.Parcel) : this(
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!,
                parcel.readString()!!
            ) {
            }

            override fun writeToParcel(parcel: android.os.Parcel, flags: Int) {
                parcel.writeString(isVideo)
                parcel.writeString(mediaName)
                parcel.writeString(mediaNameThumbUrl)
                parcel.writeString(mediaNameUrl)
                parcel.writeString(userFeedId)
                parcel.writeString(userFeedMediaId)
                parcel.writeString(videoImage)
                parcel.writeString(videoImageThumbUrl)
                parcel.writeString(videoImageUrl)
            }

            override fun describeContents(): Int {
                return 0
            }

            companion object CREATOR : Parcelable.Creator<Media> {
                override fun createFromParcel(parcel: android.os.Parcel): Media {
                    return Media(parcel)
                }

                override fun newArray(size: Int): Array<Media?> {
                    return arrayOfNulls(size)
                }
            }
        }
    }
}