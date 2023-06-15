//
//  AppConstant.swift
//  Momentor
//
//  Created by Wdev3 on 30/10/20.
//  Copyright © 2020 Wdev3. All rights reserved.
//

import UIKit

//typealias FailureBlock = (_ error: String, _ customError: ErrorType) -> Void
//typealias FailureBlock = (_ statuscode: Int,_ error: String, _ customError: ErrorType) -> Void
typealias FailureBlock = (_ statuscode: String,_ error: String, _ customError: ErrorType) -> Void

//Error enum

enum ErrorType: String {
    case server = "Error"
    case connection = "No connection"
    case response = ""
}
let appDelegate = UIApplication.shared.delegate as! AppDelegate

// MARK: - Media Enum
enum MediaType : String {
    case kImage  = "public.image"
    case kVideo  = "public.movie"
}

//iPhone Screensize
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

//iPhone devicetype
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = ScreenSize.SCREEN_HEIGHT == 812.0
    static let IS_IPHONE_6_OR_LESS  = ScreenSize.SCREEN_MAX_LENGTH <= 736.0
    static let IS_IPHONE_XMAX          = ScreenSize.SCREEN_HEIGHT == 896.0
    static let IS_PAD               = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

struct FileData
{
    static let FILE_NAME         = "com.DDD.filename"
    static let FILE_MIME_TYPE    = "com.DDD.mimetype"
    static let FILE_URL          = "com.DDD.fileurl"
    static let FILE_DATA         = "com.DDD.filedata"
    static let FILE_ATTACHMENTMESSAGE_KEY    = "TEXT"
    static let FILE_ATTACHMENTMESSGE_IMAGE   = "IMAGE"
    static let FILE_ATTACHMENTMESSGE_VIDEO   = "VIDEO"
    static let MIME_JPG  = "image/jpg"
    static let MIME_JPEG = "image/jpeg"
    static let MIME_PNG  = "image/png"
    static let MIME_MP4  = "video/mp4"
    static let MIME_MOV  = "video/mov"
}

struct LinkedInConstants {
    
    static let CLIENT_ID = "78ab6vx75k4ahc"
    static let CLIENT_SECRET = "S3oUxR65dqXCEKPW"
    static let REDIRECT_URI = "https://xtrahelp.com"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}

enum userRole : Int{
    case User = 2
    case Doctor = 3
}

// MARK: - Menu Type Enum
enum TutorialImages : Int {
    case tutorial1
    case tutorial2
    case tutorial3
    
    var HeaderName : String {
        switch self {
        case .tutorial1:
            return "Every family deserves some XtraHelp"
        case .tutorial2:
            return "Post a job on XtraHelp!"
        case .tutorial3 :
            return "Connecting families through care!"
        }
    }
    
    var HeaderDescName : String {
        switch self
        {
        case .tutorial1:
            return "XtraHelp provides unique care services, specifically designed for the special needs community."
        case .tutorial2:
            return "We make sure you are connected to qualified professionals depending upon your needs."
        case .tutorial3 :
            return "It might sound challenging, but it is not. You can find qualified caregivers near you through Xtra Help"
        }
    }
    
    var img : UIImage {
        switch self {
        case .tutorial1:
            return #imageLiteral(resourceName: "Tutorial1")
        case .tutorial2:
            return #imageLiteral(resourceName: "Tutorial2")
        case .tutorial3 :
            return #imageLiteral(resourceName: "Tutorial3")
        }
    }
}

enum keyboardEnumType : Int {
    case defaultkeyboard
    case password
}

enum supportForReplyType : String {
    case admin = "1"
    case user = "2"
}

enum pageIDEnum : Int {
    case AboutUs
    case TermCondition
    case PrivacyPolicy
    case Compliances
    case CancellationPolicy
    case AppLicenseAgreement
    case ProviderAgreement﻿
    
    var name : String{
        switch self {
        case .AboutUs:
            return "About Us"
        case .TermCondition:
            return "Terms & Conditions"
        case .PrivacyPolicy:
            return "Privacy Policy"
        case .Compliances:
            return "Compliances"
        case .CancellationPolicy:
            return "Cancelation Policy"
        case .AppLicenseAgreement:
            return "App License Agreement"
        case .ProviderAgreement﻿:
            return "Provider Agreement﻿"
        }
    }
    
    var pageid : String{
        switch self {
        case .AboutUs:
            return "aboutus"
        case .TermCondition:
            return "termscondition"
        case .PrivacyPolicy:
            return "privacypolicy"
        case .Compliances:
            return "compliances"
        case .CancellationPolicy:
            return "cancelationpolicy"
        case .AppLicenseAgreement:
            return "appeula"
        case .ProviderAgreement﻿:
            return "provideragreement"
        }
    }
}

enum MonthSelection : Int{
    case January = 1,February,March,April,May,June,July,August,September,October,November,December
    
    var name : String {
        switch self {
        case .January:
            return "January"
        case .February:
            return "February"
        case .March:
            return "March"
        case .April:
            return "April"
        case .May:
            return "May"
        case .June:
            return "June"
        case .July:
            return "July"
        case .August:
            return "August"
        case .September:
            return "September"
        case .October:
            return "October"
        case .November:
            return "November"
        case .December:
            return "December"
        }
    }
}

enum DaySelection : Int{
    case One = 1,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Eleven,Twelve,Thirteen,Fourteen,Fifteen,Sixteen, Seventeen,Eighteen,Nineteen,Twenty,Twentyone,Twentytwo,Twentythree,Twentyfour, Twentyfive,Twentysix,Twentyseven,Twentyeight,Twentynine,Thirty,Thirtyone
    
    var name : String {
        switch self {
        case .One:
            return "1st"
        case .Two:
            return "2nd"
        case .Three:
            return "3rd"
        case .Four:
            return "4th"
        case .Five:
            return "5th"
        case .Six:
            return "6th"
        case .Seven:
            return "7th"
        case .Eight:
            return "8th"
        case .Nine:
            return "9th"
        case .Ten:
            return "10th"
        case .Eleven:
            return "11th"
        case .Twelve:
            return "12th"
        case .Thirteen:
            return "13th"
        case .Fourteen:
            return "14th"
        case .Fifteen:
            return "15th"
        case .Sixteen:
            return "16th"
        case .Seventeen:
            return "17th"
        case .Eighteen:
            return "18th"
        case .Nineteen:
            return "19th"
        case .Twenty:
            return "20th"
        case .Twentyone:
            return "21st"
        case .Twentytwo:
            return "22nd"
        case .Twentythree:
            return "23rd"
        case .Twentyfour:
            return "24th"
        case .Twentyfive:
            return "25th"
        case .Twentysix:
            return "26th"
        case .Twentyseven:
            return "27th"
        case .Twentyeight:
            return "28th"
        case .Twentynine:
            return "29th"
        case .Thirty:
            return "30th"
        case .Thirtyone:
            return "31st"
        }
    }
}


//MARK: LanguageSelection Type
enum LanguageSelection : Int {
    case English = 1, Spanish, Chinese, Russian
    
    var languageCode : String {
        switch self {
        case .English:
            return "en"
        case .Spanish:
            return "es"
        case .Chinese:
            return "zh-Hans"
        case .Russian:
            return "ru"
        }
    }
    
    var apiLanguageCode : String {
        switch self {
        case .English:
            return "english"
        case .Spanish:
            return "spain"
        case .Chinese:
            return "chinese"
        case .Russian:
            return "russian"
        }
    }
}

enum supportReplyType : String {
    case message = "1"
    case media = "2"
}

enum complaintType : String {
    case Better = "1"
    case Worse = "2"
    case SameAs  = "3"
    
    var name : String{
        switch self {
        case .Better:
            return "Better"
        case .Worse:
            return "Worse"
        case .SameAs:
            return "Staying the same"
        }
    }
}

enum appointmentType : String {
    case Virtual = "1"
    case MyPlace = "2"
    case GymOfc  = "3"
    
    var name : String{
        switch self {
        case .Virtual:
            return "Virtual"
        case .MyPlace:
            return "My Place"
        case .GymOfc:
            return "Gym / Office"
        }
    }
}

// MARK: - TabBar ItempType Enum
enum TabbarItemType : Int {
    case Home
    case MyJobs
    case Caregiver
    case Feed
    
    var name : String {
        switch self {
        case .Home:
            return "Home"
        case .MyJobs:
            return "My jobs"
        case .Caregiver :
            return "Caregiver"
        case .Feed :
            return "Feed"
        }
    }
    
    var img : UIImage {
        switch self {
        case .Home:
            return UIImage(imageLiteralResourceName: "ic_TabHomeUnSelected")
        case .MyJobs:
            return UIImage(imageLiteralResourceName: "ic_TabMyJobUnSelected")
        case .Caregiver :
            return UIImage(imageLiteralResourceName: "ic_TabUnSelelctCargiver")
        case .Feed :
            return UIImage(imageLiteralResourceName: "ic_TabFeedUnSelected")
        }
    }
//    #imageLiteral(resourceName:sidemenu)
    var Selectimg : UIImage {
        switch self {
        case .Home:
           return UIImage(imageLiteralResourceName: "select_HomeTab")
        case .MyJobs:
            return   UIImage(imageLiteralResourceName: "SelectMyjob")
        case .Caregiver :
          return  UIImage(imageLiteralResourceName: "selectCaregiver")
        case .Feed :
            return  UIImage(imageLiteralResourceName:"SelectFeed")
        }
    }
}

