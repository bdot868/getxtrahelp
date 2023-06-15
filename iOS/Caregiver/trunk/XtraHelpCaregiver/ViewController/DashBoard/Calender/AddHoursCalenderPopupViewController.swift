//
//  AddHoursCalenderPopupViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 27/12/21.
//

import UIKit

class AddHoursCalenderPopupViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet weak var lblBottomHeader: UILabel?
    
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwSubBottom: UIView?
    @IBOutlet weak var vwWeeklyMonSatMain: UIView?
    
    @IBOutlet weak var btnClose: UIButton?
    @IBOutlet weak var btnCloseTouch: UIButton?
    
    @IBOutlet weak var stackAddHoursMain: UIStackView?
    
    @IBOutlet var lblTextName: [UILabel]?
    
    @IBOutlet weak var btnRepeat: UIButton?
    @IBOutlet weak var btnWeekly: UIButton?
    @IBOutlet weak var btnMonSat: UIButton?
    
    // MARK: - Variables
    var selectedDate : Date?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.vwSub?.clipsToBounds = true
        self.vwSub?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 0, height: 0), opacity: 1)
        self.vwSub?.maskToBounds = false
    }
}

// MARK: - Init Configure
extension AddHoursCalenderPopupViewController {
    private func InitConfig(){
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblBottomHeader?.textColor = UIColor.CustomColor.SliderTextColor
        self.lblBottomHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        
        //delay(seconds: 0.2) {
        self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        //}
        self.vwSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        self.vwSubBottom?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTextName?.forEach({
            $0.textColor = UIColor.CustomColor.SliderTextColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        })
        
        self.btnWeekly?.isSelected = true
        self.btnRepeat?.isSelected = false
        
        self.btnRepeat?.isSelected = true
        
        if let date = self.selectedDate {
            self.lblHeader?.text = "Set for \(self.convertDateFormate(date: date))"
        }
    }
    
    func convertDateFormate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)

        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM yyyy"
        let newDate = dateFormate.string(from: date)

        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + " " + newDate
    }
}

// MARK: - IBAction
extension AddHoursCalenderPopupViewController {
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRepeatClicked(_ sender: UIButton) {
        self.btnRepeat?.isSelected = !(self.btnRepeat?.isSelected ?? false)
        self.vwWeeklyMonSatMain?.isHidden = !(self.btnRepeat?.isSelected ?? false)
    }
    @IBAction func btnWeeklyClicked(_ sender: UIButton) {
        self.btnWeekly?.isSelected = true
        self.btnMonSat?.isSelected = false
    }
    @IBAction func btnMonSatClicked(_ sender: UIButton) {
        self.btnWeekly?.isSelected = false
        self.btnMonSat?.isSelected = true
    }
}

// MARK: - ViewControllerDescribable
extension AddHoursCalenderPopupViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.MyCalender
    }
}

// MARK: - AppNavigationControllerInteractable
extension AddHoursCalenderPopupViewController: AppNavigationControllerInteractable { }
