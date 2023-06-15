//
//  AboutLoveCategoryTabelCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 31/05/22.
//

import UIKit

class AboutLoveCategoryTabelCell: UITableViewCell {
    
    @IBOutlet weak var lblUsername: UILabel?
    
    @IBOutlet weak var vwSelectMain: UIView?
    @IBOutlet weak var btnSelect: UIButton?
    @IBOutlet weak var btnSelectMain: UIButton?
    
    @IBOutlet weak var vwSelectAbout: UIView?
    @IBOutlet weak var btnSelectAbout: UIButton?

    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblUsername?.textColor = UIColor.CustomColor.SliderTextColor
        self.lblUsername?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        self.lblUsername?.sizeToFit()
    }
    
    func setSpecialitiesData(obj : LovedSpecialitiesModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectSpecialities
        self.vwSelectAbout?.isHidden = true
    }
    
    func setCategoriesData(obj : LovedCategoryModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectCategory
        self.vwSelectAbout?.isHidden = obj.lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) ? true : false
    }
    
    func setCreateJobSubCategoriesData(obj : JobSubCategoryModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectSubCategory
        self.vwSelectAbout?.isHidden = true
    }
}

// MARK: - NibReusable
extension AboutLoveCategoryTabelCell: NibReusable { }