// MARK: - Menu Type Enum
enum SideMenu : Int {
    case Profile
    case Messages
    case InviteBlackProfessionals
    case Badges
    case SendFeedback
    case Settings
    
    var name : String {
        switch self {
        case .Profile:
            return "Profile"
        case .Messages:
            return "Messages"
        case .InviteBlackProfessionals :
            return "Invite Black Professionals"
        case .Badges :
            return "Badges"
        case .SendFeedback :
            return "Send Feedback"
        case .Settings :
            return "Settings"
        }
    }
    
    var img : UIImage {
        switch self {
        case .Profile:
            return #imageLiteral(resourceName: "IC_user")
        case .Messages:
            return #imageLiteral(resourceName: "messages")
        case .InviteBlackProfessionals :
            return #imageLiteral(resourceName: "add-user")
        case .Badges :
            return #imageLiteral(resourceName: "trophy")
        case .SendFeedback :
            return #imageLiteral(resourceName: "feedback")
        case .Settings :
            return #imageLiteral(resourceName: "settings")
        }
    }
}

enum CardAPIType : String {
    case Visa = "Visa"
    case Mastercard = "MasterCard"//,"Mastercard"
    case AmericanExpress = "American Express"
    case Discover = "Discover"
    case DinersClub = "Diners Club"
    case JCB = "JCB"
    case UnionPay = "UnionPay"
    case None = ""
    
    var img : UIImage {
        switch self {
        case .Visa:
            return #imageLiteral(resourceName: "ic_CardVisa")
        case .Mastercard:
            return #imageLiteral(resourceName: "ic_CardMastercard")
        case .AmericanExpress:
            return #imageLiteral(resourceName: "ic_CardAmericanExpress")
        case .Discover:
            return #imageLiteral(resourceName: "ic_CardDiscover")
        case .DinersClub:
            return #imageLiteral(resourceName: "ic_CardDinerClub")
        case .JCB:
            return #imageLiteral(resourceName: "ic_CardJCB")
        case .UnionPay:
            return #imageLiteral(resourceName: "ic_CardUnionPay")
        case .None:
            return #imageLiteral(resourceName: "ic_CardNone")
        }
    }
}


enum SocialLoginType : Int {
    case LinkedIn = 1
    case Apple = 2
}

enum MessageReplyType : String {
    case Text = "1"
    case Image = "2"
    case Video = "3"
    case CareGiver = "4"
    case Files = "5"
}

enum AuthVerificationType : Int {
    case Voice = 1
    case Question = 2
    case DOB = 3
}

struct shareContentApp {
    static let kContent = "Share XtraHelpApp with friends and caregivers : \n"
    static let kLink = "https://apps.apple.com/us/app/xtrahelpapp/id1606312003"
}

// MARK: - Constant
class AppConstant {
    // MARK: - Validation Messages constants
    static let deviceType : String = "2"
    static let pageSize = 10
    
    struct WebSocketAPI {
        static let kregistration = "registration"
        static let kuserSupportTicketMessageList = "userSupportTicketMessageList"
        static let kuserSupportTicketReply = "userSupportTicketReply"
        
        static let kchatinbox = "chatinbox"
        static let kchatmessagelist = "chatmessagelist"
        static let kusermessagelist = "usermessagelist"
        static let kmessage = "message"
        static let kremovechatmessagelist = "removechatmessagelist"
         
        static let socketURL = "wss://app.getxtrahelp.com:9023"
        //static let socketURL = "ws://project.greatwisher.com:9023"
    }
    struct API {
        //static let MAIN_URL = "http://project.greatwisher.com/app-xtrahelp/"
        static let MAIN_URL = "https://app.getxtrahelp.com/"//"http://project.greatwisher.com/app-xtrahelp/"
        //static let MAIN_URL = "http://192.168.0.108/app-xtrahelp/"
        
        static let BASE_URL = MAIN_URL + "api/"
        
        //Login Module
        static let kLogin               = BASE_URL + "auth/login"
        static let ksocialLogin         = BASE_URL + "auth/socialLogin"
        static let kRegisterUser        = BASE_URL + "auth/signup"
        static let kForgotPassword      = BASE_URL + "ForgotPassword"
        static let kChangePassword      = BASE_URL + "auth/changePassword"
        static let kResetPassword       = BASE_URL + "ResetPassword"
        static let kgetCommonData          = BASE_URL + "common/getCommonData"
        static let kgetJobCategoryList  = BASE_URL + "common/getJobCategoryList"
        
        static let kverify              = BASE_URL + "auth/verify"
        static let kresendVerification = BASE_URL + "auth/resendVerification"
        static let kforgotPassword          = BASE_URL + "auth/forgotPassword"
        static let kresetPassword          = BASE_URL + "auth/resetPassword"
        static let kchangePassword          = BASE_URL + "auth/changePassword"
        static let kcheckForgotCode          = BASE_URL + "auth/checkForgotCode"
        
        static let kGetProfile          = BASE_URL + "users/getUserInfo"
        static let kupdateProfileStatus = BASE_URL + "users/updateProfileStatus"
        static let kUpdateUserProfile   = BASE_URL + "users/saveUserProfile"
        static let ksavePersonalDetails   = BASE_URL + "users/savePersonalDetails"
        static let ksaveAboutLoved   = BASE_URL + "users/saveAboutLoved"
        static let ksaveInsurance   = BASE_URL + "users/saveInsurance"
        static let ksaveCertificationsLicenses   = BASE_URL + "users/saveCertificationsLicenses"
        static let kgetCertificationsLicenses   = BASE_URL + "users/getCertificationsLicenses"
        static let kgetAboutLoved   = BASE_URL + "users/getAboutLoved"
        static let kgetInsurance = BASE_URL + "users/getInsurance"
        static let ksaveAddressOrLocation   = BASE_URL + "users/saveAddressOrLocation"
        static let ksaveWorkDetails   = BASE_URL + "users/saveWorkDetails"
        static let ksaveCaregiverAvailabilitySetting   = BASE_URL + "users/saveCaregiverAvailabilitySetting"
        static let klogout          = BASE_URL + "auth/logout"
        
        static let kmediaUpload          = BASE_URL + "common/mediaUpload"
        static let ksetAppFeedback          = BASE_URL + "common/setAppFeedback"
        static let kGetAppFeedback          = BASE_URL + "common/getMyAppFeedback"
        static let kgetResource          = BASE_URL + "resources/getResource"
        static let kgetResourceDetail          = BASE_URL + "resources/getResourceDetail"
        static let kgetCMS               = BASE_URL + "common/getCMS"
        static let kfaq                  = BASE_URL + "common/faq"
        static let kfaqDetails           = BASE_URL + "common/faqDetails"
        static let kgetTicket            = BASE_URL + "common/getTicket"
        static let kgetActiveTicket     = BASE_URL + "common/getActiveTicket"
        static let kgetTicketDetail      = BASE_URL + "common/getTicketDetail"
        static let ksetTicket            = BASE_URL + "common/setTicket"
        static let kreopenTicket         = BASE_URL + "common/reopenTicket"
        
        //Language
        static let kgetLanguagesList          = BASE_URL + "common/getLanguagesList"
        
        //City
        static let kgetStateList          = BASE_URL + "common/getStateList"
        static let kgetCityList          = BASE_URL + "common/getCityList"
        static let kgetProfessionList          = BASE_URL + "common/getProfessionList"
        
        //Card
        static let ksaveCard         = BASE_URL + "payment/saveUserCard"
        static let kgetUserCards         = BASE_URL + "payment/getUserCardList"
        static let kdeleteUserCard        = BASE_URL + "payment/removeUserCard"
        
        //Search
        static let kgetUserSearchHistory        = BASE_URL + "caregiver/getUserSearchHistory"
        static let kclearUserSearchHistory      = BASE_URL + "caregiver/clearUserSearchHistory"
        static let kremoveUserSearchHistory     = BASE_URL + "caregiver/removeUserSearchHistory"
        
        //Rating
        static let kgetUserTransaction        = BASE_URL + "payment/caregiverAccountTransaction"
        
        //VOIP
        static let ksetVoipToken_URL                 =  BASE_URL + "common/setVoipToken"
        static let kgenerateAccessToken_URL          =  BASE_URL + "common/generateAccessToken"
        
        //Notification
        static let kgetNotificationsList          = BASE_URL + "common/getNotificationsList"
        static let kgetUnreadNotificationsCount          = BASE_URL + "common/getUnreadNotificationsCount"
        
