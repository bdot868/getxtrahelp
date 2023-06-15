//
//  FilterSpecialitiesCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 13/12/21.
//

import UIKit

class FilterSpecialitiesCell: UICollectionViewCell {

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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblUsername?.textColor = UIColor.CustomColor.SliderTextColor
        self.lblUsername?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
    }
    
    func setSpecialitiesData(obj : WorkSpecialityModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectSpecialities
        self.vwSelectAbout?.isHidden = true
    }
    
    /*func setSpecialitiesData(obj : LovedSpecialitiesModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectSpecialities
        self.vwSelectAbout?.isHidden = true
    }
    
    func setCategoriesData(obj : LovedCategoryModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectCategory
        self.vwSelectAbout?.isHidden = false
    }
    
    func setCreateJobSubCategoriesData(obj : JobSubCategoryModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectSubCategory
        self.vwSelectAbout?.isHidden = true
    }*/
}

// MARK: - NibReusable
extension FilterSpecialitiesCell: NibReusable { }
