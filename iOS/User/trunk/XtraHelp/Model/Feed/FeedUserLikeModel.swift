//
//  FeedUserLikeModel.swift
//  Momentor
//
//  Created by Harshad on 01/02/22.
//

import UIKit

class FeedUserLikeModel: NSObject {

    var id : String
    var userId : String
    var feedId : String
    var name : String
    var profileimage : String
    var thumbprofileimage : String
    var comment : String
    var formatedCreatedDate : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.userId = dictionary[kuserId] as? String ?? ""
        self.feedId = dictionary[kuserFeedId] as? String ?? ""
        self.name = dictionary[kuserFullName] as? String ?? ""
        self.profileimage = dictionary[kprofileImageUrl] as? String ?? ""
        self.thumbprofileimage = dictionary[kprofileImageThumbUrl] as? String ?? ""
        self.comment = dictionary[kcomment] as? String ?? ""
        self.formatedCreatedDate = dictionary[ktime_ago] as? String ?? ""
    }
    
    class func getFeedLikeCommentUser(with param: [String:Any]?,isShowLoader : Bool = true,isFromComment : Bool = false ,success withResponse: @escaping (_ arr: [FeedUserLikeModel],_ totalpage : Int,_ msg : String) -> Void, failure: @escaping FailureBlock) {
        if isShowLoader {
            SVProgressHUD.show()
        }
        APIManager.makeRequest(with: isFromComment ? AppConstant.API.kgetFeedCommentUser : AppConstant.API.kgetFeedLikeUser, method: .post, parameter: param, success: {(response) in
            if isShowLoader {
                SVProgressHUD.dismiss()
            }
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            let totalPages : Int = Int(dict[ktotalPages] as? String ?? "0") ?? 0
            if  isSuccess,let dataDict = dict[kData] as? [[String:Any]] {
                let arr = dataDict.compactMap(FeedUserLikeModel.init)
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
