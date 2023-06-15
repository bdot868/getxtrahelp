//
//  SelectAppButton.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import Foundation
import UIKit

class SelectAppButton : UIButton
{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    @IBInspectable var isSelectBtn: Bool = false {
        didSet {
            self.setTitleColor(isSelectBtn ? UIColor.CustomColor.appColor : UIColor.CustomColor.tutorialColor, for: .normal)
            self.borderColor = isSelectBtn ? UIColor.CustomColor.appColor : UIColor.CustomColor.tutorialColor
        }
    }
    
    func setupView()
    {
        
        self.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.setTitleColor(UIColor.CustomColor.tutorialColor, for: .normal)
        self.cornerRadius = 12.0
        
        self.backgroundColor = UIColor.clear
        self.borderWidth = 1.5
        self.borderColor = UIColor.CustomColor.tutorialColor
    }
}
