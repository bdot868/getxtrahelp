//
//  FilterCategoryCell.swift
//  XtraHelp
//
//  Created by wm-ioskp on 22/10/21.
//

import UIKit

class FilterCategoryCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    @IBOutlet weak var vwOverlay: UIView?
    
    @IBOutlet weak var lblCategoryName: UILabel?
    
    @IBOutlet weak var imgCategory: UIImageView?
    
    // MARK: - Variables
    
    // MARK: - LIfe Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        self.vwMain?.cornerRadius = 10.0
        self.imgCategory?.cornerRadius = 10.0
        self.vwOverlay?.cornerRadius = 10.0
        self.vwOverlay?.backgroundColor = UIColor.CustomColor.black50Per
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.whitecolor
        self.lblCategoryName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwMain?.borderWidth = 2.0
    }
    
    func setCategoryData(obj : JobCategoryModel){
        self.lblCategoryName?.text = obj.name
        self.imgCategory?.setImage(withUrl: obj.imageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.vwMain?.borderColor = obj.isSelectCategory ? UIColor.CustomColor.appColor : UIColor.clear
    }

}

// MARK: - NibReusable
extension FilterCategoryCell: NibReusable { }
