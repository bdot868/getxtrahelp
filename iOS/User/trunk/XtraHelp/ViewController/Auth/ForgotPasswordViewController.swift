//
//  ForgotPasswordViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 13/08/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController
{

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var vwEmail: ReusableView?
    
    @IBOutlet weak var btnResend: UIButton?
    // MARK: - Variables
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
}

// MARK: - Init Configure
extension ForgotPasswordViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        self.lblSubHeader?.textColor = UIColor.CustomColor.textConnectLogin
        
        self.btnResend?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.btnResend?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        [self.vwEmail].forEach({
            $0?.txtInput.delegate = self
            $0?.txtInput.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            $0?.txtInput.keyboardType = .emailAddress
        })
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

// MARK: - IBAction
extension ForgotPasswordViewController {
    @IBAction func btnResetClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(VerificationViewController.self)
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        self.forgotpasswordAPICall()
    }
}

//MARK: - Validation
extension ForgotPasswordViewController {
    private func validateFields() -> String? {
        if self.vwEmail?.txtInput.isEmpty ?? false {
            self.vwEmail?.txtInput.becomeFirstResponder()
            self.vwEmail?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kEmptyEmail
        } else if !(self.vwEmail?.txtInput.isValidEmail() ?? false){
            self.vwEmail?.txtInput.becomeFirstResponder()
            self.vwEmail?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kInValidEmail
        } else {
            return nil
        }
    }
}


//MARK : - UITextFieldDelegate
extension ForgotPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwEmail?.txtInput:
            self.vwEmail?.txtInput.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwEmail?.txtInput:
            self.vwEmail?.isSetFocusTextField = true
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwEmail?.txtInput:
            self.vwEmail?.isSetFocusTextField = false
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

//MARK : - API
extension ForgotPasswordViewController {
    
    private func forgotpasswordAPICall() {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage)
            return
        }
        let dict : [String:Any] = [
            kEmail : self.vwEmail?.txtInput.text ?? "",
            klangType : XtraHelp.sharedInstance.languageType,
            krole : XtraHelp.sharedInstance.userRole
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        UserModel.forgotPassword(with: param, success: { (msg) in
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(VerificationViewController.self, configuration: { (vc) in
                vc.isFromForgotPassword = true
                vc.userEmail = self.vwEmail?.txtInput.text ?? ""
            })
           
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
           
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                }
        })
    }
}

// MARK: - ViewControllerDescribable
extension ForgotPasswordViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension ForgotPasswordViewController: AppNavigationControllerInteractable { }

