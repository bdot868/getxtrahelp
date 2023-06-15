//
//  SupportTicketHeaderCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 19/10/21.
//

import UIKit

class SupportTicketHeaderCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var btnCreateTicket: XtraHelpButton?

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
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 30.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
    }
}

// MARK: - NibReusable
extension SupportTicketHeaderCell: NibReusable{}
