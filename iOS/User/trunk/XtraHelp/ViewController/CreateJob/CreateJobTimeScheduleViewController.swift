//
//  CreateJobTimeScheduleViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 10/12/21.
//

import UIKit

protocol CreateJobJobSearchPostDelegate {
    func btnSubmitJob(isSearchCaregiver : Bool)
}

class CreateJobTimeScheduleViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTopHeader: UILabel?
    
    @IBOutlet weak var calenderView: UIView?
    
    @IBOutlet weak var btnOneTime: UIButton?
    @IBOutlet weak var btnRecurring: UIButton?
    
    //StartCAneclJob
    @IBOutlet weak var vwBottomJobCancelStartMain: UIView?
    @IBOutlet weak var vwJobCancelMain: UIView?
    @IBOutlet weak var vwJobStartMain: UIView?
    @IBOutlet weak var lblJobCancel: UILabel?
    @IBOutlet weak var lblJobStart: UILabel?
    
    @IBOutlet weak var stackAddHoursMain: UIStackView?
    @IBOutlet weak var lblTimingHeader: UILabel?
    @IBOutlet var lblStartEndHeader: [UILabel]?
    @IBOutlet var vwStartEndSub: [UIView]?
    @IBOutlet weak var lblStartTime: UILabel?
    @IBOutlet weak var lblEndTime: UILabel?
    @IBOutlet weak var btnStartTime: UIButton?
    @IBOutlet weak var btnEndTime: UIButton?
    
    // MARK: - Variables
    private var CalderHeaderCellViewXib : CalenderView?
    private var isSelectOneTime : Bool = false {
        didSet{
            self.btnOneTime?.backgroundColor = isSelectOneTime ? GradientColor(gradientStyle: .topToBottom, frame: (self.btnOneTime?.frame) ?? CGRect.zero, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom]) : UIColor.clear
            self.btnRecurring?.backgroundColor = !isSelectOneTime ? GradientColor(gradientStyle: .topToBottom, frame: (self.btnOneTime?.frame) ?? CGRect.zero, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom]) : UIColor.clear
            self.btnOneTime?.borderColor = isSelectOneTime ? UIColor.clear : UIColor.CustomColor.tutorialColor
            self.btnRecurring?.borderColor = !isSelectOneTime ? UIColor.clear : UIColor.CustomColor.tutorialColor
            self.btnOneTime?.borderWidth = isSelectOneTime ? 0.0 : 1.0
            self.btnRecurring?.borderWidth = !isSelectOneTime ? 0.0 : 1.0
            self.btnOneTime?.setTitleColor(isSelectOneTime ? UIColor.CustomColor.whitecolor : UIColor.CustomColor.tutorialColor, for: .normal)
            self.btnRecurring?.setTitleColor(!isSelectOneTime ? UIColor.CustomColor.whitecolor : UIColor.CustomColor.tutorialColor, for: .normal)
        }
    }
    private var arrSelectedDate : [Date] = []
    var paramDict : [String:Any] = [:]
    
    var selectedCategory : JobCategoryModel?
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        
        self.CalderHeaderCellViewXib = UINib(nibName: "CalenderView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? CalenderView
        CalderHeaderCellViewXib?.frame = self.calenderView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        CalderHeaderCellViewXib?.delegate = self
        if let vw = self.CalderHeaderCellViewXib {
            self.calenderView?.addSubview(vw)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        [self.vwJobCancelMain].forEach({
            $0?.roundCorners(corners: [.topRight], radius: ($0?.frame.width ?? 0.0)/2.0)
        })
        
        if let vw = self.vwJobStartMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            vw.roundCorners(corners: [.topLeft], radius: vw.frame.width / 2)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - Init Configure
extension CreateJobTimeScheduleViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTopHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        
        [self.lblJobCancel,self.lblJobStart].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size:15.0))
        })
        
        self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        
        self.vwStartEndSub?.forEach({
            $0.backgroundColor = UIColor.CustomColor.whitecolor
            $0.cornerRadius = 15.0
        })
        
        self.lblTimingHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTimingHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        [self.btnOneTime,self.btnRecurring].forEach({
            $0?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
            $0?.cornerRadius = 12.0
        })
        
        self.lblStartEndHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblStartTime,self.lblEndTime].forEach({
            $0?.textColor = UIColor.CustomColor.commonLabelColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
            $0?.isHidden = true
        })
        
        delay(seconds: 0.2) {
            self.isSelectOneTime = true
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
    
}

// MARK: - CalenderView Delegate
extension CreateJobTimeScheduleViewController : calenderViewDelegate{
    func selectMultipleCalenderDate(arr: [Date]) {
        print(arr)
        self.arrSelectedDate = arr
    }
    
    func deSelectMultipleCalenderDate(arr: [Date]) {
        print(arr)
        self.arrSelectedDate = arr
    }
    
    func selectCalenderDate(date: Date) {
       // let selectedadte = date.removeTimeStampFromDate()
        
    }
}

