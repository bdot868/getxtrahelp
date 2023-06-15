//
//  BlurView.swift
//  Momentor
//
//  Created by wmdevios-h on 14/08/21.
//

import Foundation
import UIKit

class BlurView: UIView {
    
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
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear//UIColor.white//.withAlphaComponent(0.2)

            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.6
            //blurEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = .black
        }
    }
}
