//
//  AddAvailabilityViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 17/11/21.
//

import UIKit

enum SelectDayEnum : String{
    case Monday = "1"
    case Tuesday = "2"
    case Wednesday = "3"
    case Thursday = "4"
    case Friday = "5"
    case Saturday = "6"
    case Sunday = "7"
    
    var DayName : String {
        switch self {
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        case .Sunday:
            return "Sunday"
        }
    }
    
    var APIValue : String {
        switch self {
        case .Monday:
            return "1"
        case .Tuesday:
            return "2"
        case .Wednesday:
            return "3"
        case .Thursday:
            return "4"
        case .Friday:
            return "5"
        case .Saturday:
            return "6"
        case .Sunday:
            return "7"
        }
    }
}

enum SelectAvailibilityDay : String{
    case EveryDay = "1"
    case MondaytoSaturday = "2"
    case DayOfWeek = "3"
    case Monday = "4"
    case Tuesday = "5"
    case Wednesday = "6"
    case Thursday = "7"
    case Friday = "8"
    case Saturday = "9"
    case Sunday = "10"
    
    var DayName : String {
        switch self {
        case .EveryDay:
            return "Every Day"
        case .MondaytoSaturday:
            return "Monday to Saturday"
        case .DayOfWeek:
            return "Day Of Week"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        case .Sunday:
            return "Sunday"
        }
    }
    
    var APIValue : String {
        switch self {
        case .EveryDay:
            return "1"
        case .MondaytoSaturday:
            return "2"
        case .DayOfWeek:
            return "3"
        case .Monday:
            return "1"
        case .Tuesday:
            return "2"
        case .Wednesday:
            return "3"
        case .Thursday:
            return "4"
        case .Friday:
            return "5"
        case .Saturday:
            return "6"
        case .Sunday:
            return "7"
        }
    }
}

enum SelectMonthTime : String{
    case January = "1"
    case February = "2"
    case March = "3"
    case April = "4"
    case May = "5"
    case June = "6"
    case July = "7"
    case August = "8"
    case September = "9"
    case October = "10"
    case November = "11"
    case December = "12"
    
    var DayName : String {
        switch self {
        case .January:
            return "January"
        case .February:
            return "February"
        case .March:
            return "March"
        case .April:
            return "April"
        case .May:
            return "May"
        case .June:
            return "June"
        case .July:
            return "July"
        case .August:
            return "August"
        case .September:
            return "September"
        case .October:
            return "October"
        case .November:
            return "November"
        case .December:
            return "December"
        }
    }
    
    var APIValue : String {
        switch self {
        case .January:
            return "1"
        case .February:
            return "2"
        case .March:
            return "3"
        case .April:
            return "4"
        case .May:
            return "5"
        case .June:
            return "6"
        case .July:
            return "7"
        case .August:
            return "8"
        case .September:
            return "9"
        case .October:
            return "10"
        case .November:
            return "11"
        case .December:
            return "12"
        }
    }
}

enum TimingEnum : String {
    case HalfHours = "30"
    case OneHours = "60"
}


class AddAvailabilityViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var vwMainContent: UIView!
    
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet weak var lblMinuteHeader: UILabel!
    @IBOutlet weak var lblHourHeader: UILabel!
    
    @IBOutlet weak var switchHours: UISwitch!
    
    @IBOutlet weak var lblAvilibilityWindowHeader: UILabel?
    @IBOutlet weak var lblAvilibilityFromHeader: UILabel?
    @IBOutlet weak var lblAvilibilityToHeader: UILabel?
    @IBOutlet weak var lblAddHourHeader: UILabel?
    @IBOutlet weak var btnAddHour: UIButton?
    @IBOutlet weak var lblTimeOffHeader: UILabel?
    @IBOutlet weak var lblAddTimeOffHeader: UILabel?
    @IBOutlet weak var btnAddTimeOff: UIButton?
    
    @IBOutlet weak var tblAvailibility: UITableView?
    @IBOutlet weak var tblTimeOff: UITableView?
    
    @IBOutlet weak var constarintTblAvailibilityHeight: NSLayoutConstraint?
    @IBOutlet weak var constarintTblTimeOffHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwHeaderMain: UIView?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    
    @IBOutlet weak var vwSaveNextMain: UIView?
    
    // MARK: - Variables
    private var arrSelectedDays : [SelectAvailibilityDay] = [.EveryDay,.MondaytoSaturday,.Monday,.Tuesday,.Wednesday,.Thursday,.Friday,.Saturday,.Sunday]
    private var arrTimeMonth : [SelectMonthTime] = [.January,.February,.March,.April,.May,.June,.July,.August,.September,.October,.November,.December]
    private var arrDay : [Int] = []
    
    //private var selectedMonth : SelectMonthTime?
    
    private var arrAvailibility : [AvailibilitySettingTimeModel] = []
    private var arrTimeOff : [AvailabilityTimeOffModel] = []
    var isFromLogin : Bool = false
    
    var isFromEditProfile : Bool = false
    var selectedUserProfileData : UserProfileModel?
    var isFromTabbar : Bool = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addTableviewOberver()
        if self.isFromTabbar {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.getCaregiverAvailabilitySetting()
            self.btnSubmit?.setTitle("Save", for: .normal)
        } else {
            self.configureNavigationBar()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /*if let myswitch = self.switchHours {
            myswitch.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: myswitch.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            myswitch.onTintColor = GradientColor(gradientStyle: .topToBottom, frame: myswitch.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            myswitch.tintColor = GradientColor(gradientStyle: .topToBottom, frame: myswitch.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            //myswitch.tintColor = UIColor.lightGray
            myswitch.layer.cornerRadius = 16.0
        }*/
    }
    
}
// MARK: - Init Configure
extension AddAvailabilityViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor

        [self.lblHourHeader,self.lblMinuteHeader].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))
        })
        
        [self.lblAvilibilityToHeader,self.lblAvilibilityFromHeader,self.lblAvilibilityWindowHeader,self.lblTimeOffHeader].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.lblAddHourHeader,self.lblAddTimeOffHeader].forEach({
            $0?.textColor = UIColor.CustomColor.appColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
       /* if let myswitch = self.switchHours {
            myswitch.isOn = true
            myswitch.cornerRadius = 16.0
            myswitch.thumbTintColor = UIColor.CustomColor.whitecolor
        }
        
        self.switchHours?.isOn = true*/
        self.vwSaveNextMain?.isHidden = !self.isFromEditProfile
        self.btnSubmit?.setTitle(self.isFromEditProfile ? "Save" : "Next", for: .normal)
        
        [self.tblAvailibility,self.tblTimeOff].forEach({
            $0?.estimatedRowHeight = 60.0
            $0?.rowHeight = UITableView.automaticDimension
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        self.tblAvailibility?.register(AvailibilityCell.self)
        self.tblTimeOff?.register(TimeOffCell.self)
        
        self.vwHeaderMain?.isHidden = !self.isFromTabbar
        
        if self.isFromEditProfile || self.isFromTabbar {
            self.getCaregiverAvailabilitySetting()
        }
        
        
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isShowRightBtn: true,RightBtnTitle: self.isFromEditProfile ? "" : "Skip",isFromDirect : self.isFromLogin)
        
        self.appNavigationController?.btnNextClickBlock = {
            self.SaveDoctorAvailibilityAPI(isSave: false)
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - UISwitch Action
extension AddAvailabilityViewController {
    @IBAction func switchHours(_ sender: UISwitch) {
        
       // if self.selectedAvilbilityIndex >= 0 {
            //let obj = self.arrDate[selectedAvilbilityIndex]
            
           // obj.timing = sender.isOn ? .OneHours : .HalfHours
            
       // }
    }
}

// MARK: - IBAction
extension AddAvailabilityViewController {
    @IBAction func btnSaveAvailability(_ sender: UIButton) {
        //self.appNavigationController?.push(ProfileSuccessViewController.self)
        
        if self.isFromEditProfile {
            self.SaveDoctorAvailibilityAPI(isSave: true)
        } else {
            self.SaveDoctorAvailibilityAPI(isSave: false)
        }
    }
    
    @IBAction func btnSaveNextClicked(_ sender: UIButton) {
        
        self.SaveDoctorAvailibilityAPI(isSave: false)
    }
    
    @IBAction func btnAddTimeOffClicked(_ sender: UIButton) {
        //if let user = UserModel.getCurrentUserFromDefault() {
        if self.arrAvailibility.count > 0 {
            let filterMonth = self.arrTimeOff.filter({$0.month.DayName.isEmpty})
            let filterDay = self.arrTimeOff.filter({$0.day.isEmpty})
            let filterFromTime = self.arrTimeOff.filter({$0.startTime.isEmpty})
            let filterToTime = self.arrTimeOff.filter({$0.endTime.isEmpty})
            if filterMonth.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmptyTimeOffMonth, themeStyle: .warning)
            } else if filterDay.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmptyTimeOffDay, themeStyle: .warning)
            } else if filterFromTime.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmptyTimeOffFromTime, themeStyle: .warning)
            } else if filterToTime.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmptyTimeOffToTime, themeStyle: .warning)
            } else {
                let obj = AvailabilityTimeOffModel.init(useravailabilityOfftimeId: "", userid: "", Day: "1", Month: .January, starttime: "", endtime: "")
                self.arrTimeOff.append(obj)
                self.tblTimeOff?.reloadData()
            }
        } else {
            let obj = AvailabilityTimeOffModel.init(useravailabilityOfftimeId: "", userid: "", Day: "1", Month: .January, starttime: "", endtime: "")
            self.arrTimeOff.append(obj)
            self.tblTimeOff?.reloadData()
        }
    }
    
    @IBAction func btnAddHourClicked(_ sender: UIButton) {
        //if let user = UserModel.getCurrentUserFromDefault() {
        if self.arrAvailibility.count > 0 {
            let filterWindow = self.arrAvailibility.filter({$0.day.DayName.isEmpty})
            let filterFromTime = self.arrAvailibility.filter({$0.startTime.isEmpty})
            let filterToTime = self.arrAvailibility.filter({$0.endTime.isEmpty})
            if filterWindow.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmptyAvailibilityWindow, themeStyle: .warning)
            } else if filterFromTime.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmprtAvailibilityFromTime, themeStyle: .warning)
            } else if filterToTime.count > 0 {
                self.showMessage(AppConstant.ValidationMessages.kEmprtAvailibilityToTime, themeStyle: .warning)
            } else {
                //let obj = AvailibilitySettingTimeModel.init(availibilitysettingid: "", userid: "", availibilitytype: .EveryDay, daytype: .Monday, timingtype: self.switchHours.isOn ? .OneHours : .HalfHours, starttime: "", endtime: "")
                let obj = AvailibilitySettingTimeModel.init(availibilitysettingid: "", userid: "", availibilitytype: .EveryDay, daytype: .Monday, timingtype: .OneHours, starttime: "", endtime: "")
                self.arrAvailibility.append(obj)
                self.tblAvailibility?.reloadData()
            }
        } else {
            let obj = AvailibilitySettingTimeModel.init(availibilitysettingid: "", userid: "", availibilitytype: .EveryDay, daytype: .Monday, timingtype: .OneHours, starttime: "", endtime: "")
            self.arrAvailibility.append(obj)
            self.tblAvailibility?.reloadData()
        }
    }
}

