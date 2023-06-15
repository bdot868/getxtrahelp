//
//  JobModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 10/12/21.
//

import UIKit

enum StartJobStatusEnum : String {
    case NotStarted = "0"
    case Ongoing = "1"
    case Completed = "2"
    
    var name : String {
        switch self {
        case .NotStarted:
            return "Not Started"
        case .Ongoing:
            return "Ongoing"
        case .Completed:
            return "Completed"
        }
    }
}

class JobModel: NSObject {
    
    var userJobId : String
    var userId : String
    var categoryId : String
    var name : String
    var price : String
    var formatedPrice : String
    var ownTransportation : String
    var nonSmoker : String
    var currentEmployment : String
    var minExperience : String
    var yearExperience : String
    var location : String
    var latitude : String
    var longitude : String
    var jobDesc : String
    var isJob : String
    var totalApplication : String
    var startDateTime : String
    var CategoryName : String
    var createdDateFormat : String
    var media : [AddPhotoVideoModel]
    var questions : [AdditionalQuestionModel]
    var applicants : [JobApplicantsModel]
    
    var caregiverId : String
    var userJobApplyId : String
    var userJobIsHire : String
    var userJobDetailId : String
    var jobStatus : SegmentJobTabEnum
    var profileImageUrl : String
    var profileImageThumbUrl : String
    var userFullName : String
    var verificationCode : String
    var jobRating : String
    var jobFeedback : String
    var caregiverRatingAverage : String
    var caregiverPhone : String
    
    var uploadedMedia : [AddPhotoVideoModel]
    var userJobSubstituteRequestId : String
    var jobName : String
    var newCaregiverId : String
    var endTime : String
    var startTime : String
    
