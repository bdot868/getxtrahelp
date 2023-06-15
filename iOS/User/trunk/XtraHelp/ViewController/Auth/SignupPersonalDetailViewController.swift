//
//  SignupPersonalDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit

enum SignupPersonalDetailEnum : Int {
    case HereAboutUs
    case SoonPlanning
}

class SignupPersonalDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet var lblTextHeader: [UILabel]?
    
    @IBOutlet weak var vwFirstName: ReusableView?
    @IBOutlet weak var vwLastName: ReusableView?
    @IBOutlet weak var vwAge: ReusableView?
    @IBOutlet weak var vwPhoneNUmber: ReusableView?
    @IBOutlet weak var vwHereAboutUs: ReusableView?
    @IBOutlet weak var vwSoonPlanning: ReusableView?
    
    @IBOutlet weak var vwHereAboutUsMain: UIView?
    @IBOutlet weak var vwProfileRound: UIView?
    @IBOutlet weak var imgProfile: UIImageView?
    @IBOutlet weak var btnAddProfile: UIButton?
    @IBOutlet weak var btnNext: XtraHelpButton?
    
    @IBOutlet weak var btnMale: SelectAppButton?
    @IBOutlet weak var btnFeMale: SelectAppButton?
    @IBOutlet weak var btnOther: SelectAppButton?
    
    @IBOutlet weak var btnFamilyVaccinatedYes: SelectAppButton?
    @IBOutlet weak var btnFamilyVaccinatedNo: SelectAppButton?
    
    @IBOutlet weak var btnCovid19Guidline: UIButton?
    
    // MARK: - Variables
    private let imagePicker = ImagePicker()
    private var mediaName : String = ""
    private var selectedHearAboutData : HearAboutUsModel?
    var isFromLogin : Bool = false
    private var PlanningSoonDate : Date?
    var isFromEditProfile : Bool = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
}

// MARK: - Init Configure
extension SignupPersonalDetailViewController {
    
    private func InitConfig(){
        
        self.imagePicker.viewController = self
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        
        delay(seconds: 0.2) {
            self.vwProfileRound?.cornerRadius = (self.vwProfileRound?.frame.height ?? 0.0) / 2
        }
        
        self.vwProfileRound?.borderColor = UIColor.CustomColor.tabBarColor
        self.vwProfileRound?.borderWidth = 5.0
        
        self.lblTextHeader?.forEach({
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
            $0.textColor = UIColor.CustomColor.SubscriptuionSubColor
        })
        
        self.btnFamilyVaccinatedYes?.isSelectBtn = false
        self.btnFamilyVaccinatedNo?.isSelectBtn = true
        
        self.btnCovid19Guidline?.setCovidAttributedTextLable(firstText: "Covid-19 Guidelines")
        
        self.btnMale?.isSelectBtn = true
        self.btnFeMale?.isSelectBtn = false
        self.btnOther?.isSelectBtn = false
        
        [self.vwFirstName,self.vwLastName,self.vwPhoneNUmber,self.vwAge].forEach({
            $0?.txtInput.delegate = self
            $0?.txtInput.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            
        })
        
        self.vwFirstName?.txtInput.autocapitalizationType = .words
        self.vwLastName?.txtInput.autocapitalizationType = .words
        
        self.vwHereAboutUs?.reusableViewDelegate = self
        self.vwHereAboutUs?.btnSelect.tag = SignupPersonalDetailEnum.HereAboutUs.rawValue
        self.vwSoonPlanning?.reusableViewDelegate = self
        self.vwSoonPlanning?.btnSelect.tag = SignupPersonalDetailEnum.SoonPlanning.rawValue
        
        if let user = UserModel.getCurrentUserFromDefault() {
            
            self.lblHeader?.isHidden = self.isFromEditProfile
            self.vwHereAboutUsMain?.isHidden = self.isFromEditProfile
            self.vwSoonPlanning?.isHidden = self.isFromEditProfile
            
            self.vwFirstName?.txtInput.text = user.FirstName
            self.vwLastName?.txtInput.text = user.LastName
            self.vwAge?.txtInput.text = user.age
            if !user.phone.isEmpty {
                self.vwPhoneNUmber?.txtInput.text = format(with: Masking.kUSPhoneNumberMasking, phone: user.phone)
            }
            self.btnMale?.isSelectBtn = user.gender == .Male
            self.btnFeMale?.isSelectBtn = user.gender == .Female
            self.btnOther?.isSelectBtn = user.gender == .Other
            self.btnFamilyVaccinatedYes?.isSelectBtn = user.familyVaccinated == "1"
            self.btnFamilyVaccinatedNo?.isSelectBtn = user.familyVaccinated == "2"
            if !user.profileimage.isEmpty {
                if #available(iOS 13.0, *) {
                    self.imgProfile?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                } else {
                    // Fallback on earlier versions
                }
            }
            if user.gender == .None {
                self.btnMale?.isSelectBtn = true
            }
            if user.familyVaccinated == "0" {
                self.btnFamilyVaccinatedYes?.isSelectBtn = true
            }
            
            self.vwFirstName?.ShowRightLabelView = !(self.vwFirstName?.txtInput.isEmpty ?? false)
            self.vwLastName?.ShowRightLabelView = !(self.vwLastName?.txtInput.isEmpty ?? false)
            
            self.btnNext?.setTitle(self.isFromEditProfile ? "Update" : "Next", for: .normal)
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isFromDirect : self.isFromLogin)
        
