//
//  HelpSupportCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 16/10/21.
//

import UIKit

class HelpSupportCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwArrowMain: UIView?
    @IBOutlet weak var vwArrowSub: UIView?
    @IBOutlet weak var vwContentMain: UIView?

    @IBOutlet weak var lblCMSDesc: UILabel?
    
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
        
        self.vwArrowSub?.cornerRadius = (self.vwArrowSub?.frame.width ?? 0.0) / 3
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        self.lblCMSDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblCMSDesc?.font = UIFont.RubikLight(ofSize: GetAppFontSize(size: 15.0))
        
        self.vwArrowSub?.backgroundColor = UIColor.CustomColor.tabBarColor
    }
    
}

// MARK: - NibReusable
extension HelpSupportCell: NibReusable{}