        static let ksaveUserJob          = BASE_URL + "job/saveUserJob"
        static let kgetMyPostedJob          = BASE_URL + "job/getMyPostedJob"
        static let kgetUserRelatedJobList          = BASE_URL + "job/getUserRelatedJobList"
        static let kgetUserRelatedJobDetail          = BASE_URL + "job/getUserRelatedJobDetail"
        static let kgetMyPostedJobDetail          = BASE_URL + "job/getMyPostedJobDetail"
        static let kcancelMyPostedJob          = BASE_URL + "job/cancelMyPostedJob"
        static let kgetMyPostedJobApplicants          = BASE_URL + "job/getMyPostedJobApplicants"
        static let kacceptCaregiverJobRequest          = BASE_URL + "job/acceptCaregiverJobRequest"
        static let krejectCaregiverJobRequest          = BASE_URL + "job/rejectCaregiverJobRequest"
        static let ksetJobReview          = BASE_URL + "job/setJobReview"
        static let kapplicantApplyJobQueAnsList          = BASE_URL + "job/applicantApplyJobQueAnsList"
        
        static let kgetUserSubstituteJobRequestList          = BASE_URL + "job/getUserSubstituteJobRequestList"
        static let kacceptSubstituteJobRequest          = BASE_URL + "job/acceptSubstituteJobRequestByUser"
        static let krejectSubstituteJobRequest          = BASE_URL + "job/rejectSubstituteJobRequestByUser"
        
        static let krequestJobImageVideo          = BASE_URL + "job/requestJobImageVideo"
        
        static let kfindCaregivers = BASE_URL + "job/findCaregivers"
        static let kgetMyJobRelatedCaregiver = BASE_URL + "job/getMyJobRelatedCaregiver"
        static let kgetUserDashboard = BASE_URL + "job/getUserDashboard"
        static let kgetCaregiverProfile = BASE_URL + "job/getCaregiverProfile"
        
        static let ksendJobExtraHoursRequest          = BASE_URL + "job/sendJobExtraHoursRequest"
        
        static let kawardJobSavePaymentData          = BASE_URL + "job/awardJobSavePaymentData"
        
        //Feed
        static let ksetFeed              = BASE_URL + "feed/saveUserFeed"
        static let kgetFeedList          = BASE_URL + "feed/getUserFeedList"
        static let ksetFeedLikeUnlike    = BASE_URL + "feed/likeUnlikeFeed"
        static let kgetFeedLikeUser      = BASE_URL + "feed/getFeedLikeUserList"
        static let kgetFeedCommentUser      = BASE_URL + "feed/getFeedCommentList"
        static let ksetFeedReport      = BASE_URL + "feed/feedReport"
        static let ksetFeedCommentReport      = BASE_URL + "feed/feedCommentReport"
        static let kdeleteFeed      = BASE_URL + "feed/deleteFeed"
        static let kdeleteFeedComment      = BASE_URL + "feed/deleteFeedComment"
        static let ksetFeedComment      = BASE_URL + "feed/feedComment"
        
        static let kgetCaregiverReviewList      = BASE_URL + "job/getCaregiverReviewList"
        static let kgetCaregiverAvailability   = BASE_URL + "users/getCaregiverAvailabilityNew"
        
        static let kawardJobRequest          = BASE_URL + "job/awardJobRequest"
    }
    
    struct PhoneNumberMasking {
        static let kPhoneNumber = "XXX-XXX-XXXX"
    }
    
    struct ValidationMessages {
        
        static let kComingSoon = "Coming Soon"
        
        static let kEmptyTicketTile      = "Please enter ticket title"
        static let kEmptyTicketDesc      = "Please enter ticket description"
        
        static let kstartdateLessThanendDate = "Start date must be less then from end date."
        static let kendDateGreterthanfromstartdate = "End date must be greater then from start date."
        static let kSelectStartdate = "Select start date."
        static let kSelectEnddate = "Select end date."
        
        static let kAcceptTermsnCondition = "Please accept term of service."
        static let kEmptyLanguage = "Please select atleast one Preferred Language"
        
        //Login validation message
        static let kvalidPassword       =   "Password must be 8 to 15 character"
        static let kStrongValidPassword = "Your password must be contain 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character"
        static let kInValidPassword       =   "Invalid username or password "
        static let kConfirmPass         = "Enter your confirm password"
        static let kPasswordNotMatch    = "Please ensure your password matches"
        static let kOldNewPasswordoNotMatch = "Old password and new password must not be same"
        static let kEmptyEmail           = "Please enter email address"
        static let kEmptyValidationCode = "Please enter verification code"
        static let kValidValidationCode = "Please enter valid verification code"
        static let kEmptyPassword        = "Please enter password"
        static let KNewPassword          = "Please enter new password"
        static let KOldPassword          = "Please enter old password"
        static let kOldPAsswordInvalid = "Old password must be 8 to 15 character"
        static let kInValidEmail         = "Please enter valid email address"
        //Register validation message
        static let kEmptyName            = "Please enter full name"
        static let kEmptyFullName            = "Please enter your last name"
        static let kEmptyMedicationName            = "Please enter medication name"
        static let kEmptyAge            = "Please enter age"
        static let kEmptyDOB  = "Please select date of birth"
        static let kInvalideAge            = "Age should be more than 18 years"
        static let kEmptyGender            = "Please select gender"
        static let kEmptyDosage            = "Please select dosage"
        static let kEmptyFrequency            = "Please select frequency"
        static let kEmptyRelation            = "Please select family relation"
        static let kEmptyDocumentType            = "Please enter document name"
        
        static let kEmptyAllergiesName            = "Please enter allergie name"
        static let kEmptyIllnessName            = "Please enter illness name"
        static let kEmptyHealthIssueName            = "Please enter health issue name"
        static let kEmptyInjuriesName            = "Please enter injuries name"
        static let kEmptySurgerieName            = "Please enter surgerie name"
        static let kEmptyAllergieKeyword            = "Please enter allergie type"
       
        static let kEmptyPhoneNumber          = "Please enter phone number"
        static let kEmptyEmergencyContact          = "Please enter emergency contact"
        static let kEmptyProfession      = "Please enter your profession."
        static let kEmptyAddress         = "Please enter address"
        static let kEmptyConfirmPassword = "Please enter confirm password"
        static let kDontMatchPassword    = "Password and confirm password do not match"
        static let kInvalidPassword      = "Password must contain at least 6 characters."
        static let kInvalidOldPassword   = "Old password must contain at least 6 characters."
        static let kEmptyOldPassword     = "Please enter old password."
        static let kPostEmpaty           = "Please enter at leate one value."
        static let kEmptyPhoneNo         = "Please enter phone number."
        static let kInValidPhoneNo       = "Please enter valid phone number."
        static let kSelectLocation       = "Please choose the location first"
        static let kSelectPlanningSoon       = "Please select date you planning to hire"
        
        static let kApartmentNumberUnit = "Please enter Apartment Number/Unit"
        static let kEmptyCity = "Please select city"
        static let kEmptyState = "Please select state"
        static let kEmptyZipcode = "Please enter zipcode"
        
        static let kEmptyAppointmentType = "Please select appointment type"
        static let kEmptyAppointmentTime = "Please select appointment time"
        static let kEmptyLocation = "Please select location"
        
        static let kEmptyExperience = "Please enter minimum years of experience"
        
        //Card Validation message
        /*static let KCardHolderName       = "Please enter card holder name."
        static let KCardNumber           = "Please enter card number."
        static let KExpiryDate           = "Please enter expiry Date."
        static let KCVV                  = "Please enter cvv."
        static let KInvalidCardNumber    = "Please enter valid card number."
        static let KInvalidCVV                  = "Please enter valid cvv."
        static let KValidExpiryDate      = "Please enter valid expiry date"*/
        
        static let KSelectGoal       = "Please enter goal"
        static let KSelectPainScale       = "Please select pain scale"
        static let KSelectFunctionScale       = "Please select function scale"
        static let KSelectcomplaint       = "Please select complaint"
    
        static let KSelectCard       = "Please select card"
        static let KCardHolderName       = "Please enter card holder name"
        static let KCardNumber           = "Please enter card number"
        static let KExpiryDate           = "Please enter expiry Date"
        static let KCVV                  = "Please enter cvv"
        static let KMM                  = "Please enter expiry month"
        static let KYYYY                  = "Please enter expiry year"
        static let KInvalidCardNumber    = "Please enter valid card number"
        static let KInvalidCVV           = "Please enter valid cvv"
        static let KInvalidMM    = "Please enter valid expiry month"
        static let KInvalidYYYY           = "Please enter valid expiry year"
        static let KValidExpiryDate      = "Please enter valid expiry date"
        
        static let kAge18Year = "You must be 18 years or older to join"
        static let kAge18YearProfile = "You must be older than 18 years"
        
        static let KGiveRating           = "Please give your rating"
        static let KGiveFeedback           = "Please give your feedback"
        static let KGiveReview           = "Please give your review"
        //Location access message
        static let kLocationDenied       = "Please allow permission to access your location. Go to Settings > MLAB > Location Services > Allow."
        static let kEmptyOpinion         = "Please write something..."
        
        
        static let kFirstName            = "Please enter first name"
        static let kMiddleName            = "Enter middle name"
        static let kLastName            = "Please enter last name"
        static let kPhoneNumber            = "Please enter phone number"
        static let kValidPhoneNumber            = "Please enter valid phone number"
        static let kDOB            = "Please enter date of birth"
        
