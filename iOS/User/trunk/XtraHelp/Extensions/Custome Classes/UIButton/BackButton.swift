//
//  BackButton.swift
//  Momentor
//
//  Created by Wdev3 on 18/02/21.
//

import Foundation
import UIKit

class BackButton : UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        self.setImage(#imageLiteral(resourceName: "ic_BackImg"), for: .normal)
//        self.setButtonImageTintColor(UIColor.black)
        self.backgroundColor = UIColor.CustomColor.whitecolor
        self.maskToBounds = true
        self.cornerRadius = cornerRadiousValue.defaulrCorner
        self.shadow(UIColor.CustomColor.shadowColor, radius: 6.0, offset: CGSize(width: 5, height: 3), opacity: 1)
        self.maskToBounds = false
        
    }
}
