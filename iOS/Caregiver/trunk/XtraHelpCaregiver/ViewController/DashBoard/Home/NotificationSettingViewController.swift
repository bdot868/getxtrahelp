//
//  NotificationSettingViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

class NotificationSettingViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet var lblUpdatesHeader: [UILabel]?
    @IBOutlet var lblHeader: [UILabel]?
    
    @IBOutlet weak var btnInboxText: UIButton?
    @IBOutlet weak var btnInboxEmail: UIButton?
    @IBOutlet weak var btnJobsText: UIButton?
    @IBOutlet weak var btnJobsEmail: UIButton?
    @IBOutlet weak var btnMessageText: UIButton?
    @IBOutlet weak var btnMessageEmail: UIButton?
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}

// MARK: - Init Configure
extension NotificationSettingViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblUpdatesHeader?.forEach({
            $0.textColor = UIColor.CustomColor.commonLabelColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        })
        
        self.lblHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        if let user = UserModel.getCurrentUserFromDefault() {
            self.btnJobsText?.isSelected = user.jobMsgText == "1"
            self.btnJobsEmail?.isSelected = user.jobMsgMail == "1"
            self.btnInboxText?.isSelected = user.inboxMsgText == "1"
            self.btnInboxEmail?.isSelected = user.inboxMsgMail == "1"
            self.btnMessageText?.isSelected = user.caregiverUpdateText == "1"
            self.btnMessageEmail?.isSelected = user.caregiverUpdateMail == "1"
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Notifications", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension NotificationSettingViewController {
    @IBAction func btnInboxTextClicked(_ sender: UIButton) {
        self.btnInboxText?.isSelected = !(self.btnInboxText?.isSelected ?? false)
    }
    
    @IBAction func btnInboxEmailClicked(_ sender: UIButton) {
        self.btnInboxEmail?.isSelected = !(self.btnInboxEmail?.isSelected ?? false)
    }
    
    @IBAction func btnJobsTextClicked(_ sender: UIButton) {
        self.btnJobsText?.isSelected = !(self.btnJobsText?.isSelected ?? false)
    }
    
    @IBAction func btnJobsEmailClicked(_ sender: UIButton) {
        self.btnJobsEmail?.isSelected = !(self.btnJobsEmail?.isSelected ?? false)
    }
    
    @IBAction func btnMessageTextClicked(_ sender: UIButton) {
        self.btnMessageText?.isSelected = !(self.btnMessageText?.isSelected ?? false)
    }
    
    @IBAction func btnMessageEmailClicked(_ sender: UIButton) {
        self.btnMessageEmail?.isSelected = !(self.btnMessageEmail?.isSelected ?? false)
    }
    
    @IBAction func btnUpdateClicked(_ sender: UIButton) {
        self.setNotificationsAPI()
    }
}

// MARK: - API Call
extension NotificationSettingViewController{
    
    private func setNotificationsAPI() {
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kinboxMsgText : (self.btnInboxText?.isSelected ?? false) ? "1" : "2",
                kinboxMsgMail : (self.btnInboxEmail?.isSelected ?? false) ? "1" : "2",
                kjobMsgText : (self.btnJobsText?.isSelected ?? false) ? "1" : "2",
                kjobMsgMail : (self.btnJobsEmail?.isSelected ?? false) ? "1" : "2",
                kcaregiverUpdateText : (self.btnMessageText?.isSelected ?? false) ? "1" : "2",
                kcaregiverUpdateMail : (self.btnMessageEmail?.isSelected ?? false) ? "1" : "2"
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserModel.saveSignupProfileDetails(with: param,type: .PersonalDetails, success: { (model, msg) in
                self.showMessage("Settings updated successfully",themeStyle: .success)
                self.appNavigationController?.popViewController(animated: true)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension NotificationSettingViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.DashBoard
    }
}

// MARK: - AppNavigationControllerInteractable
extension NotificationSettingViewController: AppNavigationControllerInteractable { }