        static let kEmptyAprtmentAddress = "Please apartment number."
        static let kEmptyFeedback       = "Please enter feedback"
        
        
        static let kToTimeLessThenFromTime = "To Time should be greater than From Time."
        static let kSelectedTimeLessThenFromTime = "To Time should be greater than From Time."
        static let kSelectedTimeSameFromTime = "To Time and From Time should not be same."
        static let kFromTimeGreterThenFromTime = "From Time should not be greater than To Time."
        static let kFromTimeSameToTime = "From Time and To Time should not be same."
        
        
        static let kEndTimeLessThenStartTime = "End Time should be greater than Start Time."
        static let kSelectedTimeLessThenStartTime = "To Time should be greater than Start Time."
        static let kSelectedTimeSameStartTime = "End Time and Start Time should not be same."
        static let kStartTimeGreterThenEndTime = "Start Time should not be greater than End Time."
        static let kStartTimeSameEndTime = "Start Time and End Time should not be same."
        static let kEmptyStartTime = "Please select Start Time"
        static let kEmptyEndTime = "Please select End Time"
        
        static let kEmptyTimeOffMonth = "Please select timeoff month"
        static let kEmptyTimeOffDay = "Please select timeoff day"
        static let kEmptyTimeOffFromTime = "Please select timeoff From Time"
        static let kEmptyTimeOffToTime = "Please select timeoff To Time"
        static let kEmptyAvailibilityWindow = "Please select availibility window"
        static let kEmprtAvailibilityFromTime = "Please select availibility From Time"
        static let kEmprtAvailibilityToTime = "Please select availibility To Time"
        
        static let kTimeAlreadyBooked = "The changes cannot be done as the patient has already booked the appointment for this time slot."
        
        
        static let kSelectedIssueExpireDateSameFromTime = "Date Issue and Date Expires should not be same."
        
        static let kDateExpireLessThenDateIssue = "Date Expires should be greater than Date Issue."
        static let kDateExpireSameDateIssue = "Date Expires and Date Issue should not be same."
        static let kDateExpireGreterThenFromTime = "Date Issue should not be greater than Date Expires."
        static let kDateIssueSameDateExpire = "Date Issue and Date Expires should not be same."
        
        
        static let kEndDategreaterThenStartDate = "EndDate should be greater than StartDate."
        static let kStartDateLessThenEndDate = "EndDate should be less than StartDate."
        static let kEndDateLessThenTodayDate = "EndDate should be less than Today Date."
        static let kStartDateLessThenTodayDate = "StartDate should be less than Today Date."
        
        static let kEmprtIssueDate = "Please select Issue Date"
        
        
        static let kEmprtCertificateLicenses = "Please enter Certifications/Licenses details"
        static let kEmprtInsurance = "Please enter Insurance details"
        static let kAtLeastOneCertificateLicenses = "Please enter at least one Certifications/Licenses details"
        
        
        
        static let kEmptyWorkPlace            = "Please enter Work Place"
        static let kEmptyWorkReasonleaving            = "Please enter Reason for Leaving"
        static let kEmptyStartDate            = "Please select Start Date"
        static let kEmptyEndDate            = "Please select End Date"
        static let kEmptyWorkDetail            = "Please enter work detail"
        
        
        static let kEmptyJobCategory = "Please select job categories"
        static let kEmptySpeciality = "Please select job speciality"
        static let kEmptyMaximumdistanceyourewillingtotravel = "Please select maximum distance you're willing to travel"
        static let kEmptyyourmethodoftransportation = "Please select your method of transportation"
        static let kEmptyTypesofdisabilitiescaregiveriswillingtowork  = "Please select types of disabilities caregiver is willing to work"
        static let kEmptyYearsofexperience = "Please select years of experience"
        
        static let kEmptyJobSubCategory = "Please select job subcategories"
        /*static let k = ""
        static let k = ""*/
        
        static let kDisabilityTypeEmpty = "Select types of disabilities your loved one has"
        static let kEmptyAboutLoved = "Please describe about your loved one"
        static let kEmptyCategoryLoved = "Please select at least one category your loved one needs help with"
        static let kEmptyOtherCategoryLoved = "Please enter desired category your loved one needs help"
        static let kEmptyAllergiesLoved = "Please enter allergies"
        static let kEmptyspecialities = "Please select at least one specialities"
        //static let k = ""
        
        
        static let kEmptyJobAddress         = "Please select job address"
        static let kEmptyJobName         = "Please enter job name"
        static let kEmptyJobPrice         = "Please enter job price"
        static let kValidJobPrice         = "Please enter the minimum job price of $25.00/hr"
        static let kEmptyJobDate         = "Please select job date"
        static let kEmptyJobStartTime         = "Please select job Start Time"
        static let kEmptyJobEndTime         = "Please select job End Time"
    }
    
    struct SuccessMessage {
        static let kImageUploadingSuccess = "Image uploaded successfully."
        static let kProfileUpdatedSuccess = "Profile updated successfully."
        static let kMailSent = "Email sent successfully."
    }
    
    struct FailureMessage {
        static let kNoInternetConnection    = "Please check your internet connection."
        static let kCommanErrorMessage      = "Something went wrong. Please try again later."
        static let kFailToLogin             = "Fail to login."
        static let kFailToLoadCategories    = "Fail to load categories."
        static let kInvalidCredential       = "Invalid login credential."
        static let kFailToUploadImage       = "Image uploading failed."
        static let kFailToUploadProfile     = "Fail to update profile"
        static let kNoDataAvailable         = "No data available at the moment."
        static let kQuickBloxErrorMessage   = "We're having a hard time connecting you to your chat room, please try again."
        static let kMailNoteSetUp           = "Please send your feedback to info@onix-network.com."
        static let kInvaliedCard            = "Card is invalid. Please enter valid card detail."
        
        static let kFbIdNotFound = "Unable to get facebook id"
    }
    
    struct NoDataFoundText {
        static let kNoSearchResult       = "No Search Result Found."
        static let kNoDataFound          = "No Data Found."
        static let kNoStudioFound        = "No Studios Found."
        static let kNoBussinessData      = "No Bussiness Data Available."
        static let kNoUserRequestData    = "No User Request Available."
        static let kNoScheduleData       = "No Scheduled Booking Data Available."
        static let kNoCompletedBookingData = "No Completed Booking Data Available."
        static let kReviewData             =  "No Review Data Available."
        static let kNoFollowingFound             =  "No Following Data Available."
        
    }
    
    //MARK: - Informative Messages Constants
    struct AlertMessages {
        
        static let kDelete               = "Are you sure you want to delete this?"
        
        static let kWrongUsername   = "Enter valid email and password."
        static let kLogout          = "Are you sure you want to logout?"
        static let kMailNoteSetUp   = "Email is not setup in your device."
        static let kMailSent        = "Email sent successfully."
        static let kProfileUpdated  = "Profile updated succesfully."
        
        static let kEmptyMsg  = "Please write message"
        
        static let kSelectAns  = "Please select answer"
        
        //Tour Detail Message
        static let kNoAudioFound    = "No media found."
        static let copySuccess      = "copy clipboard successfully."
        static let commingSoon      = "Coming Soon"
        
        static let AuthTokenExpire  = "Authentication Token Expire."
        static let LIkedinAccountDataNotFound  = "Oho! There are some actions needed to update privacy of your linkedin profile. we are not able to access your basic data at the moment. So please review the privacy setting in the linkedin profile and try again."
        
