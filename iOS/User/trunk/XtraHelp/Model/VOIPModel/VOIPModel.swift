//
//  VOIPModel.swift
//  Momentor
//
//  Created by Harshad on 07/05/21.
//

import UIKit

class VOIPModel: NSObject {

    let category : String
    let messageData : VOIPMessageDataModel?
    let unread : String
    
    init?(dict : [String:Any]){
        self.category = dict[kcategory] as? String ?? ""
        self.messageData = VOIPMessageDataModel.init(dict: dict[kmessageData] as? [String:Any] ?? [:])
        self.unread = dict[kunread] as? String ?? ""
    }
}
