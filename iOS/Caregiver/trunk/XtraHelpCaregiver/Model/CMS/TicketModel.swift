//
//  TicketModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/12/21.
//

import UIKit

class TicketModel: NSObject {

    var id : String
    var userId : String
    var title : String
    var priority : String
    var closedDate : String
    var reopenDate : String
    var createdDate : String
    var status : String
    var name : String
    var email : String
    var ticketdescription : String
    var replyType : String
    var ticketId : String
    var lastMsgTime : String
    var forReply : supportForReplyType
    var lastReplay : String
    var time : String
    var profileimage : String
    var senderName : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.title = dictionary[ktitle] as? String ?? ""
        self.priority = dictionary[kpriority] as? String ?? ""
        self.closedDate = dictionary[kclosedDate] as? String ?? ""
        self.reopenDate = dictionary[kreopenDate] as? String ?? ""
        self.createdDate = dictionary[kcreatedDate] as? String ?? ""
        self.status = dictionary[kstatus] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.email = dictionary[kEmail] as? String ?? ""
        self.ticketdescription = dictionary[kdescription] as? String ?? ""
        self.replyType = dictionary[kreplyType] as? String ?? ""
        self.ticketId = dictionary[kticketId] as? String ?? ""
        self.lastMsgTime = dictionary[klastMsgTime] as? String ?? ""
        self.forReply = supportForReplyType.init(rawValue: dictionary[kforReply] as? String ?? "1") ?? supportForReplyType.admin
        self.lastReplay = dictionary[klastReplay] as? String ?? ""
        self.time = dictionary[ktime] as? String ?? ""
        self.profileimage = dictionary[kprofileimage] as? String ?? ""
        self.senderName = dictionary[ksenderName] as? String ?? ""
    }
    
    class func addNewTicket(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetTicket, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func getTicketList(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [TicketModel],_ totalpage : Int) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetTicket, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                
                let arr = dataDict.compactMap(TicketModel.init)
                
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
    
    class func getTicketDetail(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ ticket : TicketModel,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetTicketDetail, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let ticket = TicketModel.init(dictionary: dataDict){
                
                withResponse(ticket,message)
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
    
    class func reopenTicket(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
        SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kreopenTicket, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
            SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                
                withResponse(message)
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
    
    class func getActiveTicket(with param: [String:Any]?,success withResponse: @escaping (_ ticketcount : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetActiveTicket, method: .post, parameter: param, success: {(response) in
            
            SVProgressHUD.dismiss()
            
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? String {
                let ticket : Int = Int(dataDict) ?? 0
                withResponse(ticket,message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
}
