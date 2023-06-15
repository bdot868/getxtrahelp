//
//  SideMenuTopProfileCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

class SideMenuTopProfileCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwProfileSub: UIView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblAddress: UILabel?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    // MARK: - Variables
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let vw = self.vwProfileSub {
            vw.cornerRadius = vw.frame.width / 2.0
        }
        if let img = self.imgProfile {
            img.cornerRadius = img.frame.width / 2.0
        }
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblUserName?.textColor = UIColor.CustomColor.whitecolor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblAddress?.textColor = UIColor.CustomColor.whitecolor
        self.lblAddress?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension SideMenuTopProfileCell : NibReusable {}
