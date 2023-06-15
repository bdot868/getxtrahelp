//
//  HelpSupportHeaderSectionCell.swift
//  DDD
//
//  Created by wmdevios-h on 18/06/21.
//  Copyright © 2021 Wdev3. All rights reserved.
//

import UIKit

class HelpSupportHeaderSectionCell: UITableViewHeaderFooterView {

    @IBOutlet weak var lblHeader: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblHeader.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblHeader.textColor = UIColor.CustomColor.tabBarColor
    }
}

extension HelpSupportHeaderSectionCell : NibReusable {}
