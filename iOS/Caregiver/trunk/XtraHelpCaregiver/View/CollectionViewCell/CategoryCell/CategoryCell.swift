//
//  CategoryCell.swift
//  Momentor
//
//  Created by wmdevios-h on 14/08/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwMainContent: UIView?
    @IBOutlet weak var vwCategoryMain: UIView?
    
    @IBOutlet weak var imgCategory: UIImageView?
    
    
    @IBOutlet weak var lblCategoryName: UILabel?
    
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.InitConfig()
    }
    
    private func InitConfig(){
        self.vwMainContent?.cornerRadius = 15.0
        
        self.vwCategoryMain?.backgroundColor = UIColor.CustomColor.black60Per
        self.vwMainContent?.borderWidth = 3.0
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.whitecolor
        self.lblCategoryName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension CategoryCell : NibReusable {}
