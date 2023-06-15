//
//  ConnectAccountModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 14/02/22.
//

import UIKit

class ConnectAccountModel: NSObject {

    var isPayout : String
    var isBankDetail : String
    var isPayment : String
    var isStripeConnect : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        self.isPayout = dictionary[kisPayout] as? String ?? ""
        self.isBankDetail = dictionary[kisBankDetail] as? String ?? ""
        self.isPayment = dictionary[kisPayment] as? String ?? ""
        self.isStripeConnect = dictionary[kisStripeConnect] as? String ?? ""
    }
}
