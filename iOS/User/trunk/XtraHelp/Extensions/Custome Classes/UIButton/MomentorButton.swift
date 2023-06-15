//
//  MomentorButton.swift
//  Momentor
//
//  Created by wmdevios-h on 14/08/21.
//

import Foundation
import UIKit
import ChameleonFramework

class XtraHelpButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        self.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.setTitleColor(UIColor.CustomColor.whitecolor, for: .normal)
        
        delay(seconds: 0.1, execute: {
            self.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        })
        delay(seconds: 0.1, execute: {
            self.maskToBounds = true
            self.cornerRadius = 10.0
            self.shadow(UIColor.CustomColor.ButtonShadowColor, radius: 10.0, offset: CGSize(width: 5, height: 3), opacity: 1)
            self.maskToBounds = false
        })
    }
}
