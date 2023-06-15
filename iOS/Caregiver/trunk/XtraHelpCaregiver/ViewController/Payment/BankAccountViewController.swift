//
//  BankAccountViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 14/02/22.
//

import UIKit

class BankAccountViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lblAccountType: UILabel?
    @IBOutlet weak var lblIndividual: UILabel?
    @IBOutlet weak var lblCompany: UILabel?
    
    @IBOutlet weak var vwAccountName: ReusableView?
    @IBOutlet weak var vwRoutingNumber: ReusableView?
    @IBOutlet weak var vwAccountNumber: ReusableView?
    @IBOutlet weak var vwReEnterAccountNumber: ReusableView?
    
    @IBOutlet weak var btnIndividual: UIButton?
    @IBOutlet weak var btnCompany: UIButton?
    @IBOutlet weak var btnIndividualCheck: UIButton?
    @IBOutlet weak var btnCompanyCheck: UIButton?
    @IBOutlet weak var btnFinish: XtraHelpButton?
    
    // MARK: - Variables
    var isSelectIndividual : Bool = false {
        didSet{
            self.btnIndividualCheck?.isSelected = isSelectIndividual
            self.btnCompanyCheck?.isSelected = !isSelectIndividual
        }
    }
    var isFromAccountScreen : Bool = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
}

// MARK: - Init Configure
extension BankAccountViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.isSelectIndividual = true
        
        self.lblTitle?.textColor = UIColor.CustomColor.labelTextColor
        self.lblTitle?.font = UIFont.RubikBold(ofSize: GetAppFontSize(size: 24.0))

        self.lblAccountType?.textColor = UIColor.CustomColor.labelTextColor
        self.lblAccountType?.font = UIFont.RubikRegular(ofSize: 14.0)
        
        self.vwAccountName?.txtInput.autocapitalizationType = .words
    
        [self.lblCompany,self.lblIndividual].forEach({
            $0?.textColor = UIColor.CustomColor.labelTextColor
            $0?.font = UIFont.RubikRegular(ofSize: 14.0)
        })
        
        [self.vwAccountName,self.vwAccountNumber,self.vwRoutingNumber,self.vwReEnterAccountNumber].forEach({
            $0?.txtInput.delegate = self
        })
        self.vwRoutingNumber?.isFromBankRoutingNumber = true
        //if self.isFromSideMenu {
            self.getBankDetailAPI()
        //}
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
        
    }
}

// MARK: - IBAction
extension BankAccountViewController {
   
    @IBAction func btnIndividualClicked(_ sender: UIButton) {
        self.isSelectIndividual = true
    }
    
    @IBAction func btnCompanyClicked(_ sender: UIButton) {
        self.isSelectIndividual = false
    }
    
    @IBAction func btnFinishClicked(_ sender: XtraHelpButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            //self.showAlert(errMessage)
            self.showMessage(errMessage, themeStyle: .warning,presentationStyle: .top)
            return
        }
        
        self.saveBankDetailInStripeAPI()
    }
}

//MARK : - UITextFieldDelegate
extension BankAccountViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwAccountName?.txtInput:
            self.vwAccountName?.txtInput.resignFirstResponder()
            self.vwRoutingNumber?.txtInput.becomeFirstResponder()
        case self.vwRoutingNumber?.txtInput:
            self.vwRoutingNumber?.txtInput.resignFirstResponder()
            self.vwAccountNumber?.txtInput.becomeFirstResponder()
        case self.vwAccountNumber?.txtInput:
            self.vwAccountNumber?.txtInput.resignFirstResponder()
            self.vwReEnterAccountNumber?.txtInput.becomeFirstResponder()
        case self.vwReEnterAccountNumber?.txtInput:
            self.vwReEnterAccountNumber?.txtInput.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwAccountName?.txtInput:
            self.vwAccountName?.isSetFocusTextField = true
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
        case self.vwRoutingNumber?.txtInput:
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = true
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
        case self.vwAccountNumber?.txtInput:
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = true
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
        case self.vwReEnterAccountNumber?.txtInput:
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = true
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.vwRoutingNumber?.txtInput {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: Masking.kRoutingNumberMasking, phone: newString)
            return false
        }
        return true
    }
}

