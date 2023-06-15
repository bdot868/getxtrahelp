//
//  LoginViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 13/08/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblConnect: UILabel?
    @IBOutlet weak var subView: UIView?
    
    @IBOutlet weak var vwEmail: ReusableView?
    @IBOutlet weak var vwPassword: ReusableView?
    
    @IBOutlet weak var btnSignup: UIButton?
    @IBOutlet weak var btnForgotPassword: UIButton?
    @IBOutlet weak var btnLogin: XtraHelpButton?
    
    // MARK: - Variables
    private var lat_currnt : Double = 0.0
    private var long_currnt : Double = 0.0
    private var locationname : String = ""
    
    private var socilalogin = SocialLoginManager()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
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
extension LoginViewController {
    private func InitConfig(){
        
        self.socilalogin.viewController = self
        self.socilalogin.appnavigationcontroller = self.appNavigationController
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 28.0))
        self.lblHeader?.textColor = UIColor.CustomColor.textHedareLogin
        
        self.lblConnect?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        self.lblConnect?.textColor = UIColor.CustomColor.textConnectLogin
        
        self.btnForgotPassword?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.btnForgotPassword?.setTitleColor(UIColor.CustomColor.forgotColor, for: .normal)
        
        self.btnSignup?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        self.btnSignup?.setTitleColor(UIColor.CustomColor.textConnectLogin, for: .normal)
        
        [self.vwEmail,self.vwPassword].forEach({
            $0?.txtInput.delegate = self
            $0?.txtInput.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            $0?.reusableViewDelegate = self
        })
        
    }
}

// MARK: - ReusableViewDelegate
extension LoginViewController:ReusableViewDelegate{
    func buttonClicked(_ sender: UIButton) {
        
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        if !(self.vwPassword?.btnRightSelect.isSelected ?? false) {
            self.vwPassword?.RightImage = UIImage(named: "Password") ?? UIImage()
            self.vwPassword?.isShowPassword = true
        }else{
            self.vwPassword?.RightImage = UIImage(named: "password_visble") ?? UIImage()
            self.vwPassword?.isShowPassword = false
        }
        self.vwPassword?.btnRightSelect.isSelected = !(self.vwPassword?.btnRightSelect.isSelected ?? false)
    }
}

//MARK: - Validation
extension LoginViewController {
    private func validateFields() -> String? {
        if self.vwEmail?.txtInput.isEmpty ?? false {
            self.vwEmail?.txtInput.becomeFirstResponder()
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyEmail
        } else if !(self.vwEmail?.txtInput.isValidEmail() ?? false){
            self.vwEmail?.txtInput.becomeFirstResponder()
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kInValidEmail
        } else if self.vwPassword?.txtInput.isEmpty ?? false {
            self.vwPassword?.txtInput?.becomeFirstResponder()
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kEmptyPassword
        } else if (self.vwPassword?.txtInput.text ?? "").count < 8 || (self.vwPassword?.txtInput.text ?? "").count > 15 {
            self.vwPassword?.txtInput.becomeFirstResponder()
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kvalidPassword
        } else {
            return nil
        }
    }
}


//MARK : - UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwEmail?.txtInput:
            self.vwEmail?.txtInput.resignFirstResponder()
            self.vwPassword?.txtInput.becomeFirstResponder()
        case self.vwPassword?.txtInput:
            self.vwPassword?.txtInput.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwEmail?.txtInput:
            self.vwEmail?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
        case self.vwPassword?.txtInput:
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwEmail?.txtInput:
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
        case self.vwPassword?.txtInput:
            self.vwEmail?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    @objc func textChange(_ sender : UITextField){
        switch sender {
        case self.vwEmail?.txtInput:
            self.vwEmail?.ShowRightLabelView = !(self.vwEmail?.txtInput.isEmpty ?? false)
        default:
            break
        }
    }
}

// MARK: - IBAction
extension LoginViewController {
    @IBAction func btnSingupClicked(_ sender: UIButton){
        self.appNavigationController?.push(SignUpViewController.self)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton){
        self.appNavigationController?.push(ForgotPasswordViewController.self)
    }
    
    @IBAction func btnLoginClicked(_ sender: NextRoundButton) {
        //self.appNavigationController?.push(JobSuccessViewController.self)
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        self.signinAPICall()
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

// MARK: - LinkedinDelegate
extension LoginViewController : LinkedinDelegate {
    func linkeDinData(firstname: String, lastname: String, email: String, profile: String, linkedinID: String) {
        self.socialLoginAPICall(firstname: firstname, lastname: lastname, email: email, authProvider: "linkedin", socialuserid: linkedinID)
    }
}

// MARK: - API Call
extension LoginViewController {
    private func signinAPICall() {
        
        let dict : [String:Any] = [
            kEmail : self.vwEmail?.txtInput.text ?? "",
            kpassword : self.vwPassword?.txtInput.text ?? "",
            klangType : XtraHelp.sharedInstance.languageType,
            krole : XtraHelp.sharedInstance.userRole,
            kdeviceToken : UserDefaults.setDeviceToken,
            kdeviceType : XtraHelp.sharedInstance.DeviceType,
            ktimeZone : XtraHelp.sharedInstance.localTimeZoneIdentifier,
            kdeviceId: XtraHelp.sharedInstance.deviceID,
            klatitude : "\(lat_currnt)",
            klongitude : "\(long_currnt)"
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.userLogin(with: param, success: { (user, msg) in
            
            print("User Token : \(user.token)")
            //self.showMessage(msg, themeStyle: .success)
            UserDefaults.isUserLogin = true
            UserDefaults.isShowCreateJobTutorial = true
            //WebSocketChat.shared.connectSocket()
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
                //appDelegate.updateVOIPToken(token: "")
                self.appNavigationController?.showDashBoardViewController()
            }
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
extension LoginViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension LoginViewController: AppNavigationControllerInteractable { }
