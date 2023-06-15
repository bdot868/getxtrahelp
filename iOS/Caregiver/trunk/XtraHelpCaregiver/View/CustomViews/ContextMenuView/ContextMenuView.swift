//
//  ContextMenuView.swift
//  DDD
//
//  Created by Wdev3 on 24/11/20.
//  Copyright © 2020 Wdev3. All rights reserved.
//

import UIKit

enum contentMenuBtn : Int {
    case RescheduleAppointment
    case CancelAppointment
    //case UpgradeCourse
    //case ExitLesson
    
    var name : String {
        switch self {
        case .RescheduleAppointment:
            return "Reschedule Appointment"
        case .CancelAppointment:
            return "Cancel Appointment"
        }
    }
    
    var textColor : UIColor{
        switch self {
        case .RescheduleAppointment:
            return UIColor.CustomColor.forgotColor
        case .CancelAppointment:
            return UIColor.CustomColor.cancelAppointColor
        }
    }
}

class ContextMenuView: UIView {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMainContent: UIView!
   
    @IBOutlet var btnRescheduleAppointment: UIButton!
    @IBOutlet var btnCancelAppointment: UIButton!
    
    @IBOutlet weak var constarintTopVwMainContent: NSLayoutConstraint!
    //MARK: Variables
    var contentView:UIView?
    let nibName = "ContextMenuView"
    
    private var selectedMenu : contentMenuBtn = .RescheduleAppointment
    
    var onBtnClick: ((_ menubtn : contentMenuBtn)-> (Void))?
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.vwMainContent.clipsToBounds = true
        self.vwMainContent.cornerRadius = 10.0
        self.vwMainContent.shadow(UIColor.CustomColor.shadowColorTenPerBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
        self.vwMainContent.maskToBounds = false
    }
    
    private func InitConfig(){
        /*self.btnMenu.forEach({
            $0.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
            $0.setTitleColor(UIColor.CustomColor.labelTextColor, for: .normal)
            $0.setTitle($0.titleLabel?.text?.localized(), for: .normal)
        })*/
        
        [self.btnCancelAppointment,self.btnRescheduleAppointment].forEach({
            $0?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
       
        self.btnRescheduleAppointment.setTitleColor(UIColor.CustomColor.forgotColor, for: .normal)
        self.btnCancelAppointment.setTitleColor(UIColor.CustomColor.cancelAppointColor, for: .normal)
        
        self.vwMainContent.cornerRadius = 10.0
    }
}
// MARK: - IBAction
extension ContextMenuView {
    @IBAction func btnRescheduleAppointmentClicked(_ sender: UIButton) {
        self.removeFromSuperview()
        self.onBtnClick?(contentMenuBtn.RescheduleAppointment)
    }
    @IBAction func btnCancelAppointmentClicked(_ sender: UIButton) {
        self.removeFromSuperview()
        self.onBtnClick?(contentMenuBtn.CancelAppointment)
    }
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    /*@IBAction func btnUpgradeCourseClicked(_ sender: UIButton) {
        self.removeFromSuperview()
        self.onBtnClick?(contentMenuBtn.UpgradeCourse)
    }
    @IBAction func btnExitLessonClicked(_ sender: UIButton) {
        self.removeFromSuperview()
        self.onBtnClick?(contentMenuBtn.ExitLesson)
    }
    */
}
