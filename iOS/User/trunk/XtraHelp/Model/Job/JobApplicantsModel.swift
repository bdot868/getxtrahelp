//
//  JobApplicantsModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 24/12/21.
//

import UIKit

class JobApplicantsModel: NSObject {

    var userId : String
    var isHire : String
    var profileImageThumbUrl : String
    var categoryNames : String
    var userJobApplyId : String
    var userFullName : String
    var profileImageUrl : String
    var jobId : String
    var caregiverRatingAverage : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userId = dictionary[kuserId] as? String ?? ""
        self.isHire = dictionary[kisHire] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.categoryNames = dictionary[kcategoryNames] as? String ?? ""
        self.userJobApplyId = dictionary[kuserJobApplyId] as? String ?? ""
        self.userFullName = dictionary[kuserFullName] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.jobId = dictionary[kjobId] as? String ?? ""
        self.caregiverRatingAverage = dictionary[kcaregiverRatingAverage] as? String ?? ""
    }
    
    class func getMyPostedJobApplicants(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [JobApplicantsModel],_ totalpage : Int) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetMyPostedJobApplicants, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(JobApplicantsModel.init)
                
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
}
