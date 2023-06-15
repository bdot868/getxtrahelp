//
//  WorkMethodOfTransportationModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class WorkMethodOfTransportationModel: NSObject {

    var workMethodOfTransportationId : String
    var name : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.workMethodOfTransportationId = dictionary[kworkSpecialityId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
}
