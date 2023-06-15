//
//  AddWorkExperienceViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 17/11/21.
//

import UIKit
import ActionSheetPicker_3_0

protocol AddWorkExperienceDelegate {
    func addWorkExperinec(obj : WorkExperienceModel)
}

enum AddWorkPlaceEnum : Int{
    case StartDate
    case EndDate
}

class AddWorkExperienceViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwSubBottom: UIView?
    
    @IBOutlet weak var btnAddExerience: XtraHelpButton?
    @IBOutlet weak var btnClose: UIButton?
    @IBOutlet weak var btnCloseTouch: UIButton?
    
    @IBOutlet weak var vwWorkPlace: ReusableView?
    @IBOutlet weak var vwStartDate: ReusableView?
    @IBOutlet weak var vwEndDate: ReusableView?
    @IBOutlet weak var vwReasonLeaving: ReusableView?
    @IBOutlet weak var vwWorkDesc: ReusableTextview?
    // MARK: - Variables
    var delegate : AddWorkExperienceDelegate?
    private var selectedStartDate : Date?
    private var selectedEndDate : Date?
    
    private var arrMonth : [String] = []
    private var arrYear : [String] = []
    private var selectedStartMonth : String = ""
    private var selectedStartYear : String = ""
    private var selectedEndMonth : String = ""
    private var selectedEndYear : String = ""
    
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
        self.vwSub?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: -4, height: -5), opacity: 1)
        self.vwSub?.maskToBounds = false
    }
}

// MARK: - Init Configure
extension AddWorkExperienceViewController {
    private func InitConfig(){
        
        self.arrMonth = XtraHelp.sharedInstance.getMonthBetween(from: "01-01-1990".getDateFromString(format: AppConstant.DateFormat.k_dd_MM_yyyy), to: "31-12-1990".getDateFromString(format: AppConstant.DateFormat.k_dd_MM_yyyy))
        self.arrYear = XtraHelp.sharedInstance.getYearBetween(from: "01-01-1990".getDateFromString(format: AppConstant.DateFormat.k_dd_MM_yyyy), to: Date())
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        //delay(seconds: 0.2) {
            self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        //}
        
        self.vwSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        self.vwSubBottom?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        [self.vwStartDate,self.vwEndDate].forEach({
            $0?.reusableViewDelegate = self
        })
        self.vwStartDate?.btnSelect.tag = AddWorkPlaceEnum.StartDate.rawValue
        self.vwEndDate?.btnSelect.tag = AddWorkPlaceEnum.EndDate.rawValue
        
        self.vwReasonLeaving?.txtInput.delegate = self
    }
}

// MARK: - ReusableViewDelegate
extension AddWorkExperienceViewController:ReusableViewDelegate{
    func buttonClicked(_ sender: UIButton) {
        switch AddWorkPlaceEnum.init(rawValue: sender.tag) ?? .StartDate  {
        case .StartDate:
            self.btnStartDateClicked(sender)
        case .EndDate:
            self.btnEndDateClicked(sender)
        }
    }
    
    func rightButtonClicked(_ sender: UIButton) {
    }
    
