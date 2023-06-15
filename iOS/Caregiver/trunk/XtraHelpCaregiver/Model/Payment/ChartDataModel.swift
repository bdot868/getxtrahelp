//
//  ChartDataModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 24/02/22.
//

import UIKit

class ChartDataModel: NSObject {

    var month : String
    var amount : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.month = dictionary[kmonth] as? String ?? ""
        self.amount = dictionary[kamount] as? String ?? ""
    }
    
    class func getAccountChartData(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [ChartDataModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetAccountChartData, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(ChartDataModel.init)
                
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
