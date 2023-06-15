//
//  JobSuccessViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class JobSuccessViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    // MARK: - Variables
    
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
extension JobSuccessViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
    }
}

// MARK: - IBAction
extension JobSuccessViewController {
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
        self.appNavigationController?.showDashBoardViewController()
    }
}

// MARK: - ViewControllerDescribable
extension JobSuccessViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension JobSuccessViewController: AppNavigationControllerInteractable { }
