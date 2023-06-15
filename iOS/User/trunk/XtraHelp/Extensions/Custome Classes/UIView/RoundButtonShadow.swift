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
        self.clipsToBounds = true
        self.maskToBounds = true
        delay(seconds: 0.1, execute: {
            self.cornerRadius = self.frame.height / 2
            self.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            self.maskToBounds = false
        })
    }
}
