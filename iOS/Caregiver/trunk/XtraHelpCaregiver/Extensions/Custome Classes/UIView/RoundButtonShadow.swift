//
//  RoundButtonShadow.swift
//  Momentor
//
//  Created by wmdevios-h on 16/08/21.
//

import Foundation
import UIKit

class RoundButtonShadow: UIView {
    
    //MARK: - Life Cycle Methods
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
            self.maskToBounds = true
            self.shadow(UIColor.CustomColor.whitecolor0Per, radius: 6.0, offset: CGSize(width: 5, height: 3), opacity: 1)
            self.maskToBounds = false
        })
    }
}
