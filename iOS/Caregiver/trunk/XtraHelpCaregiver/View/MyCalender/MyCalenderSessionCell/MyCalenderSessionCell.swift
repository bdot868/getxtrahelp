//
//  MyCalenderSessionCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 23/10/21.
//

import UIKit

class MyCalenderSessionCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwDateMain: UIView?
    @IBOutlet weak var vwSessionDataMain: UIView?

    @IBOutlet weak var lblSessionType: UILabel?
    @IBOutlet weak var lblSessionName: UILabel?
    @IBOutlet weak var lblSessionDate: UILabel?
    @IBOutlet weak var lblSessionTime: UILabel?

    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        self.lblSessionType?.textColor = UIColor.CustomColor.NavTitleColor
        self.lblSessionType?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblSessionName?.textColor = UIColor.CustomColor.blackColor
        self.lblSessionName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblSessionTime?.textColor = UIColor.CustomColor.NavTitleColor
        self.lblSessionTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblSessionDate?.setSessionDateAttributedTextLable(firstText: "July\n", SecondText: "15")
        
        self.vwSessionDataMain?.cornerRadius = 10.0
        self.vwSessionDataMain?.backgroundColor = #colorLiteral(red: 0.8117647059, green: 0.9254901961, blue: 1, alpha: 1)
    }
}

// MARK: - NibReusable
extension MyCalenderSessionCell: NibReusable{}