        if self.isFromEditProfile {
            appNavigationController?.setNavigationBackTitleRightBackBtnNavigationBar(title: "My Profile", TitleColor: UIColor.CustomColor.tabBarColor, rightBtntitle: "Change Password", rightBtnColor: UIColor.CustomColor.appColor, navigationItem: self.navigationItem)
        } else {
            appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isFromDirect : self.isFromLogin)
        }
        
        appNavigationController?.btnNextClickBlock = {
            if let user = UserModel.getCurrentUserFromDefault() {
                self.appNavigationController?.push(ChangePasswordVC.self,configuration: { vc in
                    vc.isFromForgotPassword = false
                    vc.userEmail = user.email
                })
            }
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}



// MARK: - IBAction
extension SignupPersonalDetailViewController {
    @IBAction func btnNextClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(SignUpLicensesViewController.self)
        //print(self.vwPhoneNUmber?.txtInput.text?.removeSpecialCharsFromString)
//        SignUp2VC
        self.view.endEditing(true)
        
        //let vc = loadVC(strStoryboardId: UIStoryboard.Name.auth.rawValue, strVCId: "SignUp3VC") as! SignUp3VC
            //  self.navigationController?.pushViewController(vc, animated: true)
        
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        self.savePersonalInfo()
    }
    
    @IBAction func btnAddProfileClicked(_ sender: UIButton) {
        self.imagePicker.pickImage(sender, "Select Profile Picture") { (img,url) in
            self.imgProfile?.image = img
            self.mediaAPICall(img: img)
        }
    }
   
    @IBAction func btnMaleClicked(_ sender: SelectAppButton)
    {
        self.btnMale?.isSelectBtn = true
        self.btnFeMale?.isSelectBtn = false
        self.btnOther?.isSelectBtn = false
    }
    
    @IBAction func btnFeMaleClicked(_ sender: SelectAppButton) {
        self.btnMale?.isSelectBtn = false
        self.btnFeMale?.isSelectBtn = true
        self.btnOther?.isSelectBtn = false
    }
    
    @IBAction func btnOtherClicked(_ sender: SelectAppButton) {
        self.btnMale?.isSelectBtn = false
        self.btnFeMale?.isSelectBtn = false
        self.btnOther?.isSelectBtn = true
    }
    
    @IBAction func btnFamilyVaccinatedYesClicked(_ sender: SelectAppButton) {
        self.btnFamilyVaccinatedYes?.isSelectBtn = true
        self.btnFamilyVaccinatedNo?.isSelectBtn = false
        self.appNavigationController?.present(CovidGuidelinesViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
        })
    }
    
    @IBAction func btnFamilyVaccinatedNoClicked(_ sender: SelectAppButton) {
        self.btnFamilyVaccinatedYes?.isSelectBtn = false
        self.btnFamilyVaccinatedNo?.isSelectBtn = true
    }
    
    @IBAction func btnCovid19GuidelineClicked(_ sender: UIButton) {
        self.appNavigationController?.present(CovidGuidelinesViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
        })
    }
}

