//
//  CareGiverAvailibilitySlotModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 28/03/22.
//

import UIKit

class CareGiverAvailibilitySlotModel: NSObject {

    var startTimeStamp : String
    var endTimeStamp : String
    var caregiverStartTimeStamp : String
    var caregiverEndTimeStamp : String
    var startDateTime : String
    var endDateTime : String
    var date : String
    var time : String
    var duration : String
    var isBooked : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.startTimeStamp = dictionary[kstartTimeStamp] as? String ?? ""
        self.endTimeStamp = dictionary[kendTimeStamp] as? String ?? ""
        self.caregiverStartTimeStamp = dictionary[kcaregiverStartTimeStamp] as? String ?? ""
        self.caregiverEndTimeStamp = dictionary[kcaregiverEndTimeStamp] as? String ?? ""
        self.startDateTime = dictionary[kstartDateTime] as? String ?? ""
        self.endDateTime = dictionary[kendDateTime] as? String ?? ""
        self.date = dictionary[kdate] as? String ?? ""
        self.time = dictionary[ktime] as? String ?? ""
        self.duration = dictionary[kduration] as? String ?? ""
        self.isBooked = dictionary[kisBooked] as? String ?? ""
    }
}
