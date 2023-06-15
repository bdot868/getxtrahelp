//
//  MyJobTableCell.swift
//  XtraHelp
//
//  Created by wm-ioskp on 05/10/21.
//

import UIKit

class MyJobTableCell: UITableViewCell {

    @IBOutlet weak var jobNameLbl: UILabel!
    @IBOutlet weak var applicationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
// MARK: - NibReusable
extension MyJobTableCell: NibReusable { }
