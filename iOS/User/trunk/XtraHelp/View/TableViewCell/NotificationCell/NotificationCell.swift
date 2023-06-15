//
//  NotificationCell.swift
//  Chiry
//
//  Created by Wdev3 on 20/02/21.
//

import UIKit

class NotificationCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwLeftRound: UIView?
    
    @IBOutlet weak var lblNotificationName: UILabel?
    @IBOutlet weak var lblNotificationTime: UILabel?
    @IBOutlet weak var vwSeprator: UIView?
    
    @IBOutlet weak var imgNotificationType: UIImageView?
    
    @IBOutlet weak var vwAwardPaynowMain: UIView?
    @IBOutlet weak var btnAwardJobPayNow: UIButton?
    @IBOutlet weak var btnAwardJobCancel: UIButton?
    
    // MARK: - Variables
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib(){
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    private func InitConfig(){
        self.lblNotificationName?.textColor = UIColor.CustomColor.blackColor
        self.lblNotificationName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblNotificationTime?.textColor = UIColor.CustomColor.tutorialColor
        self.lblNotificationTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwSeprator?.backgroundColor = UIColor.CustomColor.sepratorColorLocation
        
        self.vwLeftRound?.cornerRadius = 10.0
        self.vwLeftRound?.backgroundColor = UIColor.CustomColor.ticketIDcolor
        
        self.btnAwardJobCancel?.titleLabel?.font = UIFont.RubikMedium(ofSize: 14.0)
        self.btnAwardJobCancel?.setTitleColor(UIColor.CustomColor.labelTextColor, for: .normal)
    }
    
    func setData(obj : NotificationModel){
        self.lblNotificationName?.text = obj.desc
        self.lblNotificationTime?.text = obj.time_ago
        
        self.vwAwardPaynowMain?.isHidden = !(obj.model == "acceptAwardJobRequestByCaregiver")
    }
}

// MARK: - NibReusable
extension NotificationCell: NibReusable { }
