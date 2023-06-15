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
}

protocol JobCancelSubstituteDelegate {
    func cancelJob(selectedjobData : JobModel)
    func substituteJob()
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
    
    // MARK: - Variables
    var isSubstituteJob : Bool = false
    var OpenFromType : JobCancelPopupEnumOpenType = .CancelJob
    var selectedjobData : JobModel?
    var delegate : JobCancelSubstituteDelegate?
    private var isCancelSubstituteClicked : Bool = false
    var isFromJobTabCancelJob : Bool = false
    
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
        
        [self.lblAdditionalHourUpdatedHour,self.lblAdditionalHourPrevHour].forEach({
            $0?.textColor = UIColor.CustomColor.SubscriptuionSubColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        switch self.OpenFromType {
        case .CancelJob:
            self.lblHeader?.text = self.isFromJobTabCancelJob ? "Cancel Job Request" : "Cancel Application"
            self.lblSubHeader?.text = self.isFromJobTabCancelJob ? "Are you sure want to cancel this job request?" : "Are you sure want to cancel this job?"
            self.lblSubHeader?.isHidden = false
            self.btnYes?.setTitle("Yes", for: .normal)
            self.btnNo?.setTitle("No", for: .normal)
        case .SubstituteJob:
            self.lblHeader?.text = "Cancel / Substitute Job"
            self.lblSubHeader?.isHidden = true
            self.btnYes?.setTitle("Cancel", for: .normal)
            self.btnNo?.setTitle("Substitute", for: .normal)
        case .AdditionalHours:
            self.vwAdditionalHour?.isHidden = false
            self.lblHeader?.text = "Additional Hours"
            self.lblSubHeader?.isHidden = false
            self.lblSubHeader?.text = "Please confirm your availability for additional hours."//"Thinking about leaving the job, you can choose a substitute for the family."
            self.btnYes?.setTitle("Accept", for: .normal)
            self.btnNo?.setTitle("Decline", for: .normal)
            
            if let obj = self.selectedjobData {
                self.lblAdditionalHourPrevHour?.text = obj.perviousHours
                self.lblAdditionalHourUpdatedHour?.text = obj.updatedHours
            }
        }
    }
}

// MARK: - IBAction
extension JobCancelSubstitutePopupViewController {
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnYesClicked(_ sender: SelectAppButton) {
        
            if self.OpenFromType == .SubstituteJob {
                if !self.isCancelSubstituteClicked {
                    self.lblHeader?.text = "Cancel Application"
                    self.lblSubHeader?.text = "Are you sure want to cancel this job?"
                    self.btnYes?.setTitle("Yes", for: .normal)
                    self.btnNo?.setTitle("No", for: .normal)
                    self.isCancelSubstituteClicked = true
                } else {
                    self.dismiss(animated: true) {
                        if let obj = self.selectedjobData {
                            self.delegate?.cancelJob(selectedjobData : obj)
                        }
                    }
                }
            } else if self.OpenFromType == .AdditionalHours {
                self.showAlert(withTitle: "", with: "Are you sure want to accept additional hours request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                    self.AcceptRejectJobAdditionalHoursRequestAPICall(isAccept: true)
                }, secondButton: ButtonTitle.No, secondHandler: nil)
                
            } else {
                self.dismiss(animated: true) {
                    if let obj = self.selectedjobData {
                        self.delegate?.cancelJob(selectedjobData : obj)
                    }
                }
            }
            //self.delegate?.cancelJob()
        
    }
    @IBAction func btnNoClicked(_ sender: SelectAppButton) {
        
        if self.OpenFromType == .AdditionalHours {
            self.showAlert(withTitle: "", with: "Are you sure want to decline additional hours request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                self.AcceptRejectJobAdditionalHoursRequestAPICall(isAccept: false)
            }, secondButton: ButtonTitle.No, secondHandler: nil)
        } else {
            
            self.dismiss(animated: true) {
                if self.OpenFromType == .SubstituteJob {//self.isSubstituteJob {
                    /*self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                     vc.modalPresentationStyle = .overFullScreen
                     vc.modalTransitionStyle = .crossDissolve
                     vc.OpenFromType = .SubstituteJob
                     })*/
                    if !self.isCancelSubstituteClicked {
                        self.delegate?.substituteJob()
                    }
                }
            }
        }
    }
}

// MARK: - API Call
extension JobCancelSubstitutePopupViewController {
    func AcceptRejectJobAdditionalHoursRequestAPICall(isAccept : Bool = false) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let obj = self.selectedjobData{
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobDetailId : obj.userJobDetailId
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.AcceptRejectJobAdditionalHoursRequest(with: param, isAccept: isAccept) { msg in
                self.showMessage(msg, themeStyle: .success)
                self.dismiss(animated: true)
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

