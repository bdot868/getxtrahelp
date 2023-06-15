package com.app.xtrahelpcaregiver.Response

data class GetJobCategoryListResponse(
    val status: String, val message: String, val data: ArrayList<CategoryData>
)

data class CategoryData(
    val jobCategoryId: String,
    val name: String,
    val imageUrl: String,
    val imageThumbUrl: String,
    var isSelect: Boolean = false
)