        static let sloteBooked      = "Selecetd slot is already booked"
        
    }
    struct DateFormat {
        static let k_yyyy_MM_dd              = "yyyy-MM-dd"
        static let k_YYYY_MM_dd              = "YYYY-MM-dd"
        //static let k_dd_MM_yyyy              = "dd/MM/yyyy"
        static let k_dd_MM_yyyy              = "dd-MM-yyyy"
        static let k_MM_dd_yyyy              = "MM-dd-yyyy"
        static let k_dd_MM_yyyy_hh_mm        = "dd-MM-yyyy hh:mm"
        static let k_dd_MM_yyyy_hh_mm_ss     = "dd-MM-yyyy hh:mm:ss"
        static let k_dd_MM_yyyy_hh_mm_a      = "dd-MM-yyyy hh:mm a"
        static let k_MM_dd_yyyy_hh_mm_a      = "MM-dd-yyyy hh:mm a"
        static let k_yyyy_MM_dd_HH_mm        = "yyyy-MM-dd HH:mm"
        static let k_MMMM_dd_yyyy_EEE_dd_MMM = "MMMM dd, yyyy-EEE-dd-MMM"
        static let k_MMMM_dd_yyyy            = "MMMM dd, yyyy"
        static let k_MMMM_dd_yyyyy           = "MMMM dd yyyy"
        static let k_MMM_dd_yyyy             = "MMM dd yyyy"
        static let k_HH_mm_ss                = "HH:mm:ss"
        static let k_hh_mm_a                 = "hh:mm a"
        static let k_hh_mm_ss_a              = "hh:mm:ss a"
        static let k_h_mm_a                  = "h:mm a"
        static let k_HH_mm                   = "HH:mm"
        static let k_EEEE                    = "EEEE"
        static let k_a_hh_mm                 = "a hh:mm"
        static let k_MMMM_yyyy               = "MMMM yyyy"
        static let k_MMM_yyyy                = "MMM yyyy"
        static let k_MMM_dd                  = "MMM dd"
        static let k_MMM_d                   = "MMM d"
        static let k_MMM_dd_hh_mm_a          = "MMM dd yyyy hh:mm a"
        static let k_dd_MMMM_yyyy            = "dd MMMM yyyy"
        static let k_HH_mm_a                 = "HH:mm a"
        static let k_dd_MMMM                 = "dd MMMM"
        static let k_dd_MMM_yyyy             = "dd MMM yyyy"
        static let k_HH_MM                   = "HH:MM"
        static let k_yyyy                    = "yyyy"
        static let k_yyyy_MM_dd_HH_mm_ss     = "yyyy-MM-dd HH:mm:ss"
        static let k_MMMM                    = "MMMM"
        static let k_MM_yyyy                 = "MM/yyyy"
        static let k_MMMMyyyy                = "MMMM/yyyy"
        static let k_EEEE_DD_MMM_YYYY        = "EEE, dd MMM yyyy"
        static let k_EEEE_DD_MMM             = "EEE, dd MMM"
    }

}

func GetAppFontSize(size : CGFloat) -> CGFloat {
    return DeviceType.IS_PAD ? (size + 6.0) : size
}

//MARK: - WeekDayLabels
struct WeekDayLabels {
    
    static let kSunday                          = "sunday"
    static let kMonday                          = "monday"
    static let kTuesday                         = "tuesday"
    static let kWednesday                       = "wednesday"
    static let kThursday                        = "thursday"
    static let kFriday                          = "friday"
    static let kSaturday                        = "saturday"
}

//MARK: - MonthNames
struct MonthNames {
    static let kJan                             = "jan"
    static let kFeb                             = "feb"
    static let kMar                             = "mar"
    static let kApr                             = "apr"
    static let kMay                             = "may"
    static let kJun                             = "jun"
    static let kJul                             = "jul"
    static let kAug                             = "aug"
    static let kSep                             = "sep"
    static let kOct                             = "oct"
    static let kNov                             = "nov"
    static let kDec                             = "dec"
}

/*
struct APIStatusCode {
    static let kSessionInvalid   = 401
    static let kSucessResponse   = 200
    static let kFailResponse     = 402
    static let kEmailNotFound    = 404
    static let kAccountNotApprove    = 105
}*/ 

// MARK: - Social API Key
struct APIKeys {
    //static let GooglePlaceAPIKey = "AIzaSyBDnm5bcs_I4KnnBKSHGjTIp-_cfJUyc5Q"
    static let GooglePlaceAPIKey = "AIzaSyBVhRAiqbiO54B9LS47TOLANfFz4tU4oC0"
    static let stripPublicKey = "pk_test_9wyRe5j6MuA1kwWFsMJ08CEI"
    static let stripSecrateKey = "sk_test_Uwe7QpaZBkyFjaL0tVHbFaIA"
}
struct StorageFolder {
    static let ProfilePicture = "Profile_Picture"
}

// MARK: - Screen Title
struct ScreenTitle {
    static let OM = "MLAB"
}

// MARK: - Button Title
struct ButtonTitle {
   static let EditProfile = "EDIT PROFILE"
    static let Update = "UPDATE"
    static let SUBMIT = "SUBMIT"
    static let TakePhoto = "Take photo"
    static let PickFromGallery = "Pick from gallery"
    static let Cancel = "Cancel"
    static let OK = "OK"
    static let kNewTicket = "New Ticket"
    static let kReopen = "Reopen"

    static let Yes = "Yes"
    static let No = "No"
    static let kLogout = "Logout"
}

//MARK: - Alert Title
struct AlertTitles {
    static let kSelectProfileImage  = "Select Profile Image"
    static let kSelectStudioImagesImage  = "Select Studio Image"
    static let kCamera              = "Camera"
    static let kGallery             = "Gallery"
    static let kSelectCancellationPolicy = " Cancellation Fees"
    static let kSelectFeature = " Feature"
    static let KSelectBusinessType = " Select Studio Type"
    static let kSelectFromTime = "Select FromTime"
    static let kSelectToTime = "Select ToTime"
    static let KSelectDate = "Select Date"
    static let kSuccess     = "Success"
    static let kDone     = "Done"
    static let kSelectIndustry     = "Select Industry"
    static let kSelectUniversity     = "Select University"
    static let kSelectStartDate     = "Select Start Date"
    static let kSelectEndDate     = "Select End Date"
    static let kDeleteBookmark = "Are you sure want to delete this bookmark?"
    static let kDeleteMedications = "Are you sure want to delete this medication?"
    static let kDeleteAllergies = "Are you sure want to delete this allergy?"
    static let kDeleteHealthIssue = "Are you sure want to delete this healthissue?"
    static let kDeleteInjuries = "Are you sure want to delete this injury?"
    static let kDeleteSurgeries = "Are you sure want to delete this surgery?"
    static let kDeleteFamilyIllness = "Are you sure want to delete this family illness?"
    static let kDeleteCard = "Are you sure want to delete this card?"
    static let kDeleteDocument = "Are you sure want to delete this document?"
    static let kDeleteChat = "Are you sure want to delete this chat?"
    
    static let kSelectDOB     = "Select Date of Birth"
    static let kSelectMonth = "Select Month of Birth"
    static let kSelectDay = "Select Day of Birth"
    static let kSelectRelaton = "Select Relation"
    
    static let kCanceleAppointment = "Are you sure want to cancel this appointment?"
}

struct TextFieldPlaceHolderText {
    static let kZero = "0"
}

struct ObserverName {
    static let kcontentSize     = "contentSize"
}

struct cornerRadiousValue {
    static let defaulrCorner : CGFloat = 10.0
    static let buttonCorner : CGFloat = 15.0
}

// MARK: - Color Constant
extension UIColor {
    struct CustomColor {
        
        //00297A
        static let OnlineSidemenuColor = #colorLiteral(red: 0.1411764706, green: 0.1450980392, blue: 0.1607843137, alpha: 1)
        
        static let subTextColor = #colorLiteral(red: 0.5137254902, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        //4D2C5E
        static let tabBarColor = #colorLiteral(red: 0.3019607843, green: 0.1725490196, blue: 0.368627451, alpha: 1)
        
        //4D2C5E 40%
        static let timeUnavailableColor = #colorLiteral(red: 0.3019607843, green: 0.1725490196, blue: 0.368627451, alpha: 0.4)
        
        //White 40%
        static let timeUnavailableTExtColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        
        //848A94 50%
        static let prevDateTextColor = #colorLiteral(red: 0.5176470588, green: 0.5411764706, blue: 0.5803921569, alpha: 0.5)
        
        static let appThemeColor = #colorLiteral(red: 0.9928019643, green: 0.975951612, blue: 0.9399128556, alpha: 1)
        //F79C1C
        static let appColor = #colorLiteral(red: 0.968627451, green: 0.6117647059, blue: 0.1098039216, alpha: 1)
        static let appBackgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        static let TextViewTextColor = #colorLiteral(red: 0.6549019608, green: 0.6549019608, blue: 0.6549019608, alpha: 1)
        
        static let SegemntBGColor26Per = #colorLiteral(red: 0.9529411765, green: 0.9568627451, blue: 0.968627451, alpha: 0.26)
        //348FFC
        static let statusCloseTicketColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        //30C39E
        static let chatStatusSuccessColor = #colorLiteral(red: 0.1882352941, green: 0.7647058824, blue: 0.6196078431, alpha: 1)
        
        //848A94 38%
        static let weekdayTextColor = #colorLiteral(red: 0.5176470588, green: 0.5411764706, blue: 0.5803921569, alpha: 0.38)
        
        //D4D4D4
        static let jobRemainingColor = #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        //646464 80%
        static let talkDescColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 0.8)
        
        //0C0C0E 38%
        static let filterBtnLogin = #colorLiteral(red: 0.04705882353, green: 0.04705882353, blue: 0.05490196078, alpha: 0.38)
        
        //D4B4E2 10%
        static let TransactionBGColor = #colorLiteral(red: 0.831372549, green: 0.7058823529, blue: 0.8862745098, alpha: 0.2386320153)
        
        //FFDCAA
        static let borderColorSession  = #colorLiteral(red: 1, green: 0.862745098, blue: 0.6666666667, alpha: 1)
        
        //FFE9CB
        static let outgoingChatBGColor = #colorLiteral(red: 1, green: 0.9137254902, blue: 0.7960784314, alpha: 1)
        
