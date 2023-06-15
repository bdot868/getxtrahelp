//
//  ChangePasswordVC.swift
//  XtraHelp
//
//  Created by DeviOS1 on 16/09/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var vwOldPass: ReusableView?
    @IBOutlet weak var vwPassword: ReusableView?
    @IBOutlet weak var vwConfirmNewPass: ReusableView?
    
    @IBOutlet weak var btnUpdate: XtraHelpButton?
    
    // MARK: - Variables
    var userEmail : String = ""
    var isFromForgotPassword : Bool = false
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.configureNavigationBar()
    }

    @IBAction func btnSetPasswordClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        if self.isFromForgotPassword {
            self.recoverpasswordAPICall()
        } else {
            self.changePasswordAPICall()
        }
       // self.appNavigationController?.showLoginViewController(animationType: .fromRight, configuration: nil)
    }
}

// MARK: - Init Configure
extension ChangePasswordVC {
    
    private func InitConfig(){
        
        self.vwOldPass?.isHidden = self.isFromForgotPassword
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        self.lblSubHeader?.textColor = UIColor.CustomColor.textConnectLogin
        
        [self.vwOldPass,self.vwPassword,self.vwConfirmNewPass].forEach({
            $0?.txtInput.delegate = self
            $0?.txtInput.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            $0?.reusableViewDelegate = self
        })
        
        self.vwPassword?.btnRightSelect.tag = 0
        self.vwPassword?.btnRightSelect.tag = 1
        self.vwConfirmNewPass?.btnRightSelect.tag = 2
    
    }
    
