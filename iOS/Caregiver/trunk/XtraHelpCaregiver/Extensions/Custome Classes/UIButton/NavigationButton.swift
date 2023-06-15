//
//  NavigationButton.swift
//  Momentor
//
//  Created by Wdev3 on 18/02/21.
//

import Foundation
import UIKit

class NavigationButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        //self.setImage(#imageLiteral(resourceName: "ic_BackImg"), for: .normal)
//        self.setButtonImageTintColor(UIColor.black)
        self.backgroundColor = UIColor.CustomColor.whitecolor
        self.maskToBounds = true
        self.cornerRadius = cornerRadiousValue.defaulrCorner
        self.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
        self.maskToBounds = false
        
    }
}