    @objc func btnStartDateClicked(_ sender : UIButton){
        //var selectedDate : Date = Date()
        //selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        //if self.arrData.count > 0 && sender.tag <= self.arrData.count {
           // let obj = self.arrData[sender.tag]
        var selctedMonth : Int = (Date().getMonthFromDate()) - 1
        selctedMonth = (selctedMonth > 0) ? selctedMonth : 0
        var selctedYear : Int = self.arrYear.count - 1
        if (self.vwStartDate?.txtInput.text ?? "") != "" {
           /* if let date = self.selectedStartDate {
                selectedDate = date.removeTimeStampFromDate()
            }*/
            for i in stride(from: 0, to: self.arrMonth.count, by: 1) {
                if self.arrMonth[i] == self.selectedStartMonth {
                    selctedMonth = i
                }
            }
            
            for i in stride(from: 0, to: self.arrYear.count, by: 1) {
                if self.arrYear[i] == self.selectedStartYear {
                    selctedYear = i
                }
            }
        }
        //}
        
        /*ActionSheetMultipleStringPicker(title: "Select StartDate", rows: [], initialSelection: [], target: self, successAction: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
        }, cancelAction: { picker in
            return
        }, origin: sender)*/
        ActionSheetMultipleStringPicker.show(withTitle: "Select StartDate", rows: [self.arrMonth,self.arrYear], initialSelection: [selctedMonth,selctedYear], doneBlock: { picker, index, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: index))")
            print("origin = \(String(describing: origin))")
            var tmpselectedStartMonth = ""
            var tmpselectedStartYear = ""
            if let arr = index as? [Int] {
                for i in stride(from: 0, to: arr.count, by: 1) {
                    if i == 0 {
                        if self.arrMonth.count > 0 {
                            tmpselectedStartMonth = self.arrMonth[arr[i]]
                        }
                    } else {
                        if self.arrYear.count > 0 {
                            tmpselectedStartYear = self.arrYear[arr[i]]
                        }
                    }
                }
                
                
                
                let selectStrDate : String = "\(tmpselectedStartMonth) \(tmpselectedStartYear)"
                let mainSeletedDate : Date = selectStrDate.getDateFromString(format: AppConstant.DateFormat.k_MMMM_yyyy)
                if mainSeletedDate > ((Date().getTimeString(inFormate: AppConstant.DateFormat.k_MMMM_yyyy)).getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_MMMM_yyyy, secondformat: AppConstant.DateFormat.k_MMMM_yyyy)) {
                    
                    delay(seconds: 0.3) {
                        self.showMessage(AppConstant.ValidationMessages.kStartDateLessThenTodayDate, themeStyle: .warning)
                    }
                } else if !((self.vwEndDate?.txtInput.text ?? "").isEmpty) && mainSeletedDate > ((self.vwEndDate?.txtInput.text ?? "").getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_MMMM_yyyy, secondformat: AppConstant.DateFormat.k_MMMM_yyyy)) {
                    
                    delay(seconds: 0.3) {
                        self.showMessage(AppConstant.ValidationMessages.kStartDateLessThenEndDate, themeStyle: .warning)
                    }
                } else {
                    self.selectedStartMonth = tmpselectedStartMonth
                    self.selectedStartYear = tmpselectedStartYear
                    self.vwStartDate?.txtInput.text = "\(self.selectedStartMonth) \(self.selectedStartYear)"
                }
            }
            
        }, cancel: { picker in
            return
        }, origin: sender)
        
        /*let datePicker = ActionSheetDatePicker(title: "Select StartDate",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = ((date as? Date ?? Date()).removeTimeStampFromDate()).getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.issueDate = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
        
            //if self.arrData.count > 0 && sender.tag <= self.arrData.count {
               // let obj = self.arrData[sender.tag]
                if let selectdate = date as? Date {
                    let enddate = self.vwEndDate?.txtInput.text ?? ""
                    print(selectdate.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd))
                    let ftime = selectdate.removeTimeStampFromDate().getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    if !enddate.isEmpty && mainSeletedDate == (enddate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireSameDateIssue, themeStyle: .warning)
                        }
                    } else if !enddate.isEmpty && mainSeletedDate > (enddate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireGreterThenFromTime, themeStyle: .warning)
                        }
                    } else {
                        //obj.issueDate = time
                        self.selectedStartDate = selectdate
                        self.vwStartDate?.txtInput.text = time.getFormmattedDateFromString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
                        
                    }
                }
            //}
            return
        },cancel: { picker in
            return
        },origin: sender)
        //datePicker?.minuteInterval = 30
        datePicker?.maximumDate = Date()
        //datePicker?.minimumDate = selectedDate
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()*/
    }
    
    @objc func btnEndDateClicked(_ sender : UIButton){
        
       // var selectedDate : Date = Date()
        // var minimumSelectDate : Date = Date()
        //selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        
        if (self.vwStartDate?.txtInput.text ?? "").isEmpty {
            self.showMessage(AppConstant.ValidationMessages.kEmptyStartDate, themeStyle: .warning)
            return
        }
        /*if (self.vwEndDate?.txtInput.text ?? "") != "" {
            if let date = self.selectedEndDate {
                selectedDate = date//(self.vwEndDate?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).removeTimeStampFromDate()
            }
        }
            
        if (self.vwStartDate?.txtInput.text ?? "") != "" {
            minimumSelectDate = (self.vwStartDate?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).removeTimeStampFromDate()
            //selectedDate = minimumSelectDate
            if (self.vwEndDate?.txtInput.text ?? "").isEmpty {
                var dayComponent    = DateComponents()
                dayComponent.day    = 1 // For removing one day (yesterday): -1
                let theCalendar     = Calendar.current
                let nextDate        = theCalendar.date(byAdding: dayComponent, to: minimumSelectDate)
                selectedDate = nextDate ?? minimumSelectDate
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select EndDate",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = ((date as? Date ?? Date()).removeTimeStampFromDate()).getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.expireDate = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
            
            
                if let selectdate = date as? Date {
                    print(selectdate.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd))
                    let ftime = selectdate.removeTimeStampFromDate().getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    if !((self.vwStartDate?.txtInput.text ?? "").isEmpty) && mainSeletedDate == ((self.vwStartDate?.txtInput.text ?? "").getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireSameDateIssue, themeStyle: .warning)
                        }
                    } else if !((self.vwStartDate?.txtInput.text ?? "").isEmpty) && mainSeletedDate < ((self.vwStartDate?.txtInput.text ?? "").getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireLessThenDateIssue, themeStyle: .warning)
                        }
                    } else {
                        self.selectedEndDate = selectdate
                        self.vwEndDate?.txtInput.text = time.getFormmattedDateFromString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
                    }
                }
            
            return
        },cancel: { picker in
            return
        },origin: sender)
        //datePicker?.minuteInterval = 30//self.switchHours.isOn ? 60 : 30
        //datePicker?.countDownDuration = 60
        datePicker?.minimumDate = minimumSelectDate
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()*/
        
        var selctedMonth : Int = (Date().getMonthFromDate()) - 1
        selctedMonth = (selctedMonth > 0) ? selctedMonth : 0
        var selctedYear : Int = self.arrYear.count - 1
        if (self.vwEndDate?.txtInput.text ?? "") != "" {
           /* if let date = self.selectedStartDate {
                selectedDate = date.removeTimeStampFromDate()
            }*/
            for i in stride(from: 0, to: self.arrMonth.count, by: 1) {
                if self.arrMonth[i] == self.selectedEndMonth {
                    selctedMonth = i
                }
            }
            
            for i in stride(from: 0, to: self.arrYear.count, by: 1) {
                if self.arrYear[i] == self.selectedEndYear {
                    selctedYear = i
                }
            }
        }
        
        //}
        
        /*ActionSheetMultipleStringPicker(title: "Select StartDate", rows: [], initialSelection: [], target: self, successAction: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
        }, cancelAction: { picker in
            return
        }, origin: sender)*/
        ActionSheetMultipleStringPicker.show(withTitle: "Select EndDate", rows: [self.arrMonth,self.arrYear], initialSelection: [selctedMonth,selctedYear], doneBlock: { picker, index, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: index))")
            print("origin = \(String(describing: origin))")
            var tmpselectedEndMonth = ""
            var tmpselectedEndYear = ""
            if let arr = index as? [Int] {
                for i in stride(from: 0, to: arr.count, by: 1) {
                    if i == 0 {
                        if self.arrMonth.count > 0 {
                            tmpselectedEndMonth = self.arrMonth[arr[i]]
                        }
                    } else {
                        if self.arrYear.count > 0 {
                            tmpselectedEndYear = self.arrYear[arr[i]]
                        }
                    }
                }
                let selectStrDate : String = "\(tmpselectedEndMonth) \(tmpselectedEndYear)"
                let mainSeletedDate : Date = selectStrDate.getDateFromString(format: AppConstant.DateFormat.k_MMMM_yyyy)
                if mainSeletedDate > ((Date().getTimeString(inFormate: AppConstant.DateFormat.k_MMMM_yyyy)).getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_MMMM_yyyy, secondformat: AppConstant.DateFormat.k_MMMM_yyyy)) {
                    
                    delay(seconds: 0.3) {
                        self.showMessage(AppConstant.ValidationMessages.kEndDateLessThenTodayDate, themeStyle: .warning)
                    }
                } else if !((self.vwStartDate?.txtInput.text ?? "").isEmpty) && mainSeletedDate < ((self.vwStartDate?.txtInput.text ?? "").getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_MMMM_yyyy, secondformat: AppConstant.DateFormat.k_MMMM_yyyy)) {
                    
                    delay(seconds: 0.3) {
                        self.showMessage(AppConstant.ValidationMessages.kEndDategreaterThenStartDate, themeStyle: .warning)
                    }
                } else {
                    self.selectedEndMonth = tmpselectedEndMonth
                    self.selectedEndYear = tmpselectedEndYear
                    self.vwEndDate?.txtInput.text = "\(self.selectedEndMonth) \(self.selectedEndYear)"
                }
                
                
            }
            
        }, cancel: { picker in
            return
        }, origin: sender)
    }
}

