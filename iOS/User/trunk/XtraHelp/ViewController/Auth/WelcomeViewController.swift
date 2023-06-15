//
//  WelcomeViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 13/08/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet var lblText: [UILabel]?
    
    @IBOutlet var vwMainLogin: [UIView]?
    
    @IBOutlet var vwRound: [UIView]?
    
    @IBOutlet weak var btnEmail: UIButton?
    @IBOutlet weak var btnFB: UIButton?
    @IBOutlet weak var btnGoogle: UIButton?
    @IBOutlet weak var btnApple: UIButton?
    @IBOutlet weak var btnLinkedln: UIButton?
    
    // MARK: - Variables
    private var socilalogin = SocialLoginManager()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.socilalogin.getLocation()
        appNavigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
    }
}

// MARK: - Init Configure
extension WelcomeViewController {
    private func InitConfig(){
        
        self.socilalogin.viewController = self
        self.socilalogin.appnavigationcontroller = self.appNavigationController
        
        self.vwMainLogin?.forEach({
            $0.backgroundColor = UIColor.CustomColor.loginBoxBGColor
            $0.cornerRadius = 12.0
        })
        
        self.vwRound?.forEach({
            $0.backgroundColor = UIColor.CustomColor.whitecolor
            $0.cornerRadius = $0.frame.height / 3
        })
        
        self.lblText?.forEach({
            $0.textColor = UIColor.CustomColor.appColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        })
        
        self.lblHeader?.setHeaderCommonAttributedTextLable(firstText: "Get connected\nto the best\n", SecondText: "Mentors.")
        //self.lblHeader?.addInterlineSpacing()
        self.lblSubHeader?.textColor = UIColor.CustomColor.whitecolor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
    }
}

// MARK: - IBAction
extension WelcomeViewController {
    @IBAction func btnEmailClicked(_ sender: UIButton) {
        self.appNavigationController?.push(LoginViewController.self)
    }
    
    @IBAction func btnFBClicked(_ sender: UIButton) {
        //self.socilalogin.loginWithFacebook()
    }
    
    @IBAction func btnGoogleClicked(_ sender: UIButton) {
        //self.socilalogin.loginWithGoogle()
    }
    
    @IBAction func btnAppleClicked(_ sender: UIButton) {
        //self.socilalogin.loginWithApple()
    }
    
    @IBAction func btnLinkedlnClicked(_ sender: UIButton) {
        //self.socilalogin.loginWithApple()
    }
}

// MARK: - ViewControllerDescribable
extension WelcomeViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension WelcomeViewController: AppNavigationControllerInteractable { }
