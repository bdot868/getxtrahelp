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
        self.workMethodOfTransportationId = dictionary[kworkMethodOfTransportationId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
    
    init(WorkMethodOfTransportationId : String,Name : String){
        self.workMethodOfTransportationId = WorkMethodOfTransportationId
        self.name = Name
    }
    
    override init() {
        self.workMethodOfTransportationId = ""
        self.name = ""
    }
}
