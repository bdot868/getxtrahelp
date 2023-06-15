//
//  WorkDetailModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 31/01/22.
//

import UIKit

class WorkDetailModel: NSObject {

    var userWorkDetailId : String
    var userId : String
    var workSpecialityId : String
    var workSpecialityName : String
    var maxDistanceTravel : String
    var experienceOfYear : String
    var inspiredYouBecome : String
    var bio : String
    var workMethodOfTransportationId : String
    var workMethodOfTransportationName : String
    var workDisabilitiesWillingTypeId : String
    var workDisabilitiesWillingTypeName : String
    var workDistancewillingTravel : String
    var workExperienceData : [WorkExperienceModel]
    var categoryData : [JobCategoryModel]
    var workDisabilitiesWillingTypeData : [WorkDisabilitiesWillingTypeModel]
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        
        self.userWorkDetailId = dictionary[kuserWorkDetailId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.workSpecialityId = dictionary[kworkSpecialityId] as? String ?? ""
        self.maxDistanceTravel = dictionary[kmaxDistanceTravel] as? String ?? ""
        self.workMethodOfTransportationId = dictionary[kworkMethodOfTransportationId] as? String ?? ""
        self.workDisabilitiesWillingTypeId = dictionary[kworkDisabilitiesWillingTypeId] as? String ?? ""
        self.experienceOfYear = dictionary[kexperienceOfYear] as? String ?? ""
        self.inspiredYouBecome = dictionary[kinspiredYouBecome] as? String ?? ""
        self.bio = dictionary[kbio] as? String ?? ""
        self.workSpecialityName = dictionary[kworkSpecialityName] as? String ?? ""
        self.workSpecialityName = dictionary[kworkSpecialityName] as? String ?? ""
        self.workMethodOfTransportationName = dictionary[kworkMethodOfTransportationName] as? String ?? ""
        self.workDisabilitiesWillingTypeName = dictionary[kworkDisabilitiesWillingTypeName] as? String ?? ""
        self.workDistancewillingTravel = dictionary[kworkDistancewillingTravel] as? String ?? ""
        //self.totalYearWorkExperience = dictionary[ktotalYearWorkExperience] as? String ?? ""
        self.workExperienceData = (dictionary[kworkExperienceData] as? [[String:Any]] ?? []).compactMap(WorkExperienceModel.init)
        self.categoryData = (dictionary[kcategoryData] as? [[String:Any]] ?? []).compactMap(JobCategoryModel.init)
        self.workDisabilitiesWillingTypeData = (dictionary[kworkDisabilitiesWillingTypeData] as? [[String:Any]] ?? []).compactMap(WorkDisabilitiesWillingTypeModel.init)
    }
    
    // MARK: - API call
    class func getWorkDetails(with param: [String:Any]?, success withResponse: @escaping (_ user: WorkDetailModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetWorkDetails, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = WorkDetailModel(dictionary: dataDict) {
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
