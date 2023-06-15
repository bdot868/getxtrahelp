//
//  CareGiverAvailibilityModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 28/03/22.
//

import UIKit

class CareGiverAvailibilityModel: NSObject {
    
    var startTimeStamp : String
    var endTimeStamp : String
    var caregiverStartTimeStamp : String
    var caregiverEndTimeStamp : String
    var caregiverStartDateTime : String
    var caregiverEndDateTime : String
    var date : String
    var dayAndDate : String
    var slot : [CareGiverAvailibilitySlotModel]
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.startTimeStamp = dictionary[kstartTimeStamp] as? String ?? ""
        self.endTimeStamp = dictionary[kendTimeStamp] as? String ?? ""
        self.caregiverStartTimeStamp = dictionary[kcaregiverStartTimeStamp] as? String ?? ""
        self.caregiverEndTimeStamp = dictionary[kcaregiverEndTimeStamp] as? String ?? ""
        self.caregiverStartDateTime = dictionary[kcaregiverStartDateTime] as? String ?? ""
        self.caregiverEndDateTime = dictionary[kcaregiverEndDateTime] as? String ?? ""
        self.date = dictionary[kdate] as? String ?? ""
        self.dayAndDate = dictionary[kdayAndDate] as? String ?? ""
        self.slot = (dictionary[kslot] as? [[String:Any]] ?? []).compactMap(CareGiverAvailibilitySlotModel.init)
    }
    
    class func getCaregiverAvailability(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arr: [CareGiverAvailibilityModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverAvailability, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                let arr = dataDict.compactMap(CareGiverAvailibilityModel.init)
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
