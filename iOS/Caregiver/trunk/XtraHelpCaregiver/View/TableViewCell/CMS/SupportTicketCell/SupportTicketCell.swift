//
//  SupportTicketCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 19/10/21.
//

import UIKit

class SupportTicketCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwSeprator: UIView?
    @IBOutlet weak var vwChatStatusMain: UIView?
    @IBOutlet weak var vwChatStatusSub: UIView?

    @IBOutlet weak var lblticketSubject: UILabel?
    @IBOutlet weak var lblticketTime: UILabel?
    @IBOutlet weak var lblticketDesc: UILabel?
    
    // MARK: - Variables
    var isTicketClose : Bool = false {
        didSet{
            self.vwChatStatusSub?.backgroundColor = isTicketClose ? UIColor.CustomColor.statusCloseTicketColor : UIColor.CustomColor.statusTicketColor
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.vwChatStatusSub?.roundedCornerRadius()
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        self.lblticketSubject?.textColor = UIColor.CustomColor.subscriptionColor
        self.lblticketSubject?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblticketTime?.textColor = UIColor.CustomColor.tutorialColor
        self.lblticketTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblticketDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblticketDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwSeprator?.backgroundColor = UIColor.CustomColor.borderColorMsg
    }
    
    func setupTicketData(obj : TicketModel){
        //self.lblTicketTitle.text = obj.title
        self.lblticketSubject?.text = obj.title
        self.lblticketDesc?.text = obj.ticketdescription
        self.lblticketTime?.text = obj.lastMsgTime
       
        self.isTicketClose = (obj.status == "0")
    }
}

// MARK: - NibReusable
extension SupportTicketCell: NibReusable{}

