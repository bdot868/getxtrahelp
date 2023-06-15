//
//  AddPhotoVideoModel.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 10/12/21.
//

import UIKit

class AddPhotoVideoModel: NSObject {

    var userJobMediaId : String
    var jobId : String
    var mediaNameUrl : String
    var mediaName : String
    var isVideo : Bool
    var videoImage : String
    var videoThumpImg : UIImage
    var mediaNameThumbUrl : String
    var videoImageUrl : String
    var videoImageThumbUrl : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.userJobMediaId = dictionary[kuserJobMediaId] as? String ?? ""
        self.jobId = dictionary[kjobId] as? String ?? ""
        self.mediaNameUrl = dictionary[kmediaNameUrl] as? String ?? ""
        self.mediaName = dictionary[kmediaName] as? String ?? ""
        self.isVideo = (dictionary[kisVideo] as? String ?? "") == "1" ? true : false
        self.videoThumpImg = UIImage(named: DefaultPlaceholderImage.AppPlaceholder) ?? UIImage()
        self.videoImage = dictionary[kvideoImage] as? String ?? ""
        self.mediaNameThumbUrl = dictionary[kmediaNameThumbUrl] as? String ?? ""
        self.videoImageUrl = dictionary[kvideoImageUrl] as? String ?? ""
        self.videoImageThumbUrl = dictionary[kvideoImageThumbUrl] as? String ?? ""
    }
    
    init(UserJobMediaId : String,JobId : String,MediaNameUrl : String,MediaName : String,isvideo : Bool,VideoImage : String,videothumpimg : UIImage,MediaNameThumbUrl : String,VideoImageUrl : String,VideoImageThumbUrl : String){
        self.userJobMediaId = UserJobMediaId
        self.jobId = JobId
        self.mediaNameUrl = MediaNameUrl
        self.mediaName = MediaName
        self.isVideo = isvideo
        self.videoThumpImg = videothumpimg
        self.videoImage = VideoImage
        self.mediaNameThumbUrl = MediaNameThumbUrl
        self.videoImageUrl = VideoImageUrl
        self.videoImageThumbUrl = VideoImageThumbUrl
    }
    
    override init() {
        self.userJobMediaId = ""
        self.jobId = ""
        self.mediaNameUrl = ""
        self.mediaName = ""
        self.isVideo = false
        self.videoThumpImg = UIImage()
        self.videoImage = ""
        self.mediaNameThumbUrl = ""
        self.videoImageUrl = ""
        self.videoImageThumbUrl = ""
    }
    
    class func addVideoAPI(with videoData: NSData?,image : UIImage?,param: [String:Any]?, success withResponse: @escaping (_ videoname : String,_ videourl : String,_ videoThumImgUrl : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeMultipartFormDataVideoRequest(AppConstant.API.kmediaUpload, videodata: videoData, videoName: kfiles, image: image, imageName: kVideoThumbnail, withParameter: param, withSuccess: { (response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if isSuccess,let dataDict = dict[kData] as? [[String:Any]]{
                
                if let first = dataDict.first {
                    let msg = first[kmediaName] as? String ?? ""
                    let videourl = first[kmediaBaseUrl] as? String ?? ""
                    let videoThumnailurl = first[kvideoThumbImgUrl] as? String ?? ""
                    withResponse(msg,videourl,videoThumnailurl)
                } else {
                    failure(statuscode,message, .response)
                }
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
    
    class func addFeedVideoAPI(with videoData: NSData?,image : UIImage?,param: [String:Any]?, success withResponse: @escaping (_ videoname : String,_ videourl : String,_ videoThumImgUrl : String,_ videoThumImgName : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeMultipartFormDataVideoRequest(AppConstant.API.kmediaUpload, videodata: videoData, videoName: kfiles, image: image, imageName: kVideoThumbnail, withParameter: param, withSuccess: { (response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if isSuccess,let dataDict = dict[kData] as? [[String:Any]]{
                
                if let first = dataDict.first {
                    let msg = first[kmediaName] as? String ?? ""
                    let videourl = first[kmediaBaseUrl] as? String ?? ""
                    let videoThumnailurl = first[kvideoThumbImgUrl] as? String ?? ""
                    let thumpImgName = first[kvideoThumbImgName] as? String ?? ""
                    withResponse(msg,videourl,videoThumnailurl,thumpImgName)
                } else {
                    failure(statuscode,message, .response)
                }
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
