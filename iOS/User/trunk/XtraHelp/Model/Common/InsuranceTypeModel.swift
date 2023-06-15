//
//  InsuranceTypeModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class InsuranceTypeModel: NSObject {

    var insuranceTypeId : String
    var name : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.insuranceTypeId = dictionary[kinsuranceTypeId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
}