// MARK: - ReusableViewDelegate
extension SignupPersonalDetailViewController:ReusableViewDelegate{
    func buttonClicked(_ sender: UIButton) {
//        self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.delegate = self
//            vc.OpenFromType = .HearAboutUs
//            if let obj = self.selectedHearAboutData {
//                vc.selectedHearAboutData = obj
//            }
//        })
        switch SignupPersonalDetailEnum.init(rawValue: sender.tag) ?? .HereAboutUs {
        case .HereAboutUs:
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.OpenFromType = .HearAboutUs
                if let obj = self.selectedHearAboutData {
                    vc.selectedHearAboutData = obj
                }
            })
        case .SoonPlanning:
            self.opemPlanningDate(btn: sender)
            break
        }
    }
    
    func rightButtonClicked(_ sender: UIButton) {
    }
    
    private func opemPlanningDate(btn : UIButton){
        var selecteddate : Date = Date()
        if self.vwSoonPlanning?.txtInput.text != "" {
            selecteddate = (self.vwSoonPlanning?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
        }
        
        ActionSheetDatePicker.show(withTitle: "Select Date", datePickerMode: .date, selectedDate: selecteddate, minimumDate: Date(), maximumDate: nil, doneBlock: { (picker, indexes, values) in
            
            self.vwSoonPlanning?.txtInput.text = (indexes as? Date ?? Date()).getFormattedString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
            self.PlanningSoonDate = (indexes as? Date ?? Date())
            return
        }, cancel: { (actiosheet) in
            return
        }, origin: btn)
    }
}

//MARK: - Validation
extension SignupPersonalDetailViewController: ListCommonDataDelegate {
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel,selectIndex : Int) {
        
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        
    }
    
    func selectDisabilitiesData(obj: WorkDisabilitiesWillingTypeModel) {
        
    }
    
    func selectHearAboutData(obj: HearAboutUsModel) {
        self.selectedHearAboutData = obj
        self.vwHereAboutUs?.txtInput.text = obj.name
    }
    
    func selectCertificateTypeData(obj: licenceTypeModel,selectIndex : Int) {
        
    }
    
    func selectLovedDisabilitiesData(obj: LovedDisabilitiesTypeModel,selectIndex : Int) {
        
    }
}

//MARK: - Validation
extension SignupPersonalDetailViewController {
    private func validateFields() -> String? {
        if self.vwFirstName?.txtInput.isEmpty ?? false{
            self.vwFirstName?.txtInput.becomeFirstResponder()
            self.vwFirstName?.isSetFocusTextField = true
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kFirstName
        } else if self.vwLastName?.txtInput.isEmpty ?? false{
            self.vwLastName?.txtInput.becomeFirstResponder()
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = true
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kLastName
        } /*else if self.vwAge?.txtInput.isEmpty ?? false {
            self.vwAge?.txtInput.becomeFirstResponder()
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kvalidPassword
        }*/ else if self.vwPhoneNUmber?.txtInput.isEmpty ?? false {
            self.vwPhoneNUmber?.txtInput?.becomeFirstResponder()
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = true
            self.vwAge?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kPhoneNumber
        } else if !(self.vwPhoneNUmber?.txtInput.isValidContactPhoneno() ?? false) {
            self.vwPhoneNUmber?.txtInput?.becomeFirstResponder()
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = true
            self.vwAge?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kInValidPhoneNo
        } else if (self.vwSoonPlanning?.txtInput.isEmpty ?? false) && !self.isFromEditProfile {
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kSelectPlanningSoon
        } else {
            return nil
        }
    }
}

