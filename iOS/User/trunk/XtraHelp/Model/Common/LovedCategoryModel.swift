//
//  LovedCategoryModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/12/21.
//

import UIKit

class LovedCategoryModel: NSObject {

    var userLovedCategoryId : String
    var userId : String
    var lovedCategoryId : String
    var name : String
    var loveCatDescription : String
    var lovedCategoryName : String
    var isSelectCategory : Bool = false
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userLovedCategoryId = dictionary[kuserLovedCategoryId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.lovedCategoryId = dictionary[klovedCategoryId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.loveCatDescription = dictionary[kdescription] as? String ?? ""
        self.lovedCategoryName = dictionary[klovedCategoryName] as? String ?? ""
        self.isSelectCategory = false
    }
    
    required init(obj : LovedCategoryModel) {
        self.userLovedCategoryId = obj.userLovedCategoryId
        self.userId = obj.userId
        self.lovedCategoryId = obj.lovedCategoryId
        self.name = obj.name
        self.loveCatDescription = obj.loveCatDescription
        self.lovedCategoryName = obj.lovedCategoryName
        self.isSelectCategory = obj.isSelectCategory
    }
    
    /*override init() {
        super.init()
    }*/
    
    init(userlovedcategoryId : String,userid : String,lovedcategoryId : String,Name : String,lovecatdescription : String,lovedcategoryname: String,isselectcategory : Bool) {
        self.userLovedCategoryId = userlovedcategoryId
        self.userId = userid
        self.lovedCategoryId = lovedcategoryId
        self.name = Name
        self.loveCatDescription = lovecatdescription
        self.lovedCategoryName = lovedcategoryname
        self.isSelectCategory = isselectcategory
    }
    
}

extension Array where Element: NSCopying {
      func copy() -> [Element] {
            return self.map { $0.copy() as! Element }
      }
}

// MARK: - Copyable
extension LovedCategoryModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(obj: self)
    }
}

protocol Copying {
    init(original: Self)
}

//Concrete class extension
extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}
