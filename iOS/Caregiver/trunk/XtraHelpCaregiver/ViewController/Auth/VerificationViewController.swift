//
//  VerificationViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 14/08/21.
//

import UIKit

protocol verificationDelegate {
    func verifyJobCode(jobdata : JobModel)
}

class VerificationViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet weak var lblResend: UILabel?
   
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    
    @IBOutlet weak var btnResend: UIButton?
    @IBOutlet weak var vwOTP: DPOTPView?
   
    @IBOutlet weak var vwBottomSubView: UIView?
    @IBOutlet weak var vwResendMain: UIView?
    
    // MARK: - Variables
    var userEmail : String = ""
    var isFromSignup : Bool = false
    
    private var verificationCode : String = ""
    var isFromForgotPassword : Bool = false
    
    var isFromjobStart : Bool = false
    var selectedJobData : JobModel?
    var delegate : verificationDelegate?
    
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
extension VerificationViewController
{
    private func InitConfig() {
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        self.lblSubHeader?.textColor = UIColor.CustomColor.textConnectLogin
        
        self.lblResend?.textColor = UIColor.CustomColor.ResendButtonColor
        self.lblResend?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwResendMain?.isHidden = self.isFromjobStart
        
        if self.isFromjobStart {
            self.lblSubHeader?.text = "We have sent you OTP on your registered email address. You can also ask for the OTP directly from your job provider"
        }
        
        self.setupOtpView()
    }
    
    private func setupOtpView(){
        self.vwOTP?.placeholder = ""
        self.vwOTP?.count = 4
        self.vwOTP?.spacing = 20.0
        self.vwOTP?.fontTextField = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 28.0))
        self.vwOTP?.dismissOnLastEntry = true
        self.vwOTP?.isBottomLineTextField = true
        self.vwOTP?.placeholderTextColor = UIColor.CustomColor.verificationTextColor
        self.vwOTP?.isCursorHidden = false
        self.vwOTP?.textColorTextField = UIColor.CustomColor.verificationTextColor
        self.vwOTP?.selectedBorderWidthTextField = 2
        self.vwOTP?.selectedBorderColorTextField = UIColor.CustomColor.verificationTextColor
        self.vwOTP?.borderColorTextField = UIColor.CustomColor.verificationTextColor
        self.vwOTP?.borderWidthTextField = 2
        self.vwOTP?.tintColorTextField = UIColor.CustomColor.verificationTextColor
        self.vwOTP?.dpOTPViewDelegate = self
        self.vwOTP?.tintColor = UIColor.CustomColor.verificationTextColor
        self.vwOTP?.becomeFirstResponder()
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

// MARK: - OTPFieldView Delegate
extension VerificationViewController : DPOTPViewDelegate {
   func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
        self.verificationCode = text.count == 4 ? text : ""
       print("Verification Text : \(self.verificationCode)")
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
        self.verificationCode = text.count == 4 ? text : ""
        print("Verification Text : \(self.verificationCode)")
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}

// MARK: - IBAction
extension VerificationViewController {
    @IBAction func btnResendClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isFromForgotPassword {
            self.forgotpasswordAPICall()
        } else {
            self.resendVerificationAPICall()
        }
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage, themeStyle: .warning,presentationStyle: .top)
            return
        }
        if self.isFromjobStart {
            self.verifyJobVerificationCodeAPICall()
        } else {
            if self.isFromSignup {
                self.verificationAPICall()
                //self.appNavigationController?.push(MembershipViewController.self)
            } else {
                //self.appNavigationController?.push(ChangePasswordVC.self)
                self.checkForgotPasswordVerificationAPICall()
            }
        }
    }
  
}

//MARK : - API Call
extension VerificationViewController {
    
    private func validateFields() -> String? {
        if self.verificationCode.isEmpty {
            return AppConstant.ValidationMessages.kEmptyValidationCode
        } else {
            return nil
        }
    }
    
    private func verificationAPICall() {
        
        let dict : [String:Any] = [
            kdeviceId : XtraHelp.sharedInstance.deviceID,
            ktimeZone : XtraHelp.sharedInstance.localTimeZoneIdentifier,
            klangType : XtraHelp.sharedInstance.languageType,
            kdeviceType : XtraHelp.sharedInstance.DeviceType,
            krole : XtraHelp.sharedInstance.userRole,
            kEmail : self.userEmail,
            kdeviceToken : UserDefaults.setDeviceToken,
            kverificationCode : self.verificationCode
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.verifyCode(with: param, success: { (user, msg) in
            self.appNavigationController?.detachLeftSideMenu()
            /*self.appNavigationController?.push(MembershipViewController.self, configuration: { vc in
                vc.isFromLogin = true
            })*/
            self.appNavigationController?.push(SignupPersonalDetailViewController.self,configuration: { (vc) in
                vc.isFromLogin = true
            })
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
                //self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })
    }
    
    private func checkForgotPasswordVerificationAPICall() {
        
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType,
            kverificationCode : self.verificationCode,
            krole : XtraHelp.sharedInstance.userRole,
            kEmail : self.userEmail
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.checkforgotVerificationCode(with: param, success: { (msg) in
            self.appNavigationController?.push(ChangePasswordVC.self,configuration: { (vc) in
                vc.userEmail = self.userEmail
                vc.isFromForgotPassword = self.isFromForgotPassword
            })
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
                //self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })
    }
    
    private func forgotpasswordAPICall() {
       
        let dict : [String:Any] = [
            kEmail : self.userEmail,
            klangType : XtraHelp.sharedInstance.languageType,
            krole : XtraHelp.sharedInstance.userRole
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.forgotPassword(with: param, success: { (msg) in
            //self.showAlert(with: msg)
            self.showMessage(msg, themeStyle: .success)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
                //self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })
    }
    
    private func resendVerificationAPICall() {
        
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType,
            krole : XtraHelp.sharedInstance.userRole,
            kEmail : self.userEmail
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.resendVerificationCode(with: param, success: { (msg) in
            //self.showAlert(with: msg)
            self.showMessage(msg, themeStyle: .success)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
                //self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })
    }
    
    private func verifyJobVerificationCodeAPICall() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                kverificationCode : self.verificationCode,
                ktoken : user.token,
                kjobId : jobdata.userJobId,
                kuserJobDetailId : jobdata.userJobDetailId
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.verifyJobVerificationCode(with: param, success: { (jobdata,msg) in
                self.navigationController?.popViewController(animated: false)
                self.delegate?.verifyJobCode(jobdata: jobdata)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension VerificationViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension VerificationViewController: AppNavigationControllerInteractable { }
