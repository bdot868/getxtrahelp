//
//  TicketChatHeaderCell.swift
//  DDD
//
//  Created by Wdev3 on 05/11/20.
//  Copyright © 2020 Wdev3. All rights reserved.
//

import UIKit

class TicketChatHeaderCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeaderTicketID: UILabel?
    @IBOutlet weak var lblTicketid: UILabel?
    @IBOutlet weak var lblHeaderTicketTitle: UILabel?
    @IBOutlet weak var lblTicketTitle: UILabel?
    @IBOutlet weak var lblHeaderStatus: UILabel?
    @IBOutlet weak var lblTicketStatus: UILabel?
    @IBOutlet weak var lblHeaderTicketDesc: UILabel?
    @IBOutlet weak var lblTicketDesc: UILabel?
    
    @IBOutlet weak var vwMainContent: UIView?
    
    // MARK: - Variables
    var isCloseTicket : Bool = false {
        didSet{
            self.lblTicketStatus?.text = isCloseTicket ? "Closed" : "Open"
            self.lblTicketStatus?.textColor = isCloseTicket ? UIColor.CustomColor.resourceBtnColor : UIColor.CustomColor.ticketStausColor
        }
    }
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfigure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.vwMainContent?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 40.0)
    }
    
    private func InitConfigure(){
        [self.lblHeaderTicketID,self.lblHeaderTicketTitle,self.lblHeaderStatus,self.lblHeaderTicketDesc].forEach({
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
            $0?.textColor = UIColor.CustomColor.whitecolor
        })
        
        [self.lblTicketid,self.lblTicketTitle,self.lblTicketStatus,self.lblTicketDesc].forEach({
            $0?.font = UIFont.RubikLight(ofSize: GetAppFontSize(size: 14.0))
            $0?.textColor = UIColor.CustomColor.ticketIDcolor
            $0?.addInterlineSpacing(spacingValue: 5.0)
        })
        
        self.lblTicketStatus?.textColor = UIColor.CustomColor.ticketStausColor
        self.vwMainContent?.backgroundColor = UIColor.CustomColor.tabBarColor
        
    }
}

//extension TicketChatHeaderCell : NibReusable {}
extension TicketChatHeaderCell : NibReusable{}
