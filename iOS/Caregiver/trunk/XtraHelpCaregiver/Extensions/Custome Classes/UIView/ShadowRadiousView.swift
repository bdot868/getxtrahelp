//
//  ShadowRadiousView.swift
//  DDD
//
//  Created by Wdev3 on 31/10/20.
//  Copyright © 2020 Wdev3. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class ShadowRadiousView: UIView {
    
    // MARK: - IBOutlet
    
    
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
        //self.cornerRadius(4.0)
        self.backgroundColor = UIColor.CustomColor.whitecolor
        self.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
        //self.borderWidth(1.0)
        //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
        self.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
        self.maskToBounds = false
        
    }
}
