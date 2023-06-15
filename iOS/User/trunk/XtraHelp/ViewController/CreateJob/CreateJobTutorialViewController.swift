//
//  CreateJobTutorialViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobTutorialViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    
    @IBOutlet var lblSteps: [UILabel]?
    @IBOutlet var lblStepsDesc: [UILabel]?
    // MARK: - Variables
    private var arrCategory : [JobCategoryModel] = []
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}


// MARK: - Init Configure
extension CreateJobTutorialViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
     
        self.lblSteps?.forEach({
            $0.textColor = UIColor.CustomColor.verificationTextColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 17.0))
        })
        
        self.lblStepsDesc?.forEach({
            $0.textColor = UIColor.CustomColor.tutorialColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        })
    }
}

// MARK: - IBAction
extension CreateJobTutorialViewController {
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        UserDefaults.isShowCreateJobTutorial = false
        self.dismiss(animated: true) {
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(CreateJobSelectCategoryViewController.self)
        }
    }
}

// MARK: - ViewControllerDescribable
extension CreateJobTutorialViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateJobTutorialViewController: AppNavigationControllerInteractable { }
