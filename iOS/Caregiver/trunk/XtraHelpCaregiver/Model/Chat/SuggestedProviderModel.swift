//
//  SuggestedProviderModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 13/01/22.
//

import UIKit

class SuggestedProviderModel: NSObject {

    var categoryNames : String
    var email : String
    var firstName : String
    var fullName : String
    var id : String
    var lastName : String
    var profileImageThumbUrl : String
    var profileImageUrl : String
    var ratingAverage : String
    var status : String
    var totalJobCompleted : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.categoryNames = dictionary[kcategoryNames] as? String ?? ""
        self.email = dictionary[kemail] as? String ?? ""
        self.firstName = dictionary[kFirstName] as? String ?? ""
        self.fullName = dictionary[kfullName] as? String ?? ""
        self.id = dictionary[kid] as? String ?? ""
        self.lastName = dictionary[kLastName] as? String ?? ""
        self.profileImageThumbUrl = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.profileImageUrl = dictionary[kprofileImageUrl] as? String ?? ""
        self.ratingAverage = dictionary[kratingAverage] as? String ?? ""
        self.status = dictionary[kstatus] as? String ?? ""
        self.totalJobCompleted = dictionary[ktotalJobCompleted] as? String ?? ""
    }
}