//MARK: - Validation
extension AddWorkExperienceViewController {
    private func validateFields() -> String? {
        if self.vwWorkPlace?.txtInput.isEmpty ?? false{
            self.vwWorkPlace?.txtInput.becomeFirstResponder()
            self.vwWorkPlace?.isSetFocusTextField = true
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyWorkPlace
        } else if self.vwStartDate?.txtInput.isEmpty ?? false{
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kLastName
        } /*else if self.vwEndDate?.txtInput.isEmpty ?? false {
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kvalidPassword
        }*/ else if self.vwReasonLeaving?.txtInput.isEmpty ?? false {
            self.vwReasonLeaving?.txtInput.becomeFirstResponder()
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = true
            self.vwWorkDesc?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kPhoneNumber
        } else if self.vwWorkDesc?.txtInput?.isEmpty ?? false {
            self.vwWorkDesc?.txtInput?.becomeFirstResponder()
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kInValidPhoneNo
        } else {
            return nil
        }
    }
}

//MARK : - UITextViewDelegate
extension AddWorkExperienceViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.vwWorkDesc?.txtInput {
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = true
        }
    }
}

//MARK : - UITextFieldDelegate
extension AddWorkExperienceViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwWorkPlace?.txtInput:
            self.vwWorkPlace?.txtInput.resignFirstResponder()
            self.vwReasonLeaving?.txtInput.becomeFirstResponder()
        case self.vwReasonLeaving?.txtInput:
            self.vwReasonLeaving?.txtInput.resignFirstResponder()
            self.vwWorkDesc?.txtInput?.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwWorkPlace?.txtInput:
            self.vwWorkPlace?.isSetFocusTextField = true
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = false
        case self.vwReasonLeaving?.txtInput:
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = true
            self.vwWorkDesc?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwWorkPlace?.txtInput:
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = true
            self.vwWorkDesc?.isSetFocusTextField = false
        case self.vwReasonLeaving?.txtInput:
            self.vwWorkPlace?.isSetFocusTextField = false
            self.vwStartDate?.isSetFocusTextField = false
            self.vwEndDate?.isSetFocusTextField = false
            self.vwReasonLeaving?.isSetFocusTextField = false
            self.vwWorkDesc?.isSetFocusTextField = true
        default:
            break
        }
    }
}

