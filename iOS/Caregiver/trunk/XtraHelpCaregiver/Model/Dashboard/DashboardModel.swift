//
//  DashboardModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/01/22.
//

import UIKit

class DashboardModel: NSObject {

    class func getCaregiverDashboard(with param: [String:Any]?, success withResponse: @escaping (_ arrUpcoming : [JobModel],_ arrNearest : [JobModel],_ arrCategory : [JobCategoryModel],_ arrResourcesAndBlogs : [ResourcesAndBlogsModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverDashboard, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any] {
                
                let arrUpcoming = (dataDict[kupcomingJobs] as? [[String:Any]] ?? []).compactMap(JobModel.init)
                let arrNearest = (dataDict[knearestJobs] as? [[String:Any]] ?? []).compactMap(JobModel.init)
                let arrCategory = (dataDict[kcategories] as? [[String:Any]] ?? []).compactMap(JobCategoryModel.init)
                let arrResourcesAndBlogs = (dataDict[kresourcesAndBlogs] as? [[String:Any]] ?? []).compactMap(ResourcesAndBlogsModel.init)
                withResponse(arrUpcoming,arrNearest,arrCategory,arrResourcesAndBlogs,message)
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
