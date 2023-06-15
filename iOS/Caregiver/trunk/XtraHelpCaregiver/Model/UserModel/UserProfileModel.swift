//
//  UserProfileModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 31/01/22.
//

import UIKit

class UserProfileModel: NSObject {

    var id : String
    var FirstName : String
    var LastName : String
    var fullName : String
    var email : String
    var profileImageUrl : String
    var profileImageThumbUrl : String
    var ratingAverage : String
    var totalJobCompleted : String
    var caregiverBio : String
    var status : String
    var totalJobs : String
    var successPercentage : String
    var totalJobsHours : String
    var workSpecialityName : String
    var workMethodOfTransportationName : String
    var workDisabilitiesWillingTypeName : String
    var workDistancewillingTravel : String
    var totalYearWorkExperience : String
    var workExperienceData : [WorkExperienceModel]
    var categoryData : [JobCategoryModel]
    var phone : String
    var age : String
    var gender : GenderEnum
    var familyVaccinated : String
    var latitude : String
    var longitude : String
    var address : String
    var reviewData : [RatingModel]
    var totalReview : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        
        self.id = dictionary[kid] as? String ?? ""
        self.FirstName = dictionary[kFirstName] as? String ?? ""
        self.LastName = dictionary[kLastName] as? String ?? ""
        self.fullName = dictionary[kfullName] as? String ?? ""
        self.email = dictionary[kEmail] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.ratingAverage = dictionary[kratingAverage] as? String ?? ""
        self.totalJobCompleted = dictionary[ktotalJobCompleted] as? String ?? ""
        self.caregiverBio = dictionary[kcaregiverBio] as? String ?? ""
        self.status = dictionary[kstatus] as? String ?? ""
        self.totalJobs = dictionary[ktotalJobs] as? String ?? ""
        self.successPercentage = dictionary[ksuccessPercentage] as? String ?? ""
        self.totalJobsHours = dictionary[ktotalJobsHours] as? String ?? ""
        self.workSpecialityName = dictionary[kworkSpecialityName] as? String ?? ""
        self.workMethodOfTransportationName = dictionary[kworkMethodOfTransportationName] as? String ?? ""
        self.workDisabilitiesWillingTypeName = dictionary[kworkDisabilitiesWillingTypeName] as? String ?? ""
        self.workDistancewillingTravel = dictionary[kworkDistancewillingTravel] as? String ?? ""
        self.totalYearWorkExperience = dictionary[ktotalYearWorkExperience] as? String ?? ""
        self.totalJobs = dictionary[ktotalJobs] as? String ?? ""
        self.workExperienceData = (dictionary[kworkExperienceData] as? [[String:Any]] ?? []).compactMap(WorkExperienceModel.init)
        self.categoryData = (dictionary[kcategoryData] as? [[String:Any]] ?? []).compactMap(JobCategoryModel.init)
        
        self.familyVaccinated = dictionary[kfamilyVaccinated] as? String ?? ""
        self.phone = dictionary[kphone] as? String ?? ""
        self.age = dictionary[kage] as? String ?? ""
        self.gender = GenderEnum(rawValue: (Int(dictionary[kgender] as? String ?? "0")) ?? 0) ?? .None
        
        self.latitude = dictionary[klatitude] as? String ?? ""
        self.longitude = dictionary[klongitude] as? String ?? ""
        self.address = dictionary[kaddress] as? String ?? ""
        
        self.reviewData = (dictionary[kreviewData] as? [[String:Any]] ?? []).compactMap(RatingModel.init)
        self.totalReview = dictionary[ktotalReview] as? String ?? ""
    }
    
    // MARK: - API call
    class func getCaregiverMyProfile(with param: [String:Any]?, success withResponse: @escaping (_ user: UserProfileModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverMyProfile, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserProfileModel(dictionary: dataDict) {
                withResponse(user, message)
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
    
    class func getCaregiverProfile(with param: [String:Any]?, success withResponse: @escaping (_ user: UserProfileModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverProfile, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserProfileModel(dictionary: dataDict) {
                withResponse(user, message)
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
