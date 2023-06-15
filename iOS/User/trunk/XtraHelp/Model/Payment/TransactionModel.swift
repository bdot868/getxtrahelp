//
//  TransactionModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 24/02/22.
//

import UIKit

class TransactionModel: NSObject {

    var userTransactionId : String
    var userJobId : String
    var type : String
    var payType : String
    var tranType : String
    var amount : String
    var userTransactionTime : String
    var jobName : String
    var caregiverName : String
    var amountFormatted : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userTransactionId = dictionary[kuserTransactionId] as? String ?? ""
        self.userJobId = dictionary[kuserJobId] as? String ?? ""
        self.type = dictionary[ktype] as? String ?? ""
        self.payType = dictionary[kpayType] as? String ?? ""
        self.tranType = dictionary[ktranType] as? String ?? ""
        self.amount = dictionary[kamount] as? String ?? ""
        self.userTransactionTime = dictionary[kuserTransactionTime] as? String ?? ""
        self.jobName = dictionary[kjobName] as? String ?? ""
        self.caregiverName = dictionary[kcaregiverName] as? String ?? ""
        self.amountFormatted = dictionary[kamountFormatted] as? String ?? ""
    }
    
    class func getUserTransaction(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [TransactionModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetUserTransaction, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(TransactionModel.init)
                
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
}