        //83718B
        static let tutorialColor = #colorLiteral(red: 0.5137254902, green: 0.4431372549, blue: 0.5450980392, alpha: 1)
        //A89BAE 17%
        static let priceColor17 = #colorLiteral(red: 0.6588235294, green: 0.6078431373, blue: 0.6823529412, alpha: 0.17)

        //D6D8DB
        static let progressBarBackColor = #colorLiteral(red: 0.8392156863, green: 0.8470588235, blue: 0.8588235294, alpha: 1)
        
        //141E30
        static let TextColor = #colorLiteral(red: 0.07843137255, green: 0.1176470588, blue: 0.1882352941, alpha: 1)
        
        //020B2D
        static let HomeNearColor = #colorLiteral(red: 0.007843137255, green: 0.0431372549, blue: 0.1764705882, alpha: 1)
        
        //037EF3
        static let ResendButtonColor = #colorLiteral(red: 0.9554305673, green: 0.6617327332, blue: 0.2603107691, alpha: 1)
        
        //FFDE17
        static let countBGColor = #colorLiteral(red: 1, green: 0.8705882353, blue: 0.09019607843, alpha: 1)
        
        //326CDE
        static let categoriesBorderColor = #colorLiteral(red: 0.1960784314, green: 0.4235294118, blue: 0.8705882353, alpha: 1)
        
