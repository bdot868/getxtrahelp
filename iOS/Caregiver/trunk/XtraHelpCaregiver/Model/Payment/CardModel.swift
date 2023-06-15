//
//  CardModel.swift
//  Chiry
//
//  Created by Harshad on 29/04/21.
//

import UIKit

class CardModel: NSObject {

    var userCardId : String
    var userId : String
    var customerId : String
    var cardId : String
    var cardBrand : String
    var holderName : String
    var number : String
    var month : String
    var year : String
    var isCardSelected : Bool
    var isDefault : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userCardId = dictionary[kuserCardId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.customerId = dictionary[kcustomerId] as? String ?? ""
        self.cardId = dictionary[kcardId] as? String ?? ""
        self.cardBrand = dictionary[kcardBrand] as? String ?? ""
        self.holderName = dictionary[kholderName] as? String ?? ""
        self.number = dictionary[klast4] as? String ?? ""
        self.month = dictionary[kmonth] as? String ?? ""
        self.year = dictionary[kyear] as? String ?? ""
        self.isDefault = dictionary[kisDefault] as? String ?? ""
        self.isCardSelected = false
    }

    class func addNewCard(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveCard, method: .post, parameter: param, success: {(response) in
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
    
    class func deleteCard(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kdeleteUserCard, method: .post, parameter: param, success: {(response) in
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
    
    /*class func setCardDefault(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetCardDefault, method: .post, parameter: param, success: {(response) in
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
    
    class func getCardList(with param: [String:Any]?, success withResponse: @escaping (_ arr: [CardModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetUserCards, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(CardModel.init)
                
                withResponse(arr,message)
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
