//
//  CMSModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/12/21.
//

import UIKit

class CMSModel: NSObject {

    var id : String
    var key : String
    var name : String
    var cmsdescription : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.key = dictionary[kkey] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.cmsdescription = dictionary[kdescription] as? String ?? ""
        self.id = dictionary[kid] as? String ?? ""
    }
    
    class func getCMSContent(with param: [String:Any]?, success withResponse: @escaping (_ user: CMSModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetCMS, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = CMSModel(dictionary: dataDict) {
                
                withResponse(user, message)
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
