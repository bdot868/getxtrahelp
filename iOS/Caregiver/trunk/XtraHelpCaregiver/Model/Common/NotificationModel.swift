//
//  NotificationModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 25/02/22.
//

import UIKit

class NotificationModel: NSObject {

    var id : String
    var title : String
    var desc : String
    var send_from : String
    var send_to : String
    var model : String
    var model_id : String
    var status : String
    var time_ago : String
    var thumbSenderImage : String
    var senderImage : String
    var senderName : String
    
    init?(dict : [String:Any]){
        
        self.id = dict[kid] as? String ?? ""
        self.title = dict[ktitle] as? String ?? ""
        self.desc = dict[kdesc] as? String ?? ""
        self.send_from = dict[ksend_from] as? String ?? ""
        self.send_to = dict[ksend_to] as? String ?? ""
        self.model = dict[kmodel] as? String ?? ""
        self.model_id = dict[kmodel_id] as? String ?? ""
        self.status = dict[kstatus] as? String ?? ""
        self.time_ago = dict[ktime] as? String ?? ""
        
        self.thumbSenderImage = dict[kthumbSenderImage] as? String ?? ""
        self.senderImage = dict[ksenderImage] as? String ?? ""
        self.senderName = dict[ksenderName] as? String ?? ""
    }
    
    class func getNotificationsListAPICall(with param: [String:Any]?,isShowLoader : Bool, success withResponse: @escaping (_ arr: [NotificationModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
           if isShowLoader {
           SVProgressHUD.show()
           }
        APIManager.makeRequest(with: AppConstant.API.kgetNotificationsList, method: .post, parameter: param, success: {(response) in
               if isShowLoader {
               SVProgressHUD.dismiss()
               }
               let dict = response as? [String:Any] ?? [:]
               
               let message = dict[kMessage] as? String ?? ""
               let statuscode = dict[kstatus] as? String ?? "0"
               let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
               let totalPages : Int = Int(dict["total_page"] as? String ?? "0") ?? 0
               if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                   
                   let arr = dataDict.compactMap(NotificationModel.init)
                   
                   withResponse(arr,totalPages,message)
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
