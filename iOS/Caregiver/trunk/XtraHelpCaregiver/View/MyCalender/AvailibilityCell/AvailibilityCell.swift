//
//  DoctorAvailibilityCell.swift
//  ChiryDoctor
//
//  Created by wm-devIOShp on 04/10/21.
//

import UIKit

class AvailibilityCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwSelectDayMain: UIView?
    @IBOutlet weak var vwSelectFromTimeMain: UIView?
    @IBOutlet weak var vwSelectToTimeMain: UIView?
    
    @IBOutlet weak var lblSelectDay: UILabel?
    @IBOutlet weak var lblSelectFromTime: UILabel?
    @IBOutlet weak var lblSelectToTime: UILabel?
    
    @IBOutlet weak var btnSelectDay: UIButton?
    @IBOutlet weak var btnSelectFromTime: UIButton?
    @IBOutlet weak var btnSelectToTime: UIButton?
    @IBOutlet weak var btnDelete: UIButton?
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
        [self.lblSelectDay,self.lblSelectFromTime,self.lblSelectToTime].forEach({
            $0?.textColor = UIColor.CustomColor.blackColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.vwSelectDayMain,self.vwSelectToTimeMain,self.vwSelectFromTimeMain].forEach({
            $0?.cornerRadius = 10.0
            $0?.borderWidth = 1.0
            $0?.borderColor = UIColor.CustomColor.NavTitleColor
            $0?.backgroundColor = UIColor.CustomColor.whitecolor
        })
    }
    
    func setData(obj : AvailibilitySettingTimeModel){
        
        switch obj.type {
        case .DayOfWeek:
       // case .Monday,.Tuesday,.Wednesday,.Thursday,.Friday,.Saturday:
            self.lblSelectDay?.text = obj.day.DayName
        default:
            self.lblSelectDay?.text = obj.type.DayName
        }
        self.lblSelectFromTime?.text = obj.startTime
        self.lblSelectToTime?.text = obj.endTime
    }
}

// MARK: - NibReusable
extension AvailibilityCell: NibReusable { }

