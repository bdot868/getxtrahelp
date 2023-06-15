//
//  SideMenuBottomCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

class SideMenuBottomCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var btnMenu: UIButton?
    @IBOutlet weak var lblMenuName: UILabel?
    
    // MARK: - Variables
    var isLogout : Bool = false {
        didSet {
            self.lblMenuName?.textColor = isLogout ? UIColor.CustomColor.appColor : UIColor.CustomColor.whitecolor
            self.lblMenuName?.font = isLogout ? UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0)) : UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func initConfig(){
        self.lblMenuName?.textColor = UIColor.CustomColor.whitecolor
        self.lblMenuName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension SideMenuBottomCell: NibReusable { }
