package com.app.xtrahelpcaregiver.apiCalling

import com.app.xtrahelpcaregiver.Request.*
import com.app.xtrahelpcaregiver.Response.*
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.Part

interface APIService {

    @POST("auth/signup")
    fun signup(@Body signUpRequest: SignUpRequest): Call<CommonResponse?>

    @POST("auth/verify")
    fun verify(@Body verificationRequest: VerificationRequest): Call<LoginResponse?>

    @POST("auth/resendVerification")
    fun resendVerification(@Body resendCodeVerifyRequest: ResendCodeVerifyRequest): Call<CommonResponse?>

    @POST("auth/forgotPassword")
    fun forgotPassword(@Body resendCodeVerifyRequest: ResendCodeVerifyRequest): Call<CommonResponse?>

    @POST("auth/login")
    fun login(@Body loginRequest: LoginRequest): Call<LoginResponse?>

    @POST("auth/socialLogin")
    fun socialLogin(@Body loginRequest: SocialLoginRequest): Call<LoginResponse?>

    @POST("auth/checkForgotCode")
    fun checkForgotCode(@Body checkForgotCodeRequest: CheckForgotCodeRequest): Call<CommonResponse?>

    @POST("auth/resetPassword")
    fun resetPassword(@Body resetPasswordRequest: ResetPasswordRequest): Call<CommonResponse?>

    @POST("auth/changePassword")
    fun changePassword(@Body changePasswordRequest: ChangePasswordRequest): Call<CommonResponse?>

    @POST("common/getCommonData")
    fun getCommonData(@Body commonDataRequest: CommonDataRequest): Call<CommonDataResponse?>

    @POST("auth/logout")
    fun logout(@Body logOutRequest: LangTokenRequest): Call<CommonResponse?>


    //common
    @POST("common/getJobCategoryList")
    fun getJobCategoryList(@Body langToken: LangTokenSearchRequest): Call<GetJobCategoryListResponse?>

    @POST("common/faq")
    fun faq(@Body faqRequest: FaqRequest): Call<FaqResponse?>

    @POST("common/faqDetails")
    fun faqDetails(@Body faqDetailRequest: FaqDetailRequest): Call<FaqDetailResponse?>

    @POST("common/setAppFeedback")
    fun setAppFeedback(@Body setFeedBackRequest: SetFeedBackRequest): Call<CommonResponse?>

    @POST("common/getMyAppFeedback")
    fun getMyAppFeedback(@Body langTokenRequest: LangTokenRequest): Call<MyFeedBackResponse?>

    @POST("common/getCMS")
    fun getCMS(@Body langTokenRequest: CMSRequest): Call<CMSResponse?>

    @POST("common/getTicket")
    fun getTicket(@Body getTicketRequest: GetTicketRequest): Call<TicketResponse?>

    @POST("common/setTicket")
    fun setTicket(@Body setTicketRequest: SetTicketRequest): Call<CommonResponse?>

    @POST("common/reopenTicket")
    fun reopenTicket(@Body setTicketRequest: ReopenRequest): Call<CommonResponse?>

    @POST("common/getTicketDetail")
    fun getTicketDetail(@Body request: ReopenRequest): Call<TicketDetailResponse?>

    @POST("common/getNotificationsList")
    fun getNotificationsList(@Body logoutRequest: CaregiverTransactionRequest?): Call<NotificationListResponse?>

    @POST("common/getUnreadNotificationsCount")
    fun getUnreadNotificationsCount(@Body logoutRequest: LangTokenRequest?): Call<NotificationCountResponse?>


    //Resources
    @POST("resources/getResource")
    fun getResource(@Body setTicketRequest: GetResourceRequest): Call<ResourceResponse?>

    @POST("resources/getResourceDetail")
    fun getResourceDetail(@Body resourceDetail: ResourceDetailRequest): Call<ResourceDetailResponse?>


    //Users
    @POST("users/updateProfileStatus")
    fun updateProfileStatus(@Body updateProfileStatus: UpdateProfileStatusRequest): Call<LoginResponse?>

    @POST("users/savePersonalDetails")
    fun savePersonalDetails(@Body savePersonalDetailRequest: SavePersonalDetailRequest): Call<LoginResponse?>

    @POST("users/getUserInfo")
    fun getUserInfo(@Body langToken: LangTokenRequest): Call<LoginResponse?>

    @POST("users/saveCertificationsLicenses")
    fun saveCertificationsLicenses(@Body saveCertificateRequest: SaveCertificateRequest): Call<LoginResponse?>

    @POST("users/getCertificationsLicenses")
    fun getCertificationsLicenses(@Body langToken: LangTokenRequest): Call<GetCertificationsLicensesResponse?>

