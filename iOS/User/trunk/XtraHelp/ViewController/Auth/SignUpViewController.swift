//
//  SignUpViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 13/08/21.
//

import UIKit

class SignUpViewController: UIViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblConnect: UILabel?
    
    @IBOutlet weak var lblTermCondition: FRHyperLabel?
    
    @IBOutlet weak var vwName: ReusableView?
    @IBOutlet weak var vwEmail: ReusableView?
    @IBOutlet weak var vwPassword: ReusableView?
    @IBOutlet weak var vwRePassword: ReusableView?
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var btnLogin: UIButton?
    
    @IBOutlet weak var btnAlreadyMember: UIButton?
    
    // MARK: - Variables
    var isPassword = false
    
    private var lat_currnt : Double = 0.0
    private var long_currnt : Double = 0.0
    private var locationname : String = ""
    
    private var socilalogin = SocialLoginManager()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        self.InitConfig()
    }
    
    @IBAction func clickToLogin(_ sender: Any){
        self.appNavigationController?.push(LoginViewController.self)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        
        delay(seconds: 0.2) {
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                self.lat_currnt = coordinate.latitude
                self.long_currnt = coordinate.longitude
                XtraHelp.sharedInstance.getAddressFromLatLong(lat: coordinate.latitude, long: coordinate.longitude) { address, country, state, city, street, zipcode in
                    self.locationname = address
                }
            }
        }
    }
   
    
}

// MARK: - Init Configure
extension SignUpViewController {
    private func InitConfig(){
        
        self.socilalogin.viewController = self
        self.socilalogin.appnavigationcontroller = self.appNavigationController
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 28.0))
        self.lblHeader?.textColor = UIColor.CustomColor.textHedareLogin
        
        self.lblConnect?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        self.lblConnect?.textColor = UIColor.CustomColor.textConnectLogin
        
        self.btnAlreadyMember?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        self.btnAlreadyMember?.setTitleColor(UIColor.CustomColor.whitecolor, for: .normal)
        
        self.lblTermCondition?.setTermConditionAttributedTextLable(firstText: "By Signing Up, you are agree to our \n", SecondText: "Terms & Conditions")
        /*self.lblTermCondition?.isUserInteractionEnabled = true
        self.lblTermCondition?.clearActionDictionary()
        let termsAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.forgotColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))]
        self.lblTermCondition?.setLinkForSubstring("Terms & Conditions", withAttribute: termsAttributes) { (lbl, str) in
            if str == "Terms & Conditions" {
                print("Clicked")
//                self.appNavigationController?.push(terms.self)
            }
        }*/
        
        [self.vwName,self.vwEmail,self.vwPassword,self.vwRePassword].forEach({
            $0?.txtInput.delegate = self
            $0?.txtInput.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            $0?.reusableViewDelegate = self
        })
        
        self.vwPassword?.btnRightSelect.tag = 0
        self.vwRePassword?.btnRightSelect.tag = 1
        
        self.vwName?.txtInput.autocapitalizationType = .words
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerLogin(btntitle: "", btnTitleColor: UIColor.CustomColor.whitecolor, navigationItem: self.navigationItem)//appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.whitecolor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.clear, tintColor: UIColor.CustomColor.borderColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - ReusableViewDelegate
extension SignUpViewController:ReusableViewDelegate{
    func buttonClicked(_ sender: UIButton) {
        
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if !(self.vwPassword?.btnRightSelect.isSelected ?? false) {
                self.vwPassword?.RightImage = UIImage(named: "Password") ?? UIImage()
                self.vwPassword?.isShowPassword = true
            }else{
                self.vwPassword?.RightImage = UIImage(named: "password_visble") ?? UIImage()
                self.vwPassword?.isShowPassword = false
            }
            self.vwPassword?.btnRightSelect.isSelected = !(self.vwPassword?.btnRightSelect.isSelected ?? false)
        }else{
            if !(self.vwRePassword?.btnRightSelect.isSelected ?? false) {
                self.vwRePassword?.RightImage = UIImage(named: "Password") ?? UIImage()
                self.vwRePassword?.isShowPassword = true
            }else{
                self.vwRePassword?.RightImage = UIImage(named: "password_visble") ?? UIImage()
                self.vwRePassword?.isShowPassword = false
            }
            self.vwRePassword?.btnRightSelect.isSelected = !(self.vwRePassword?.btnRightSelect.isSelected ?? false)
        }
    }
}

