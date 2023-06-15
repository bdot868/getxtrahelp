//
//  CaregiverListModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/02/22.
//

import UIKit

class CaregiverListModel: NSObject {

    var id : String
    var firstName : String
    var lastName : String
    var fullName : String
    var email : String
    var profileImageUrl : String
    var profileImageThumbUrl : String
    var status : String
    var categoryNames : String
    var ratingAverage : String
    var distance : String
    var totalJobCompleted : String
    var totalJobOngoingWithMe : String
    var totalJobWithMe : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.firstName = dictionary[kFirstName] as? String ?? ""
        self.lastName = dictionary[kLastName] as? String ?? ""
        self.fullName = dictionary[kfullName] as? String ?? ""
        self.email = dictionary[kemail] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.status = dictionary[kstatus] as? String ?? ""
        self.categoryNames = dictionary[kcategoryNames] as? String ?? ""
        self.ratingAverage = dictionary[kratingAverage] as? String ?? ""
        self.distance = dictionary[kdistance] as? String ?? ""
        self.totalJobCompleted = dictionary[ktotalJobCompleted] as? String ?? ""
        self.totalJobOngoingWithMe = dictionary[ktotalJobOngoingWithMe] as? String ?? ""
        self.totalJobWithMe = dictionary[ktotalJobWithMe] as? String ?? ""
    }
    
    class func getCaregiverList(with param: [String:Any]?,isShowLoader : Bool,isMyCaregiverList : Bool = false ,success withResponse: @escaping (_ arr: [CaregiverListModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: isMyCaregiverList ? AppConstant.API.kgetMyJobRelatedCaregiver : AppConstant.API.kfindCaregivers, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(CaregiverListModel.init)
                
                withResponse(arr,totalPages,message)
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
}
