//
//  SearchHistoryModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/02/22.
//

import UIKit

class SearchHistoryModel: NSObject {

    var userSarchHistoryId : String
    var userId : String
    var keyword : String

    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userSarchHistoryId = dictionary[kuserSearchHistoryId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.keyword = dictionary[kkeyword] as? String ?? ""
    }
    
    class func getUserSearchHistory(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [SearchHistoryModel],_ totalpage : Int) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetUserSearchHistory, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(SearchHistoryModel.init)
                
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
    
    class func clearUserSearchHistory(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kclearUserSearchHistory, method: .post, parameter: param, success: {(response) in
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
    
    class func removeUserSearchHistory(with param: [String:Any]?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kremoveUserSearchHistory, method: .post, parameter: param, success: {(response) in
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
