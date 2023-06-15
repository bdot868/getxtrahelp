//
//  JobSubCategoryTableCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 22/06/22.
//

import UIKit

protocol JobSubCategoryDelegate {
    func selectSubCategoryData(isSelectSubCategory : Bool,cell : JobSubCategoryTableCell)
}

class JobSubCategoryTableCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel?
    
    @IBOutlet weak var vwSelectMain: UIView?
    @IBOutlet weak var btnSelect: UIButton?
    @IBOutlet weak var btnSelectMain: UIButton?
    
    @IBOutlet weak var vwSelectAbout: UIView?
    @IBOutlet weak var btnSelectAbout: UIButton?
    
    // MARK: - Variables
    var delegate : JobSubCategoryDelegate?

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
        self.lblUsername?.sizeToFit()
    }
    
    func setCreateJobSubCategoriesData(obj : JobSubCategoryModel){
        self.lblUsername?.text = obj.name
        self.btnSelect?.isSelected = obj.isSelectSubCategory
        self.vwSelectAbout?.isHidden = true
    }
    @IBAction func btnSelectMainClicked(_ sender: UIButton) {
        self.btnSelect?.isSelected = !(self.btnSelect?.isSelected ?? false)
        self.delegate?.selectSubCategoryData(isSelectSubCategory: (self.btnSelect?.isSelected ?? false), cell: self)
    }
}

// MARK: - NibReusable
extension JobSubCategoryTableCell: NibReusable { }
