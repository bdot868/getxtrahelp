//
//  FilterSortByCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

class FilterSortByCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    
    @IBOutlet weak var lblCategoryName: UILabel?
    
    // MARK: - Variables
    var isSelelctSortCell : Bool = false {
        didSet{
            self.lblCategoryName?.textColor = isSelelctSortCell ? UIColor.CustomColor.appColor : UIColor.CustomColor.textConnectLogin
            self.vwMain?.borderColor = isSelelctSortCell ? UIColor.CustomColor.appColor : UIColor.CustomColor.textConnectLogin
        }
    }
    
    
    // MARK: - LIfe Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblCategoryName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwMain?.cornerRadius = 12.0
        self.vwMain?.borderWidth = 2.0
        self.vwMain?.borderColor = UIColor.CustomColor.textConnectLogin
    }
}

// MARK: - NibReusable
extension FilterSortByCell: NibReusable { }
