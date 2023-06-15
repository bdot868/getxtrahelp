//
//  FeedbackViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

class FeedbackViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwNotAllHappyMain: UIView?
    @IBOutlet weak var vwNotHappyMain: UIView?
    @IBOutlet weak var vwHappyMain: UIView?
    @IBOutlet weak var vwVeryHappyMain: UIView?
    @IBOutlet weak var vwLoveAppMain: UIView?
    @IBOutlet weak var vwNotAllHappySub: UIView?
    @IBOutlet weak var vwNotHappySub: UIView?
    @IBOutlet weak var vwHappySub: UIView?
    @IBOutlet weak var vwVeryHappySub: UIView?
    @IBOutlet weak var vwLoveAppSub: UIView?
    
    @IBOutlet weak var lblCharCount: UILabel?
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblNotAllHappy: UILabel?
    @IBOutlet weak var lblNotHappy: UILabel?
    @IBOutlet weak var lblHappy: UILabel?
    @IBOutlet weak var lblVeryHappy: UILabel?
    @IBOutlet weak var lblLoveApp: UILabel?
    
    @IBOutlet weak var btnNotAllHappy: UIButton?
    @IBOutlet weak var btnNotHappy: UIButton?
    @IBOutlet weak var btnHappy: UIButton?
    @IBOutlet weak var btnVeryHappy: UIButton?
    @IBOutlet weak var btnLoveApp: UIButton?
    @IBOutlet weak var btnRateAppStore: UIButton?
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    
    @IBOutlet weak var vwFeedback: ReusableTextview?
    // MARK: - Variables
    var isSelectNotAllHappy : Bool = false {
        didSet{
            self.vwNotAllHappySub?.backgroundColor = isSelectNotAllHappy ? UIColor.clear : UIColor.white.withAlphaComponent(0.4)
            self.lblNotAllHappy?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        }
    }
    var isSelectNotHappy : Bool = false {
        didSet{
            self.vwNotHappySub?.backgroundColor = isSelectNotHappy ? UIColor.clear : UIColor.white.withAlphaComponent(0.4)
            self.lblNotHappy?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        }
    }
    var isSelectHappy : Bool = false {
        didSet{
            self.vwHappySub?.backgroundColor = isSelectHappy ? UIColor.clear : UIColor.white.withAlphaComponent(0.4)
            self.lblHappy?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        }
    }
    var isSelectVeryHappy : Bool = false {
        didSet{
            self.vwVeryHappySub?.backgroundColor = isSelectVeryHappy ? UIColor.clear : UIColor.white.withAlphaComponent(0.4)
            self.lblVeryHappy?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        }
    }
    var isSelectLoveApp : Bool = false {
        didSet{
            self.vwLoveAppSub?.backgroundColor = isSelectLoveApp ? UIColor.clear : UIColor.white.withAlphaComponent(0.4)
            self.lblLoveApp?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        }
    }
    
    private var selectedRating : String = ""
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
        
    }
    
}


