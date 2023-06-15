//
//  VOIPMessageDataModel.swift
//  Momentor
//
//  Created by Harshad on 07/05/21.
//

import UIKit

class VOIPMessageDataModel: NSObject {

    let receiverData : SenderReceiverDataModel?
    let senderData : SenderReceiverDataModel?
    let room_name : String
    
    init?(dict : [String:Any]){
        self.receiverData = SenderReceiverDataModel.init(dict: dict[kreceiverData] as? [String:Any] ?? [:])
        self.senderData = SenderReceiverDataModel.init(dict: dict[ksenderData] as? [String:Any] ?? [:])
        self.room_name = dict[kroom_name] as? String ?? ""
    }
}
