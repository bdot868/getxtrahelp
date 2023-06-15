//
//  licenceTypeModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import UIKit

class licenceTypeModel: NSObject {

    var licenceTypeId : String
    var name : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.licenceTypeId = dictionary[klicenceTypeId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
    
    init(licencetypeId : String,Name : String){
        self.licenceTypeId = licencetypeId
        self.name = Name
    }
    
    override init() {
        self.licenceTypeId = ""
        self.name = ""
    }
}
