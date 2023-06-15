//
//  FeedModel.swift
//  Momentor
//
//  Created by Harshad on 31/01/22.
//

import UIKit

class FeedModel: NSObject {
    
    var id : String
    var userId : String
    var feed : String
    var name : String
    var profileimage : String
    var thumbprofileimage : String
    var formatedTime : String
    var isLiked : String
    var totalLikes : String
    var totalComments : String
    var imageVideo : [AddPhotoVideoModel]
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kuserFeedId] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.feed = dictionary[kdescription] as? String ?? ""
        self.name = dictionary[kuserFullName] as? String ?? ""
        self.profileimage = dictionary[kprofileImageUrl] as? String ?? ""
        self.thumbprofileimage = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.formatedTime = dictionary[kcreatedTime] as? String ?? ""
        self.isLiked = dictionary[kisLike] as? String ?? ""
        self.totalLikes = dictionary[ktotalFeedLike] as? String ?? ""
        self.totalComments = dictionary[ktotalFeedComment] as? String ?? ""
        self.imageVideo = (dictionary[kmedia] as? [[String:Any]] ?? []).compactMap(AddPhotoVideoModel.init)
    }

    class func setFeed(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetFeed, method: .post, parameter: param, success: {(response) in
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
    
    class func getFeedList(with param: [String:Any]?,isShowLoader : Bool = true, success withResponse: @escaping (_ arr: [FeedModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: AppConstant.API.kgetFeedList, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                let arr = dataDict.compactMap(FeedModel.init)
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
    
    class func setFeedLikeUnlike(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        //SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetFeedLikeUnlike, method: .post, parameter: param, success: {(response) in
            //SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            //SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            //SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func setFeedReport(with param: [String:Any]?,isFromComment : Bool = false, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: isFromComment ? AppConstant.API.ksetFeedCommentReport : AppConstant.API.ksetFeedReport, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            } else {
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
    
    class func deleteFeed(with param: [String:Any]?,isFromComment : Bool = false, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: isFromComment ? AppConstant.API.kdeleteFeedComment : AppConstant.API.kdeleteFeed, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            } else {
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
    
    class func setFeedComment(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetFeedComment, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            } else {
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
