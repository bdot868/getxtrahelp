//
//  CommonListCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import UIKit

class CommonListCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblName: UILabel?
    
    @IBOutlet weak var vwSelectMain: UIView?
    @IBOutlet weak var btnSelect: UIButton?
    @IBOutlet weak var btnSelectMain: UIButton?
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        self.lblName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension CommonListCell : NibReusable {}
