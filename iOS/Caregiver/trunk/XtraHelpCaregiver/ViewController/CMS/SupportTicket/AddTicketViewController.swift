//
//  AddTicketViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

protocol addNewTicketDelegate {
    func addnewticket()
}

class AddTicketViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwSub: UIView?
    
    @IBOutlet weak var btnAddCard: XtraHelpButton?
    
    @IBOutlet weak var lblAddCardCard: UILabel?
    @IBOutlet weak var lblCardDesc: UILabel?
    @IBOutlet weak var lblCharCount: UILabel?
    
    @IBOutlet weak var vwTicketTitle: ReusableView?
    @IBOutlet weak var vwTicketSubject: ReusableView?
    
    @IBOutlet weak var txtTicketDesc: ReusableTextview?
    
    // MARK: - Variables
    var delegate : addNewTicketDelegate?
   
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
extension AddTicketViewController {
    private func InitConfig(){
        
        self.lblAddCardCard?.textColor = UIColor.CustomColor.tabBarColor
        self.lblAddCardCard?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.lblCardDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblCardDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        
        self.lblCharCount?.textColor = UIColor.CustomColor.aboutDetailColor
        self.lblCharCount?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.txtTicketDesc?.txtInput?.delegate = self
    }
}

//MARK: - UITextView Delegate
extension AddTicketViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.lblCharCount?.text = "\(textView.text.count)/300 characters"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if numberOfChars <= 300 {
            return true
        }
        else{
            return false
        }
    }
}

// MARK: - IBAction
extension AddTicketViewController {
    @IBAction func btnAddCardClicked(_ sender: XtraHelpButton) {
        self.addNewTicketAPICall()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTouchCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - API Call
extension AddTicketViewController {
    
    private func validateFields() -> String? {
        if self.vwTicketTitle?.txtInput.isEmpty ?? true{
            self.vwTicketTitle?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.kEmptyTicketTile
        } else if self.txtTicketDesc?.txtInput?.isEmpty ?? true {
            self.txtTicketDesc?.txtInput?.becomeFirstResponder()
            return AppConstant.ValidationMessages.kEmptyTicketDesc
        } else {
            return nil
        }
    }
    
    private func addNewTicketAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            if let errMessage = self.validateFields() {
                self.showMessage(errMessage, themeStyle: .warning,presentationStyle: .top)
                return
            }
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                ktitle : self.vwTicketTitle?.txtInput.text ?? "",
                kdescription : self.txtTicketDesc?.txtInput?.text ?? ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            TicketModel.addNewTicket(with: param, success: { (msg) in
                
                //self.showMessage(msg, themeStyle: .success)
                
                self.dismiss(animated: true) {
                    self.delegate?.addnewticket()
                }

            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(errorType.rawValue, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension AddTicketViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension AddTicketViewController: AppNavigationControllerInteractable{}

