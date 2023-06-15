//
//  HearAboutUsModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import UIKit

class HearAboutUsModel: NSObject {

    var hearAboutUsId : String
    var name : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.hearAboutUsId = dictionary[khearAboutUsId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
    }
}
