//
//  JobSubCategoryModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class JobSubCategoryModel: NSObject {

    var jobSubCategoryId : String
    var name : String
    var jobCategoryId : String
    var isSelectSubCategory : Bool = false
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.jobSubCategoryId = dictionary[kjobSubCategoryId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.jobCategoryId = dictionary[kjobCategoryId] as? String ?? ""
        self.isSelectSubCategory = false
    }
}