    @POST("users/saveAddressOrLocation")
    fun saveAddressOrLocation(@Body saveAddressRequest: SaveAddressRequest): Call<LoginResponse?>

    @POST("users/saveWorkDetails")
    fun saveWorkDetails(@Body saveAddressRequest: SaveWorkDetailsRequest): Call<LoginResponse?>

    @POST("users/getWorkDetails")
    fun getWorkDetails(@Body langToken: LangTokenRequest): Call<GetWorkDetailsResponse?>

    @POST("users/saveInsurance")
    fun saveInsurance(@Body saveInsuranceRequest: SaveInsuranceRequest): Call<LoginResponse?>

    @POST("users/getInsurance")
    fun getInsurance(@Body langToken: LangTokenRequest): Call<GetInsuranceResponse?>

    @POST("users/saveCaregiverAvailabilitySetting")
    fun saveCaregiverAvailabilitySetting(@Body saveAvailabilityRequest: SaveAvailabilityRequest): Call<LoginResponse?>

    @POST("users/getCaregiverAvailabilitySetting")
    fun getCaregiverAvailabilitySetting(@Body langToken: LangTokenRequest): Call<AvailabilityResponse?>

    @POST("users/getCaregiverAvailabilitySettingNew")
    fun getCaregiverAvailabilitySettingNew(@Body langToken: LangTokenRequest): Call<CaregiverAvailabilitySettingNewResponse?>

    @POST("users/getCaregiverCalendarAvailabilityNew")
    fun getCaregiverCalendarAvailabilityNew(@Body langToken: LangTokenRequest): Call<CaregiverCalendarAvailabilityNewResponse?>

    @POST("users/savePersonalDetails")
    fun savePersonalDetails(@Body langToken: NotificationSettingRequest): Call<CommonResponse?>

    @POST("users/saveCaregiverAvailability")
    fun saveCaregiverAvailability(@Body langToken: SaveCaregiverAvailibility): Call<CommonResponse?>

    @POST("users/removeSingleAvailabilityNew")
    fun removeSingleAvailabilityNew(@Body langToken: RemoveSingleAvailabilityRequest): Call<CommonResponse?>


    //caregiver
    @POST("caregiver/getUserJobList")
    fun getUserJobList(@Body langToken: GetUserJobListRequest): Call<GetUserJobResponse?>

    @POST("caregiver/getUserJobDetail")
    fun getUserJobDetail(@Body langToken: JobDetailRequest): Call<JobDetailResponse?>

    @POST("caregiver/applyUserJob")
    fun applyUserJob(@Body langToken: ApplyJobRequest): Call<CommonResponse?>

    @POST("caregiver/getUserSearchHistory")
    fun getUserSearchHistory(@Body langToken: SearchHistoryRequest): Call<SearchHistoryResponse?>

    @POST("caregiver/removeUserSearchHistory")
    fun removeUserSearchHistory(@Body langToken: RemoveSearchRequest): Call<CommonResponse?>

    @POST("caregiver/clearUserSearchHistory")
    fun clearUserSearchHistory(@Body langToken: LangTokenRequest): Call<CommonResponse?>

    @POST("caregiver/getSubstituteJobRequestList")
    fun getSubstituteJobRequestList(@Body langToken: SubstituteJobRequest): Call<SubstituteListResponse?>

    @POST("caregiver/getAwardJobRequestList")
    fun getAwardJobRequestList(@Body langToken: SubstituteJobRequest): Call<AwardListResponse?>

    @POST("caregiver/getCaregiverDashboard")
    fun getCaregiverDashboard(@Body langToken: DashboardRequest): Call<DashboardResponse?>

    @POST("caregiver/getCaregiverRelatedJobList")
    fun getCaregiverRelatedJobList(@Body langToken: CaregiverRelatedJobRequest): Call<CaregiverRelatedResponse?>

    @POST("caregiver/getCaregiverRelatedJobDetail")
    fun getCaregiverRelatedJobDetail(@Body langToken: CaregiverRelatedJobDetailRequest): Call<CaregiverRelatedJobDetailResponse?>

    @POST("caregiver/cancelJobRequest")
    fun cancelJobRequest(@Body langToken: CancelJobRequest): Call<CommonResponse?>

    @POST("caregiver/modifyJobAnswer")
    fun modifyJobAnswer(@Body langToken: ModifyAnswerRequest): Call<CommonResponse?>

    @POST("caregiver/getCaregiverList")
    fun getCaregiverList(@Body langToken: CaregiverListRequest): Call<CaregiverListResponse?>

    @POST("caregiver/sendSubstituteJobRequest")
    fun sendSubstituteJobRequest(@Body langToken: CaregiverSubstituteJobRequest): Call<CommonResponse?>