// MARK: - IBAction
extension SignUpViewController {
    
    @IBAction func btnLoginClicked(_ sender: NextRoundButton) {
        self.appNavigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignupClicked(_ sender: Any){
        /*self.appNavigationController?.push(VerificationViewController.self,configuration: { vc in
            vc.isFromSignup = true
        })*/
        //self.appNavigationController?.push(SignupPersonalDetailViewController.self)
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        self.SignUpAPICall()
    }
    
    @IBAction func btnTermConditionClicked(_ sender: Any){
        self.appNavigationController?.push(TermConditionViewController.self,configuration: { vc in
            vc.pageid = .TermCondition
        })
    }
    
    @IBAction func btnFBClicked(_ sender: UIButton){
        self.socilalogin.loginWithFacebook()
    }
    @IBAction func btnTwitterClicked(_ sender: UIButton){
        self.socilalogin.loginTwitter()
    }
    @IBAction func btnGoogleClicked(_ sender: UIButton){
        self.socilalogin.loginWithGoogle()
    }
    @IBAction func btnAppleClicked(_ sender: UIButton){
        self.socilalogin.loginWithApple()
    }
    @IBAction func btnLinkdnClicked(_ sender: UIButton){
        self.appNavigationController?.push(LinkedinManagerViewController.self,configuration: { (vc) in
            vc.delegate = self
        })
    }
}

//MARK: - Validation
extension SignUpViewController {
    private func validateFields() -> String? {
        
        let components = (self.vwName?.txtInput?.text ?? "").components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        
        if self.vwName?.txtInput.isEmpty ?? false{
            self.vwName?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = true
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyName
        } else if words.count < 2 {
            self.vwName?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = true
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyFullName
        } else if self.vwEmail?.txtInput.isEmpty ?? false {
            self.vwEmail?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyEmail
        } else if !(self.vwEmail?.txtInput.isValidEmail() ?? false){
            self.vwEmail?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kInValidEmail
        } else if self.vwPassword?.txtInput.isEmpty ?? false {
            self.vwPassword?.txtInput?.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyPassword
        } else if (self.vwPassword?.txtInput.text ?? "").count < 8 || (self.vwPassword?.txtInput.text ?? "").count > 15 {
            self.vwPassword?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kvalidPassword
        } else if !(self.vwPassword?.txtInput?.isValidPassword() ?? false) {
            self.vwPassword?.txtInput?.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwRePassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kStrongValidPassword
        } else if self.vwRePassword?.txtInput.isEmpty ?? false {
            self.vwRePassword?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kEmptyConfirmPassword
        } else if self.vwPassword?.txtInput.text != self.vwRePassword?.txtInput.text {
            self.vwRePassword?.txtInput.becomeFirstResponder()
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kDontMatchPassword
        } else {
            return nil
        }
    }
}


//MARK : - UITextFieldDelegate
extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwName?.txtInput:
            self.vwName?.txtInput.resignFirstResponder()
            self.vwEmail?.txtInput.becomeFirstResponder()
        case self.vwEmail?.txtInput:
            self.vwEmail?.txtInput.resignFirstResponder()
            self.vwPassword?.txtInput.becomeFirstResponder()
        case self.vwPassword?.txtInput:
            self.vwPassword?.txtInput.resignFirstResponder()
            self.vwRePassword?.txtInput.becomeFirstResponder()
        case self.vwRePassword?.txtInput:
            self.vwRePassword?.txtInput.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwName?.txtInput:
            self.vwName?.isSetFocusTextField = true
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
        case self.vwEmail?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
        case self.vwPassword?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwRePassword?.isSetFocusTextField = false
        case self.vwRePassword?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = true
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwName?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
        case self.vwEmail?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwRePassword?.isSetFocusTextField = false
        case self.vwPassword?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = true
        case self.vwRePassword?.txtInput:
            self.vwName?.isSetFocusTextField = false
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwRePassword?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    @objc func textChange(_ sender : UITextField){
        switch sender {
        case self.vwName?.txtInput:
            self.vwName?.ShowRightLabelView = !(self.vwName?.txtInput.isEmpty ?? false)
        case self.vwEmail?.txtInput:
            self.vwEmail?.ShowRightLabelView = !(self.vwEmail?.txtInput.isEmpty ?? false)
        default:
            break
        }
    }
}

