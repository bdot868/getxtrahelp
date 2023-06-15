//
//  FAQModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/12/21.
//

import UIKit

class FAQModel: NSObject {

    var id : String
    var type : String
    var name : String
    var FAQdescription : String

    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.type = dictionary[ktype] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.FAQdescription = dictionary[kdescription] as? String ?? ""
    }
    
    class func getFAQList(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [FAQModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kfaq, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(FAQModel.init)
                
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
    
    class func getFAQDetail(with param: [String:Any]?, success withResponse: @escaping (_ data: FAQModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeRequest(with: AppConstant.API.kfaqDetails, method: .post, parameter: param, success: {(response) in
            
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let obj = FAQModel.init(dictionary: dataDict) {
               
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
}