//MARK: - Tableview Observer
extension AddAvailabilityViewController {
    
    private func addTableviewOberver() {
        self.tblAvailibility?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblTimeOff?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblAvailibility?.observationInfo != nil {
            self.tblAvailibility?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.tblTimeOff?.observationInfo != nil {
            self.tblTimeOff?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblAvailibility && keyPath == ObserverName.kcontentSize {
                self.constarintTblAvailibilityHeight?.constant = self.tblAvailibility?.contentSize.height ?? 0.0
            }
            
            if obj == self.tblTimeOff && keyPath == ObserverName.kcontentSize {
                self.constarintTblTimeOffHeight?.constant = self.tblTimeOff?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension AddAvailabilityViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblAvailibility {
            return self.arrAvailibility.count
        }
        return self.arrTimeOff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblAvailibility {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: AvailibilityCell.self)
            if self.arrAvailibility.count > 0 {
                let obj = self.arrAvailibility[indexPath.row]
                cell.setData(obj: obj)
                
                cell.btnSelectDay?.tag = indexPath.row
                cell.btnSelectDay?.addTarget(self, action: #selector(self.btnSelectDayAvailibilityClicked(_:)), for: .touchUpInside)
                
                cell.btnSelectFromTime?.tag = indexPath.row
                cell.btnSelectFromTime?.addTarget(self, action: #selector(self.btnFromTimeAvailibilityClicked(_:)), for: .touchUpInside)
                
                cell.btnSelectToTime?.tag = indexPath.row
                cell.btnSelectToTime?.addTarget(self, action: #selector(self.btnToTimeAvailibilityClicked(_:)), for: .touchUpInside)
                
                cell.btnDelete?.tag = indexPath.row
                cell.btnDelete?.addTarget(self, action: #selector(self.btnDeleteAvailibilityClicked(_:)), for: .touchUpInside)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, with: TimeOffCell.self)
        if self.arrTimeOff.count > 0 {
            let obj = self.arrTimeOff[indexPath.row]
            cell.setData(obj: obj)
            cell.btnSelectDay?.tag = indexPath.row
            cell.btnSelectDay?.addTarget(self, action: #selector(self.btnSelectMonthAddHourTimeClicked(_:)), for: .touchUpInside)
            
            cell.btnDay?.tag = indexPath.row
            cell.btnDay?.addTarget(self, action: #selector(self.btnSelectDayAddHourTimeClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectFromTime?.tag = indexPath.row
            cell.btnSelectFromTime?.addTarget(self, action: #selector(self.btnFromTimeTimeOFFClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectToTime?.tag = indexPath.row
            cell.btnSelectToTime?.addTarget(self, action: #selector(self.btnToTimeTimeOFFClicked(_:)), for: .touchUpInside)
            
            cell.btnDelete?.tag = indexPath.row
            cell.btnDelete?.addTarget(self, action: #selector(self.btnDeleteTimeOFFClicked(_:)), for: .touchUpInside)
        }
        return cell
        
    }
    @objc func btnDeleteTimeOFFClicked(_ sender : UIButton){
        if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
            self.arrTimeOff.remove(at: sender.tag)
            self.tblTimeOff?.reloadData()
        }
    }
    
    @objc func btnDeleteAvailibilityClicked(_ sender : UIButton){
        if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
            self.arrAvailibility.remove(at: sender.tag)
            self.tblAvailibility?.reloadData()
        }
    }
    
    @objc func btnFromTimeTimeOFFClicked(_ sender : UIButton){
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
            let obj = self.arrTimeOff[sender.tag]
            if obj.startTime != "" {
                selectedDate = obj.startTime.getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select From Time",
                                               datePickerMode: UIDatePicker.Mode.time,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = (date as? Date ?? Date()).getTimeString(inFormate: AppConstant.DateFormat.k_hh_mm_a)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.startTime = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
        
            if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
                let obj = self.arrTimeOff[sender.tag]
                if let selectdate = date as? Date {
                    print(selectdate.get12HoursTimeString())
                    let ftime = selectdate.get24HoursTimeString()
                    
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    /*if !obj.endTime.isEmpty && mainSeletedDate == (obj.endTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameFromTime, themeStyle: .warning)
                        }
                    } else*/ if !obj.endTime.isEmpty && mainSeletedDate > (obj.endTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kFromTimeGreterThenFromTime, themeStyle: .warning)
                        }
                    } else {
                        obj.startTime = time
                        self.tblTimeOff?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                    }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 30
        //datePicker?.minimumDate = Date()
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
    
    @objc func btnToTimeTimeOFFClicked(_ sender : UIButton){
        
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
            let obj = self.arrTimeOff[sender.tag]
            if obj.startTime.isEmpty {
                self.showMessage(AppConstant.ValidationMessages.kEmprtAvailibilityFromTime, themeStyle: .warning)
                return
            }
            if obj.endTime != "" {
                selectedDate = obj.endTime.getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select To Time",
                                               datePickerMode: UIDatePicker.Mode.time,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = (date as? Date ?? Date()).getTimeString(inFormate: AppConstant.DateFormat.k_hh_mm_a)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.endTime = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
            
            if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
                let obj = self.arrTimeOff[sender.tag]
                if let selectdate = date as? Date {
                    print(selectdate.get12HoursTimeString())
                    let ftime = selectdate.get24HoursTimeString()
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    /*if !obj.startTime.isEmpty && mainSeletedDate == (obj.startTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameFromTime, themeStyle: .warning)
                        }
                    } else*/ if !obj.startTime.isEmpty && mainSeletedDate < (obj.startTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kToTimeLessThenFromTime, themeStyle: .warning)
                        }
                    } else {
                        obj.endTime = time
                        self.tblTimeOff?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                    }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 30//self.switchHours.isOn ? 60 : 30
        //datePicker?.countDownDuration = 60
        //datePicker?.minimumDate = Date()
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
    
    @objc func btnSelectMonthAddHourTimeClicked(_ sender : UIButton){
        print("jgjhgj")
        let arr = self.arrTimeMonth.map({$0.DayName})
        var selecetdIndex : Int = 0
        for i in stride(from: 0, to: arr.count, by: 1){
            let obj = arr[i]
            if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
                if obj == self.arrTimeOff[sender.tag].month.DayName {
                    selecetdIndex = i
                    break
                }
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Select Month", rows: arr, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            //self.selectedGender = self.arrGender[indexes]
            //self.vwPIGender.txtField.text = self.selectedGender.name
            let selectedMonth = self.arrTimeMonth[indexes]
            //if let month = selectedMonth {
                let year = Calendar.current.component(.year, from: Date())
                let dateComponents = DateComponents(year: year, month: Int(selectedMonth.APIValue) ?? 0)
                let calendar = Calendar.current
                if let date = calendar.date(from: dateComponents) {
                    
                    if let range = calendar.range(of: .day, in: .month, for: date) {
                        let numDays = range.count
                        print(numDays)
                        
                        if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
                            self.arrDay = self.getMonthArrayFromNumber(number: numDays)
                            let obj = self.arrTimeOff[sender.tag]
                            obj.month = selectedMonth
                            if (Int(obj.day) ?? 0) > self.arrDay.count {
                                obj.day = "1"
                            }
                            self.tblTimeOff?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                        }
                    }
                }
            //}
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
    
    @objc func btnSelectDayAddHourTimeClicked(_ sender : UIButton){
        
        //let arr = self.arrTimeMonth.map({$0.DayName})
        var selecetdIndex : Int = 0
        
        if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
            let obj = self.arrTimeOff[sender.tag]
            
            let year = Calendar.current.component(.year, from: Date())
            let dateComponents = DateComponents(year: year, month: Int(obj.month.APIValue) ?? 0)
            let calendar = Calendar.current
            if let date = calendar.date(from: dateComponents) {
                
                if let range = calendar.range(of: .day, in: .month, for: date) {
                    let numDays = range.count
                    print(numDays)
                    self.arrDay = self.getMonthArrayFromNumber(number: numDays)
                }
            }
        }
        
        for i in stride(from: 0, to: self.arrDay.count, by: 1){
            let obj = self.arrDay[i]
            
            if self.arrTimeOff.count > 0 && sender.tag <= self.arrTimeOff.count {
                if "\(obj)" == self.arrTimeOff[sender.tag].day {
                    selecetdIndex = i
                    break
                }
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Select Day", rows: self.arrDay, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            //self.selectedGender = self.arrGender[indexes]
            //self.vwPIGender.txtField.text = self.selectedGender.name
            let selectedDay = self.arrDay[indexes]
            //if let month = selectedMonth {
                
            if self.arrDay.count > 0 && sender.tag <= self.arrDay.count {
                
                let obj = self.arrTimeOff[sender.tag]
                obj.day = "\(selectedDay)"
                self.tblTimeOff?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }
                    
            //}
            
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
    
    private func getMonthArrayFromNumber(number : Int) -> [Int]{
        var arr : [Int] = []
        for i in stride(from: 0, to: number, by: 1) {
            arr.append(i + 1)
            if i == number - 1 {
                return arr
            }
        }
        return []
    }
    
    @objc func btnSelectDayAvailibilityClicked(_ sender : UIButton){
        let arr = self.arrSelectedDays.map({$0.DayName})
        var selecetdIndex : Int = 0
        for i in stride(from: 0, to: arr.count, by: 1){
            if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                switch obj.type{
                case .DayOfWeek:
                    if "\(arr[i])" == obj.day.DayName {
                        selecetdIndex = i
                        break
                    }
                default:
                    if "\(arr[i])" == obj.type.DayName {
                        selecetdIndex = i
                        break
                    }
                }
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Select Availibility Window", rows: arr, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            if self.arrSelectedDays.count > 0 && indexes <= self.arrSelectedDays.count {
                let selectedDay = self.arrSelectedDays[indexes]
                
                if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                    let obj = self.arrAvailibility[sender.tag]
                    obj.type = selectedDay
                    switch selectedDay {
                    case .Monday,.Tuesday,.Wednesday,.Thursday,.Friday,.Saturday,.Sunday:
                        obj.type = .DayOfWeek
                        obj.day = SelectDayEnum(rawValue: selectedDay.APIValue) ?? .Monday
                        //print(obj.day.DayName)
                    default:
                        break
                    }
                    self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                }
            }
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
    
    @objc func btnFromTimeAvailibilityClicked(_ sender : UIButton){
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        
        if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
            let obj = self.arrAvailibility[sender.tag]
            if obj.startTime != "" {
                selectedDate = obj.startTime.getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select From Time",
                                               datePickerMode: UIDatePicker.Mode.time,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = (date as? Date ?? selectedDate).getTimeString(inFormate: AppConstant.DateFormat.k_hh_mm_a)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.startTime = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
        
            if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                if let selectdate = date as? Date {
                    print(selectdate.get12HoursTimeString())
                    let ftime = selectdate.get24HoursTimeString()
                    
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    /*if !obj.endTime.isEmpty && mainSeletedDate == (obj.endTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameFromTime, themeStyle: .warning)
                        }
                    } else*/ if !obj.endTime.isEmpty && mainSeletedDate > (obj.endTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kFromTimeGreterThenFromTime, themeStyle: .warning)
                        }
                    } else {
                        obj.startTime = time
                        self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                    }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 30
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        //datePicker?.minimumDate = Date()
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
    
    @objc func btnToTimeAvailibilityClicked(_ sender : UIButton){
        
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
            let obj = self.arrAvailibility[sender.tag]
            if obj.startTime.isEmpty {
                self.showMessage(AppConstant.ValidationMessages.kEmprtAvailibilityFromTime, themeStyle: .warning)
                return
            }
            if obj.endTime != "" {
                selectedDate = obj.endTime.getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
            }
            //selectedDate = obj.endTime.getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select To Time",
                                               datePickerMode: UIDatePicker.Mode.time,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = (date as? Date ?? Date()).getTimeString(inFormate: AppConstant.DateFormat.k_hh_mm_a)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.endTime = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
            
            if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                if let selectdate = date as? Date {
                    print(selectdate.get12HoursTimeString())
                    let ftime = selectdate.get24HoursTimeString()
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    /*if !obj.startTime.isEmpty && mainSeletedDate == (obj.startTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameFromTime, themeStyle: .warning)
                        }
                    } else*/ if !obj.startTime.isEmpty && mainSeletedDate < (obj.startTime.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kToTimeLessThenFromTime, themeStyle: .warning)
                        }
                    } else {
                        obj.endTime = time
                        self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                    }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 30
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        //datePicker?.minimumDate = Date()
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
}

//MARK:- API Calling
extension AddAvailabilityViewController {
    
    /*func SaveDoctorAvailibilityAPI() {
        if let user = UserModel.getCurrentUserFromDefault() {
            var datesarr : [[String:Any]] = []
            for i in stride(from: 0, to: self.arrDate.count, by: 1){
                let objdate = self.arrDate[i]
                let filter = objdate.arrTimes.filter({$0.selectedTime})
                if filter.count > 0 {
                    
                    let dict : [String:Any] =
                        [ktiming : objdate.timing.rawValue,
                         kdate : objdate.availibilityDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).getFormattedString(format: AppConstant.DateFormat.k_dd_MM_yyyy),
                         kslots : filter.map({$0.availibilityTime})]
                    datesarr.append(dict)
                }
            }
            print(datesarr.count)
            let dict : [String:Any] = [
                klangType : Chiry.sharedInstance.languageType,
                ktoken : user.token,
                kavailability : datesarr
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            AvailibilityDateModel.SaveDoctorAvailibility(with: param) { (sucess, msg) in
                self.showMessage(msg, themeStyle: .success)
                if let user = UserModel.getCurrentUserFromDefault() {
                    user.profileStatus = "1"
                    user.saveCurrentUserInDefault()
                    self.delegate?.addAvailibility()
                    self.appNavigationController?.popViewController(animated: true)
                }
                
            } failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(errorType.rawValue, themeStyle: .error)
                }
            }
        }
    }*/
    
    func SaveDoctorAvailibilityAPI(isSave : Bool = true) {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var availibility : [[String:Any]] = []
            for i in stride(from: 0, to: self.arrAvailibility.count, by: 1){
                let obj = self.arrAvailibility[i]
                if !obj.type.DayName.isEmpty && !obj.startTime.isEmpty && !obj.endTime.isEmpty {
                    var dic : [String:Any] = [
                        ktype : obj.type.APIValue,
                        kstartTime : obj.startTime,
                        kendTime : obj.endTime
                    ]
                    switch obj.type {
                    case .DayOfWeek:
                        dic[kday] = obj.day.APIValue
                    default:
                        break
                    }
                    availibility.append(dic)
                }
            }
            
            var timeoff : [[String:Any]] = []
            for i in stride(from: 0, to: self.arrTimeOff.count, by: 1){
                let obj = self.arrTimeOff[i]
                if !obj.day.isEmpty && !obj.startTime.isEmpty && !obj.endTime.isEmpty && !obj.month.DayName.isEmpty {
                    let dic : [String:Any] = [
                        kday : obj.day,
                        kmonth : obj.month.APIValue,
                        kstartTime : obj.startTime,
                        kendTime : obj.endTime
                    ]
                    timeoff.append(dic)
                }
            }
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kavailability : availibility,
                //kprofileStatus : "7",
                //ktiming : self.switchHours.isOn ? TimingEnum.OneHours.rawValue : TimingEnum.HalfHours.rawValue,
                koffDateTime : timeoff
            ]
            
            if !self.isFromEditProfile {
                dict[kprofileStatus] = "7"
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserModel.saveSignupProfileDetails(with: param,type: .SetAvailabilityAndUnderReview, success: { (model, msg) in
                if !self.isFromTabbar {
                    
                    if self.isFromEditProfile || isSave {
                        for controller in (self.navigationController?.viewControllers ?? []) as Array {
                            if controller.isKind(of: ProfileViewController.self) {
                                XtraHelp.sharedInstance.isCallReloadProfileData = true
                                self.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    } else {
                        self.appNavigationController?.push(ProfileSuccessViewController.self,animated: false) { vc in
                        }
                    }
                    
                } else {
                    self.showMessage(msg,themeStyle: .success)
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
            
           /* AvailibilitySettingTimeModel.saveDoctorAvailabilitySetting(with: param) { (sucess, msg) in
                self.showMessage(msg, themeStyle: .success)
                if let user = UserModel.getCurrentUserFromDefault() {
                    user.profileStatus = "1"
                    user.saveCurrentUserInDefault()
                    self.delegate?.addAvailibility()
                    self.appNavigationController?.popViewController(animated: true)
                }
            } failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(errorType.rawValue, themeStyle: .error)
                }
            }*/
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
            
            UserModel.getCaregiverAvailabilitySetting(with: param, success:  { (arravailiblity,arrtimeoff) in
                self.arrAvailibility = arravailiblity
                self.tblAvailibility?.reloadData()
                delay(seconds: 0.2) {
                    self.arrTimeOff = arrtimeoff
                    self.tblTimeOff?.reloadData()
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                
               // if !error.isEmpty {
                    //self.showMessage(error, themeStyle: .error)
                    //self.appNavigationController?.popViewController(animated: true)
               // }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension AddAvailabilityViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension AddAvailabilityViewController: AppNavigationControllerInteractable { }
