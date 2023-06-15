//
//  PreferencesCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class PreferencesCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var vwRound: UIView?
    
    // MARK: - Variables
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.vwRound?.roundedCornerRadius()
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.vwRound?.backgroundColor = UIColor.CustomColor.tabBarColor
         
        self.lblName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension PreferencesCell: NibReusable { }
