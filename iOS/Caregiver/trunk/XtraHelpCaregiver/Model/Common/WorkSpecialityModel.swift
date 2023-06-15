//
//  WorkSpecialityModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class WorkSpecialityModel: NSObject {
    
    var workSpecialityId : String
    var name : String
    var isSelectSpecialities : Bool = false
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.workSpecialityId = dictionary[kworkSpecialityId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.isSelectSpecialities = false
    }
    
    init(WorkSpecialityId : String,Name : String){
        self.workSpecialityId = WorkSpecialityId
        self.name = Name
    }
    
    override init() {
        self.workSpecialityId = ""
        self.name = ""
    }
}
