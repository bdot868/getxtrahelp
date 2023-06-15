//
//  SepratorView.swift
//  OnixNetwork
//
//  Created by Harshad on 31/08/20.
//  Copyright © 2020 Differenz. All rights reserved.
//

import UIKit

class SepratorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        //self.cornerRadius(4.0)
        self.backgroundColor = UIColor.CustomColor.sepratorcolor
    }
}
