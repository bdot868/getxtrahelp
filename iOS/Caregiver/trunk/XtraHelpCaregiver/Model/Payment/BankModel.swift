//
//  BankModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 14/02/22.
//

import UIKit

class BankModel: NSObject {

    var id : String
    var account_holder_name : String
    var account_holder_type : String
    var routing_number : String
    var country : String
    var currency : String
    var account_number : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.account_holder_name = dictionary[kaccount_holder_name] as? String ?? ""
        self.account_holder_type = dictionary[kaccount_holder_type] as? String ?? ""
        self.routing_number = dictionary[krouting_number] as? String ?? ""
        self.country = dictionary[kcountry] as? String ?? ""
        self.currency = dictionary[kcurrency] as? String ?? ""
        self.account_number = dictionary[kaccount_number] as? String ?? ""
    }

    class func saveBankDetailInStripe(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveBankDetailInStripe, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess  {
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
    
    class func getBankDetail(with param: [String:Any]?, success withResponse: @escaping (_ bankdata: BankModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
      
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetBankDetail, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any],let objdata = BankModel(dictionary: dataDict) {
                withResponse(objdata,message)
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
}
