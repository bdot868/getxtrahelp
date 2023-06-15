//
//  MembershipContentCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 08/10/21.
//

import UIKit

class MembershipContentCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblSubDesc: UILabel?
    
    // MARK: - Variables

    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblSubDesc?.textColor = UIColor.CustomColor.subscriptionColor
        self.lblSubDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
    }
}

// MARK: - NibReusable
extension MembershipContentCell: NibReusable { }
