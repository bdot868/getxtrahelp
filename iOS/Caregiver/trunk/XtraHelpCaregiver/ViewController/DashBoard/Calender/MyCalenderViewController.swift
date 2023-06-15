//
//  MyCalenderViewController.swift
//  Momentor
//
//  Created by wm-devIOShp on 23/10/21.
//

import UIKit

class MyCalenderViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var calenderView: UIView?
    
    @IBOutlet weak var vwTopSub: UIView?
    @IBOutlet weak var vwTabCalenderMain: UIView?
    @IBOutlet weak var vwTabManuallyMain: UIView?
    @IBOutlet weak var lblTabCalender: UILabel?
    @IBOutlet weak var lblTabManually: UILabel?
    
    @IBOutlet weak var switchOnOff: UISwitch?
    
    @IBOutlet weak var lblTravelHeader: UILabel?
    
    @IBOutlet weak var btnAdd: UIButton?
    
    @IBOutlet weak var tblSession: UITableView?
    @IBOutlet weak var constraintTblSessionHeight: NSLayoutConstraint?
    
    @IBOutlet weak var stackManualyMain: UIStackView?
    @IBOutlet weak var btnWeekly: UIButton?
    @IBOutlet weak var lblWeekly: UILabel?
    @IBOutlet weak var btnMonSat: UIButton?
    @IBOutlet weak var lblMonSat: UILabel?
    
    @IBOutlet weak var lblManualyBottomHeader: UILabel?
    @IBOutlet weak var vwStartDate: ReusableView?
    @IBOutlet weak var vwEndDate: ReusableView?
    
    @IBOutlet weak var vwDeleteAvailibility: UIView?
    
    @IBOutlet weak var btnSetAvailibility: XtraHelpButton?
    
    // MARK: - Variables
    private var CalderHeaderCellViewXib : CalenderView?
    
    private var selectedCalenderTab : Bool = false {
        didSet {
            self.vwTabCalenderMain?.backgroundColor = selectedCalenderTab ? UIColor.CustomColor.whitecolor : UIColor.clear
            self.vwTabManuallyMain?.backgroundColor = selectedCalenderTab ? UIColor.clear : UIColor.CustomColor.whitecolor
            self.lblTabCalender?.textColor = selectedCalenderTab ? UIColor.CustomColor.CalendarTabSelectColor : UIColor.CustomColor.bookedSlotColor
            self.lblTabManually?.textColor = selectedCalenderTab ? UIColor.CustomColor.bookedSlotColor : UIColor.CustomColor.CalendarTabSelectColor
        }
    }
    
    private var selectedDate : [Date] = []
    private var arrAvailibilityDate : [Date] = []
    private var arrAvailibility : [CaregiverAvailabilitySettingModel] = []
    
    private var repeatTyep : String = ""
    
    var isFromLogin : Bool = false
    var isFromEditProfile : Bool = false
    var isFromTabbar : Bool = false
    var selectedUserProfileData : UserProfileModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.addTableviewOberver()
        
        self.CalderHeaderCellViewXib = UINib(nibName: "CalenderView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? CalenderView
        CalderHeaderCellViewXib?.frame = self.calenderView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        //CalderHeaderCellViewXib?.delegate = self
        if let vw = self.CalderHeaderCellViewXib {
            vw.delegate = self
            self.calenderView?.addSubview(vw)
        }
        
        //delay(seconds: 0.1) {
            if self.isFromTabbar {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                //self.getCaregiverAvailabilitySetting()
                //self.btn?.setTitle("Save", for: .normal)
                
            } else {
                self.configureNavigationBar()
            }
       // }
        
        
        if self.isFromEditProfile || self.isFromTabbar {
            self.getCaregiverAvailabilitySetting()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /*if let myswitch = self.switchOnOff {
            myswitch.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: myswitch.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
            myswitch.onTintColor = GradientColor(gradientStyle: .topToBottom, frame: myswitch.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
            myswitch.tintColor = GradientColor(gradientStyle: .topToBottom, frame: myswitch.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
            //myswitch.tintColor = UIColor.lightGray
            myswitch.layer.cornerRadius = 16.0
        }*/
        
        if let btn = self.btnAdd {
            btn.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: btn.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
            btn.maskToBounds = true
            btn.setButtonImageTintColor(UIColor.CustomColor.whitecolor)
            delay(seconds: 0.1, execute: {
                btn.cornerRadius = btn.frame.height / 2
                btn.shadow(UIColor.CustomColor.ButtonShadowColor, radius: 6.0, offset: CGSize(width: 5, height: 3), opacity: 1)
                btn.maskToBounds = false
            })
        }
        
        if let vw = self.vwTopSub {
            vw.cornerRadius = vw.frame.height / 2.0
        }
        
        if let vw = self.vwTabCalenderMain {
            vw.cornerRadius = vw.frame.height / 2.0
        }
        
        if let vw = self.vwTabManuallyMain {
            vw.cornerRadius = vw.frame.height / 2.0
        }
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Init Configure
extension MyCalenderViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTravelHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTravelHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        
        self.lblManualyBottomHeader?.textColor = UIColor.CustomColor.SliderTextColor
        self.lblManualyBottomHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        
        [self.lblWeekly,self.lblMonSat].forEach({
            $0?.textColor = UIColor.CustomColor.SliderTextColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        })
        
        self.tblSession?.register(MyCalenderSessionCell.self)
        self.tblSession?.estimatedRowHeight = 100.0
        self.tblSession?.rowHeight = UITableView.automaticDimension
        self.tblSession?.delegate = self
        self.tblSession?.dataSource = self
        
        /*if let myswitch = self.switchOnOff {
            myswitch.isOn = true
            myswitch.cornerRadius = 16.0
            myswitch.thumbTintColor = UIColor.CustomColor.whitecolor
        }
        
        self.switchOnOff?.isOn = true*/
        
        [self.lblTabCalender,self.lblTabManually].forEach({
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        self.vwTopSub?.backgroundColor = UIColor.CustomColor.CalendarTabBGColor
        
        self.vwStartDate?.reusableViewDelegate = self
        self.vwEndDate?.reusableViewDelegate = self
        self.vwStartDate?.btnSelect.tag = 0
        self.vwEndDate?.btnSelect.tag = 1
        
        self.btnWeekly?.isSelected = true
        self.btnMonSat?.isSelected = false
        
        self.vwDeleteAvailibility?.isHidden = true
        self.selectedCalenderTab = true
        
        
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isShowRightBtn: !self.isFromEditProfile,RightBtnTitle: self.isFromEditProfile ? "" : "Skip",isFromDirect : self.isFromLogin)
        
        self.appNavigationController?.btnNextClickBlock = {
            self.UpdateStatusAvailibilityAPI()
        }
        
        self.title = "Set Availability"
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

extension MyCalenderViewController : ReusableViewDelegate {
    func buttonClicked(_ sender: UIButton) {
        //Start Date
        if sender.tag == 0 {
            self.startTimePicker(sender: sender)
        } else {
            self.endTimeClicked(sender: sender)
        }
    }
    
    func rightButtonClicked(_ sender: UIButton) {
    }
    
    private func startTimePicker(sender : UIButton){
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 10, rounding: .ceil)
        
        
        if !(self.vwStartDate?.txtInput.isEmpty ?? false) {
            selectedDate = (self.vwStartDate?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        }
        
        
        let datePicker = ActionSheetDatePicker(title: "Select Start Time",
                                               datePickerMode: UIDatePicker.Mode.time,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            //let time = (date as? Date ?? selectedDate).getTimeString(inFormate: AppConstant.DateFormat.k_hh_mm_a)
            
            if let selectdate = date as? Date {
                print(selectdate.get12HoursTimeString())
                //let ftime = selectdate.get24HoursTimeString()
                
                //let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                
                /*if !obj.endTime.isEmpty && mainSeletedDate == (obj.endTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                 delay(seconds: 0.3) {
                 self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameFromTime, themeStyle: .warning)
                 }
                 } else*/
                /*if !(self.vwEndDate?.txtInput.isEmpty ?? false) && mainSeletedDate > ((self.vwEndDate?.txtInput.text ?? "").getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                    delay(seconds: 0.3) {
                        self.showMessage(AppConstant.ValidationMessages.kFromTimeGreterThenFromTime, themeStyle: .warning)
                    }
                } else {*/
                    self.vwStartDate?.txtInput.text = selectdate.getFormattedString(format: AppConstant.DateFormat.k_hh_mm_a)
                //}
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 10
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        //datePicker?.minimumDate = Date()
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
    
    private func endTimeClicked(sender : UIButton){
        var selectedDate : Date = Date()
        
        selectedDate = Date().rounded(minutes: 10, rounding: .ceil)
        
        if (self.vwStartDate?.txtInput.isEmpty ?? false) {
            self.showMessage("Please select availibility Start Time", themeStyle: .warning)
            return
        }
        if !(self.vwEndDate?.txtInput.isEmpty ?? false){
            selectedDate = (self.vwEndDate?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select End Time",
                                               datePickerMode: UIDatePicker.Mode.time,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = (date as? Date ?? Date()).getTimeString(inFormate: AppConstant.DateFormat.k_hh_mm_a)
            
            if let selectdate = date as? Date {
                print(selectdate.get12HoursTimeString())
                let ftime = selectdate.get24HoursTimeString()
                //let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                
                /*if !obj.startTime.isEmpty && mainSeletedDate == (obj.startTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                 delay(seconds: 0.3) {
                 self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameFromTime, themeStyle: .warning)
                 }
                 } else if !(self.vwStartDate?.txtInput.isEmpty ?? false) && mainSeletedDate < ((self.vwStartDate?.txtInput.text ?? "").getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                     delay(seconds: 0.3) {
                         self.showMessage(AppConstant.ValidationMessages.kToTimeLessThenFromTime, themeStyle: .warning)
                     }
                 } else {*/
                self.vwEndDate?.txtInput.text = time
                 //}
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 10//self.switchHours.isOn ? 60 : 30
        //datePicker?.countDownDuration = 60
        //datePicker?.minimumDate = Date()
        if !(self.vwStartDate?.txtInput.isEmpty ?? false){
            //datePicker?.minimumDate = minimumSelectDate///(self.vwStartDate?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a).getFormattedString(format: AppConstant.DateFormat.k_hh_mm_a).getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        }
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
}

//MARK: - Tableview Observer
extension MyCalenderViewController : CalenderViewDelegate {
    func didSelectCalenderDate(date: Date) {
        /*self.appNavigationController?.present(AddHoursCalenderPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.selectedDate = date
        })*/
        if !self.selectedCalenderTab {
            
            self.btnWeekly?.isSelected = true
            self.btnMonSat?.isSelected = false
            
            self.selectedDate = [date]
            self.lblWeekly?.text = "Weekly on \(date.getFormattedString(format: AppConstant.DateFormat.k_EEE))"
            print("Weekly on \(date.getFormattedString(format: AppConstant.DateFormat.k_EEE))")
            let day = date.getFormattedString(format: AppConstant.DateFormat.k_EEE)
            switch day {
            case "Sun":
                self.repeatTyep = "7"
            case "Mon":
                self.repeatTyep = "1"
            case "Tue":
                self.repeatTyep = "2"
            case "Wed":
                self.repeatTyep = "3"
            case "Thu":
                self.repeatTyep = "4"
            case "Fri":
                self.repeatTyep = "5"
            case "Sat":
                self.repeatTyep = "6"
            default:
                break
            }
            
            let filter = self.arrAvailibility.filter({$0.date == date.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
            if let first = filter.first {
                self.vwStartDate?.txtInput.text = first.startTime
                self.vwEndDate?.txtInput.text = first.endTime
                self.vwDeleteAvailibility?.isHidden = false
                self.btnSetAvailibility?.setTitle("Update Availability", for: .normal)
                
            } else {
                self.vwStartDate?.txtInput.text = ""
                self.vwEndDate?.txtInput.text = ""
                self.vwDeleteAvailibility?.isHidden = true
                self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
            }
            
        } else {
            if self.arrAvailibilityDate.contains(date) {
                
                self.selectedDate.removeAll()
                self.selectedDate = [date]
                if let vw = self.CalderHeaderCellViewXib {
                    vw.isReloadCalender = true
                    vw.selectedDates = self.selectedDate
                }
                
                let filter = self.arrAvailibility.filter({$0.date == date.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
                if let first = filter.first {
                    self.vwStartDate?.txtInput.text = first.startTime
                    self.vwEndDate?.txtInput.text = first.endTime
                    self.vwDeleteAvailibility?.isHidden = false
                    self.btnSetAvailibility?.setTitle("Update Availability", for: .normal)
                    
                } else {
                    self.vwDeleteAvailibility?.isHidden = true
                    self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
                }
            } else {
                self.vwDeleteAvailibility?.isHidden = true
                //self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
                let maparr = self.arrAvailibility.map({$0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
                let commonarr = self.selectedDate.filter{maparr.contains($0)}
                print(commonarr)
                if commonarr.count > 0 {
                    //self.selectedDate.removeAll({$0.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd) == (date.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd))})
                    
                    if let first = commonarr.first {
                        
                        self.selectedDate.removeAll(where: {$0.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd) == (first.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd))})
                        
                        self.vwStartDate?.txtInput.text = ""
                        self.vwEndDate?.txtInput.text = ""
                        self.vwDeleteAvailibility?.isHidden = true
                        self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
                        
                        if let vw = self.CalderHeaderCellViewXib {
                            vw.isReloadCalender = true
                            vw.selectedDates = self.selectedDate
                        }
                    }
                }
                
            }
        }
    }
    
    func selectMultipleCalenderDate(arr: [Date]) {
        if self.selectedCalenderTab {
            self.selectedDate = arr
            
            print(arr)
        }
    }
    
    func didDeSelectCalenderDate(date: Date) {
        let filter = self.arrAvailibility.filter({$0.date == date.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
        if let first = filter.first {
            self.vwStartDate?.txtInput.text = ""
            self.vwEndDate?.txtInput.text = ""
            self.vwDeleteAvailibility?.isHidden = true
            self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
            
        }
    }
}

//MARK: - Tableview Observer
extension MyCalenderViewController {
    
    private func addTableviewOberver() {
        self.tblSession?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblSession?.observationInfo != nil {
            self.tblSession?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblSession && keyPath == ObserverName.kcontentSize {
                self.constraintTblSessionHeight?.constant = self.tblSession?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension MyCalenderViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: MyCalenderSessionCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - IBAction
extension MyCalenderViewController {
    @IBAction func btnAddClicked(_ sender: UIButton) {
//        self.appNavigationController?.push(AddAvailabilityViewController.self)
    }
    
    @IBAction func btnRemovedAvailibilityClicked(_ sender: UIButton) {
        if let selectfirst = self.selectedDate.first {
            let filter = self.arrAvailibility.filter({$0.date == selectfirst.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
            if let first = filter.first {
                self.showAlert(withTitle: "", with: "Are you sure want to delete this availability?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                    self.deleteAvailability(availabilityid: first.availabilityId)
                }, secondButton: ButtonTitle.No, secondHandler: nil)
            }
        }
    }
    
    @IBAction func btnTabCalenderClicked(_ sender: UIButton) {
        self.selectedCalenderTab = true
        
        
        
        let filter = self.arrAvailibility.filter({$0.date != "0000-00-00" && (($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)) >= Date())})
        //&& $0.type == "1"
        self.selectedDate = filter.map({($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd))})
        self.arrAvailibilityDate = self.selectedDate
        
        if let vw = self.CalderHeaderCellViewXib {
            vw.isReloadCalender = true
            vw.isFromAvailibilityRecurring = false
            vw.selectedDates = []
            //let filter = self.arrAvailibility.filter({})
            vw.arrPrevCaregiverAvailibilityDates = self.arrAvailibilityDate
        }
        
        self.vwStartDate?.txtInput.text = ""
        self.vwEndDate?.txtInput.text = ""
        self.vwDeleteAvailibility?.isHidden = true
        self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
        //self.calenderView?.isHidden = false
        self.stackManualyMain?.isHidden = true
    }
    
    @IBAction func btnTabManuallyClicked(_ sender: UIButton) {
        self.selectedCalenderTab = false
        self.selectedDate = []
        
        
        let filter = self.arrAvailibility.filter({$0.date != "0000-00-00" && (($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)) >= Date())})
        //&& $0.repeatType != "" && $0.type == "2"
        self.selectedDate = filter.map({($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd))})
        self.arrAvailibilityDate = self.selectedDate
        
        if let vw = self.CalderHeaderCellViewXib {
            vw.isReloadCalender = true
            vw.isFromAvailibilityRecurring = true
            vw.selectedDates = []
            vw.arrPrevCaregiverAvailibilityDates = self.arrAvailibilityDate
        }
        
        self.vwStartDate?.txtInput.text = ""
        self.vwEndDate?.txtInput.text = ""
        self.vwDeleteAvailibility?.isHidden = true
        self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
        //self.calenderView?.isHidden = true
        self.stackManualyMain?.isHidden = false
        
        self.btnWeekly?.isSelected = false
        self.btnMonSat?.isSelected = false
    }
    
    @IBAction func switchOnOff(_ sender: UISwitch) {
        sender.backgroundColor = sender.isOn ? GradientColor(gradientStyle: .topToBottom, frame: sender.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom]) : UIColor.CustomColor.black60Per
    }
    
    @IBAction func btnWeeklyClicked(_ sender: UIButton) {
        self.btnWeekly?.isSelected = true
        self.btnMonSat?.isSelected = false
    }
    @IBAction func btnMonSatClicked(_ sender: UIButton) {
        self.btnWeekly?.isSelected = false
        self.btnMonSat?.isSelected = true
    }
    
    @IBAction func btnSetAvailibilityClicked(_ sender: UIButton) {
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        self.SetAvailability()
    }
    
    private func validateFields() -> String? {
         if !self.selectedCalenderTab && self.selectedDate.isEmpty{
            return "Please select availability dates"
        } else if !self.selectedCalenderTab && (!(self.btnWeekly?.isSelected ?? false) && !(self.btnMonSat?.isSelected ?? false)){
            return "Please select recurring availability type"
        } else if self.selectedCalenderTab && self.selectedDate.isEmpty{
            return "Please select availability dates"
        } else if self.vwStartDate?.txtInput.isEmpty ?? false {
            return "Please select availability start time"
        } else if self.vwEndDate?.txtInput.isEmpty ?? false {
            return "Please select availability end time"
        } else {
            return nil
        }
    }
}

// MARK: - API Call
extension MyCalenderViewController {
    private func SetAvailability(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kdates : self.selectedCalenderTab ? self.selectedDate.map({$0.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)}) : [],
                ktype : self.selectedCalenderTab ? "1" : "2",
                krepeatType : self.selectedCalenderTab ? "" : ((self.btnWeekly?.isSelected ?? false) ? self.repeatTyep : "8"),
                kstartTime : self.vwStartDate?.txtInput.text ?? "",
                kendTime : self.vwEndDate?.txtInput.text ?? ""
            ]
            
            
            if !self.isFromEditProfile && !self.isFromTabbar {
                dict[kprofileStatus] = "7"
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserModel.saveCaregiverAvailability(with: param, success: { (msg) in
                //self.showMessage(msg,themeStyle: .success)
                
                self.vwStartDate?.txtInput.text = ""
                self.vwEndDate?.txtInput.text = ""
                self.vwDeleteAvailibility?.isHidden = true
                self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
                
                self.btnWeekly?.isSelected = false
                self.btnMonSat?.isSelected = false
                
                if !self.isFromTabbar {
                    
                    if self.isFromEditProfile {
                        for controller in (self.navigationController?.viewControllers ?? []) as Array {
                            if controller.isKind(of: ProfileViewController.self) {
                                XtraHelp.sharedInstance.isCallReloadProfileData = true
                                self.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    } else {
                        self.appNavigationController?.push(ProfileSuccessViewController.self)
                        //self.UpdateStatusAvailibilityAPI()
                    }
                    
                } else {
                    self.showMessage(msg,themeStyle: .success)
                }
                
                self.getCaregiverAvailabilitySetting()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func getCaregiverAvailabilitySetting(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CaregiverAvailabilitySettingModel.getCaregiverAvailabilitySettingNew(with: param, success: { (arr,msg) in
                
                self.arrAvailibility = arr
                let filter = arr.filter({$0.date != "0000-00-00" && (($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)).removeTimeStampFromDate() >= Date().removeTimeStampFromDate())})
                // && $0.type == "1"
                self.selectedDate = filter.map({($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd))})
                self.arrAvailibilityDate = self.selectedDate
                self.vwStartDate?.txtInput.text = ""
                self.vwEndDate?.txtInput.text = ""
                self.vwDeleteAvailibility?.isHidden = true
                self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
                if let vw = self.CalderHeaderCellViewXib {
                    vw.isReloadCalender = true
                }
                
                if let vw = self.CalderHeaderCellViewXib {
                    vw.arrPrevCaregiverAvailibilityDates = self.selectedDate
                }
                
                /*if let first = self.arrAvailibility.first {
                    self.vwStartDate?.txtInput.text = first.startTime
                    self.vwEndDate?.txtInput.text = first.endTime
                    
                    self.btnWeekly?.isSelected = (first.repeatType == "1")
                    self.btnMonSat?.isSelected = (first.repeatType == "2")
                }*/
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
            })
        }
    }
    
    private func deleteAvailability(availabilityid : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kavailabilityId : availabilityid
            ]
            
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserModel.removeSingleAvailability(with: param, success: { (msg) in
                
                self.arrAvailibility.removeAll(where: {$0.availabilityId == availabilityid})
                self.vwStartDate?.txtInput.text = ""
                self.vwEndDate?.txtInput.text = ""
                self.vwDeleteAvailibility?.isHidden = true
                self.btnSetAvailibility?.setTitle("Set Availability", for: .normal)
                if let vw = self.CalderHeaderCellViewXib {
                    vw.isReloadCalender = true
                }
                if let vw = self.CalderHeaderCellViewXib {
                    vw.arrPrevCaregiverAvailibilityDates = self.arrAvailibility.map({($0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd))})
                }
                //self.showMessage(msg,themeStyle: .success)
                self.getCaregiverAvailabilitySetting()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func UpdateStatusAvailibilityAPI() {
        if let user = UserModel.getCurrentUserFromDefault() {
           
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kprofileStatus : "7"
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserModel.saveSignupProfileDetails(with: param,type: .SetAvailabilityAndUnderReview, success: { (model, msg) in
                self.appNavigationController?.push(ProfileSuccessViewController.self)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension MyCalenderViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.MyCalender
    }
}

// MARK: - AppNavigationControllerInteractable
extension MyCalenderViewController: AppNavigationControllerInteractable { }