// MARK: - IBAction
extension CreateJobTimeScheduleViewController {
    
    private func validateFields() -> String? {
        if self.arrSelectedDate.isEmpty{
            return AppConstant.ValidationMessages.kEmptyJobDate
        } else if (self.lblStartTime?.text ?? "").isEmpty {
            return AppConstant.ValidationMessages.kEmptyJobStartTime
        } else if (self.lblEndTime?.text ?? "").isEmpty {
            return AppConstant.ValidationMessages.kEmptyJobEndTime
        } else {
            return nil
        }
    }
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        
        let filter = self.arrSelectedDate.removingDuplicates().map({$0.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)})
        if filter.count > 0 {
            let dic : [String:Any] = [
                kdate : filter,
                kstartTime : self.lblStartTime?.text ?? "",
                kendTime : self.lblEndTime?.text ?? ""
            ]
            self.paramDict[kjobTiming] = dic
            self.paramDict[kisJob] = self.isSelectOneTime ? "1" : "2"
        }
        
        self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.OpenFromType = .CreateJob
            vc.paramDict = self.paramDict
            vc.delegate = self
        })
    }
    
    @IBAction func btnOneTimeClicked(_ sender: UIButton) {
        self.isSelectOneTime = true
        self.CalderHeaderCellViewXib?.isFromOneTime = true
        self.arrSelectedDate.removeAll()
    }
    @IBAction func btnRecurringClicked(_ sender: UIButton) {
        self.isSelectOneTime = false
        self.CalderHeaderCellViewXib?.isFromOneTime = false
    }
    
    @IBAction func btnStartTimeClicked(_ sender: UIButton) {
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 15, rounding: .ceil)
        if !(self.lblStartTime?.text?.isEmpty ?? false) {
            selectedDate = (self.lblStartTime?.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select Start Time",
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
                    let endtimeText : String = self.lblEndTime?.text ?? ""
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    if !endtimeText.isEmpty && mainSeletedDate == (endtimeText.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameStartTime, themeStyle: .warning)
                        }
                    } /*else if !endtimeText.isEmpty && mainSeletedDate > (endtimeText.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kStartTimeGreterThenEndTime, themeStyle: .warning)
                        }
                    }*/ else {
                        self.lblStartTime?.text = time
                        self.lblStartTime?.isHidden = false
                    }
                }
            
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 15
        //datePicker?.minimumDate = Date()
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
        
    }
    @IBAction func btnEndTimeClicked(_ sender: UIButton) {
        
        if (self.lblStartTime?.text?.isEmpty ?? false) {
            self.showMessage(AppConstant.ValidationMessages.kEmptyStartTime, themeStyle: .warning)
            return
        }
        
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 15, rounding: .ceil)
        if !(self.lblEndTime?.text?.isEmpty ?? false) {
            selectedDate = (self.lblEndTime?.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        } else if !(self.lblStartTime?.text?.isEmpty ?? false) {
            selectedDate = (self.lblStartTime?.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
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
                    let starttimeText : String = self.lblStartTime?.text ?? ""
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    if !starttimeText.isEmpty && mainSeletedDate == (starttimeText.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameStartTime, themeStyle: .warning)
                        }
                    } /*else if !starttimeText.isEmpty && mainSeletedDate < (starttimeText.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kEndTimeLessThenStartTime, themeStyle: .warning)
                        }
                    }*/ else {
                        self.lblEndTime?.text = time
                        self.lblEndTime?.isHidden = false
                    }
                }
            
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 15//self.switchHours.isOn ? 60 : 30
        //datePicker?.countDownDuration = 60
        //datePicker?.minimumDate = Date()
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
}

// MARK: - CreateJob JobSearch Post Delegate
extension CreateJobTimeScheduleViewController : CreateJobJobSearchPostDelegate {
    func btnSubmitJob(isSearchCaregiver: Bool) {
        //if isSearchCaregiver {
            self.saveUserJobAPICall(isSearchCaregiver: isSearchCaregiver)
        /*} else {
            self.saveUserJobAPICall()
        }*/
    }
}

// MARK: - API Call
extension CreateJobTimeScheduleViewController {
    func saveUserJobAPICall(isSearchCaregiver : Bool = false) {
        self.view.endEditing(true)
        let param : [String:Any] = [
            kData : self.paramDict
        ]
        
        JobModel.saveUserJob(with: param, success: { (msg,jobid) in
            if isSearchCaregiver {
                if let catObj = self.selectedCategory {
                    self.appNavigationController?.push(SearchViewController.self,configuration: { vc in
                        vc.selecetdCategory = catObj
                        vc.isFromSearchCaregiver = true
                        vc.searchCaregiverJobID = jobid
                    })
                }
            } else {
                self.appNavigationController?.push(JobSuccessViewController.self)
            }
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
}

// MARK: - ViewControllerDescribable
extension CreateJobTimeScheduleViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateJobTimeScheduleViewController: AppNavigationControllerInteractable { }
