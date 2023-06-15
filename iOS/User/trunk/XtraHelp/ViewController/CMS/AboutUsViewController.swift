//
//  AboutUsViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

class AboutUsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var vwMainContent: UIView?
    
    @IBOutlet weak var lblCMSContent: UILabel?
    @IBOutlet weak var lblContactWithUs: UILabel?
    
    @IBOutlet weak var btnTwitter: UIButton?
    @IBOutlet weak var btnFacebook: UIButton?
    @IBOutlet weak var btnInsta: UIButton?
    @IBOutlet weak var btnSher: UIButton?
    
    @IBOutlet weak var btnTermCondition: UIButton?
    @IBOutlet weak var btnPrivacyPolicy: UIButton?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
    }
}


// MARK: - Init Configure
extension AboutUsViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblCMSContent?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblCMSContent?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblContactWithUs?.textColor = UIColor.CustomColor.tabBarColor
        self.lblContactWithUs?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))
        
        [self.btnTermCondition,self.btnPrivacyPolicy].forEach({
            $0?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
            $0?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        })
        
        self.getCMSData()
    }
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "About Us", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension AboutUsViewController {
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/getxtrahelp") {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            safariVC.modalTransitionStyle = .crossDissolve
            safariVC.modalPresentationStyle = .overFullScreen
            self.present(safariVC, animated: true,completion: nil)
        }
    }
    
    @IBAction func btnInstaClicked(_ sender: UIButton) {
        if let url = URL(string: "https://www.instagram.com/getxtrahelpapp/") {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            safariVC.modalTransitionStyle = .crossDissolve
            safariVC.modalPresentationStyle = .overFullScreen
            self.present(safariVC, animated: true,completion: nil)
        }
    }
    
    @IBAction func btnTwitterClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSherClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnTermConditionClicked(_ sender: UIButton) {
        self.appNavigationController?.push(TermConditionViewController.self,configuration: { vc in
            vc.pageid = .TermCondition
        })
    }
    
    @IBAction func btnPrivacyPolicyClicked(_ sender: UIButton) {
        self.appNavigationController?.push(TermConditionViewController.self,configuration: { vc in
            vc.pageid = .PrivacyPolicy
        })
    }
}

// MARK: - SFSafariViewControllerDelegate
extension AboutUsViewController : SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - API Call
extension AboutUsViewController {
    private func getCMSData(){
        
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType,
            kpageId : "aboutus"
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        CMSModel.getCMSContent(with: param, success: { (cmsdata, msg) in
            
            self.lblCMSContent?.setHTMLFromString(text: cmsdata.cmsdescription)
            
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
extension AboutUsViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension AboutUsViewController: AppNavigationControllerInteractable { }
