//
//  CategoryListCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit

class CategoryListCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwCategoryMain: UIView?
    @IBOutlet weak var vwDeleteMain: UIView?
    
    @IBOutlet weak var btnClose: UIButton?
    
    @IBOutlet weak var lblCategoryName: UILabel?
    
    // MARK: - Variables
    var isFromProfile : Bool = false {
        didSet{
            self.vwCategoryMain?.backgroundColor = UIColor.CustomColor.appColor
            self.lblCategoryName?.textColor = UIColor.CustomColor.whitecolor
            self.vwDeleteMain?.isHidden = true
            self.lblCategoryName?.textAlignment = .center
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        self.vwCategoryMain?.cornerRadius = 20.0
        self.vwCategoryMain?.backgroundColor = UIColor.CustomColor.whitecolor
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblCategoryName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension CategoryListCell : NibReusable {}
