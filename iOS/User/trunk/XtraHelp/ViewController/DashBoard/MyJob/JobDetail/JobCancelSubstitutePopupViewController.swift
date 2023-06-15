//
//  JobCancelSubstitutePopupViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

enum JobCancelPopupEnumOpenType {
    case CancelJob
    case SubstituteJob
    case AdditionalHours
    case AddHours
    case CreateJob
    case RequestImageVideo
}

protocol JobCancelSubstitutePopupDelegate {
    func cancelJob()
}

class JobCancelSubstitutePopupViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwDataMain: UIView?
    @IBOutlet weak var vwSubBottom: UIView?
    
    @IBOutlet weak var btnYes: SelectAppButton?
    @IBOutlet weak var btnNo: SelectAppButton?
    
    @IBOutlet weak var btnClose: UIButton?
    @IBOutlet weak var btnCloseTouch: UIButton?
    
    @IBOutlet weak var vwAdditionalHour: UIView?
    @IBOutlet var lblAdditionalHourHeader: [UILabel]?
    @IBOutlet weak var lblAdditionalHourPrevHour: UILabel?
    @IBOutlet weak var lblAdditionalHourUpdatedHour: UILabel?
    
    @IBOutlet weak var stackAddHoursMain: UIStackView?
    @IBOutlet weak var lblTimingHeader: UILabel?
    @IBOutlet var lblStartEndHeader: [UILabel]?
    @IBOutlet var vwStartEndSub: [UIView]?
    @IBOutlet weak var lblStartTime: UILabel?
    @IBOutlet weak var lblEndTime: UILabel?
    @IBOutlet weak var btnStartTime: UIButton?
    @IBOutlet weak var btnEndTime: UIButton?
    
    //Create Job
    @IBOutlet weak var vwCreateJobCategoryMain: UIStackView?
    @IBOutlet weak var vwMainSearchCaregiver: UIView?
    @IBOutlet weak var vwMainPostJob: UIView?
    @IBOutlet var vwCreateJobOverlay: [UIView]?
    
    @IBOutlet var lblCreateJobCategoryName: [UILabel]?
    @IBOutlet var lblCreateJobCategoryDesc: [UILabel]?
    
    @IBOutlet weak var imgCreateJobSearchCaregiverCategory: UIImageView?
    @IBOutlet weak var imgCreateJobPostJobCategory: UIImageView?
    
    @IBOutlet weak var btnCreateJobSearchCaregiverSelect: UIButton?
    @IBOutlet weak var btnCreateJobPostJobSelect: UIButton?
    
    @IBOutlet weak var stackRequestMediaMain: UIStackView?
    @IBOutlet weak var vwRequestImageSub: UIView?
    @IBOutlet weak var vwRequestVideoSub: UIView?
    
    // MARK: - Variables
    var isSubstituteJob : Bool = false
    var OpenFromType : JobCancelPopupEnumOpenType = .CancelJob
    private var isSelectSearchCaregiver : Bool = false {
        didSet{
            self.btnCreateJobSearchCaregiverSelect?.isHidden = !isSelectSearchCaregiver
            self.btnCreateJobPostJobSelect?.isHidden = isSelectSearchCaregiver
        }
    }
    
    private var isSelectRequestImage : Bool = false {
        didSet{
            self.vwRequestImageSub?.backgroundColor = isSelectRequestImage ? UIColor.CustomColor.borderColorSession : UIColor.CustomColor.whitecolor
            self.vwRequestVideoSub?.backgroundColor = !isSelectRequestImage ? UIColor.CustomColor.borderColorSession : UIColor.CustomColor.whitecolor
        }
    }
    
    var paramDict : [String:Any] = [:]
    var delegate : CreateJobJobSearchPostDelegate?
    var cancelJobDelegate : JobCancelSubstitutePopupDelegate?
    
    var selectedJobData : JobModel?
    
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
extension JobCancelSubstitutePopupViewController {
    private func InitConfig(){
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        //delay(seconds: 0.2) {
        self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        //}
        self.vwSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        self.vwSubBottom?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        //self.lblHeader?.text = self.isSubstituteJob ? "Cancel / Substitute Job" : "Cancel Application"
        
        self.btnYes?.isSelectBtn = true
        self.btnNo?.isSelectBtn = false
        
        self.vwAdditionalHour?.backgroundColor = UIColor.CustomColor.ExperienceBGColor
        self.vwAdditionalHour?.cornerRadius = 10.0
        
        self.lblAdditionalHourHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        self.vwStartEndSub?.forEach({
            $0.backgroundColor = UIColor.CustomColor.whitecolor
            $0.cornerRadius = 15.0
        })
        
        self.lblTimingHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTimingHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblStartEndHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblStartTime,self.lblEndTime].forEach({
            $0?.textColor = UIColor.CustomColor.commonLabelColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblAdditionalHourUpdatedHour,self.lblAdditionalHourPrevHour].forEach({
            $0?.textColor = UIColor.CustomColor.SubscriptuionSubColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.vwMainPostJob,self.vwMainSearchCaregiver,self.imgCreateJobPostJobCategory,self.imgCreateJobSearchCaregiverCategory].forEach({
            $0?.cornerRadius = 20.0
        })
        
        self.vwCreateJobOverlay?.forEach({
            $0.cornerRadius = 20.0
            $0.backgroundColor = UIColor.CustomColor.black50Per
        })
        
        self.lblCreateJobCategoryName?.forEach({
            $0.textColor = UIColor.CustomColor.whitecolor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        })
        
        self.lblCreateJobCategoryDesc?.forEach({
            $0.textColor = UIColor.CustomColor.CategoryPricecolor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.vwRequestImageSub,self.vwRequestVideoSub].forEach({
            $0?.backgroundColor = UIColor.CustomColor.whitecolor
            $0?.borderColor = UIColor.CustomColor.borderColor
            $0?.borderWidth = 1.0
            $0?.cornerRadius = 15.0
        })
        
        switch self.OpenFromType {
        case .CancelJob:
            self.lblHeader?.text = "Cancel Application"
            self.btnYes?.setTitle("Yes", for: .normal)
            self.btnNo?.setTitle("No", for: .normal)
        case .SubstituteJob:
            self.lblHeader?.text = "Cancel / Substitute Job"
            self.btnYes?.setTitle("Cancel", for: .normal)
            self.btnNo?.setTitle("Substitute", for: .normal)
        case .AdditionalHours:
            self.vwAdditionalHour?.isHidden = false
            self.lblHeader?.text = "Additional Hours"
            self.btnYes?.setTitle("Accept", for: .normal)
            self.btnNo?.setTitle("Decline", for: .normal)
        case .AddHours:
            self.vwDataMain?.isHidden = true
            self.stackAddHoursMain?.isHidden = false
            self.lblHeader?.text = "Add Hours"
            self.lblSubHeader?.text = "Please add the start and end time that you need help for."
            if let obj = self.selectedJobData {
                self.lblStartTime?.text = obj.endTime
            }
        case .CreateJob:
            self.vwDataMain?.isHidden = true
            self.lblHeader?.text = "Job Action"
            self.lblSubHeader?.isHidden = true
            self.vwCreateJobCategoryMain?.isHidden = false
            self.isSelectSearchCaregiver = true
            self.btnCloseTouch?.isUserInteractionEnabled = false
        case .RequestImageVideo:
            self.isSelectRequestImage = true
            self.lblHeader?.text = "Request"
            self.lblSubHeader?.text = "Choose whether you would like the caregiver to send you a photo or video of your loved one currently."
            self.vwDataMain?.isHidden = true
            self.stackRequestMediaMain?.isHidden = false
            
        }
    }
}

// MARK: - IBAction
extension JobCancelSubstitutePopupViewController {
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        if self.OpenFromType == .CreateJob {
            self.dismiss(animated: true) {
                //self.paramDict[]
                
                //self.appNavigationController?.push(JobSuccessViewController.self,configuration: { vc in
                    
                //})
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnStartTimeClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnEndTimeClicked(_ sender: UIButton) {
        var selectedDate : Date = Date()
        selectedDate = Date().rounded(minutes: 15, rounding: .ceil)
        if !(self.lblEndTime?.text?.isEmpty ?? false) {
            selectedDate = (self.lblEndTime?.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
        }
        
        var mindate : Date = Date()
        if !(self.lblStartTime?.text?.isEmpty ?? false) {
            let strmindate = "\(Date().getFormattedString(format: AppConstant.DateFormat.k_dd_MM_yyyy)) \((self.lblStartTime?.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a).getFormattedString(format: AppConstant.DateFormat.k_hh_mm_a))"
            mindate = strmindate.getDateFromString(format: AppConstant.DateFormat.k_dd_MM_yyyy_hh_mm_a)//(self.lblStartTime?.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_hh_mm_a)
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
                    //let ftime = selectdate.get24HoursTimeString()
                    /*let endtimeText : String = self.lblEndTime?.text ?? ""
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_HH_mm)
                    
                    if !endtimeText.isEmpty && mainSeletedDate == (endtimeText.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kSelectedTimeSameStartTime, themeStyle: .warning)
                        }
                    } else if !endtimeText.isEmpty && mainSeletedDate > (endtimeText.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_hh_mm_a, secondformat: AppConstant.DateFormat.k_HH_mm)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kStartTimeGreterThenEndTime, themeStyle: .warning)
                        }
                    } else {*/
                        self.lblEndTime?.text = time
                    //}
                }
            
            return
        },cancel: { picker in
            return
        },origin: sender)
        datePicker?.minuteInterval = 15
        datePicker?.minimumDate = mindate
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
    
    @IBAction func btnAddHoursSubmitClicked(_ sender: XtraHelpButton) {
        if (self.lblStartTime?.text ?? "").isEmpty {
            self.showMessage("Please select start time")
            return
        } else if (self.lblEndTime?.text ?? "").isEmpty {
            self.showMessage("Please select end time")
            return
        }
        
        self.sendJobExtraHoursRequestAPI()
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRequestImageClicked(_ sender: UIButton) {
        self.isSelectRequestImage = true
    }
    
    @IBAction func btnRequestVideoClicked(_ sender: UIButton) {
        self.isSelectRequestImage = false
    }
    
    @IBAction func btnRequestSubmitClicked(_ sender: UIButton) {
        self.requestJobImageVideo()
    }
    
    @IBAction func btnYesClicked(_ sender: SelectAppButton) {
        self.dismiss(animated: true) {
            self.cancelJobDelegate?.cancelJob()
        }
        //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnNoClicked(_ sender: SelectAppButton) {
        self.dismiss(animated: true) {
            if self.isSubstituteJob {
                self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.OpenFromType = .SubstituteJob
                })
            }
        }
    }
    
    @IBAction func btnCreateJobSearchCareGiverClicked(_ sender: UIButton) {
        self.isSelectSearchCaregiver = true
        
    }
    @IBAction func btnCreateJobPostJobClicked(_ sender: UIButton) {
        self.isSelectSearchCaregiver = false
    }
    
    @IBAction func btnSubmitCreateJobClicked(_ sender: XtraHelpButton) {
        self.dismiss(animated: true) {
            self.delegate?.btnSubmitJob(isSearchCaregiver: self.isSelectSearchCaregiver)
            //self.appNavigationController?.push(JobSuccessViewController.self)
        }
    }
}

// MARK: - API Call
extension JobCancelSubstitutePopupViewController {
    func requestJobImageVideo() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobDetailId : jobdata.userJobDetailId,
                kmediaType : self.isSelectRequestImage ? "1" : "2"
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.requestJobImageVideo(with: param, success: { ( msg) in
                self.showMessage(msg,themeStyle: .success)
                self.dismiss(animated: true, completion: nil)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    
    func sendJobExtraHoursRequestAPI() {
        self.view.endEditing(true)
        
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobDetailId : jobdata.userJobDetailId,
                kstartTime : self.lblStartTime?.text ?? "",
                kendTime : self.lblEndTime?.text ?? ""
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            JobModel.sendJobExtraHoursRequest(with: param) { msg in
                self.showMessage(msg,themeStyle: .success)
                self.dismiss(animated: true, completion: nil)
            } failure: { statuscode, error, customError in
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension JobCancelSubstitutePopupViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension JobCancelSubstitutePopupViewController: AppNavigationControllerInteractable { }

