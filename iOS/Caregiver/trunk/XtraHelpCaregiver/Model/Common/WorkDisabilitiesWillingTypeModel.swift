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
    var userWorkJobDisabilitiesWillingTypeId : String
    var isSelectDisabilitiesWilling : Bool
    var userId : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.workDisabilitiesWillingTypeId = dictionary[kworkDisabilitiesWillingTypeId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.userWorkJobDisabilitiesWillingTypeId = dictionary[kuserWorkJobDisabilitiesWillingTypeId] as? String ?? ""
        self.isSelectDisabilitiesWilling = false
        self.userId = dictionary[kuserId] as? String ?? ""
    }
}