// MARK: - LinkedinDelegate
extension SignUpViewController : LinkedinDelegate {
    func linkeDinData(firstname: String, lastname: String, email: String, profile: String, linkedinID: String) {
        self.socialLoginAPICall(firstname: firstname, lastname: lastname, email: email, authProvider: "linkedin", socialuserid: linkedinID)
    }
}

//MARK : - API Call
extension SignUpViewController{
    
    func SignUpAPICall() {
        self.view.endEditing(true)
        
        let dict : [String:Any] = [
            kEmail : self.vwEmail?.txtInput.text ?? "",
            kpassword : self.vwPassword?.txtInput.text ?? "",
            kname : self.vwName?.txtInput.text ?? "",
            klangType : XtraHelp.sharedInstance.languageType,
            kdeviceToken : UserDefaults.setDeviceToken,
            krole : XtraHelp.sharedInstance.userRole,
            kdeviceType : AppConstant.deviceType
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.registerUser(withParam: param, success: { (user, msg) in
           
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if statuscode == APIStatusCode.verifyAcccout.rawValue {
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(VerificationViewController.self,configuration: { (vc) in
                    vc.userEmail = self.vwEmail?.txtInput.text ?? ""
                    vc.isFromSignup = true
                })
            } else {
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                }
            }
        })
    }
    
    private func socialLoginAPICall(firstname : String,lastname : String,email : String,authProvider : String,socialuserid : String){
        
        let dict : [String:Any] = [
            kauth_id : socialuserid,
            kauth_provider : authProvider,
            kdeviceToken : UserDefaults.setDeviceToken,
            klangType : XtraHelp.sharedInstance.languageType,
            kdeviceType : XtraHelp.sharedInstance.DeviceType,
            kdeviceId : XtraHelp.sharedInstance.deviceID,
            ktimeZone : XtraHelp.sharedInstance.localTimeZoneIdentifier,
            kEmail : email,
            krole : XtraHelp.sharedInstance.userRole,
            kisManualEmail : "0",
            kFirstName : firstname,
            kLastName :lastname,
            klocation : self.locationname,
            klatitude : "\(self.lat_currnt)",
            klongitude : "\(self.long_currnt)"
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.userSocialLogin(with: param, success: { (user, msg) in
           
            UserDefaults.isUserLogin = true
            
            if user.profileStatus == .Default || user.profileStatus == .Subscription{
                /*self.appNavigationController?.push(MembershipViewController.self,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .Subscription {*/
                self.appNavigationController?.push(SignupPersonalDetailViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .PersonalDetails {
                self.appNavigationController?.push(SignupAboutYourLoveViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .AboutYouLoveOne {
                self.appNavigationController?.push(SignupLocationViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else{
                WebSocketChat.shared.connectSocket()
                self.appNavigationController?.showDashBoardViewController()
            }
           
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if statuscode == APIStatusCode.verifyAcccout.rawValue {
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(VerificationViewController.self,configuration: { (vc) in
                    vc.userEmail = email
                    vc.isFromSignup = true
                })
            } else {
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            }
        })
    }
}

// MARK: - ViewControllerDescribable
extension SignUpViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable
    {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignUpViewController: AppNavigationControllerInteractable { }

