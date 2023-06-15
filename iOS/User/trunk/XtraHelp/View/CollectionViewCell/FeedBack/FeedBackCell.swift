//
//  FeedBackCell.swift
//  XtraHelp
//
//  Created by wm-ioskp on 18/11/21.
//

import UIKit

class FeedBackCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension FeedBackCell: NibReusable { }