// MARK: - Init Configure
extension FeedbackViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        [self.lblHappy,self.lblLoveApp,self.lblNotHappy,self.lblVeryHappy,self.lblNotAllHappy].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 9.0))
        })
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 30.0))
        
        [self.vwHappyMain,self.vwLoveAppMain,self.vwNotHappyMain,self.vwVeryHappyMain,self.vwNotAllHappyMain].forEach({
            $0?.borderColor = UIColor.CustomColor.whitecolor
            $0?.borderWidth = 2.0
            $0?.backgroundColor = UIColor.CustomColor.appColor
        })
        
        [self.vwHappySub,self.vwLoveAppSub,self.vwNotHappySub,self.vwVeryHappySub,self.vwNotAllHappySub].forEach({
            $0?.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        })
        
        //self.btnRateAppStore?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        //self.btnRateAppStore?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0)),
              .foregroundColor: UIColor.CustomColor.appColor,
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        
        let attributeString = NSMutableAttributedString(
                string: "Rate us on AppStore",
                attributes: yourAttributes
             )
        self.btnRateAppStore?.setAttributedTitle(attributeString, for: .normal)
        
        self.isSelectNotAllHappy = false
        self.isSelectNotHappy = false
        self.isSelectHappy = true
        self.isSelectVeryHappy = false
        self.isSelectLoveApp = false
        
        self.lblCharCount?.textColor = UIColor.CustomColor.aboutDetailColor
        self.lblCharCount?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwFeedback?.txtInput?.delegate = self
        
        delay(seconds: 0.2) {
            [self.vwHappyMain,self.vwLoveAppMain,self.vwNotHappyMain,self.vwVeryHappyMain,self.vwNotAllHappyMain,self.vwHappySub,self.vwLoveAppSub,self.vwNotHappySub,self.vwVeryHappySub,self.vwNotAllHappySub].forEach({
                $0?.cornerRadius = ($0?.frame.height ?? 1.0) / 2
            })
        }
        
        self.getFeedbackAPI()
    }
    private func configureNavigationBar() {
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Feedback", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension FeedbackViewController {
    @IBAction func btnNotAllHappyClicked(_ sender: UIButton) {
        self.isSelectNotAllHappy = true
        self.isSelectNotHappy = false
        self.isSelectHappy = false
        self.isSelectVeryHappy = false
        self.isSelectLoveApp = false
        self.selectedRating = "1"
    }
    @IBAction func btnNotHappyClicked(_ sender: UIButton) {
        self.isSelectNotAllHappy = false
        self.isSelectNotHappy = true
        self.isSelectHappy = false
        self.isSelectVeryHappy = false
        self.isSelectLoveApp = false
        self.selectedRating = "2"
    }
    @IBAction func btnHappyClicked(_ sender: UIButton) {
        self.isSelectNotAllHappy = false
        self.isSelectNotHappy = false
        self.isSelectHappy = true
        self.isSelectVeryHappy = false
        self.isSelectLoveApp = false
        self.selectedRating = "3"
    }
    @IBAction func btnVeryHappyClicked(_ sender: UIButton) {
        self.isSelectNotAllHappy = false
        self.isSelectNotHappy = false
        self.isSelectHappy = false
        self.isSelectVeryHappy = true
        self.isSelectLoveApp = false
        self.selectedRating = "4"
    }
    @IBAction func btnLoveAppClicked(_ sender: UIButton) {
        self.isSelectNotAllHappy = false
        self.isSelectNotHappy = false
        self.isSelectHappy = false
        self.isSelectVeryHappy = false
        self.isSelectLoveApp = true
        self.selectedRating = "5"
    }
 
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        self.setFeedbackAPI()
    }
    
    @IBAction func btnRateAppStoreClicked(_ sender: UIButton) {
        
    }
}

// MARK: - API Call
extension FeedbackViewController{
    
    private func setFeedbackAPI() {
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            if self.selectedRating.isEmpty {
                self.showMessage(AppConstant.ValidationMessages.kEmptyFeedback, themeStyle: .warning)
                return
            }
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kfeedback : self.vwFeedback?.txtInput?.text ?? "",
                krating: self.selectedRating
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedbackModel.setAppFeedback(with: param, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                self.navigationController?.popViewController(animated: true)

            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(errorType.rawValue, themeStyle: .error)
                }
            })
        }
    }
    
    private func getFeedbackAPI() {
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedbackModel.getAppFeedback(with: param, success: { (model, message) in
                
                self.vwFeedback?.txtInput?.text = model.feedback
                self.lblCharCount?.text = "\(((self.vwFeedback?.txtInput?.text ?? "").count))/300 characters"
                self.selectedRating = model.rating
                if model.rating == "1" {
                    self.isSelectNotAllHappy = true
                    self.isSelectNotHappy = false
                    self.isSelectHappy = false
                    self.isSelectVeryHappy = false
                    self.isSelectLoveApp = false
                } else if model.rating == "2" {
                    self.isSelectNotAllHappy = false
                    self.isSelectNotHappy = true
                    self.isSelectHappy = false
                    self.isSelectVeryHappy = false
                    self.isSelectLoveApp = false
                } else if model.rating == "3" {
                    self.isSelectNotAllHappy = false
                    self.isSelectNotHappy = false
                    self.isSelectHappy = true
                    self.isSelectVeryHappy = false
                    self.isSelectLoveApp = false
                } else if model.rating == "4" {
                    self.isSelectNotAllHappy = false
                    self.isSelectNotHappy = false
                    self.isSelectHappy = false
                    self.isSelectVeryHappy = true
                    self.isSelectLoveApp = false
                } else if model.rating == "5" {
                    self.isSelectNotAllHappy = false
                    self.isSelectNotHappy = false
                    self.isSelectHappy = false
                    self.isSelectVeryHappy = false
                    self.isSelectLoveApp = true
                }
                
            }, failure: {(statuscode,error, errorType) in
                print(error)
            })
        }
    }
}

//MARK: - UITextView Delegate
extension FeedbackViewController: UITextViewDelegate {
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

// MARK: - ViewControllerDescribable
extension FeedbackViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension FeedbackViewController: AppNavigationControllerInteractable { }