        //F5F7FB
        static let loginBoxBGColor = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9843137255, alpha: 1)
        
        //0C0C0E
        static let textHedareLogin = #colorLiteral(red: 0.04705882353, green: 0.04705882353, blue: 0.05490196078, alpha: 1)
        
        //848A94
        static let textConnectLogin = #colorLiteral(red: 0.5176470588, green: 0.5411764706, blue: 0.5803921569, alpha: 1)
        
        //646464
        static let SubscriptuionSubColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        
        //FFEFCE
        static let ExperienceBGColor = #colorLiteral(red: 1, green: 0.937254902, blue: 0.8078431373, alpha: 1)
        
        static let reusableViewBackColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 1, alpha: 0.33)
        
        //000000 10%
        static let shadowColorTenPerBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        //FC2A8C
        static let cancelAppointColor = #colorLiteral(red: 0.9882352941, green: 0.1647058824, blue: 0.5490196078, alpha: 1)
        
        //F3F3F3
        static let borderColorMsg = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
        //#FFFFFF 50%
        static let whitecolor50 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        //1B4851
        static let verificationTextColor = #colorLiteral(red: 0.1058823529, green: 0.2823529412, blue: 0.3176470588, alpha: 1)
        
        //8E8E8E
        static let bookedSlotColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5568627451, alpha: 1)
        
        //8E8E8E
        static let SetAppontmentColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5568627451, alpha: 1)
        
        //037EF3
        static let forgotColor = #colorLiteral(red: 0.01176470588, green: 0.4941176471, blue: 0.9529411765, alpha: 1)
        
        //FDF8EE
        static let tutorialBGColor = #colorLiteral(red: 0.9921568627, green: 0.9725490196, blue: 0.9333333333, alpha: 1)
        
        //FF7700
        static let muteCallColor = #colorLiteral(red: 1, green: 0.4666666667, blue: 0, alpha: 1)
        
        //348FFC
        static let EndVideoColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        
        //348FFC
        static let MuteVideoColor = #colorLiteral(red: 0.2039215686, green: 0.5607843137, blue: 0.9882352941, alpha: 1)
        
        //AAAAAA
        static let NotificationDescColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        
        //293644 alpha
        static let successprofilesubColor = #colorLiteral(red: 0.1607843137, green: 0.2117647059, blue: 0.2666666667, alpha: 0.3)
        
        //White 0%
        static let whiteGradiantOne = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        //White 100%
        static let whiteGradiantTwo = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //ADADAD
        static let alreadyColor = #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
        
        //C4C4C4
        static let searchPlaceholderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        
        //828DA4
        static let HomeCategoryColor = #colorLiteral(red: 0.5098039216, green: 0.5529411765, blue: 0.6431372549, alpha: 1)
        
        //6F27FF
        static let registerColor = #colorLiteral(red: 0.4352941176, green: 0.1529411765, blue: 1, alpha: 1)
        
        //EBEFF4
        static let SpecilityColor = #colorLiteral(red: 0.9215686275, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        
        //E0E0E0
        static let slidermaxColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        
        //272755
        static let SliderTextColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.3333333333, alpha: 1)
        
        //5B5A61
        static let segementOtherDotColor = #colorLiteral(red: 0.3568627451, green: 0.3529411765, blue: 0.3803921569, alpha: 1)
        
        //6F27FF 50%
        static let pageAlphaColor = #colorLiteral(red: 0.4352941176, green: 0.1529411765, blue: 1, alpha: 0.5)
        
        //383F45
        static let aboutDetailColor = #colorLiteral(red: 0.2196078431, green: 0.2470588235, blue: 0.2705882353, alpha: 1)
        
        //918FB7
        static let RegLanuageColor = #colorLiteral(red: 0.568627451, green: 0.5607843137, blue: 0.7176470588, alpha: 1)
        
        //363636
        static let careDateColor = #colorLiteral(red: 0.2117647059, green: 0.2117647059, blue: 0.2117647059, alpha: 1)
        
        //1E243A
        static let AppointmentTExtColor = #colorLiteral(red: 0.1176470588, green: 0.1411764706, blue: 0.2274509804, alpha: 1)
        
        //0098FF
        static let ReopenTicketColor = #colorLiteral(red: 0, green: 0.5960784314, blue: 1, alpha: 1)
        
        //1D1D1D
        static let TicketTitleColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)
        
        //00D507
        static let SuccessStaus = #colorLiteral(red: 0, green: 0.8352941176, blue: 0.02745098039, alpha: 1)
        
        //113260
        static let otpTextColor = #colorLiteral(red: 0.06666666667, green: 0.1960784314, blue: 0.3764705882, alpha: 1)
        
        //EEEEFF
        static let locationNameBackColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 1, alpha: 0.3)
        
        //D61B0A
        static let IntroCurrentTextColor = #colorLiteral(red: 0.8392156863, green: 0.1058823529, blue: 0.03921568627, alpha: 1)
        static let IntroDefaultTextColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        //F04037
        static let resourceBtnColor = #colorLiteral(red: 0.9411764706, green: 0.2509803922, blue: 0.2156862745, alpha: 1)
        
        //D42731
        static let btnBackColor = #colorLiteral(red: 0.831372549, green: 0.1529411765, blue: 0.1921568627, alpha: 1)
        
        //7F8FA4
        static let labelColorLogin = #colorLiteral(red: 0.4980392157, green: 0.5607843137, blue: 0.6431372549, alpha: 1)
        
        //#0078B5
        static let LinkedinColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.7098039216, alpha: 1)
        
        //3393F3
        static let profilebackcolor = #colorLiteral(red: 0.2, green: 0.5764705882, blue: 0.9529411765, alpha: 1)
        
        //242424
        static let labelTextColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        
        //242424 50%
        static let labelTextColorAlpha = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 0.5)
        
        //101010
        static let headerBackColor = #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1)
        
        //101010 50%
        static let headerBackAlphaColor = #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 0.5)
        
        //F8F8F8
        static let otpColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        
        //000000
        static let languageBackColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 0.06)
        
        //FFAE57
        static let gradiantColorTop =  #colorLiteral(red: 1, green: 0.6823529412, blue: 0.3411764706, alpha: 1)
        //EA9335
        static let gradiantColorBottom =  #colorLiteral(red: 0.9176470588, green: 0.5764705882, blue: 0.2078431373, alpha: 1)
        
        static let viewGradientColorTop = #colorLiteral(red: 0.9921568627, green: 0.975951612, blue: 0.9399128556, alpha: 1)
        //1C79BC 9%
        static let backBGcolor9Per = #colorLiteral(red: 0.1098039216, green: 0.4745098039, blue: 0.737254902, alpha: 0.5)
        
        //EC9334 77%
        static let buttonBGGCOne = #colorLiteral(red: 0.9254901961, green: 0.5764705882, blue: 0.2039215686, alpha: 0.77)
        
        //474747
        static let BlogDescColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        
        //D4B4E2
        static let ticketIDcolor = #colorLiteral(red: 0.831372549, green: 0.7058823529, blue: 0.8862745098, alpha: 1)
        
        static let bottomclr = #colorLiteral(red: 0.06431286782, green: 0.5271624327, blue: 0.8091296554, alpha: 1)
        
        //A93BFF 6%
        static let gradiantColorTopAlpha = #colorLiteral(red: 0.662745098, green: 0.231372549, blue: 1, alpha: 0.06)
        //00E9FF 6%
        static let gradiantColorBottomAlpha = #colorLiteral(red: 0, green: 0.9137254902, blue: 1, alpha: 0.06)
        
        //4D2C5E 75%
        static let GradiantTabBarColor75 = #colorLiteral(red: 0.3019607843, green: 0.1725490196, blue: 0.368627451, alpha: 0.75)
        
        //4D2C5E 0%
        static let GradiantTabBarColor0 = #colorLiteral(red: 0.3019607843, green: 0.1725490196, blue: 0.368627451, alpha: 0)
        
        //92929D
        static let labelORColor = #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.6156862745, alpha: 1)
        
        //EAEDF7
        static let loginBGBorderColor = #colorLiteral(red: 0.9176470588, green: 0.9294117647, blue: 0.968627451, alpha: 1)
        
        //54 54 54 242134
        static let appTextColor = #colorLiteral(red: 0.1411764706, green: 0.1294117647, blue: 0.2039215686, alpha: 1)
        
        //344356
        static let QuestonAnswerColor = #colorLiteral(red: 0.2039215686, green: 0.262745098, blue: 0.337254902, alpha: 1)
        
        //EE983C 35%
        static let ButtonShadowColor = #colorLiteral(red: 0.9333333333, green: 0.5960784314, blue: 0.2352941176, alpha: 0.35)
        
        //1C295A
        static let shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.16)
        
        //01274C 7%
        static let shadowColorBlack = #colorLiteral(red: 0.003921568627, green: 0.1529411765, blue: 0.2980392157, alpha: 0.14)
        
        //000000 20%
        static let shadowFiveColorBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        //FFA638
        static let ratingColor = #colorLiteral(red: 1, green: 0.6509803922, blue: 0.2196078431, alpha: 1)
        
        static let borderColor2 = #colorLiteral(red: 0.8823529412, green: 0.9098039216, blue: 0.9333333333, alpha: 1)
        
        //767581
        static let resourceDateColor = #colorLiteral(red: 0.462745098, green: 0.4588235294, blue: 0.5058823529, alpha: 1)
        //19191B
        static let resourceHeadreColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        
        static let viewBackgrounfLanguage = #colorLiteral(red: 0.9529411765, green: 0.9568627451, blue: 0.968627451, alpha: 1)
        
        //303639
        static let barbuttoncolor = #colorLiteral(red: 0.1882352941, green: 0.2117647059, blue: 0.2235294118, alpha: 1)
        
        
        //A89BAE
        static let appPlaceholderColor = #colorLiteral(red: 0.6588235294, green: 0.6078431373, blue: 0.6823529412, alpha: 1)
        
        //#606060
        static let buttonTextColor = #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        
        //000000
        static let blackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        //000000 60%
        static let black60Per = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        //000000 50%
        static let black50Per = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        //161616
        static let btnBackgroundColor = #colorLiteral(red: 0.0862745098, green: 0.0862745098, blue: 0.0862745098, alpha: 1)
        
        //#707070x
        static let sepretorColor  = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        
        //#6E6E6E
        static let dateColor  = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        
        //#F2F2F2
        static let sepratorFeedColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        
        //FFDEBA
        static let borderColor  = #colorLiteral(red: 1, green: 0.8705882353, blue: 0.7294117647, alpha: 1)
        //EAE9F2
        static let borderColor23 = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.9490196078, alpha: 1)
        //E2E2E2
        static let borderColor4 = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        //CFCFCF
        static let bordrColor5 = #colorLiteral(red: 0.8117647059, green: 0.8117647059, blue: 0.8117647059, alpha: 1)
        //E8EEF4
        static let borderColor6 = #colorLiteral(red: 0.9098039216, green: 0.9333333333, blue: 0.9568627451, alpha: 1)
        //E9E9E9
        static let borderColor7 = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        //D2D5E1
        static let borderColor8 = #colorLiteral(red: 0.8235294118, green: 0.8352941176, blue: 0.8823529412, alpha: 1)
        
        //E1E8EE
        static let borderFeedback = #colorLiteral(red: 0.8823529412, green: 0.9098039216, blue: 0.9333333333, alpha: 1)
        
        //E1E8EE 6%
        static let answerBackColor = #colorLiteral(red: 0.8823529412, green: 0.9098039216, blue: 0.9333333333, alpha: 0.06)
        
        //#D1D1D1
        static let feedBorderColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        
        //C7C7CC
        static let sepratorcolor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 1)
        
        //#595959
        static let LoginLabelColor  = #colorLiteral(red: 0.3490196078, green: 0.3490196078, blue: 0.3490196078, alpha: 1)
        //#8497B0
        static let LoginLabelSeondTextColor  = #colorLiteral(red: 0.5176470588, green: 0.5921568627, blue: 0.6901960784, alpha: 1)
        //#7F7F7F
        
        static let LoginSubLabelTextColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        //#8B8B8B
        static let HeaderLabelTextColor = #colorLiteral(red: 0.5450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
        
        //#A5A5A5
        static let AcceptLabelTextColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        
        //E5E5E5
        static let sepratorColorLocation = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        
        //EDF4F8
        static let availibilityBackColor = #colorLiteral(red: 0.9294117647, green: 0.9568627451, blue: 0.9725490196, alpha: 1)
        
        //#F7F7F7
        static let tabbarBackgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        
        //#151515
        static let lblProfileColor = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        
        static let welcomeBordercolor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9607843137, alpha: 1)
        
        //EBEBEB
        static let cardBackColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        //#FFFFFF
        static let whitecolor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //242529
        static let commonLabelColor = #colorLiteral(red: 0.1411764706, green: 0.1450980392, blue: 0.1607843137, alpha: 1)
        
        //E3E3E3
        static let CategoryPricecolor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        
        static let NavTitleColor = #colorLiteral(red: 0.9254901961, green: 0.5764705882, blue: 0.2039215686, alpha: 1)
        
        
        static let grayColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static let ForgotFontColor = #colorLiteral(red: 0.3362234533, green: 0.1981375515, blue: 0.4187525511, alpha: 1)
        
        //1A2332
        static let subscriptionColor = #colorLiteral(red: 0.1019607843, green: 0.137254902, blue: 0.1960784314, alpha: 1)
        
        //#FFFFFF 25*
        static let whitecolor25Per = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.25)
        
        //#FFFFFF 0%
        static let whitecolor0Per = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        //333232
        static let savedCardColor = #colorLiteral(red: 0.2, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        
        //#FFFFFF 60*
        static let whitecolorAlpha = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        //#FFFFFF 70*
        static let whitecolorAlpha70 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        //FAFCFE
        static let microColor = #colorLiteral(red: 0.9803921569, green: 0.9882352941, blue: 0.9960784314, alpha: 1)
        
        //034BB8
        static let progrescolor = #colorLiteral(red: 0.01176470588, green: 0.2941176471, blue: 0.7215686275, alpha: 1)
        
        //404040
        static let aboutVersionColor = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
        
        //DEDBDB
        static let cardHeaderColor = #colorLiteral(red: 0.8705882353, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        
        //BFBFBF
        static let cardLabelColor = #colorLiteral(red: 0.7490196078, green: 0.7490196078, blue: 0.7490196078, alpha: 1)
        
        //636E95
        static let settingSubDescColor = #colorLiteral(red: 0.3882352941, green: 0.431372549, blue: 0.5843137255, alpha: 1)
        
        //369AFE
        static let settingEditBtnColor = #colorLiteral(red: 0.2117647059, green: 0.6039215686, blue: 0.9960784314, alpha: 1)
        
        //666668
        static let profileTextHeaderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4078431373, alpha: 1)
        
        //E1E0E3
        static let prpfileSepratorColor = #colorLiteral(red: 0.8823529412, green: 0.8784313725, blue: 0.8901960784, alpha: 1)
        
        //ECEFF8
        static let SwitchOffColor = #colorLiteral(red: 0.9254901961, green: 0.937254902, blue: 0.9725490196, alpha: 1)
        
        //5EC298
        static let switchOnColor = #colorLiteral(red: 0.368627451, green: 0.7607843137, blue: 0.5960784314, alpha: 1)
        
        //24272C
        static let sepratorColor2 = #colorLiteral(red: 0.1411764706, green: 0.1529411765, blue: 0.1725490196, alpha: 1)
        
        //5D5D5D
        static let ticketHeadarColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        
        //97A0C3
        static let ticketTimeColor = #colorLiteral(red: 0.5921568627, green: 0.6274509804, blue: 0.7647058824, alpha: 1)
        
        //7ED321
        static let statusTicketColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
        
        //0052CC
        static let chatBackColor = #colorLiteral(red: 0, green: 0.3215686275, blue: 0.8, alpha: 1)
        //F5F5F5
        static let chatBackColor2 = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        //FFFFFF
        static let chatTextboxColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.21)
        
        //FFFFFF 45%
        static let copyBackColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.45)
        
        //00DF81
        static let ticketStausColor = #colorLiteral(red: 0, green: 0.8745098039, blue: 0.5058823529, alpha: 1)
        
        //EFF2F7
        static let chatIncomingBackColor = #colorLiteral(red: 0.937254902, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        //56AAFF
        static let chatSendBackColor = #colorLiteral(red: 0.337254902, green: 0.6666666667, blue: 1, alpha: 1)
        
        //171725
        static let notificationTextColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1450980392, alpha: 1)
        
        //F1F1F5
        static let NotificationSepratorColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9607843137, alpha: 1)
        
        //F4F7FF
        static let readStatusColor = #colorLiteral(red: 0.9568627451, green: 0.968627451, blue: 1, alpha: 1)
        
        //334150
        static let referEmailColor = #colorLiteral(red: 0.2, green: 0.2549019608, blue: 0.3137254902, alpha: 1)
        
        //323132
        static let referHistoryColor = #colorLiteral(red: 0.1960784314, green: 0.1921568627, blue: 0.1960784314, alpha: 1)
        
        //FC85A3
        static let homeTimeColor = #colorLiteral(red: 0.9882352941, green: 0.5215686275, blue: 0.6392156863, alpha: 1)
        
        //8476CD
        static let homeQuizColor = #colorLiteral(red: 0.5176470588, green: 0.462745098, blue: 0.8039215686, alpha: 1)
        
        //1FD0A3
        static let BookamarkColorHeader = #colorLiteral(red: 0.1215686275, green: 0.8156862745, blue: 0.6392156863, alpha: 1)
        
        //DBF7F0
        static let boomarkBackColor = #colorLiteral(red: 0.8588235294, green: 0.968627451, blue: 0.9411764706, alpha: 1)
        
        //CBDBF7
        static let courseUpgradeColor = #colorLiteral(red: 0.7960784314, green: 0.8588235294, blue: 0.968627451, alpha: 1)
        
        //296DD5
        static let pageControlTintColor = #colorLiteral(red: 0.1607843137, green: 0.4274509804, blue: 0.8352941176, alpha: 0.5)
        
        //3F88EB
        static let PurchaseHistoryColor = #colorLiteral(red: 0.2470588235, green: 0.5333333333, blue: 0.9215686275, alpha: 1)
        
        //EEF2FE
        static let ProgressTrackColor = #colorLiteral(red: 0.9333333333, green: 0.9490196078, blue: 0.9960784314, alpha: 1)
        
        //ECF0FC
        static let UnitStudentBackColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9882352941, alpha: 1)
        
        //FF4A77
        static let wrongAnswerColor = #colorLiteral(red: 1, green: 0.2901960784, blue: 0.4666666667, alpha: 1)
        
        //F3F9FF
        static let selectedColorButtonTab = #colorLiteral(red: 0.9529411765, green: 0.9764705882, blue: 1, alpha: 1)
        
        //FFFFFF
        static let acceptColorButtonText = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //6F27FF
        static let acceptColorButtonBackGround = #colorLiteral(red: 0.4352941176, green: 0.1529411765, blue: 1, alpha: 1)
        
        //#FF0057
        static let rejectColorButtonBackGround = #colorLiteral(red: 1, green: 0, blue: 0.3411764706, alpha: 1)
        
        //#FF0057
        static let viewBreakupTitleColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 0.8)
        
        static let appBackColor  = #colorLiteral(red: 0.1058823529, green: 0.2823529412, blue: 0.3176470588, alpha: 1)
        //00297A
       
    }
}

