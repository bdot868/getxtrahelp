//
//  SenderReceiverDataModel.swift
//  Momentor
//
//  Created by Harshad on 07/05/21.
//

import UIKit

class SenderReceiverDataModel: NSObject {

    let access_token : String
    let id : String
    let image : String
    let name : String
    
    init?(dict : [String:Any]){
        self.access_token = dict[kaccess_token] as? String ?? ""
        self.id = dict[kid] as? String ?? ""
        self.image = dict[kimage] as? String ?? ""
        self.name = dict[kname] as? String ?? ""
    }
}
