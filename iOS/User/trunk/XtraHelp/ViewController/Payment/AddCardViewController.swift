//
//  AddCardViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

protocol addCardDelegate {
    func reloadCard()
}


class AddCardViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwSub: UIView?
    
    @IBOutlet weak var btnAddCard: XtraHelpButton?
    @IBOutlet weak var btnMarkDefault: UIButton?
    
    @IBOutlet weak var lblAddCardCard: UILabel?
    @IBOutlet weak var lblCardDesc: UILabel?
    @IBOutlet weak var lblMarkDefaulr: UILabel?
    
    @IBOutlet weak var vwCardHolderName: ReusableView?
    @IBOutlet weak var vwCardNumber: ReusableView?
    @IBOutlet weak var vwCardExpire: ReusableView?
    @IBOutlet weak var vwCardCVV: ReusableView?
    @IBOutlet weak var vwSeprator: UIView?
    @IBOutlet weak var vwBottomSeprator: UIView?
    
    // MARK: - Variables
    var delegate : addCardDelegate?
   
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.vwSub?.clipsToBounds = true
        self.vwSub?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: -4, height: -5), opacity: 1)
        self.vwSub?.maskToBounds = false
    }
    
}
// MARK: - Init Configure
extension AddCardViewController {
    private func InitConfig(){
        
        //self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblAddCardCard?.textColor = UIColor.CustomColor.tabBarColor
        self.lblAddCardCard?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.lblCardDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblCardDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblMarkDefaulr?.textColor = UIColor.CustomColor.labelColorLogin
        self.lblMarkDefaulr?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        
        self.vwCardNumber?.isFromCardNumber = true
        self.vwCardExpire?.isFromCardExpire = true
        self.vwCardCVV?.isFromCardCVV = true
        
        self.vwCardNumber?.txtInput.keyboardType = .numberPad
        self.vwCardCVV?.txtInput.keyboardType = .numberPad
        self.vwCardExpire?.txtInput.keyboardType = .numberPad
        
        self.vwCardCVV?.isPassword = true
        
        self.vwSeprator?.backgroundColor = UIColor.CustomColor.blackColor
        
        self.vwBottomSeprator?.backgroundColor = UIColor.CustomColor.blackColor
    }
}
// MARK: - IBAction
extension AddCardViewController {
    @IBAction func btnAddCardClicked(_ sender: XtraHelpButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage, themeStyle: .warning, presentationStyle: .top)
            return
        }
        self.addNewCardAPI()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTouchCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnMarkDefaultClicked(_ sender: UIButton) {
        self.btnMarkDefault?.isSelected = !(self.btnMarkDefault?.isSelected ?? false)
    }
}

// MARK: - API
extension AddCardViewController {
    func validateFields() -> String? {
        if self.vwCardHolderName?.txtInput.isEmpty ?? false{
            self.vwCardHolderName?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KCardHolderName
        } else if self.vwCardNumber?.txtInput.isEmpty ?? false {
            self.vwCardNumber?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KCardNumber
        } else if !(self.vwCardNumber?.txtInput.isValidCard() ?? false) {
            self.vwCardNumber?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KInvalidCardNumber
        } else if self.vwCardExpire?.txtInput.isEmpty ?? false {
            self.vwCardExpire?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KExpiryDate
        } else if !(self.vwCardExpire?.txtInput.isValidCardExpiryDate() ?? false){
            self.vwCardExpire?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KValidExpiryDate
        } else if self.vwCardCVV?.txtInput.isEmpty ?? false  {
            self.vwCardCVV?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KCVV
        } else if !(self.vwCardCVV?.txtInput.isValidCVV() ?? false) {
            self.vwCardCVV?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.KInvalidCVV
        }
        return nil
    }
}

// MARK: - API
extension AddCardViewController {
    private func addNewCardAPI(){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            var month : String = ""
            var year : String = ""
            let exdate = (self.vwCardExpire?.txtInput.text ?? "00/0000").components(separatedBy: "/")
            for i in stride(from: 0, to: exdate.count, by: 1) {
                if i == 0 {
                    month = exdate[i]
                }
                if i == 1 {
                    year = exdate[i]
                }
            }
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kholderName : self.vwCardHolderName?.txtInput.text ?? "",
                knumber : (self.vwCardNumber?.txtInput.text ?? "").replacingOccurrences(of: " ", with: ""),
                kexpMonth : month,
                kexpYear : year,
                kcvv : self.vwCardCVV?.txtInput.text ?? "",
                kisDefault : (self.btnMarkDefault?.isSelected ?? false) ? "1" : "0"
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CardModel.addNewCard(with: param, success: { (msg) in
                //self.showMessage(msg, themeStyle: .success)
                
                self.dismiss(animated: true) {
                    self.delegate?.reloadCard()
                }
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
extension AddCardViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Payment
    }
}

// MARK: - AppNavigationControllerInteractable
extension AddCardViewController: AppNavigationControllerInteractable{}
