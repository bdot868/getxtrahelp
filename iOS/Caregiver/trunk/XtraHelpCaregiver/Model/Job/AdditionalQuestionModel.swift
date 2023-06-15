//
//  AdditionalQuestionModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 18/12/21.
//

import UIKit

class AdditionalQuestionModel: NSObject {

    var userJobQuestionId : String
    var jobId : String
    var question : String
    var answer : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userJobQuestionId = dictionary[kuserJobQuestionId] as? String ?? ""
        self.jobId = dictionary[kjobId] as? String ?? ""
        self.question = dictionary[kquestion] as? String ?? ""
        self.answer = dictionary[kanswer] as? String ?? ""
    }
    
    init(UserJobQuestionId : String,JobId : String,Question : String,Answer : String){
        self.userJobQuestionId = UserJobQuestionId
        self.jobId = JobId
        self.question = Question
        self.answer = Answer
    }
    
    override init() {
        self.userJobQuestionId = ""
        self.jobId = ""
        self.question = ""
        self.answer = ""
    }
}
