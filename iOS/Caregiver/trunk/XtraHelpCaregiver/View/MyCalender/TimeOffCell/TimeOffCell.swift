//
//  TimeOffCell.swift
//  ChiryDoctor
//
//  Created by wm-devIOShp on 04/10/21.
//

import UIKit

class TimeOffCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwSelectDayMain: UIView?
    @IBOutlet weak var vwDayMain: UIView?
    @IBOutlet weak var vwSelectFromTimeMain: UIView?
    @IBOutlet weak var vwSelectToTimeMain: UIView?
    
    @IBOutlet weak var lblSelectDay: UILabel?
    @IBOutlet weak var lblDay: UILabel?
    @IBOutlet weak var lblSelectFromTime: UILabel?
    @IBOutlet weak var lblSelectToTime: UILabel?
    
    @IBOutlet weak var btnSelectDay: UIButton?
    @IBOutlet weak var btnDay: UIButton?
    @IBOutlet weak var btnSelectFromTime: UIButton?
    @IBOutlet weak var btnSelectToTime: UIButton?
    @IBOutlet weak var btnDelete: UIButton?
    
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
    // MARK: - Init Configure
    private func InitConfig(){
        [self.lblSelectDay,self.lblDay,self.lblSelectFromTime,self.lblSelectToTime].forEach({
            $0?.textColor = UIColor.CustomColor.labelTextColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.vwSelectDayMain,self.vwDayMain,self.vwSelectToTimeMain,self.vwSelectFromTimeMain].forEach({
            $0?.cornerRadius = 10.0
            $0?.borderWidth = 1.0
            $0?.borderColor = UIColor.CustomColor.NavTitleColor
        })
    }
    
    func setData(obj : AvailabilityTimeOffModel){
        self.lblSelectDay?.text = obj.month.DayName
        self.lblDay?.text = obj.day
        self.lblSelectFromTime?.text = obj.startTime
        self.lblSelectToTime?.text = obj.endTime
    }
}

// MARK: - NibReusable
extension TimeOffCell: NibReusable { }
