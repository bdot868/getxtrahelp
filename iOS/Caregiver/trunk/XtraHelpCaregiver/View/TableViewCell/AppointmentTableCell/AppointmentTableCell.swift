//
//  AppointmentTableCell.swift
//  Chiry
//
//  Created by Wdev3 on 23/02/21.
//

import UIKit

class AppointmentTableCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblAppoitmentStatus: UILabel!
    @IBOutlet weak var lblAppointmentTime: UILabel!
    @IBOutlet weak var vwMainContent: UIView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet var btnNotes: UIButton!
    
    // MARK: - Variables
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.imgUser.roundedCornerRadius()
        
        self.vwMainContent.clipsToBounds = true
        self.vwMainContent.cornerRadius = 10.0
        self.vwMainContent.shadow(UIColor.CustomColor.AcceptLabelTextColor, radius: 2.0, offset: CGSize(width: 1, height: 1), opacity: 0.2)
        self.vwMainContent.maskToBounds = false
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
        
        self.lblDoctorName.textColor = UIColor.CustomColor.AppointmentTExtColor
        self.lblDoctorName.font = UIFont.RubikBold(ofSize: GetAppFontSize(size: 13.0))
        
        self.lblAppoitmentStatus.textColor = UIColor.CustomColor.SuccessStaus
        self.lblAppoitmentStatus.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 9.0))
        
        self.lblAppointmentTime.textColor = UIColor.CustomColor.AppointmentTExtColor
        self.lblAppointmentTime.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 11.0))
        
        /*self.vwMainContent.clipsToBounds = true
         self.vwMainContent.backgroundColor = UIColor.CustomColor.whitecolor
         self.vwMainContent.cornerRadius = 10.0
         self.vwMainContent.shadow(UIColor.CustomColor.appoitmentShadowColor, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1.0)
         self.vwMainContent.maskToBounds = false*/
        
    }
    
  
}

// MARK: - NibReusable
extension AppointmentTableCell: NibReusable { }
