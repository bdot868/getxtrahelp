//
//  AccountModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 14/02/22.
//

import UIKit

class AccountModel: NSObject {

    var amount : String
    var userTransactionDate : String
    var payType : String
    var createdDate : String
    var transactionId : String
    var type : String
    var amountFormatted : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.amount = dictionary[kamount] as? String ?? ""
        self.userTransactionDate = dictionary[kuserTransactionDate] as? String ?? ""
        self.payType = dictionary[kpayType] as? String ?? ""
        self.createdDate = dictionary[kcreatedDate] as? String ?? ""
        self.transactionId = dictionary[ktransactionId] as? String ?? ""
        self.type = dictionary[ktype] as? String ?? ""
        self.amountFormatted = dictionary[kamountFormatted] as? String ?? ""
    }

    class func connectStripe(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String,_ stripeId : String,_ stripeURL : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kconnectStripe, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let accid = dict[kaccId] as? String, let stripeurl = dict[kurl] as? String{
                withResponse(message,accid,stripeurl)
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
    
    class func withdrawHistory(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ strMessage : String,_ stripestatus : String,_ totalincome : String,_ arrTransaction : [AccountModel],_ totalPages : Int,_ totalwithdrawIncome : String,_ noofwithdraw : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kwithdrawHistory, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let stripeStatus = dict[kstripe_connect_status] as? String, let totalIncome = dict[ktotalIncome] as? String{
                let arr = (dict[kData] as? [[String:Any]] ?? []).compactMap(AccountModel.init)
                let totalwithdrawIncome = dict[ktotalwithdrawIncome] as? String ?? "0"
                let noofwithdraw = dict[knoofwithdraw] as? String ?? "0"
                withResponse(message,stripeStatus,totalIncome,arr,totalPages,totalwithdrawIncome,noofwithdraw)
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
    
    class func withdrawAmount(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kwithdraw, method: .post, parameter: param, success: {(response) in
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
    
    class func getWalletData(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String,_ amountremainingformate : String,_ remainingamount : String,_ stripeConnect : String,_ totalamount : String,_ withdrawamount : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetWalletData, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any] {
                let stripeConnect = dict[kstripe_connect_status] as? String ?? "0"
                let amountremainingformate = dataDict[kwalletAmountFormat] as? String ?? "0"
                let remainingamount = dataDict[kwalletAmount] as? String ?? "0"
                let totalamount = dataDict[kwalletAmountInFormat] as? String ?? "0"
                let withdrawamount = dataDict[kwalletAmountOutFormat] as? String ?? "0"
                withResponse(message,amountremainingformate,remainingamount,stripeConnect,totalamount,withdrawamount)
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
