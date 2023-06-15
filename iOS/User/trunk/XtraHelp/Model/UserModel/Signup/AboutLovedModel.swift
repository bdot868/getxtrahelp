//
//  AboutLovedModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/12/21.
//

import UIKit

class AboutLovedModel: NSObject {

    var userAboutLovedId : String
    var userId : String
    var lovedDisabilitiesTypeId : String
    var lovedDisabilitiesTypeName : String
    var lovedAboutDesc : String
    var lovedOtherCategoryText : String
    var lovedBehavioral : String
    var lovedVerbal : String
    var allergies : String
    var isAllergies : Bool = false
    var lovedCategory : [LovedCategoryModel]
    var lovedSpecialities : [LovedSpecialitiesModel]
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userAboutLovedId = dictionary[kuserAboutLovedId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.lovedDisabilitiesTypeId = dictionary[klovedDisabilitiesTypeId] as? String ?? ""
        self.lovedDisabilitiesTypeName = dictionary[klovedDisabilitiesTypeName] as? String ?? ""
        self.lovedAboutDesc = dictionary[klovedAboutDesc] as? String ?? ""
        self.lovedOtherCategoryText = dictionary[klovedOtherCategoryText] as? String ?? ""
        self.lovedBehavioral = dictionary[klovedBehavioral] as? String ?? ""
        self.lovedVerbal = dictionary[klovedVerbal] as? String ?? ""
        self.allergies = dictionary[kallergies] as? String ?? ""
        self.lovedCategory = (dictionary[klovedCategory] as? [[String:Any]] ?? []).compactMap(LovedCategoryModel.init)
        self.lovedSpecialities = (dictionary[klovedSpecialities] as? [[String:Any]] ?? []).compactMap(LovedSpecialitiesModel.init)
    }
    
    init(loveddisabilitiestypeId : String,lovedaboutdesc : String,lovedothercategorytext : String,lovedbehavioral : String,lovedverbal : String,Allergies : String,lovedcategory : [LovedCategoryModel],lovedspecialities : [LovedSpecialitiesModel],loveddisabilitiestypename : String,useraboutlovedId : String,userid : String){
        self.userAboutLovedId = useraboutlovedId
        self.userId = userid
        self.lovedDisabilitiesTypeId = loveddisabilitiestypeId
        self.lovedDisabilitiesTypeName = loveddisabilitiestypename
        self.lovedAboutDesc = lovedaboutdesc
        self.lovedOtherCategoryText = lovedothercategorytext
        self.lovedBehavioral = lovedbehavioral
        self.lovedVerbal = lovedverbal
        self.allergies = Allergies
        self.lovedCategory = lovedcategory
        self.lovedSpecialities = lovedspecialities
    }
    
    override init() {
        self.userAboutLovedId = ""
        self.userId = ""
        self.lovedDisabilitiesTypeId = ""
        self.lovedDisabilitiesTypeName = ""
        self.lovedAboutDesc = ""
        self.lovedOtherCategoryText = ""
        self.lovedBehavioral = ""
        self.lovedVerbal = ""
        self.allergies = ""
        self.lovedCategory = []
        self.lovedSpecialities = []
        
    }
    
    class func getAboutLoved(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arrInsurance: [AboutLovedModel],_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetAboutLoved, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arrcer = dataDict.compactMap(AboutLovedModel.init)
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
