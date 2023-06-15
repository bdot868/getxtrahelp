//
//  WorkExperienceModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class WorkExperienceModel: NSObject {
    
    var userWorkExperienceId : String
    var userId : String
    var workPlace : String
    var startDate : String
    var endDate : String
    var leavingReason : String
    var workDescription : String
    //var displayStartDate : String
    //var displayEndDate : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userWorkExperienceId = dictionary[kuserWorkExperienceId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.workPlace = dictionary[kworkPlace] as? String ?? ""
        self.startDate = dictionary[kstartDate] as? String ?? ""
        self.endDate = dictionary[kendDate] as? String ?? ""
        self.leavingReason = dictionary[kleavingReason] as? String ?? ""
        self.workDescription = dictionary[kdescription] as? String ?? ""
        //self.displayStartDate = ""
       // self.displayEndDate = ""
    }
    
    init(userworkexperienceId : String,userid : String,workplace : String,startdate : String,enddate : String,leavingreason : String,workdescription : String) {//,displaystartdate : String,displayenddate : String){
        self.userWorkExperienceId = userworkexperienceId
        self.userId = userid
        self.workPlace = workplace
        self.startDate = startdate
        self.endDate = enddate
        self.leavingReason = leavingreason
        self.workDescription = workdescription
        //self.displayStartDate = displaystartdate
        //self.displayEndDate = displayenddate
    }
    
    override init() {
        self.userWorkExperienceId = ""
        self.userId = ""
        self.workPlace = ""
        self.startDate = ""
        self.endDate = ""
        self.leavingReason = ""
        self.workDescription = ""
       // self.displayStartDate = ""
        //self.displayEndDate = ""
    }
}
