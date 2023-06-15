//
//  LovedSpecialitiesModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/12/21.
//

import UIKit

class LovedSpecialitiesModel: NSObject {

    var userLovedSpecialitiesId : String
    var userId : String
    var lovedSpecialitiesId : String
    var name : String
    var lovedSpecialitiesName : String
    var isSelectSpecialities : Bool = false
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userLovedSpecialitiesId = dictionary[kuserLovedSpecialitiesId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.lovedSpecialitiesId = dictionary[klovedSpecialitiesId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.lovedSpecialitiesName = dictionary[klovedSpecialitiesName] as? String ?? ""
        self.isSelectSpecialities = false
    }
}
