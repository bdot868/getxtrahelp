//
//  CommentsTableCell.swift
//  XtraHelp
//
//  Created by wm-ioskp on 21/10/21.
//

import UIKit

class CommentsTableCell: UITableViewCell {

    @IBOutlet weak var btnMore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnMore.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension CommentsTableCell: NibReusable { }