// MARK: - API Call
extension BankAccountViewController {
    private func validateFields() -> String? {
        if self.vwAccountName?.txtInput.isEmpty ?? false {
            self.vwAccountName?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = true
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyBankHolderName
        } else if self.vwRoutingNumber?.txtInput.isEmpty ?? false{
            self.vwRoutingNumber?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = true
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyBankRoutingNumber
        } else if (self.vwRoutingNumber?.txtInput.text ?? "").count != 9 {
            self.vwRoutingNumber?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = true
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kValidBankRoutingNumber
        } else if self.vwAccountNumber?.txtInput.isEmpty ?? false {
            self.vwAccountName?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = true
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyBankAccoutnNumber
        } else if (self.vwAccountNumber?.txtInput.text ?? "").count < 9 || (self.vwAccountNumber?.txtInput.text ?? "").count > 18 {
            self.vwAccountName?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = true
            self.vwReEnterAccountNumber?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kValidBankAccoutnNumber
        } else if self.vwReEnterAccountNumber?.txtInput.isEmpty ?? false {
            self.vwReEnterAccountNumber?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kEmptyConfirmAccoutnNumber
        } else if (self.vwAccountNumber?.txtInput.text ?? "") != (self.vwReEnterAccountNumber?.txtInput.text ?? "") {
            self.vwAccountName?.txtInput.becomeFirstResponder()
            self.vwAccountName?.isSetFocusTextField = false
            self.vwRoutingNumber?.isSetFocusTextField = false
            self.vwAccountNumber?.isSetFocusTextField = false
            self.vwReEnterAccountNumber?.isSetFocusTextField = true
            return AppConstant.ValidationMessages.kEmptyBankMatchAccountNumber
        } else {
            return nil
        }
    }
    
    private func saveBankDetailInStripeAPI(){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kaccount_holder_name : self.vwAccountName?.txtInput.text ?? "",
                kaccount_holder_type : self.isSelectIndividual ? "individual" : "company",
                krouting_number : self.vwRoutingNumber?.txtInput.text ?? "",
                kaccount_number : self.vwAccountNumber?.txtInput.text ?? ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            BankModel.saveBankDetailInStripe(with: param, success: { (msg) in
                if let user = UserModel.getCurrentUserFromDefault() {
                    user.isBankDetail = "1"
                    user.saveCurrentUserInDefault()
                }
                self.showMessage(msg, themeStyle: .success)
                for controller in (self.navigationController?.viewControllers ?? []) as Array {
                    if controller.isKind(of: AccountViewController.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
                /*if self.isFromHomeScreen {
                    Chiry.sharedInstance.isReloadDashboardData = true
                    if self.isDirectFromHomeScreen {
                        self.appNavigationController?.popViewController(animated: true)
                        
                    } else {
                        self.appNavigationController?.popToRootViewController(animated: true)
                    }
                } else {*/
                    /*if self.isFromSideMenu {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.appNavigationController?.push(SetAvailabilityPriceVC.self,configuration: { (vc) in
                            vc.isHideBackbtn = true
                            vc.isfromLogin = false
                        })
                    }*/
                //}
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    private func getBankDetailAPI(){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            BankModel.getBankDetail(with: param, success: { (bankdata,msg) in
                self.vwAccountName?.txtInput.text = bankdata.account_holder_name
                self.vwAccountNumber?.txtInput.text = bankdata.account_number
                self.vwRoutingNumber?.txtInput.text = bankdata.routing_number
                self.vwReEnterAccountNumber?.txtInput.text = bankdata.account_number
                self.isSelectIndividual = bankdata.account_holder_type == "individual"
                self.btnFinish?.setTitle("Update", for: .normal)
            }, failure: { (statuscode,error, errorType) in
                self.btnFinish?.setTitle("Finish", for: .normal)
            })
        }
    }
    
}

// MARK: - ViewControllerDescribable
extension BankAccountViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension BankAccountViewController: AppNavigationControllerInteractable { }
