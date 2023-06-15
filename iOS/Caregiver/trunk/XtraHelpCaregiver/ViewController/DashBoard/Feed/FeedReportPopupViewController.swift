//
//  FeedReportPopupViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 08/02/22.
//

import UIKit

protocol feedPopupDelegate {
    func feedReport(btn : UIButton,obj : FeedModel)
    func feedDelete(btn : UIButton,obj : FeedModel)
    func feedCommentReport(btn : UIButton,obj : FeedUserLikeModel)
    func feedCommentDelete(btn : UIButton,obj : FeedUserLikeModel)
}

class FeedReportPopupViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet weak var vwSub: UIView?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    @IBOutlet weak var btnClose: UIButton?
    @IBOutlet weak var btnCloseTouch: UIButton?
    
    @IBOutlet weak var vwReportText: ReusableTextview?
    @IBOutlet weak var constarintBottoView: NSLayoutConstraint?
    // MARK: - Variables
    var selectedFeedData : FeedModel?
    
    var isFromComment : Bool = false
    var selectedFeedCommentData : FeedUserLikeModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Enable IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Disable IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.vwSub?.clipsToBounds = true
        self.vwSub?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: -4, height: -5), opacity: 1)
        self.vwSub?.maskToBounds = false
    }
}

// MARK: - Init Configure
extension FeedReportPopupViewController {
    private func InitConfig(){
        
        self.lblHeader?.textColor = UIColor.CustomColor.TextColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))
        
        //delay(seconds: 0.2) {
            self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        //}
        
        self.lblHeader?.text = "\(self.isFromComment ? "Comment" : "Feed") Report"
    }
}

// MARK: - IBAction
extension FeedReportPopupViewController {
    @IBAction func btnSubmitClicked(_ sender: XtraHelp) {
        self.view.endEditing(true)
        if self.vwReportText?.txtInput?.isEmpty ?? false {
            self.showMessage("Please enter report text", themeStyle: .warning, presentationStyle: .top)
            return
        }
        if self.isFromComment {
            self.setFeedCommentReport()
        } else {
            self.setFeedReport()
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - NotificateionValueDelegate methods
extension FeedReportPopupViewController {
    
    //MARK:- Notification observer for keyboard
    func addKeyboardObserver () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureHandler() {
        self.view.endEditing(true)
    }
    
    func removeKeyboardObserver () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            
            self.constarintBottoView?.constant = keyboardHeight + 20.0//+ (DeviceType.IS_PAD ? 18 : 9) + 30.0
            view.layoutIfNeeded()
        }
    }
}


//MARK:- API Call
extension FeedReportPopupViewController{
    
    private func setFeedReport(){
        if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedData {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserFeedId : feeddata.id,
                kmessage : (self.vwReportText?.txtInput?.text ?? "").encodindEmoji()
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.setFeedReport(with: param, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                delay(seconds: 0.2) {
                    self.dismiss(animated: true, completion: nil)
                }
            }, failure: { (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func setFeedCommentReport(){
        if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedCommentData {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserFeedId : feeddata.feedId,
                kfeedCommentId : feeddata.id,
                kmessage : self.vwReportText?.txtInput?.text ?? ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.setFeedReport(with: param,isFromComment : true, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                delay(seconds: 0.2) {
                    self.dismiss(animated: true, completion: nil)
                }
            }, failure: { (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension FeedReportPopupViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.FeedTab
    }
}

// MARK: - AppNavigationControllerInteractable
extension FeedReportPopupViewController: AppNavigationControllerInteractable { }



