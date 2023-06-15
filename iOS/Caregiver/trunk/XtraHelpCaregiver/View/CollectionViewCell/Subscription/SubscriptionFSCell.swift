//
//  SubscriptionFSCell.swift
//  LoanX
//
//  Created by APPLE on 04/12/20.
//  Copyright © 2020 wm-devr. All rights reserved.
//

import UIKit
import FSPagerView

class SubscriptionFSCell: FSPagerViewCell {
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var planNameLbl: UILabel!
    @IBOutlet weak var ratePriceLbl: UILabel!
    @IBOutlet var imgSelectedCard: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
