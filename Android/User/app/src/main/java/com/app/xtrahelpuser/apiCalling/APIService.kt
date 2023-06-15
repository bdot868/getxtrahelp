package com.app.xtrahelpcaregiver.apiCalling

import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Response.*
import com.app.xtrahelpuser.Request.*
import com.app.xtrahelpuser.Response.*
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.Part

interface APIService {

    @POST("auth/signup")
    fun signup(@Body request: SignUpRequest): Call<CommonResponse?>

    @POST("auth/verify")
    fun verify(@Body request: VerificationRequest): Call<LoginResponse?>

    @POST("auth/resendVerification")
    fun resendVerification(@Body request: ResendCodeVerifyRequest): Call<CommonResponse?>

    @POST("auth/forgotPassword")
    fun forgotPassword(@Body request: ResendCodeVerifyRequest): Call<CommonResponse?>

    @POST("auth/login")
    fun login(@Body request: LoginRequest): Call<LoginResponse?>

    @POST("auth/socialLogin")
    fun socialLogin(@Body loginRequest: SocialLoginRequest): Call<LoginResponse?>

    @POST("auth/checkForgotCode")
    fun checkForgotCode(@Body request: CheckForgotCodeRequest): Call<CommonResponse?>

    @POST("auth/resetPassword")
    fun resetPassword(@Body request: ResetPasswordRequest): Call<CommonResponse?>

    @POST("auth/changePassword")
    fun changePassword(@Body request: ChangePasswordRequest): Call<CommonResponse?>

    @POST("common/getCommonData")
    fun getCommonData(@Body request: CommonDataRequest): Call<CommonDataResponse?>

    @POST("common/getJobCategoryList")
    fun getJobCategoryList(@Body request: LangTokenSearchRequest): Call<GetJobCategoryListResponse?>

    @POST("auth/logout")
    fun logout(@Body request: LangTokenRequest): Call<CommonResponse?>


    // common
    @POST("common/faq")
    fun faq(@Body request: FaqRequest): Call<FaqResponse?>

    @POST("common/faqDetails")
    fun faqDetails(@Body request: FaqDetailRequest): Call<FaqDetailResponse?>

    @POST("common/setAppFeedback")
    fun setAppFeedback(@Body request: SetFeedBackRequest): Call<CommonResponse?>

    @POST("common/getMyAppFeedback")
    fun getMyAppFeedback(@Body request: LangTokenRequest): Call<MyFeedBackResponse?>

    @POST("common/getCMS")
    fun getCMS(@Body request: CMSRequest): Call<CMSResponse?>

    @POST("common/getNotificationsList")
    fun getNotificationsList(@Body logoutRequest: CaregiverTransactionRequest?): Call<NotificationListResponse?>

    @POST("common/getUnreadNotificationsCount")
    fun getUnreadNotificationsCount(@Body logoutRequest: LangTokenRequest?): Call<NotificationCountResponse?>

    //Support
    @POST("common/getTicket")
    fun getTicket(@Body request: GetTicketRequest): Call<TicketResponse?>

    @POST("common/setTicket")
    fun setTicket(@Body request: SetTicketRequest): Call<CommonResponse?>

    @POST("common/reopenTicket")
    fun reopenTicket(@Body request: ReopenRequest): Call<CommonResponse?>

    @POST("common/getTicketDetail")
    fun getTicketDetail(@Body request: ReopenRequest): Call<TicketDetailResponse?>


    //Job
    @POST("job/saveUserJob")
    fun saveUserJob(@Body request: SaveUserJobRequest): Call<CommonResponse?>

    @POST("job/getUserRelatedJobList")
    fun getUserRelatedJobList(@Body request: UserRelatedJobRequest): Call<UserRelatedJobResponse?>

    @POST("job/getUserSubstituteJobRequestList")
    fun getUserSubstituteJobRequestList(@Body request: SubstituteJobRequest): Call<SubstituteListResponse?>

    @POST("job/getUserRelatedJobDetail")
    fun getUserRelatedJobDetail(@Body request: UserRelatedJobDetailRequest): Call<UserRelatedJobDetailResponse?>

    @POST("job/cancelMyPostedJob")
    fun cancelMyPostedJob(@Body request: CancelJobRequest): Call<CommonResponse?>

    @POST("job/acceptSubstituteJobRequestByUser")
    fun acceptSubstituteJobRequestByUser(@Body request: AcceptRejectSubJobRequest): Call<CommonResponse?>
    
    @POST("job/rejectSubstituteJobRequestByUser")
    fun rejectSubstituteJobRequestByUser(@Body request: AcceptRejectSubJobRequest): Call<CommonResponse?>

    @POST("job/findCaregivers")
    fun findCaregivers(@Body request: FindCaregiverRequest): Call<FindCaregiverResponse?>

    @POST("job/getMyJobRelatedCaregiver")
    fun getMyJobRelatedCaregiver(@Body request: CaregiverJobRelatedRequest): Call<FindCaregiverResponse?>

    @POST("job/getUserDashboard")
    fun getUserDashboard(@Body request: UserDashboardRequest): Call<UserDashboardResponse?>

    @POST("job/getCaregiverProfile")
    fun getCaregiverProfile(@Body request: CaregiverProfileRequest): Call<CaregiverProfileResponse?>