    var startJobStatus : StartJobStatusEnum
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userJobId = dictionary[kuserJobId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.categoryId = dictionary[kcategoryId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.price = dictionary[kprice] as? String ?? ""
        self.formatedPrice = dictionary[kformatedPrice] as? String ?? ""
        self.ownTransportation = dictionary[kownTransportation] as? String ?? ""
        self.nonSmoker = dictionary[knonSmoker] as? String ?? ""
        self.currentEmployment = dictionary[kcurrentEmployment] as? String ?? ""
        self.minExperience = dictionary[kminExperience] as? String ?? ""
        self.yearExperience = dictionary[kyearExperience] as? String ?? ""
        self.location = dictionary[klocation] as? String ?? ""
        self.latitude = dictionary[klatitude] as? String ?? ""
        self.longitude = dictionary[klongitude] as? String ?? ""
        self.jobDesc = dictionary[kdescription] as? String ?? ""
        self.isJob = dictionary[kisJob] as? String ?? ""
        self.totalApplication = dictionary[ktotalApplication] as? String ?? ""
        self.startDateTime = dictionary[kstartDateTime] as? String ?? ""
        self.CategoryName = dictionary[kCategoryName] as? String ?? ""
        self.createdDateFormat = dictionary[kcreatedDateFormat] as? String ?? ""
        self.media = (dictionary[kmedia] as? [[String:Any]] ?? []).compactMap(AddPhotoVideoModel.init)
        self.questions = (dictionary[kquestions] as? [[String:Any]] ?? []).compactMap(AdditionalQuestionModel.init)
        self.applicants = (dictionary[kapplicants] as? [[String:Any]] ?? []).compactMap(JobApplicantsModel.init)
        
        self.caregiverId = dictionary[kcaregiverId] as? String ?? ""
        self.userJobApplyId = dictionary[kuserJobApplyId] as? String ?? ""
        self.userJobIsHire = dictionary[kuserJobIsHire] as? String ?? ""
        self.userJobDetailId = dictionary[kuserJobDetailId] as? String ?? ""
        self.jobStatus = (SegmentJobTabEnum.init(rawValue: Int(dictionary[kjobStatus] as? String ?? "") ?? 0)) ?? .Upcoming
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.userFullName = dictionary[kuserFullName] as? String ?? ""
        self.verificationCode = dictionary[kverificationCode] as? String ?? ""
        self.jobRating = dictionary[kjobRating] as? String ?? ""
        self.jobFeedback = dictionary[kjobFeedback] as? String ?? ""
        self.caregiverRatingAverage = dictionary[kcaregiverRatingAverage] as? String ?? ""
        self.caregiverPhone = dictionary[kcaregiverPhone] as? String ?? ""
        
        self.uploadedMedia = (dictionary[kuploadedMedia] as? [[String:Any]] ?? []).compactMap(AddPhotoVideoModel.init)
        self.userJobSubstituteRequestId = dictionary[kuserJobSubstituteRequestId] as? String ?? ""
        self.jobName = dictionary[kjobName] as? String ?? ""
        self.newCaregiverId = dictionary[knewCaregiverId] as? String ?? ""
        
        self.startTime = dictionary[kstartTime] as? String ?? ""
        self.endTime = dictionary[kendTime] as? String ?? ""
        
        self.startJobStatus = (StartJobStatusEnum.init(rawValue: dictionary[kstartJobStatus] as? String ?? "")) ?? .NotStarted
    }

    class func saveUserJob(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String,_ jobid : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveUserJob, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                var jobid : String = ""
                if let dataDict = dict[kData] as? [String:Any] {
                    jobid = dataDict[kjobId] as? String ?? ""
                }
                withResponse(message,jobid)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
   
    class func getMyPostedJobList(with param: [String:Any]?,isfromPostedJob : Bool = true,isShowLoader : Bool,selectedTab : SegmentJobTabEnum = .Upcoming, success withResponse: @escaping (_ arr: [JobModel],_ totalpage : Int) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        
        
        var APIName : String = AppConstant.API.kgetMyPostedJob
        if isfromPostedJob {
            APIName = AppConstant.API.kgetMyPostedJob
        } else {
            switch selectedTab {
            case .Posted:
                APIName = AppConstant.API.kgetMyPostedJob
            case .Upcoming:
                APIName = AppConstant.API.kgetUserRelatedJobList
            case .Completed:
                APIName = AppConstant.API.kgetUserRelatedJobList
            case .Substitute:
                APIName = AppConstant.API.kgetUserSubstituteJobRequestList
            }
        }
        //isfromPostedJob ? AppConstant.API.kgetMyPostedJob : AppConstant.API.kgetUserRelatedJobList
        APIManager.makeRequest(with: APIName, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(JobModel.init)
                
                withResponse(arr,totalPages)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            failure("0",connectionError, .connection)
        })
    }
    
    class func getMyPostedJobDetail(with param: [String:Any]?,isFromRelatedjobDetail : Bool = false, success withResponse: @escaping (_ obj: JobModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isFromRelatedjobDetail ? AppConstant.API.kgetUserRelatedJobDetail : AppConstant.API.kgetMyPostedJobDetail, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let model = JobModel.init(dictionary: dataDict) {
                withResponse(model,message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func acceptRejectCaregiverJobRequest(with param: [String:Any]?,isAccept : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isAccept ? AppConstant.API.kacceptCaregiverJobRequest : AppConstant.API.krejectCaregiverJobRequest, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func cancelMyPostedJob(with param: [String:Any]?,success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kcancelMyPostedJob, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func requestJobImageVideo(with param: [String:Any]?,success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.krequestJobImageVideo, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func AcceptRejectJobSubstitudeRequest(with param: [String:Any]?,isAccept : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isAccept ? AppConstant.API.kacceptSubstituteJobRequest : AppConstant.API.krejectSubstituteJobRequest, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func sendJobExtraHoursRequest(with param: [String:Any]?,success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with:AppConstant.API.ksendJobExtraHoursRequest, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func awardJobRequest(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kawardJobRequest, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func awardJobSavePaymentData(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kawardJobSavePaymentData, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
}
