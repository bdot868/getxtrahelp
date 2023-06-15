//
//  JobStartViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 01/02/22.
//

import UIKit

class JobStartViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    @IBOutlet weak var btnTalkSupport: UIButton?
    
    // MARK: - Variables
    var selectedJobData : JobModel?
    var selectedPrevJobData : JobModel?
    var isfromVerification : Bool = false
    
    private var timer: Timer?
    private var totalTimerSeconds : Int = 0
    
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
        if let time = self.timer {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}

// MARK: - Init Configure
extension JobStartViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTime?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 28.0))
     
        self.btnTalkSupport?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.btnTalkSupport?.setTitleColor(UIColor.CustomColor.tabBarColor, for: .normal)
        
        
        if let data = self.selectedJobData {
            self.totalTimerSeconds = Int(self.isfromVerification ? data.TotalSeconds : data.ongoingJobPendingSeconds) ?? 0
            self.lblTime?.text = self.convertSecondstoTime(seconds: Int(self.isfromVerification ? data.TotalSeconds : data.ongoingJobPendingSeconds) ?? 0)//data.totalTiming
            
            //print(self.convertSecondstoTime(seconds: 7450))
            if self.totalTimerSeconds > 0 {
                XtraHelp.sharedInstance.isCallJobDetailReloadData = true
                self.setTimer()
            }
        }
    }
    
    private func setTimer(){
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                print(timer)
                self.totalTimerSeconds = self.totalTimerSeconds - 1
                if self.totalTimerSeconds < 0 {
                    self.timer?.invalidate()
                    self.timer = nil
                } else {
                    self.lblTime?.text = self.convertSecondstoTime(seconds: self.totalTimerSeconds)
                }
            }
        }
    }
    
    func convertSecondstoTime(seconds: Int) -> String {

        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let second = (seconds % 3600) % 60
        if hours <= 0 {
            return "\(NSString(format: "%0.2d:%0.2d",minutes,second)) min"
        } /*else if hours <= 0 && minutes > 0{
            return "\(NSString(format: "%0.2d:%0.2d",minutes,second)) min"
        }*/
        return "\(NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,second)) min"
        //return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.setNavigationBackTitleJobStartNavigationBar(navigationItem: self.navigationItem)
        
        self.appNavigationController?.btnNextClickBlock = {
            if let obj = self.selectedPrevJobData {
                self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                    vc.chatUserID = obj.userId
                    vc.chatUserName = obj.userFullName
                    vc.chatUserImage = obj.profileImageThumbUrl
                })
            }
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension JobStartViewController {
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        if let obj = self.selectedJobData {
            self.showAlert(withTitle: "", with: "Are you sure want to end this job?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                self.endUserJob()
            }, secondButton: ButtonTitle.No, secondHandler: nil)
        }
    }
    
    @IBAction func btnTalkSupportClicked(_ sender: UIButton) {
        self.appNavigationController?.push(SupportTicketViewController.self)
    }
}

// MARK: - API
extension JobStartViewController {
    func endUserJob() {
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kjobId : jobdata.userJobId,
                kuserJobDetailId : jobdata.userJobDetailId
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.endUserJob(with: param, success: { ( msg) in
                self.showMessage(msg,themeStyle: .success,presentationStyle: .bottom)
                //XtraHelp.sharedInstance.isCallDashboardJobReloadData = true
                XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                XtraHelp.sharedInstance.setJobEndSelecetdTab = .Completed
                self.appNavigationController?.showDashBoardViewController()
                
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
extension JobStartViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension JobStartViewController: AppNavigationControllerInteractable { }