//MARK : - UITextFieldDelegate
extension SignupPersonalDetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwFirstName?.txtInput:
            self.vwFirstName?.txtInput.resignFirstResponder()
            self.vwLastName?.txtInput.becomeFirstResponder()
        case self.vwLastName?.txtInput:
            self.vwLastName?.txtInput.resignFirstResponder()
            self.vwAge?.txtInput.becomeFirstResponder()
        case self.vwAge?.txtInput:
            self.vwAge?.txtInput.resignFirstResponder()
            self.vwPhoneNUmber?.txtInput.becomeFirstResponder()
        case self.vwPhoneNUmber?.txtInput:
            self.vwPhoneNUmber?.txtInput.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwFirstName?.txtInput:
            self.vwFirstName?.isSetFocusTextField = true
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
        case self.vwLastName?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = true
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
        case self.vwAge?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = true
        case self.vwPhoneNUmber?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = true
            self.vwAge?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwFirstName?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = true
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
        case self.vwLastName?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = true
        case self.vwAge?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = true
            self.vwAge?.isSetFocusTextField = false
        case self.vwPhoneNUmber?.txtInput:
            self.vwFirstName?.isSetFocusTextField = false
            self.vwLastName?.isSetFocusTextField = false
            self.vwPhoneNUmber?.isSetFocusTextField = false
            self.vwAge?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .phonePad  && textField == self.vwPhoneNUmber?.txtInput{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: Masking.kUSPhoneNumberMasking, phone: newString)
            self.vwPhoneNUmber?.ShowRightLabelView = !(self.vwPhoneNUmber?.txtInput.isEmpty ?? false)
            return false
        }
        return true
    }
    
    @objc func textChange(_ sender : UITextField){
        switch sender {
        case self.vwFirstName?.txtInput:
            self.vwFirstName?.ShowRightLabelView = !(self.vwFirstName?.txtInput.isEmpty ?? false)
        case self.vwLastName?.txtInput:
            self.vwLastName?.ShowRightLabelView = !(self.vwLastName?.txtInput.isEmpty ?? false)
        /*case self.vwAge?.txtInput:
            self.vwAge?.ShowRightLabelView = !(self.vwAge?.txtInput.isEmpty ?? false)
        case self.vwPhoneNUmber?.txtInput:
            self.vwPhoneNUmber?.ShowRightLabelView = !(self.vwPhoneNUmber?.txtInput.isEmpty ?? false)*/
        default:
            break
        }
    }
}

// MARK: - API Call
extension SignupPersonalDetailViewController {
    
    private func mediaAPICall(img : UIImage) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadMedia(with: dict, image: img, success: { (msg) in
            self.mediaName = msg
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func savePersonalInfo(){
        if let user = UserModel.getCurrentUserFromDefault() {
            let phoneData : String = self.vwPhoneNUmber?.txtInput.text?.removeSpecialCharsFromString ?? ""
            var selectgender : String = "3"
            if (self.btnMale?.isSelectBtn ?? false) {
                selectgender = "1"
            } else if (self.btnFeMale?.isSelectBtn ?? false) {
                selectgender = "2"
            }
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kFirstName : self.vwFirstName?.txtInput.text ?? "",
                kLastName : self.vwLastName?.txtInput.text ?? "",
                kgender : selectgender,
                kage : self.vwAge?.txtInput.text ?? "",
                kphone : phoneData,
                kfamilyVaccinated : (self.btnFamilyVaccinatedYes?.isSelectBtn ?? false) ? "1" : "2",
                khearAboutUsId : self.selectedHearAboutData?.hearAboutUsId ?? "",
                //kprofileStatus : "2",
                kimage : self.mediaName
            ]
            
            if !self.isFromEditProfile {
                dict[kprofileStatus] = "2"
                if let date = self.PlanningSoonDate {
                    dict[ksoonPlanningHireDate] = date.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                }
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.savePersonalDetails(with: param, success: { (model, msg) in
                if self.isFromEditProfile {
                    self.appNavigationController?.popViewController(animated: true)
                } else {
                    self.appNavigationController?.push(SignupAboutYourLoveViewController.self,configuration: { vc in
                        //vc.isMoveAnoherVC = false
                    })
                }
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
extension SignupPersonalDetailViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignupPersonalDetailViewController: AppNavigationControllerInteractable { }
