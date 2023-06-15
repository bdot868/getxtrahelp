//
//  CertificationsLicenseModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import UIKit

class CertificationsLicenseModel: NSObject {

    var userCertificationsLicensesId : String
    var userId : String
    var licenceTypeId : String
    var licenceName : String
    var licenceNumber : String
    var issueDate : String
    var expireDate : String
    var licenceDescription : String
    var licenceImageName : String
    var licenceImageUrl : String
    var licenceImageThumbUrl : String
    var licenceTypeName : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userCertificationsLicensesId = dictionary[kuserCertificationsLicensesId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.licenceTypeId = dictionary[klicenceTypeId] as? String ?? ""
        self.licenceName = dictionary[klicenceName] as? String ?? ""
        self.licenceNumber = dictionary[klicenceNumber] as? String ?? ""
        self.issueDate = dictionary[kissueDate] as? String ?? ""
        self.expireDate = dictionary[kexpireDate] as? String ?? ""
        self.licenceDescription = dictionary[kdescription] as? String ?? ""
        self.licenceImageName = dictionary[klicenceImageName] as? String ?? ""
        self.licenceImageUrl = dictionary[klicenceImageUrl] as? String ?? ""
        self.licenceImageThumbUrl = dictionary[klicenceImageThumbUrl] as? String ?? ""
        self.licenceTypeName = dictionary[klicenceTypeName] as? String ?? ""
    }
    
    init(usercertificationslicensesId : String,userid : String,licencetypeId : String,licencename : String,licencenumber : String,issuedate : String,expiredate : String,licencedescription : String,licenceimagename : String,licenceimageurl : String,licenceimagethumburl : String,licencetypename : String){
        self.userCertificationsLicensesId = usercertificationslicensesId
        self.userId = userid
        self.licenceTypeId = licencetypeId
        self.licenceName = licencename
        self.licenceNumber = licencenumber
        self.issueDate = issuedate
        self.expireDate = expiredate
        self.licenceDescription = licencedescription
        self.licenceImageName = licenceimagename
        self.licenceImageUrl = licenceimageurl
        self.licenceImageThumbUrl = licenceimagethumburl
        self.licenceTypeName = licencetypename
    }
    
    override init() {
        self.userCertificationsLicensesId = ""
        self.userId = ""
        self.licenceTypeId = ""
        self.licenceName = ""
        self.licenceNumber = ""
        self.issueDate = ""
        self.expireDate = ""
        self.licenceDescription = ""
        self.licenceImageName = ""
        self.licenceImageUrl = ""
        self.licenceImageThumbUrl = ""
        self.licenceTypeName = ""
    }
    
    class func getCertificationsLicenses(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arrCertificatio: [CertificationsLicenseModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetCertificationsLicenses, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arrcer = dataDict.compactMap(CertificationsLicenseModel.init)
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
