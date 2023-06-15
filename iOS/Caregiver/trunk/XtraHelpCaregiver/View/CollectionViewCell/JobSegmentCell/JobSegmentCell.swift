//
//  JobSegmentCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 28/03/22.
//

import UIKit

class JobSegmentCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblTabName: UILabel?
    
    @IBOutlet weak var vwTabBottomBar: UIView?
    @IBOutlet weak var vwRightDotMain: UIView?
    @IBOutlet weak var vwRightDot: UIView?
    
    @IBOutlet weak var btnSelectTab: UIButton?
    
    // MARK: - Variables
    var isSelectTab : Bool = false{
        didSet{
            //self.vwTabBottomBar.isHidden = isHideBottomBarView
            self.lblTabName?.textColor = isSelectTab ? UIColor.CustomColor.tabBarColor : UIColor.CustomColor.SubscriptuionSubColor
            self.vwTabBottomBar?.isHidden = !isSelectTab
            self.lblTabName?.font = isSelectTab ? UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 12.0)) :  UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        }
    }
    
    var isHideRightDotView : Bool = false{
        didSet{
            self.vwRightDotMain?.isHidden = isHideRightDotView
        }
    }

    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.vwTabBottomBar?.cornerRadius = (self.vwTabBottomBar?.frame.height ?? 0.0) / 2
    }

    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblTabName?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTabName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
        
        self.vwRightDot?.backgroundColor = UIColor.CustomColor.verificationTextColor
        self.vwTabBottomBar?.backgroundColor = UIColor.CustomColor.tabBarColor
    }
}

// MARK: - NibReusable
extension JobSegmentCell: NibReusable { }

