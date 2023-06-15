//
//  CovidGuidelinesViewController.swift
//  Chiry
//
//  Created by Wdev3 on 25/03/21.
//

import UIKit

class CovidGuidelinesViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwBg: UIView?
    
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet weak var txtDesc: UITextView?
    
    @IBOutlet weak var btnContinue: XtraHelpButton?
    
    // MARK: - Variables
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vwBg?.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        self.vwBg?.shadow(UIColor.CustomColor.blackColor, radius: 5.0, offset: CGSize(width: 3, height: 3), opacity: 0.16)
    }
    
}

// MARK: - Init Configure
extension CovidGuidelinesViewController {
    private func InitConfig(){
        self.lblHeader?.textColor = UIColor.CustomColor.labelTextColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))
        
        self.txtDesc?.textColor = UIColor.CustomColor.otpTextColor
        self.txtDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.getCMSData()
    }
}

// MARK: - IBAction
extension CovidGuidelinesViewController {
    @IBAction func btnContinueClicked(_ sender: XtraHelpButton) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - API Call
extension CovidGuidelinesViewController {
    private func getCMSData(){
        
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType,
            kpageId : "covid19guideline"
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        CMSModel.getCMSContent(with: param, success: { (cmsdata, msg) in
            
            self.txtDesc?.setHTMLFromString(text: cmsdata.cmsdescription)
            
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
extension CovidGuidelinesViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension CovidGuidelinesViewController: AppNavigationControllerInteractable { }
