//
//  NextRoundButton.swift
//  Momentor
//
//  Created by wmdevios-h on 11/08/21.
//

import Foundation
import UIKit
import ChameleonFramework

class NextRoundButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        delay(seconds: 0.1, execute: {
            self.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        })
        self.setImage(#imageLiteral(resourceName: "IC_NextWhite"), for: .normal)
        self.setButtonImageTintColor(UIColor.CustomColor.whitecolor)
       // self.backgroundColor = UIColor.CustomColor.whitecolor
        self.maskToBounds = true
        delay(seconds: 0.1, execute: {
            self.cornerRadius = self.frame.height / 2
            self.shadow(UIColor.CustomColor.ButtonShadowColor, radius: 6.0, offset: CGSize(width: 5, height: 3), opacity: 1)
            self.maskToBounds = false
        })
    }
}
