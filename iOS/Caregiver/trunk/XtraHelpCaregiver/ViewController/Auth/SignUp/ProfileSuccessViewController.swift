//
//  ProfileSuccessViewController.swift
//  Chiry
//
//  Created by Wdev3 on 19/02/21.
//

import UIKit
import MessageUI

class ProfileSuccessViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblHeaderSuccess: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet weak var lblSherAppHeader: UILabel?
    
    @IBOutlet weak var btnTwitter: UIButton?
    @IBOutlet weak var btnFacebook: UIButton?
    @IBOutlet weak var btnInsta: UIButton?
    @IBOutlet weak var btnSher: UIButton?
    
    @IBOutlet weak var btnGetStarted: XtraHelpButton?
    
    @IBOutlet weak var vwSuccessSignup: UIView?
    @IBOutlet weak var vwSuccessHeader: UIView?
    @IBOutlet weak var vwApplicationHeader: UIView?
    @IBOutlet weak var vwSubmitedApplication: UIView?
    
    @IBOutlet weak var vwLogoutMain: UIView?
    @IBOutlet weak var btnLogout: UIButton?
    
    // MARK: - Variables
    var SuccessSignup : Bool = false
    var isFromLogin : Bool = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Init Configure
extension ProfileSuccessViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblHeaderSuccess?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeaderSuccess?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblSherAppHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblSherAppHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0))
        
        self.btnLogout?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        self.btnLogout?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        
        if self.SuccessSignup {
            
            self.SuccessSignup = true
            self.vwSuccessSignup?.isHidden = false
            self.vwSubmitedApplication?.isHidden = true
            self.vwApplicationHeader?.isHidden = true
            self.vwSuccessHeader?.isHidden = false
            self.lblSubHeader?.text = "Please give our team 1-2 business days to verify and activate your account."
            self.btnGetStarted?.setTitle("Connect With Us", for: .normal)
            self.vwLogoutMain?.isHidden = false
        }
    }
}

// MARK: - IBAction
extension ProfileSuccessViewController {
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnInstaClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnTwitterClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSherClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnLogoutClicked(_ sender: UIButton) {
        appDelegate.clearUserDataForLogout()
        self.appNavigationController?.showLoginViewController(animationType: .fromRight, configuration: nil)//showDashBoardViewController()
    }
    
    @IBAction func btnGetStartedClicked(_ sender: XtraHelpButton) {
        if self.SuccessSignup {
            //appDelegate.clearUserDataForLogout()
            //self.appNavigationController?.showLoginViewController(animationType: .fromRight, configuration: nil)//showDashBoardViewController()
            if MFMailComposeViewController.canSendMail() {
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setToRecipients(["info@getxtrahelp.com"])
                mailComposer.setSubject("")
                mailComposer.setMessageBody("", isHTML: false)
                DispatchQueue.main.async {
                    self.present(mailComposer,animated: true,completion: nil)
                }
            }
            else {
                self.showMessage(AppConstant.FailureMessage.kMailNoteSetUp, themeStyle: .warning)
                //self.showAlert(with: AppConstant.FailureMessage.kMailNoteSetUp)
            }
        } else {
            self.SuccessSignup = true
            self.vwSuccessSignup?.isHidden = false
            self.vwSubmitedApplication?.isHidden = true
            self.vwApplicationHeader?.isHidden = true
            self.vwSuccessHeader?.isHidden = false
            self.lblSubHeader?.text = "Please give our team 1-2 business days to verify and activate your account."
            self.btnGetStarted?.setTitle("Connect With Us", for: .normal)
            self.vwLogoutMain?.isHidden = false
        }
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension ProfileSuccessViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        //case MFMailComposeResult.cancelled: break
        case MFMailComposeResult.sent:
            controller.dismiss(animated: true) {
                //self.showAlert(with: AppConstant.SuccessMessage.kMailSent)
                self.showMessage(AppConstant.SuccessMessage.kMailSent, themeStyle: .success)
            }
        case MFMailComposeResult.cancelled:
            controller.dismiss(animated: true, completion: nil)
            
        default:
            //            self.dismiss(animated: true, completion: nil)
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - ViewControllerDescribable
extension ProfileSuccessViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension ProfileSuccessViewController: AppNavigationControllerInteractable { }