    @POST("job/applicantApplyJobQueAnsList")
    fun applicantApplyJobQueAnsList(@Body request: QuestionAnswerRequest): Call<QuestionAnswerResponse?>

    @POST("job/requestJobImageVideo")
    fun requestJobImageVideo(@Body request: RequestMediaRequest): Call<CommonResponse?>

    @POST("job/setOngoingJobReview")
    fun setOngoingJobReview(@Body langToken: OnGoingJobReviewRequest): Call<CommonResponse?>

    @POST("job/sendJobExtraHoursRequest")
    fun sendJobExtraHoursRequest(@Body langToken: SendJobExtraHrRequest): Call<CommonResponse?>


    
    //Resources
    @POST("resources/getResource")
    fun getResource(@Body request: GetResourceRequest): Call<ResourceResponse?>

    @POST("resources/getResourceDetail")
    fun getResourceDetail(@Body request: ResourceDetailRequest): Call<ResourceDetailResponse?>


    //Users
    @POST("users/updateProfileStatus")
    fun updateProfileStatus(@Body request: UpdateProfileStatusRequest): Call<LoginResponse?>

    @POST("users/savePersonalDetails")
    fun savePersonalDetails(@Body request: SavePersonalDetailRequest): Call<LoginResponse?>

    @POST("users/saveAboutLoved")
    fun saveAboutLoved(@Body request: SaveAboutLovedRequest): Call<LoginResponse?>

    @POST("users/getUserInfo")
    fun getUserInfo(@Body request: LangTokenRequest): Call<LoginResponse?>

    @POST("users/getAboutLoved")
    fun getAboutLoved(@Body request: LangTokenRequest): Call<GetLovedOneResponse?>

    @POST("users/saveAddressOrLocation")
    fun saveAddressOrLocation(@Body request: SaveAddressRequest): Call<LoginResponse?>

    @POST("users/savePersonalDetails")
    fun savePersonalDetails(@Body langToken: NotificationSettingRequest): Call<CommonResponse?>

    @POST("users/getCaregiverAvailabilityNew")
    fun getCaregiverAvailabilityNew(@Body langToken: CaregiverAvailabilityRequest): Call<CaregiverAvailabilityResponse?>


    //Job
    @POST("job/getMyPostedJobApplicants")
    fun getMyPostedJobApplicants(@Body request: PostedJobDetailRequest): Call<PostedJobAplicantResponse?>

    @POST("job/getMyPostedJob")
    fun getMyPostedJob(@Body request: GetPostedJobRequest): Call<GetMyPostedJobResponse?>

    @POST("job/getMyPostedJobDetail")
    fun getMyPostedJobDetail(@Body request: PostedJobDetailRequest): Call<PostedJobDetailResponse?>

    @POST("job/acceptCaregiverJobRequest")
    fun acceptCaregiverJobRequest(@Body request: AcceptDeclineRequest): Call<CommonResponse?>

    @POST("job/rejectCaregiverJobRequest")
    fun rejectCaregiverJobRequest(@Body request: AcceptDeclineRequest): Call<CommonResponse?>

    @POST("job/setJobReview")
    fun setJobReview(@Body request: SetJobReviewRequest): Call<CommonResponse?>


    //Payment
    @POST("payment/getUserCardList")
    fun getUserCardList(@Body request: LangTokenRequest): Call<GetCardListResponse?>

    @POST("payment/saveUserCard")
    fun saveUserCard(@Body request: SaveCardRequest): Call<CommonResponse?>

    @POST("payment/removeUserCard")
    fun removeUserCard(@Body request: RemoveCardRequest): Call<CommonResponse?>

    //Feed
    @POST("feed/saveUserFeed")
    fun saveUserFeed(@Body request: SaveFeedRequest): Call<CommonResponse?>

    @POST("feed/getUserFeedList")
    fun getUserFeedList(@Body request: FeedListRequest): Call<FeedListResponse?>

    @POST("feed/likeUnlikeFeed")
    fun likeUnlikeFeed(@Body request: LikeUnlikeRequest): Call<CommonResponse?>

    @POST("feed/getFeedLikeUserList")
    fun getFeedLikeUserList(@Body request: FeedLikeUserListRequest): Call<FeedLikeListResponse?>

    @POST("feed/feedReport")
    fun feedReport(@Body request: ReportFeedRequest): Call<CommonResponse?>

    @POST("feed/feedCommentReport")
    fun feedCommentReport(@Body request: CommentReportRequest): Call<CommonResponse?>

    @POST("feed/deleteFeedComment")
    fun deleteFeedComment(@Body request: DeleteCommentRequest): Call<CommonResponse?>

    @POST("feed/deleteFeed")
    fun deleteFeed(@Body request: DeleteFeedRequest): Call<CommonResponse?>

    @POST("feed/getFeedCommentList")
    fun getFeedCommentList(@Body request: CommentListRequest): Call<CommentListResponse?>

    @POST("feed/feedComment")
    fun feedComment(@Body request: SetCommentRequest): Call<CommonResponse?>

    @Multipart
    @POST("common/mediaUpload")
    fun mediaUpload(
        @Part("langType") fullName: RequestBody?,
        @Part files: MultipartBody.Part
    ): Call<MediaUploadResponse?>?

}