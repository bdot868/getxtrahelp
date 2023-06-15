//
//  ShadowFourSideView.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import Foundation

class ShadowFourSideView: UIView {
    
    // MARK: - IBOutlet
    @IBInspectable var cornerradious: CGFloat = 10.0
    @IBInspectable var shadowradious: CGFloat = 1.0
    
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
        self.backgroundColor = UIColor.clear
        self.cornerRadius = self.cornerradious
        self.shadow(UIColor.CustomColor.shadowColorTenPerBlack, radius: shadowradious, offset: CGSize.zero, opacity: 1)
        self.maskToBounds = false
        
    }
}
