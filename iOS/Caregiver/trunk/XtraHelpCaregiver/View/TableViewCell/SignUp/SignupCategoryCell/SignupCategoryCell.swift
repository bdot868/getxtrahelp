//
//  SignupCategoryCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 17/11/21.
//

import UIKit

class SignupCategoryCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    @IBOutlet weak var vwOverlay: UIView?
    
    @IBOutlet weak var lblCategoryName: UILabel?
    @IBOutlet weak var lblCategoryPrice: UILabel?
    
    @IBOutlet weak var imgCategory: UIImageView?
    
    @IBOutlet weak var stackTextCategory: UIStackView?
    
    @IBOutlet weak var btnSelect: UIButton?
    
    // MARK: - Variables
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        self.vwMain?.cornerRadius = 20.0
        self.imgCategory?.cornerRadius = 20.0
        self.vwOverlay?.cornerRadius = 20.0
        self.vwOverlay?.backgroundColor = UIColor.CustomColor.black50Per
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.whitecolor
        self.lblCategoryName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblCategoryPrice?.textColor = UIColor.CustomColor.CategoryPricecolor
        self.lblCategoryPrice?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwMain?.borderWidth = 2.0
    }
    
    func setCategoryData(obj : JobCategoryModel){
        self.lblCategoryName?.text = obj.name
        self.imgCategory?.setImage(withUrl: obj.imageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblCategoryPrice?.isHidden = true
        self.btnSelect?.isHidden = !obj.isSelectCategory
        self.vwMain?.borderColor = obj.isSelectCategory ? UIColor.CustomColor.appColor : UIColor.clear
    }
}

// MARK: - NibReusable
extension SignupCategoryCell : NibReusable {}
