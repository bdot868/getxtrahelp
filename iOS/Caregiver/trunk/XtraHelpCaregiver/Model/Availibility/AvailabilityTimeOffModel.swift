//
//  AvailabilityTimeOffModel.swift
//  ChiryDoctor
//
//  Created by wm-devIOShp on 04/10/21.
//

import UIKit
let kuserAvailabilitySettingId = "userAvailabilitySettingId"
let kstartTime = "startTime"
let kendTime = "endTime"
let kavailabilitySetting = "availabilitySetting"
let kuserAvailabilityOfftimeId = "userAvailabilityOfftimeId"
let kday = "day"
let ktimeOff = "timeOff"
let koffDateTime = "offDateTime"


class AvailabilityTimeOffModel: NSObject {
    
    var userAvailabilityOfftimeId : String
    var userId : String
    var day : String
    var month : SelectMonthTime = .January
    var startTime : String
    var endTime : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userAvailabilityOfftimeId = dictionary[kuserAvailabilitySettingId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.day = dictionary[kday] as? String ?? ""
        self.month = SelectMonthTime(rawValue: dictionary[kmonth] as? String ?? "30") ?? .January
        self.startTime = dictionary[kstartTime] as? String ?? ""
        self.endTime = dictionary[kendTime] as? String ?? ""
    }
    
    init(useravailabilityOfftimeId : String,userid : String,Day : String,Month : SelectMonthTime,starttime : String,endtime : String){
        self.userAvailabilityOfftimeId = useravailabilityOfftimeId
        self.userId = userid
        self.day = Day
        self.month = Month
        self.startTime = starttime
        self.endTime = endtime
    }
    
    override init() {
        self.userAvailabilityOfftimeId = ""
        self.userId = ""
        self.day = ""
        self.startTime = ""
        self.endTime = ""
    }
}