    @POST("caregiver/cancelUpcomingJob")
    fun cancelUpcomingJob(@Body langToken: CancelUpcomingJobRequest): Call<CommonResponse?>

    @POST("caregiver/getCaregiverMyProfile")
    fun getCaregiverMyProfile(@Body langToken: LangTokenRequest): Call<GetCaregiverMyProfileResponse?>

    @POST("caregiver/verifyJobVerificationCode")
    fun verifyJobVerificationCode(@Body langToken: VerifyJobVerificationCode): Call<VerifyJobCodeResponse>

    @POST("caregiver/endUserJob")
    fun endUserJob(@Body langToken: EndUserJobRequest): Call<CommonResponse?>

    @POST("caregiver/uploadJobMedia")
    fun uploadJobMedia(@Body langToken: RequestMediaUploadRequest): Call<CommonResponse?>

    @POST("caregiver/acceptSubstituteJobRequest")
    fun acceptSubstituteJobRequest(@Body request: AcceptRejectSubJobRequest): Call<CommonResponse?>

    @POST("caregiver/acceptAwardJobRequest")
    fun acceptAwardJobRequest(@Body request: AcceptRejectAwardRequest): Call<CommonResponse?>

    @POST("caregiver/declineAwardJobRequest")
    fun declineAwardJobRequest(@Body request: AcceptRejectAwardRequest): Call<CommonResponse?>

    @POST("caregiver/rejectSubstituteJobRequest")
    fun rejectSubstituteJobRequest(@Body request: AcceptRejectSubJobRequest): Call<CommonResponse?>

    @POST("caregiver/getRequestAddJobHoursDetail")
    fun getRequestAddJobHoursDetail(@Body langToken: CaregiverRelatedJobDetailRequest): Call<RequestAddJobResponse?>

    @POST("caregiver/acceptAddJobHoursRequest")
    fun acceptAddJobHoursRequest(@Body langToken: CaregiverRelatedJobDetailRequest): Call<CommonResponse?>

    @POST("caregiver/declineAddJobHoursRequest")
    fun declineAddJobHoursRequest(@Body langToken: CaregiverRelatedJobDetailRequest): Call<CommonResponse?>


    //job
    @POST("job/getCaregiverReviewList")
    fun getCaregiverReviewList(@Body langToken: MyReviewListRequest): Call<MyReviewListResponse?>

    @POST("job/setOngoingJobReview")
    fun setOngoingJobReview(@Body langToken: OnGoingJobReviewRequest): Call<CommonResponse?>

    @POST("job/getCaregiverProfile")
    fun getCaregiverProfile(@Body request: CaregiverProfileRequest): Call<CaregiverProfileResponse?>

    @POST("users/getCaregiverAvailabilityNew")
    fun getCaregiverAvailabilityNew(@Body langToken: CaregiverAvailabilityRequest): Call<CaregiverAvailabilityResponse?>


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


    //Payment
    @POST("payment/connectStripe")
    fun connectStripe(@Body logoutRequest: LangTokenRequest?): Call<ConnectStripeResponse?>

    @POST("payment/getBankDetail")
    fun getBankDetail(@Body logoutRequest: LangTokenRequest?): Call<BankDetailResponse?>

    @POST("payment/saveBankDetailInStripe")
    fun saveBankDetailInStripe(@Body logoutRequest: BankDetailRequest?): Call<CommonResponse?>

    @POST("payment/getWalletAmount")
    fun getWalletAmount(@Body logoutRequest: LangTokenRequest?): Call<WalletAmountResponse?>

    @POST("payment/withdrawMoney")
    fun withdrawMoney(@Body logoutRequest: WithdrawMoneyRequest?): Call<CommonResponse?>

    @POST("payment/caregiverAccountTransaction")
    fun caregiverAccountTransaction(@Body logoutRequest: CaregiverTransactionRequest?): Call<CaregiverTransactionResponse?>

    @POST("payment/getAccountChartData")
    fun getAccountChartData(@Body logoutRequest: AccountChartDataRequest?): Call<AccountChartDataResponse?>

    @POST("payment/getUserCardList")
    fun getUserCardList(@Body request: LangTokenRequest): Call<GetCardListResponse?>

    @POST("payment/saveUserCard")
    fun saveUserCard(@Body request: SaveCardRequest): Call<CommonResponse?>

    @POST("payment/removeUserCard")
    fun removeUserCard(@Body request: RemoveCardRequest): Call<CommonResponse?>

    @Multipart
    @POST("common/mediaUpload")
    fun mediaUpload(
        @Part("langType") fullName: RequestBody?,
        @Part files: MultipartBody.Part
    ): Call<MediaUploadResponse?>?

}