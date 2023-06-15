//
//  NoDataFoundLabel.swift
//  OnixNetwork
//
//  Created by Harshad on 03/09/20.
//  Copyright © 2020 Differenz. All rights reserved.
//

import UIKit

class NoDataFoundLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    @IBInspectable var setLabelText: String = "" {
        didSet {
            self.text = setLabelText
        }
    }
    
    @IBInspectable var setLabelFontSize: CGFloat = 12.0 {
        didSet {
            self.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: setLabelFontSize))
        }
    }
    
    func setupView() {
        self.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 16.0))
        self.textColor = UIColor.CustomColor.tabBarColor
    }

}
