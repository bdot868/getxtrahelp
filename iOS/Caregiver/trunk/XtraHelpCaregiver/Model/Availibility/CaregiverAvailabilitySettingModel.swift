//
//  CaregiverAvailabilitySettingModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/03/22.
//

import UIKit

class CaregiverAvailabilitySettingModel: NSObject {

    var userAvailabilitySettingNewId : String
    var userId : String
    var type : String
    var repeatType : String
    var timing : String
    var date : String
    var startTime : String
    var endTime : String
    var availabilityId : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userAvailabilitySettingNewId = dictionary[kuserAvailabilitySettingNewId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.type = dictionary[ktype] as? String ?? ""
        self.repeatType = dictionary[krepeatType] as? String ?? ""
        self.timing = dictionary[ktiming] as? String ?? ""
        self.date = dictionary[kdate] as? String ?? ""
        self.startTime = dictionary[kstartTime] as? String ?? ""
        self.endTime = dictionary[kendTime] as? String ?? ""
        self.availabilityId = dictionary[kavailabilityId] as? String ?? ""
    }
    
    class func getCaregiverAvailabilitySettingNew(with param: [String:Any]?, success withResponse: @escaping (_ arr: [CaregiverAvailabilitySettingModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverAvailabilitySettingNew, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(CaregiverAvailabilitySettingModel.init)
                
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
