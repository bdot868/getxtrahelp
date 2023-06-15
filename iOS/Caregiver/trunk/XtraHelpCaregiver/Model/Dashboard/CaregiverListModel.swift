//
//  CaregiverListModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/01/22.
//

import UIKit

class CaregiverListModel: NSObject {

    var id : String
    var firstName : String
    var lastName : String
    var email : String
    var profileImageUrl : String
    var profileImageThumbUrl : String
    var status : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.firstName = dictionary[kFirstName] as? String ?? ""
        self.lastName = dictionary[kLastName] as? String ?? ""
        self.email = dictionary[kemail] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.status = dictionary[kstatus] as? String ?? ""
    }
    
    class func getCaregiverList(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [CaregiverListModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverList, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(CaregiverListModel.init)
                
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
