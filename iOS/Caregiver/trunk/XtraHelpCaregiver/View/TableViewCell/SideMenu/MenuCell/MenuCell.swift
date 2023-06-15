//
//  MenuCell.swift
//  Momentor
//
//  Created by Wdev3 on 17/02/21.
//

import UIKit

class MenuCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var imgMenu: UIImageView?
    @IBOutlet weak var lblMenuName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func initConfig(){
        self.lblMenuName?.textColor = UIColor.CustomColor.whitecolor
        self.lblMenuName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - NibReusable
extension MenuCell: NibReusable { }
