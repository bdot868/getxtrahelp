//
//  AvailibilitySettingTimeModel.swift
//  ChiryDoctor
//
//  Created by wm-devIOShp on 04/10/21.
//

import UIKit

class AvailibilitySettingTimeModel: NSObject {

    var userAvailabilitySettingId : String
    var userId : String
    var type : SelectAvailibilityDay = .EveryDay
    var day : SelectDayEnum = .Monday
    var timing : TimingEnum = .HalfHours
    var startTime : String
    var endTime : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userAvailabilitySettingId = dictionary[kuserAvailabilitySettingId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.type = SelectAvailibilityDay(rawValue: dictionary[ktype] as? String ?? "1") ?? .EveryDay
        self.day = SelectDayEnum(rawValue: dictionary[kday] as? String ?? "1") ?? .Monday
        self.timing = TimingEnum(rawValue: dictionary[ktiming] as? String ?? "30") ?? .HalfHours
        self.startTime = dictionary[kstartTime] as? String ?? ""
        self.endTime = dictionary[kendTime] as? String ?? ""
    }
    
    init(availibilitysettingid : String,userid : String,availibilitytype : SelectAvailibilityDay,daytype : SelectDayEnum,timingtype : TimingEnum,starttime : String,endtime : String){
        self.userAvailabilitySettingId = availibilitysettingid
        self.userId = userid
        self.type = availibilitytype
        self.day = daytype
        self.timing = timingtype
        self.startTime = starttime
        self.endTime = endtime
    }
    
    override init() {
        self.userAvailabilitySettingId = ""
        self.userId = ""
        self.startTime = ""
        self.endTime = ""
    }
}