// MARK: - IBAction
extension AddWorkExperienceViewController {
    @IBAction func btnAddExperinecClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        if let user = UserModel.getCurrentUserFromDefault() {
            
            //let model = WorkExperienceModel.init(userworkexperienceId: "", userid: user.id, workplace: (self.vwWorkPlace?.txtInput.text ?? ""), startdate: stdate.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd), enddate: enddate.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd), leavingreason: (self.vwReasonLeaving?.txtInput.text ?? ""), workdescription: (self.vwWorkDesc?.txtInput?.text ?? ""))
            let model = WorkExperienceModel.init(userworkexperienceId: "", userid: user.id, workplace: (self.vwWorkPlace?.txtInput.text ?? ""), startdate: "\(self.selectedStartMonth)/\(self.selectedStartYear)", enddate: (self.selectedEndMonth.isEmpty && self.selectedEndYear.isEmpty) ? "" : "\(self.selectedEndMonth)/\(self.selectedEndYear)", leavingreason: (self.vwReasonLeaving?.txtInput.text ?? ""), workdescription: (self.vwWorkDesc?.txtInput?.text ?? ""))
            self.dismiss(animated: true) {
                self.delegate?.addWorkExperinec(obj: model)
            }
        }
        
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ViewControllerDescribable
extension AddWorkExperienceViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension AddWorkExperienceViewController: AppNavigationControllerInteractable { }
