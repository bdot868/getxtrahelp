//
//  JobCategoryModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class JobCategoryModel: NSObject {
    
    var jobCategoryId : String
    var name : String
    var imageUrl : String
    var imageThumbUrl : String
    var isSelectCategory : Bool
    var categoryDesc : String
    var subCategory : [JobSubCategoryModel]
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.jobCategoryId = dictionary[kjobCategoryId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.imageUrl = dictionary[kimageUrl] as? String ?? ""
        self.imageThumbUrl = dictionary[kimageThumbUrl] as? String ?? ""
        self.isSelectCategory = false
        self.categoryDesc = dictionary[kdescription] as? String ?? ""
        self.subCategory = (dictionary[ksubCategory] as? [[String:Any]] ?? []).compactMap(JobSubCategoryModel.init)
    }

    class func getJobCategoryList(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arrHearAbout: [JobCategoryModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetJobCategoryList, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                let arr = dataDict.compactMap(JobCategoryModel.init)
                withResponse(arr,message)
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
