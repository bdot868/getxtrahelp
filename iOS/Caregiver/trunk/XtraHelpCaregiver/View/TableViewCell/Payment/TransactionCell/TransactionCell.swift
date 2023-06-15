//
//  TransactionCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 15/10/21.
//

import UIKit

class TransactionCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwDollarImageSub: UIView?
    @IBOutlet weak var vwContentMainSub: UIView?
    
    @IBOutlet weak var lblMembership: UILabel?
    @IBOutlet weak var lblPrice: UILabel?
    @IBOutlet weak var lblTransDesc: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    @IBOutlet weak var imgAccount: UIImageView?
    
    // MARK: - Variables
    var isFromAcocunt : Bool = false {
        didSet{
            self.imgAccount?.image = isFromAcocunt ? #imageLiteral(resourceName: "notification_New") : #imageLiteral(resourceName: "notification_New")
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.InitConfig()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
       
        self.lblMembership?.textColor = UIColor.CustomColor.tabBarColor
        self.lblMembership?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))

        self.lblPrice?.textColor = UIColor.CustomColor.appColor
        self.lblPrice?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 17.0))
        
        self.lblTransDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblTransDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.tutorialColor
        self.lblTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwDollarImageSub?.backgroundColor = UIColor.CustomColor.TransactionBGColor
        self.vwDollarImageSub?.cornerRadius = 10.0
    }
    
    func setTransactionData(obj : TransactionModel){
        self.lblMembership?.text = obj.jobName
        self.lblPrice?.text = obj.amountFormatted
        self.lblTransDesc?.text = obj.caregiverName
        self.lblTime?.text = obj.userTransactionTime
    }
}

// MARK: - NibReusable
extension TransactionCell : NibReusable{}
