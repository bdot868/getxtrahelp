//
//  InsuranceModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 23/11/21.
//

import UIKit

class InsuranceModel: NSObject {

    var userInsuranceId : String
    var userId : String
    var insuranceTypeId : String
    var insuranceName : String
    var insuranceNumber : String
    var expireDate : String
    var insuranceImageName : String
    var insuranceImageUrl : String
    var insuranceImageThumbUrl : String
    var insuranceTypeName : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userInsuranceId = dictionary[kuserInsuranceId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.insuranceTypeId = dictionary[kinsuranceTypeId] as? String ?? ""
        self.insuranceName = dictionary[kinsuranceName] as? String ?? ""
        self.insuranceNumber = dictionary[kinsuranceNumber] as? String ?? ""
        self.expireDate = dictionary[kexpireDate] as? String ?? ""
        self.insuranceImageName = dictionary[kinsuranceImageName] as? String ?? ""
        self.insuranceImageUrl = dictionary[kinsuranceImageUrl] as? String ?? ""
        self.insuranceImageThumbUrl = dictionary[kinsuranceImageThumbUrl] as? String ?? ""
        self.insuranceTypeName = dictionary[kinsuranceTypeName] as? String ?? ""
    }
    
    init(userinsuranceId : String,userid : String,insurancetypeId : String,insurancename : String,insurancenumber : String,expiredate : String,insuranceimagename : String,insuranceimageurl : String,insuranceImagethumburl : String,insuranceyypename : String){
        self.userInsuranceId = userinsuranceId
        self.userId = userid
        self.insuranceTypeId = insurancetypeId
        self.insuranceName = insurancename
        self.insuranceNumber = insurancenumber
        self.expireDate = expiredate
        self.insuranceImageName = insuranceimagename
        self.insuranceImageUrl = insuranceimageurl
        self.insuranceImageThumbUrl = insuranceImagethumburl
        self.insuranceTypeName = insuranceyypename
    }
    
    override init() {
        self.userInsuranceId = ""
        self.userId = ""
        self.insuranceTypeId = ""
        self.insuranceName = ""
        self.insuranceNumber = ""
        self.expireDate = ""
        self.insuranceImageName = ""
        self.insuranceImageUrl = ""
        self.insuranceImageThumbUrl = ""
        self.insuranceTypeName = ""
    }
    
    class func getInsurance(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arrInsurance: [InsuranceModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetInsurance, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arrcer = dataDict.compactMap(InsuranceModel.init)
                withResponse(arrcer,message)
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
