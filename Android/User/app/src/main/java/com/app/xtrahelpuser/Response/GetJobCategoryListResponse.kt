package com.app.xtrahelpcaregiver.Response

data class GetJobCategoryListResponse(
    val status: String, val message: String, val data: ArrayList<CategoryData>
)

data class CategoryData(
    val jobCategoryId: String,
    val name: String,
    val imageUrl: String,
    val imageThumbUrl: String,
    val description: String,
    val subCategory: ArrayList<SubCategory>,
//    var isSelect: Boolean = false
)

data class SubCategory(val jobSubCategoryId: String, val jobCategoryId: String, val name: String)