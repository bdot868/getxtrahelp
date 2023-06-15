//
//  WorkExperienceCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 17/11/21.
//

import UIKit

class WorkExperienceCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMainContent: UIView?
    @IBOutlet weak var vwSubContent: UIView?
    
    @IBOutlet weak var lblWorkPlaceHeader: UILabel?
    @IBOutlet weak var lblWorkPlace: UILabel?
    @IBOutlet weak var lblStartDateHeader: UILabel?
    @IBOutlet weak var lblStartDate: UILabel?
    @IBOutlet weak var lblEndDateHeader: UILabel?
    @IBOutlet weak var lblEndDate: UILabel?
    @IBOutlet weak var lblExpDescHeader: UILabel?
    @IBOutlet weak var lblExpDesc: UILabel?
    @IBOutlet weak var lblReasonLeavingHeader: UILabel?
    @IBOutlet weak var lblReasonLeaving: UILabel?

    // MARK: - Variables
    var isFromWorkExperience : Bool = false {
        didSet {
            self.vwSubContent?.backgroundColor = UIColor.clear
            self.vwSubContent?.cornerRadius = 0.0
            self.lblWorkPlace?.text = "Old age care house"
            self.lblStartDate?.text = "11/2019"
            self.lblEndDate?.text = "Current"
            self.lblExpDesc?.text = ""
            self.lblReasonLeaving?.text = "Enviroment"
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        [self.lblWorkPlaceHeader,self.lblStartDateHeader,self.lblEndDateHeader,self.lblExpDescHeader,self.lblReasonLeavingHeader].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblWorkPlace,self.lblStartDate,self.lblEndDate,self.lblExpDesc,self.lblReasonLeaving].forEach({
            $0?.textColor = UIColor.CustomColor.SubscriptuionSubColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        self.vwSubContent?.backgroundColor = UIColor.CustomColor.ExperienceBGColor
        self.vwSubContent?.cornerRadius = 10.0
    }
    
    func setWorkExperienceData(obj : WorkExperienceModel){
        self.lblWorkPlace?.text = obj.workPlace
        self.lblStartDate?.text = obj.startDate//obj.startDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).getTimeString(inFormate: AppConstant.DateFormat.k_MM_dd_yyyy)
        self.lblEndDate?.text = obj.endDate //.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).getTimeString(inFormate: AppConstant.DateFormat.k_MM_dd_yyyy)
        self.lblExpDesc?.text = obj.workDescription
        self.lblReasonLeaving?.text = obj.leavingReason
    }
}

// MARK: - NibReusable
extension WorkExperienceCell: NibReusable{}


