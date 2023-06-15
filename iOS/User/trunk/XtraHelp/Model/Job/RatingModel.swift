//
//  RatingModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 16/02/22.
//

import UIKit

class RatingModel: NSObject {
    
    var userReviewId : String
    var userIdFrom : String
    var userIdTo : String
    var feedback : String
    var jobId : String
    var rating : String
    var reviewDate : String
    var userFullName : String
    var profileImageUrl : String
    var profileImageThumbUrl : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userReviewId = dictionary[kuserReviewId] as? String ?? ""
        self.userIdFrom = dictionary[kuserIdFrom] as? String ?? ""
        self.userIdTo = dictionary[kuserIdTo] as? String ?? ""
        self.feedback = dictionary[kfeedback] as? String ?? ""
        self.jobId = dictionary[kjobId] as? String ?? ""
        self.rating = dictionary[krating] as? String ?? ""
        self.reviewDate = dictionary[kreviewDate] as? String ?? ""
        self.userFullName = dictionary[kuserFullName] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
    }
    
    class func setJobReview(with param: [String:Any]?,success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.ksetJobReview, method: .post, parameter: param, success: {(response) in
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
    
    class func getCaregiverReviewList(with param: [String:Any]?,isShowLoader : Bool = true,success withResponse: @escaping (_ arr: [RatingModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverReviewList, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                let arr = dataDict.compactMap(RatingModel.init)
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
