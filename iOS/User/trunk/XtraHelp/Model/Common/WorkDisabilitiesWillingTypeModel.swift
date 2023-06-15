//
//  WorkDisabilitiesWillingTypeModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class WorkDisabilitiesWillingTypeModel: NSObject {

    var workDisabilitiesWillingTypeId : String
    var name : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.workDisabilitiesWillingTypeId = dictionary[kworkDisabilitiesWillingTypeId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
}
