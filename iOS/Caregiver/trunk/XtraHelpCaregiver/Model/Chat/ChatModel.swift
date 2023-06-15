//
//  ChatModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/01/22.
//

import UIKit

class ChatModel: NSObject {

    var id : String
    var friendUserId : String
    var groupType : String
    var image : String
    var isAdmin : String
    var message : String
    var messageId : String
    var name : String
    var sender : String
    var thumbImage : String
    var type : String
    var unreadMessages : String
    var time : String
    var senderImage : String
    var senderName : String
    var groupStatus : String
    var suggestedProvider : SuggestedProviderModel?
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.id = dictionary[kid] as? String ?? ""
        self.friendUserId = dictionary[kfriendUserId] as? String ?? ""
        self.groupType = dictionary[kgroupType] as? String ?? ""
        self.image = dictionary[kimage] as? String ?? ""
        self.isAdmin = dictionary[kisAdmin] as? String ?? ""
        self.message = dictionary[kmessage] as? String ?? ""
        self.messageId = dictionary[kmessageId] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.sender = dictionary[ksender] as? String ?? ""
        self.thumbImage = dictionary[kthumbImage] as? String ?? ""
        self.type = dictionary[ktype] as? String ?? ""
        self.unreadMessages = dictionary[kunreadMessages] as? String ?? ""
        self.time = dictionary[ktime] as? String ?? ""
        self.senderImage = dictionary[ksenderImage] as? String ?? ""
        self.senderName = dictionary[ksenderName] as? String ?? ""
        self.groupStatus = dictionary[kgroupStatus] as? String ?? ""
        self.suggestedProvider = SuggestedProviderModel.init(dictionary: dictionary[ksuggestedProvider] as? [String:Any] ?? [:])
    }
}