    private func configureNavigationBar(){
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - ReusableViewDelegate
extension ChangePasswordVC:ReusableViewDelegate{
    func buttonClicked(_ sender: UIButton) {
        
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if !(self.vwOldPass?.btnRightSelect.isSelected ?? false) {
                self.vwOldPass?.RightImage = UIImage(named: "Password") ?? UIImage()
                self.vwOldPass?.isShowPassword = true
            }else{
                self.vwOldPass?.RightImage = UIImage(named: "password_visble") ?? UIImage()
                self.vwOldPass?.isShowPassword = false
            }
            self.vwOldPass?.btnRightSelect.isSelected = !(self.vwOldPass?.btnRightSelect.isSelected ?? false)
        } else if sender.tag == 1 {
            if !(self.vwPassword?.btnRightSelect.isSelected ?? false) {
                self.vwPassword?.RightImage = UIImage(named: "Password") ?? UIImage()
                self.vwPassword?.isShowPassword = true
            }else{
                self.vwPassword?.RightImage = UIImage(named: "password_visble") ?? UIImage()
                self.vwPassword?.isShowPassword = false
            }
            self.vwPassword?.btnRightSelect.isSelected = !(self.vwPassword?.btnRightSelect.isSelected ?? false)
        }else{
            if !(self.vwConfirmNewPass?.btnRightSelect.isSelected ?? false) {
                self.vwConfirmNewPass?.RightImage = UIImage(named: "Password") ?? UIImage()
                self.vwConfirmNewPass?.isShowPassword = true
            }else{
                self.vwConfirmNewPass?.RightImage = UIImage(named: "password_visble") ?? UIImage()
                self.vwConfirmNewPass?.isShowPassword = false
            }
            self.vwConfirmNewPass?.btnRightSelect.isSelected = !(self.vwConfirmNewPass?.btnRightSelect.isSelected ?? false)
        }
    }
}

//MARK: - Validation
extension ChangePasswordVC {
    private func validateFields() -> String? {
        if (self.vwOldPass?.txtInput.isEmpty ?? false) && !self.isFromForgotPassword {
            self.vwOldPass?.txtInput?.becomeFirstResponder()
            self.vwOldPass?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = false
            return "Please enter current password"//AppConstant.ValidationMessages.KOldPassword
        } else if ((self.vwOldPass?.txtInput.text ?? "").count < 8 || (self.vwOldPass?.txtInput.text ?? "").count > 15) && !self.isFromForgotPassword {
            self.vwOldPass?.txtInput?.becomeFirstResponder()
            self.vwOldPass?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = false
            return "current password must be 8 to 15 character"//AppConstant.ValidationMessages.kOldPAsswordInvalid
        } else if self.vwPassword?.txtInput.isEmpty ?? false {
            self.vwPassword?.txtInput?.becomeFirstResponder()
            self.vwPassword?.isSetFocusTextField = true
            self.vwConfirmNewPass?.isSetFocusTextField = false
            self.vwOldPass?.isSetFocusTextField = false
            return "Please enter new password"//AppConstant.ValidationMessages.kEmptyPassword
        } else if (self.vwPassword?.txtInput.text ?? "").count < 8 || (self.vwPassword?.txtInput.text ?? "").count > 15 {
            self.vwPassword?.txtInput.becomeFirstResponder()
            self.vwPassword?.isSetFocusTextField = true
            self.vwConfirmNewPass?.isSetFocusTextField = false
            self.vwOldPass?.isSetFocusTextField = false
            return "New password must be 8 to 15 character"//AppConstant.ValidationMessages.kvalidPassword
        } else if !(self.vwPassword?.txtInput?.isValidPassword() ?? false) {
            self.vwPassword?.txtInput?.becomeFirstResponder()
            self.vwPassword?.txtInput?.becomeFirstResponder()
            self.vwOldPass?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kStrongValidPassword
        } else if self.vwConfirmNewPass?.txtInput.isEmpty ?? false {
            self.vwConfirmNewPass?.txtInput.becomeFirstResponder()
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = true
            self.vwOldPass?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyConfirmPassword
        } else if self.vwPassword?.txtInput.text != self.vwConfirmNewPass?.txtInput.text {
            self.vwConfirmNewPass?.txtInput.becomeFirstResponder()
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = true
            self.vwOldPass?.isSetFocusTextField = false
            return "New password and confirm password do not match"//AppConstant.ValidationMessages.kDontMatchPassword
        } else {
            return nil
        }
    }
}


//MARK : - UITextFieldDelegate
extension ChangePasswordVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwOldPass?.txtInput:
            self.vwOldPass?.txtInput.resignFirstResponder()
            self.vwPassword?.txtInput.becomeFirstResponder()
        case self.vwPassword?.txtInput:
            self.vwPassword?.txtInput.resignFirstResponder()
            self.vwConfirmNewPass?.txtInput.becomeFirstResponder()
        case self.vwConfirmNewPass?.txtInput:
            self.vwConfirmNewPass?.txtInput.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwOldPass?.txtInput:
            self.vwOldPass?.isSetFocusTextField = true
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = false
        case self.vwPassword?.txtInput:
            self.vwOldPass?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwConfirmNewPass?.isSetFocusTextField = false
        case self.vwConfirmNewPass?.txtInput:
            self.vwOldPass?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = true
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwOldPass?.txtInput:
            self.vwOldPass?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = true
            self.vwConfirmNewPass?.isSetFocusTextField = false
        case self.vwPassword?.txtInput:
            self.vwOldPass?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = true
        case self.vwConfirmNewPass?.txtInput:
            self.vwOldPass?.isSetFocusTextField = false
            self.vwPassword?.isSetFocusTextField = false
            self.vwConfirmNewPass?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    @objc func textChange(_ sender : UITextField){
    }
}

extension ChangePasswordVC {
    private func recoverpasswordAPICall() {
        
        let dict : [String:Any] = [
            kEmail : self.userEmail,
            klangType : XtraHelp.sharedInstance.languageType,
            KnewPassword : self.vwPassword?.txtInput.text ?? "",
            krole : XtraHelp.sharedInstance.userRole
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.resetPassword(with: param, success: { (msg) in
            self.appNavigationController?.showLoginViewController(animationType: .fromRight, configuration: nil)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(errorType.rawValue, themeStyle: .error)
            }
        })
    }
    
    private func changePasswordAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                ktoken : user.token,
                kEmail : self.userEmail,
                klangType : XtraHelp.sharedInstance.languageType,
                KoldPassword : self.vwOldPass?.txtInput.text ?? "",
                KnewPassword : self.vwPassword?.txtInput.text ?? ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserModel.changePassword(with: param, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                self.appNavigationController?.popViewController(animated: true)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension ChangePasswordVC: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension ChangePasswordVC: AppNavigationControllerInteractable { }
