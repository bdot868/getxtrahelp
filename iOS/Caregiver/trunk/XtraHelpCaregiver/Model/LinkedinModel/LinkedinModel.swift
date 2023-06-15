//
//  LinkedinModel.swift
//  OnixNetwork
//
//  Created by Harshad on 22/08/20.
//  Copyright © 2020 Differenz. All rights reserved.
//

import UIKit
import SVProgressHUD

class LinkedinModel: NSObject {
    
    class func getProfileDataLinkedin(url: String,param : [String:Any]?, success withResponse: @escaping (String) -> (), failure: @escaping FailureBlock) {
        /*let param: [String:Any] = [
            kEmail : email,
            kPassword : password,
            kDeviceType : Constant.deviceType,
            kDeviceToken : OnixNetwork.sharedInstance.deviceToken
        ]*/
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: url, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kStatusCode] as? Int ?? 0
            let isSuccess = dict[kFlag] as? Bool ?? false
           
            if isSuccess,let dataDict = dict[kData] as? [String:Any]{
                //user.saveCurrentUserInDefault()
                withResponse("")
            }
            else {
                failure("\(statuscode)",message, .response)
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
