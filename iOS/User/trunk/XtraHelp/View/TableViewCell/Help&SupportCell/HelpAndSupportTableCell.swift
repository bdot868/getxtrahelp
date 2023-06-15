//
//  HelpAndSupportTableCell.swift
//  XtraHelp
//
//  Created by wm-ioskp on 05/10/21.
//

import UIKit

class HelpAndSupportTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var minAgoLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
}

// MARK: - NibReusable
extension HelpAndSupportTableCell: NibReusable { }

extension UIImageView {

    func makeRounded() {

        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
