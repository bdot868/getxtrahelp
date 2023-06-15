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
    var isJob : JobTypeEnum
    var totalApplication : String
    var startDateTime : String
    var CategoryName : String
    var createdDateFormat : String
    var media : [AddPhotoVideoModel]
    var questions : [AdditionalQuestionModel]
    
    var isHire : String
    var userFullName : String
    var profileImageUrl : String
    var profileImageThumbUrl : String
    var distance : String
    var isJobApply : String
    var jobStatus : SegmentJobTabEnum
    var userJobApplyId : String
    var userJobDetailId : String
    
    var userCardId : String
    var verificationCode : String
    var totalTiming : String
    var totalMinutes : String
    var TotalSeconds : String
    var jobRating : String
    var jobFeedback : String
    var userPhone : String
    
    var uploadedMedia : [AddPhotoVideoModel]
    
    var userJobSubstituteRequestId : String
    var jobName : String
    
    var jobId : String
    var startTime : String
    var endTime : String
    var requestStartTime : String
    var requestEndTime : String
    var caregiverId : String
    var perviousHours : String
    var updatedHours : String
    var startJobStatus : StartJobStatusEnum
    var ongoingJobPendingTiming : String
    var ongoingJobPendingMinutes : String
    var ongoingJobPendingSeconds : String
    
    var userJobAwardId : String
    
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
        self.isJob = JobTypeEnum.init(rawValue: dictionary[kisJob] as? String ?? "") ?? .OneTime
        self.totalApplication = dictionary[ktotalApplication] as? String ?? ""
        self.startDateTime = dictionary[kstartDateTime] as? String ?? ""
        self.CategoryName = dictionary[kCategoryName] as? String ?? ""
        self.createdDateFormat = dictionary[kcreatedDateFormat] as? String ?? ""
        self.media = (dictionary[kmedia] as? [[String:Any]] ?? []).compactMap(AddPhotoVideoModel.init)
        self.questions = (dictionary[kquestions] as? [[String:Any]] ?? []).compactMap(AdditionalQuestionModel.init)
        
        self.isHire = dictionary[kisHire] as? String ?? ""
        self.userFullName = dictionary[kuserFullName] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.distance = dictionary[kdistance] as? String ?? ""
        self.isJobApply = dictionary[kisJobApply] as? String ?? ""
        self.jobStatus = (SegmentJobTabEnum.init(rawValue: Int(dictionary[kjobStatus] as? String ?? "") ?? 0)) ?? .Upcoming
        self.userJobDetailId = dictionary[kuserJobDetailId] as? String ?? ""
        self.userJobApplyId = dictionary[kuserJobApplyId] as? String ?? ""
        
        self.userCardId = dictionary[kuserCardId] as? String ?? ""
        self.verificationCode = dictionary[kverificationCode] as? String ?? ""
        self.totalTiming = dictionary[ktotalTiming] as? String ?? ""
        self.totalMinutes = dictionary[ktotalMinutes] as? String ?? ""
        self.TotalSeconds = dictionary[kTotalSeconds] as? String ?? ""
        self.jobRating = dictionary[kjobRating] as? String ?? ""
        self.jobFeedback = dictionary[kjobFeedback] as? String ?? ""
        self.userPhone =  dictionary[kuserPhone] as? String ?? ""
        
        self.uploadedMedia = (dictionary[kuploadedMedia] as? [[String:Any]] ?? []).compactMap(AddPhotoVideoModel.init)
        
        self.userJobSubstituteRequestId = dictionary[kuserJobSubstituteRequestId] as? String ?? ""
        self.jobName = dictionary[kjobName] as? String ?? ""
        
        self.jobId = dictionary[kjobId] as? String ?? ""
        self.startTime = dictionary[kstartTime] as? String ?? ""
        self.endTime = dictionary[kendTime] as? String ?? ""
        self.requestStartTime = dictionary[krequestStartTime] as? String ?? ""
        self.requestEndTime = dictionary[krequestEndTime] as? String ?? ""
        self.caregiverId = dictionary[kcaregiverId] as? String ?? ""
        self.perviousHours = dictionary[kperviousHours] as? String ?? ""
        self.updatedHours = dictionary[kupdatedHours] as? String ?? ""
        
        self.startJobStatus = (StartJobStatusEnum.init(rawValue: dictionary[kstartJobStatus] as? String ?? "")) ?? .NotStarted
        
        self.ongoingJobPendingTiming = dictionary[kongoingJobPendingTiming] as? String ?? ""
        self.ongoingJobPendingMinutes = dictionary[kongoingJobPendingMinutes] as? String ?? ""
        self.ongoingJobPendingSeconds = dictionary[kongoingJobPendingSeconds] as? String ?? ""
        
        self.userJobAwardId = dictionary[kuserJobAwardId] as? String ?? ""
    }

    class func kgetUserJobList(with param: [String:Any]?,isShowLoader : Bool,isFromMyJobTab : Bool = false,selectedTab : SegmentJobTabEnum = .All, success withResponse: @escaping (_ arr: [JobModel],_ totalpage : Int,_ totalWorkHours : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        
        var APIName : String = AppConstant.API.kgetUserJobList
        if !isFromMyJobTab {
            APIName = AppConstant.API.kgetUserJobList
        } else {
            switch selectedTab {
            case .All:
                APIName = AppConstant.API.kgetCaregiverRelatedJobList
            case .Upcoming:
                APIName = AppConstant.API.kgetCaregiverRelatedJobList
            case .Completed:
                APIName = AppConstant.API.kgetCaregiverRelatedJobList
            case .Applied:
                APIName = AppConstant.API.kgetCaregiverRelatedJobList
            case .Substitute:
                APIName = AppConstant.API.kgetSubstituteJobRequestList
            case .AwardJob:
                APIName = AppConstant.API.kgetAwardJobRequestList
            }
        }
        //isFromMyJobTab ? AppConstant.API.kgetCaregiverRelatedJobList : AppConstant.API.kgetUserJobList
        APIManager.makeRequest(with: APIName, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            let totalWorkHours : String = dict[ktotalWorkTime] as? String ?? ""
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(JobModel.init)
                
                withResponse(arr,totalPages,totalWorkHours)
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
    
    class func getMyPostedJobDetail(with param: [String:Any]?,isFromJobTab : Bool = false, success withResponse: @escaping (_ obj: JobModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isFromJobTab ? AppConstant.API.kgetCaregiverRelatedJobDetail : AppConstant.API.kgetUserJobDetail, method: .post, parameter: param, success: {(response) in
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
    
    class func applyUserJob(with param: [String:Any]?,isFromModifyAnswer : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isFromModifyAnswer ? AppConstant.API.kmodifyJobAnswer : AppConstant.API.kapplyUserJob, method: .post, parameter: param, success: {(response) in
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
    
    class func cancelJobRequestORJob(with param: [String:Any]?,isJobRequest : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isJobRequest ? AppConstant.API.kcancelJobRequest : AppConstant.API.kcancelUpcomingJob, method: .post, parameter: param, success: {(response) in
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
    
    class func caregiverSubstituteJob(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.ksendSubstituteJobRequest, method: .post, parameter: param, success: {(response) in
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
    
    class func verifyJobVerificationCode(with param: [String:Any]?, success withResponse: @escaping (_ jobdata : JobModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kverifyJobVerificationCode, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let model = JobModel.init(dictionary: dataDict)  {
                withResponse(model,message)
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
    
    class func endUserJob(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kendUserJob, method: .post, parameter: param, success: {(response) in
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
    
    class func uploadJobMedia(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kuploadJobMedia, method: .post, parameter: param, success: {(response) in
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
    
    class func getRequestAddJobHoursDetail(with param: [String:Any]?, success withResponse: @escaping (_ obj: JobModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kgetRequestAddJobHoursDetail, method: .post, parameter: param, success: {(response) in
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
    
    class func AcceptRejectJobAdditionalHoursRequest(with param: [String:Any]?,isAccept : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isAccept ? AppConstant.API.kacceptAddJobHoursRequest : AppConstant.API.kdeclineAddJobHoursRequest, method: .post, parameter: param, success: {(response) in
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
    
    class func AcceptRejectJobAwardRequest(with param: [String:Any]?,isAccept : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: isAccept ? AppConstant.API.kacceptAwardJobRequest : AppConstant.API.kdeclineAwardJobRequest, method: .post, parameter: param, success: {(response) in
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
}