struct Masking {
    static let kPhoneNumberMasking = "XXX-XXX-XXXX"
    static let kUSPhoneNumberMasking = "(XXX)-XXX-XXXX"
    static let kCardNumberMasking = "XXXX-XXXX-XXXX-XXXX"
    static let kCardExire = "XX/XXXX"
    static let kCardCVV = "XXXX"

}
//Alert Control Key
struct AlertControllerKey {

    static let kOpenInMap          = "Open in Apple Maps"
    static let kOpenInGoogleMap    = "Open in Google Maps"
    static let kCopyAddress        = "Copy Address"
    static let kCancel             = "Cancel"
}

struct DefaultPlaceholderImage {
    static let AppPlaceholder = "AppPlaceholder"
    static let UserAppPlaceholder = "AppPlaceholderUser"
    static let ImgImagePlaceholder = "imgImagePlaceholder"
}

// MARK: - User Defaults Key Constant
struct UserDefaultsKey {
    static let kIsLoggedIn      = "isLoggedIn"
    static let kLoginUser       = "loginUser"
    static let kIncognitoCount  = "incognitomodecount"
    static let kIncognitoDate   = "incognitomodedate"
    static let kUserChatID      = "chat_user_id"
    static let kUserFullName    = "user_fullname"
    static let kUserDeviceToken    = "UserDeviceToken"
    static let kSelectedLanguageCode = "SelectedLanguageCode"
    static let kVoipToken = "VoipToken"
    static let kIsShowTutorial = "IsShowTutorial"
}

struct NotificationPostname {
    static let KAuthenticationTokenExpire = "AuthenticationTokenExpire"
    static let KUpdateProfile = "UpdateProfile"
    static let KReloadHomeScreenData = "ReloadHomeScreenData"
    static let KLocationStatus = "LocationStatus "
    static let kShowFeedDetail = "ShowFeedDetail"
    static let KUpdateNavigationBar = "UpdateNavigationBar"
    static let kSearchClick      = "SearchClick"
    static let kReloadChatConnected = "ReloadChatConnected"
    static let kPushNotification = "PushNotification"
    static let kSearchJobClick      = "SearchJobClick"
    static let kUpdateNotificationCount = "UpdateNotificationCount"
}

struct voiceITApiKey {
    static let kAPIKey = "key_067ccd106703471b9d3d54b13a55c68b"
    static let kAPIToken = "tok_725f56b29209465db4fece353bbd35ae"
    static let kPhase = "Saving lives one driver at a time"//"Remember to wash your hands before eating"
    static let kLanguage = "en-AU"
}
/*
//Response StatusCode
enum StatusCode : Int {
    case success = 200,
    passwordInvalid = 104,
    SomthingWentWrong = 400,
    AuthTokenInvalied = 401,
    RecordNotFound = 404,
    OldPasswordWrong = 103,
    EmailAlreadyExist = 102,
    RecordAlreadyExist = 105,
    accountDisaprrove = 106
}

// MARK: - Common Request/Response API Parameter Constant
let kAuthorization = "Authorization"
let kPageNo = "page_no"
let kResult = "Result"
let kMessage = "message"
let kData = "data"
let kStatusCode = "status"
let kTotalCount = "TotalCount"
let kPageSize   = "page_size"
let kFlag = "Flag"*/

//Response StatusCode
enum APIStatusCode : String {
    case success = "1",
    Failure = "0",
    passwordInvalid = "104",
    NoRecord = "6",
    EmailNotAdded = "4",
    AuthTokenInvalied = "2",
    verifyAcccout = "3",
    blocked = "5"
}

// MARK: - Common Request/Response API Parameter Constant
let kAuthorization = "Authorization"
let kPageNo = "page"
let kResult = "Result"
let kMessage = "message"
let kData = "data"
let ktotalPages = "totalPages"
let kStatusCode = "status"
let kstatus = "status"
//let kStatus = "status"
let kTotalCount = "TotalCount"
let kPageSize   = "page_size"
let kFlag = "IsSuccess"
let kRates = "rates"

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

//MARK: - Notification Observer Strings
struct NotificationObserverStrings {
    static let kReadNotification              = "ReadNotification"
    static let kCloseVideoCall                = "closeVideoCall"
    static let kEndVideoCall                  = "endVideoCall"
    static let kPopVideoCallScreen            = "popVideoCallScreen"
    static let kCallNotReceived               = "callNotReceived"
    static let kCancelCallFromCallKit         = "cancelCallFromCallKit"
    
    //Video
    static let kDismissVideoCall              = "DismissVideoCall"
    static let kRejectVideoCall               = "RejectVideoCall"
    static let kAcceptedVideoCall             = "AcceptedVideoCall"
    static let kMissedVideoCall               = "MissedVideoCall"
    //Audio
    static let kDismissAudioCall               = "DismissAudioCall"
    static let kRejectAudioCall               = "RejectAudioCall"
    static let kAcceptedAudioCall             = "AcceptedAudioCall"
    static let kMissedAudioCall               = "MissedAudioCall"
    //For Both
    static let kFinalEndCall                  = "FinalEndCall"
    //Notification
    static let kUpdateBellIconBadge           = "UpdateBellIconBadge"
}
enum GenderEnum : Int {
    case Male = 1, Female = 2,Other = 3, PreferNotToSay = 4, None = 0
    
    var name : String {
        switch self {
        case .Male:
            return "Male"
        case .Female:
            return "Female"
        case .PreferNotToSay:
            return "Prefer not to say"
        case .Other:
            return "Other"
        case .None:
            return ""
        }
    }
    
    var apiValue : String {
        switch self {
        case .Male:
            return "1"
        case .Female:
            return "2"
        case .Other:
            return "3"
        case .PreferNotToSay:
            return "4"
        case .None:
            return "0"
        }
    }
    
}

enum ProfileStatusEnum : String {
    case Default = "0"
    case Subscription = "1"
    case PersonalDetails = "2"
    case AboutYouLoveOne = "3"
    case YourLocation = "4"
    
    var apiValue : String {
        switch self {
        case .Default:
            return "0"
        case .Subscription:
            return "1"
        case .PersonalDetails:
            return "2"
        case .AboutYouLoveOne:
            return "3"
        case .YourLocation:
            return "4"
        }
    }
}
