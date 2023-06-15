//
//  ArticalCollectionCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 02/12/21.
//

import UIKit

class ArticalCollectionCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    @IBOutlet weak var vwOverlay: UIView?
    
    @IBOutlet weak var imgArtical: UIImageView?
    
    @IBOutlet weak var lblArticalName: UILabel?
    @IBOutlet weak var lblArticalTime: UILabel?
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let vw = self.vwOverlay {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.GradiantTabBarColor0,UIColor.CustomColor.GradiantTabBarColor75,UIColor.CustomColor.tabBarColor])
        }
    }

    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblArticalName?.textColor = UIColor.CustomColor.whitecolor
        self.lblArticalName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblArticalTime?.textColor = UIColor.CustomColor.whitecolor
        self.lblArticalTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        
        self.vwMain?.cornerRadius = 15.0
        self.imgArtical?.cornerRadius = 15.0
        self.vwOverlay?.cornerRadius = 15.0
    }
}

// MARK: - NibReusable
extension ArticalCollectionCell: NibReusable { }
