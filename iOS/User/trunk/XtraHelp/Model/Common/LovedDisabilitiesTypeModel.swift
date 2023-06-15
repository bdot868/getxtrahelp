//
//  LovedDisabilitiesTypeModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/12/21.
//

import UIKit

class LovedDisabilitiesTypeModel: NSObject {

    var lovedDisabilitiesTypeId : String
    var name : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.lovedDisabilitiesTypeId = dictionary[klovedDisabilitiesTypeId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
    
    init(loveddisabilitiestypeId : String,Name : String){
        self.lovedDisabilitiesTypeId = loveddisabilitiestypeId
        self.name = Name
    }
    
    override init() {
        self.lovedDisabilitiesTypeId = ""
        self.name = ""
    }
}
