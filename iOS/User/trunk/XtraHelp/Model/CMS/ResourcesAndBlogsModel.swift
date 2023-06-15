//
//  ResourcesAndBlogsModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/12/21.
//

import UIKit

class ResourcesAndBlogsModel: NSObject {

    var resourceId : String
    var categoryId : String
    var title : String
    var resdescription : String
    var imageUrl : String
    var thumbImageUrl : String
    var categoryName : String
    var createdDateFormat : String
    var isBookmark : String
    var sharingLink : String

    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.resourceId = dictionary[kresourceId] as? String ?? ""
        self.categoryId = dictionary[kcategoryId] as? String ?? ""
        self.title = dictionary[ktitle] as? String ?? ""
        self.resdescription = dictionary[kdescription] as? String ?? ""
        self.imageUrl = dictionary[kimageUrl] as? String ?? ""
        self.thumbImageUrl = dictionary[kthumbImageUrl] as? String ?? ""
        self.categoryName = dictionary[kcategoryName] as? String ?? ""
        self.createdDateFormat = dictionary[kcreatedDateFormat] as? String ?? ""
        self.isBookmark = dictionary[kisBookmark] as? String ?? ""
        self.sharingLink = dictionary[ksharingLink] as? String ?? ""
    }
    
    class func getResourceList(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [ResourcesAndBlogsModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetResource, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(ResourcesAndBlogsModel.init)
                
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
    
    class func getResourceDetail(with param: [String:Any]?, success withResponse: @escaping (_ data: ResourcesAndBlogsModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kgetResourceDetail, method: .post, parameter: param, success: {(response) in
            
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let obj = ResourcesAndBlogsModel.init(dictionary: dataDict) {
               
                withResponse(obj,message)
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
    
    /*class func addRemoveResourceBookmark(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kaddRemoveResourceBookmark, method: .post, parameter: param, success: {(response) in
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
    }*/
}
