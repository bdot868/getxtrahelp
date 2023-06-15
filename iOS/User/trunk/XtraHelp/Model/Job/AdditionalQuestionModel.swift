//
//  AdditionalQuestionModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 18/12/21.
//

import UIKit

class AdditionalQuestionModel: NSObject {

    var id : String
    var userJobQuestionId : String
    var jobId : String
    var question : String
    var userId : String
    var userJobApplyId : String
    var answer : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.userJobQuestionId = dictionary[kuserJobQuestionId] as? String ?? ""
        self.jobId = dictionary[kjobId] as? String ?? ""
        self.question = dictionary[kquestion] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.userJobApplyId = dictionary[kuserJobApplyId] as? String ?? ""
        self.answer = dictionary[kanswer] as? String ?? ""
    }
    
    init(UserJobQuestionId : String,JobId : String,Question : String,Id : String,UserId : String,UserJobApplyId : String,Answer : String){
        self.id = Id
        self.userJobQuestionId = UserJobQuestionId
        self.jobId = JobId
        self.question = Question
        self.userId = UserId
        self.userJobApplyId = UserJobApplyId
        self.answer = Answer
    }
    
    override init() {
        self.id = ""
        self.userJobQuestionId = ""
        self.jobId = ""
        self.question = ""
        self.userId = ""
        self.userJobApplyId = ""
        self.answer = ""
    }
    
    class func applicantApplyJobQueAnsList(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [AdditionalQuestionModel],_ totalpage : Int) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kapplicantApplyJobQueAnsList, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                let arr = dataDict.compactMap(AdditionalQuestionModel.init)
                withResponse(arr,totalPages)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            failure("0",connectionError, .connection)
        })
    }
}
