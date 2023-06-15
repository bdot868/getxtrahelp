//
//  WithdrawAmountViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 14/02/22.
//

import UIKit

protocol  WithdrawAmountDelegate {
    func selectWithdrawAmount(price : String)
}

class WithdrawAmountViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwWithdrawAmount: ReusableView?
    
    @IBOutlet weak var btnOk: XtraHelpButton?
    @IBOutlet weak var btnClose: UIButton?
    
    // MARK: - Variables
    var totalAmount : Double = 0.0
    var delegate : WithdrawAmountDelegate?
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}

// MARK: - UI helpers
extension WithdrawAmountViewController  {
    func InitConfigure() {
        self.vwWithdrawAmount?.txtInput.placeholder = "Enter Amount"
        self.vwWithdrawAmount?.txtInput.keyboardType = .decimalPad
        self.vwWithdrawAmount?.txtInput.delegate = self
        self.vwWithdrawAmount?.isShowRightDollarView = true
        
        self.btnClose?.setTitleColor(UIColor.CustomColor.tabBarColor, for: .normal)
        self.btnClose?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        delay(seconds: 0.1) {
             [self.vwWithdrawAmount].forEach({
                $0?.txtInputFontSize = 14.0
                $0?.txtInputPadding = 0.0
            })
        }
    }
}

// MARK: - IBAction
extension WithdrawAmountViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        return true
    }
    
}

// MARK: - IBAction
extension WithdrawAmountViewController {
    @IBAction func btnOkClicked(_ sender: XtraHelpButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage, themeStyle: .warning)
            return
        }
        self.delegate?.selectWithdrawAmount(price: self.vwWithdrawAmount?.txtInput.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func validateFields() -> String? {
        
            let intvalue : Double = Double(self.vwWithdrawAmount?.txtInput.text ?? "0") ?? 0.0
            if self.vwWithdrawAmount?.txtInput.isEmpty ?? false {
                return AppConstant.ValidationMessages.kEmptyAmount
            } else if (intvalue <= 0) {
                return AppConstant.ValidationMessages.kValidWithdrawAmount
            } else if intvalue > self.totalAmount {
                return AppConstant.ValidationMessages.kExceedWithdrawAmount
            }
        
        return nil
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ViewControllerDescribable
extension WithdrawAmountViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension WithdrawAmountViewController: AppNavigationControllerInteractable{}

