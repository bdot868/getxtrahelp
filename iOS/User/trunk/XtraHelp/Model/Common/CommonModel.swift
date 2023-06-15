//
//  CommonModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import UIKit

class CommonModel: NSObject {

    class func getCommonData(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arrHearAbout: [HearAboutUsModel],_ arrlicenceType: [licenceTypeModel],_ arrInsuranceType: [InsuranceTypeModel],_ arrWorkSpeciality: [WorkSpecialityModel],_ arrWorkMethodOfTransportation: [WorkMethodOfTransportationModel],_ arrWorkDisabilitiesWillingType: [WorkDisabilitiesWillingTypeModel],_ arrlovedDisabilitiesType: [LovedDisabilitiesTypeModel],_ arrlovedCategory: [LovedCategoryModel],_ arrlovedSpecialities: [LovedSpecialitiesModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetCommonData, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any] {
                
                let arrHearAbout = (dataDict[khearAboutUs] as? [[String:Any]] ?? []).compactMap(HearAboutUsModel.init)
                let arrlicenceType = (dataDict[klicenceType] as? [[String:Any]] ?? []).compactMap(licenceTypeModel.init)
                let arrInsuranceType = (dataDict[klicenceType] as? [[String:Any]] ?? []).compactMap(InsuranceTypeModel.init)
                let arrWorkSpeciality = (dataDict[kworkSpeciality] as? [[String:Any]] ?? []).compactMap(WorkSpecialityModel.init)
                let arrWorkMethodOfTransportation = (dataDict[kworkMethodOfTransportation] as? [[String:Any]] ?? []).compactMap(WorkMethodOfTransportationModel.init)
                let arrWorkDisabilitiesWillingType = (dataDict[kworkDisabilitiesWillingType] as? [[String:Any]] ?? []).compactMap(WorkDisabilitiesWillingTypeModel.init)
                let arrLovedDisabilitiesTypeModel = (dataDict[klovedDisabilitiesType] as? [[String:Any]] ?? []).compactMap(LovedDisabilitiesTypeModel.init)
                let arrlovedCategory = (dataDict[klovedCategory] as? [[String:Any]] ?? []).compactMap(LovedCategoryModel.init)
                let arrlovedSpecialities = (dataDict[klovedSpecialities] as? [[String:Any]] ?? []).compactMap(LovedSpecialitiesModel.init)
                withResponse(arrHearAbout,arrlicenceType,arrInsuranceType,arrWorkSpeciality,arrWorkMethodOfTransportation,arrWorkDisabilitiesWillingType,arrLovedDisabilitiesTypeModel,arrlovedCategory,arrlovedSpecialities,message)
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
    
    class func getUnreadNotificationsCountAPICall(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ unreadPushNoti : Int,_ unreadChatMsg : Int) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
     APIManager.makeRequest(with: AppConstant.API.kgetUnreadNotificationsCount, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                let pushcount : Int = Int(dict[knotificationCount] as? String ?? "0") ?? 0
                let chatcount : Int = Int(dict[kchatCount] as? String ?? "0") ?? 0
                withResponse(pushcount,chatcount)
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
