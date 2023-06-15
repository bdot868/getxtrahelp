//
//  AppSideMenuViewController.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import ViewControllerDescribable
import MessageUI

protocol AppSideMenuViewControllerDelegate: class {
    func appSideMenuViewControllerDidChooseHome(_ sideMenuViewController: AppSideMenuViewController)
}

class AppSideMenuViewController: UIViewController {
    
    @IBOutlet weak var heightConstantTblMenu: NSLayoutConstraint!
    
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewProfilePic: UIView!
    @IBOutlet var view_MainContent: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tblMenu: UITableView!
        {
        didSet {
            configureTableView()
        }
    }
    
    @IBOutlet weak var btnAbout: UIButton!
    fileprivate lazy var sections = [RowType]()
    fileprivate lazy var BottomSections = [RowType]()
    weak var delegate: AppSideMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view_MainContent.backgroundColor = UIColor.white
        //self.lblUserName.font = UIFont.FiraSansBoldFont(ofSize: DeviceType.IS_PAD ? 24.0 : 18.0)
        
        //self.lblUserName.font = UIFont.SegoeProBoldFont(ofSize: GetAppFontSize(size: 24.0))
        //self.lblUserName.textColor = UIColor.CustomColor.borderColor
        
        /*let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.vwMain.addSubview(blurEffectView)*/
        //delay(seconds: 0.2) {
            
        //}
        self.btnClose.setTitle("", for: .normal)
        //self.lblUserName.textColor = UIColor.CustomColor.whitecolor
        //self.lblUserName.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))
    }
    
    
    @IBAction func btn_Back(_ sender: Any)
    {
        self.hideLeftViewAnimated(self)
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        //self.vwMenu.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.vwMenu.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
     
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //self.removeTableviewObserver()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureProfileData()
        
        //self.addTableviewOberver()
        prepareSections()
        tblMenu?.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileObserver(notification:)), name: NSNotification.Name(rawValue: NotificationPostname.KUpdateProfile), object: nil)
    }
    
    @objc func updateProfileObserver(notification: Notification) {
        self.configureProfileData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
       // self.configureProfileData()
        return .default
    }
    
    func updateSections() {
        prepareSections()
        tblMenu?.reloadData()
    }
    
    func configureProfileData() {
        
        if let user = UserModel.getCurrentUserFromDefault() {
            
            //self.imgProfile.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: "AppPlaceholder"), indicatorStyle: .gray, isProgressive: true, imageindicator: .medium)
            //self.lblUserName.text = user.name
        }
    }
    
    func bindTapGestureToAvatar() {
        //self.imgProfile.isUserInteractionEnabled = true
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        //self.imgProfile?.addGestureRecognizer(gesture)
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        //self.showProfileViewController()
        delay(seconds: 0.2) {
            self.hideLeftViewAnimated(self)
            //self.hideRightViewAnimated(self)
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        delay(seconds: 0.2) {
            //self.hideRightViewAnimated(true)
            self.hideLeftViewAnimated(self)
        }
    }
    
    @IBAction func btnAboutClicked(_ sender: UIButton) {
        delay(seconds: 0.2) {
            self.appNavigationController?.detachLeftSideMenu()
            self.hideLeftViewAnimated(self)
            //self.appNavigationController?.push(AboutUsViewController.self)
        }
    }
    
    @IBAction func btnProfileClicked(_ sender: UIButton)
    {
        delay(seconds: 0.2)
        {
            self.appNavigationController?.detachLeftSideMenu()
            self.hideLeftViewAnimated(self)
            //self.appNavigationController?.push(ProfileViewController.self)
        }
    }
}

//MARK: - Tableview Observer
extension AppSideMenuViewController {
    
    private func addTableviewOberver() {
        self.tblMenu?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblMenu?.observationInfo != nil {
            self.tblMenu?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblMenu && keyPath == ObserverName.kcontentSize {
                self.heightConstantTblMenu?.constant = self.tblMenu?.contentSize.height ?? 0.0
            }
         
        }
    }
}

// MARK: - Rows definition
extension AppSideMenuViewController {
    enum RowType: Int {
        case MYPROFILE
        case SUBSCRIPTION
        case PaymentsBilling
        case MyReview
        case Accounts
        case NOTIFICATIONS
        case Support
        case Feedback
        case AboutXtraHelp
        case Logout
        
        var name : String {
            switch self
            {
            case .MYPROFILE:
                return "My Profile"
            case .SUBSCRIPTION:
                return "Subscription"
            case .PaymentsBilling :
                return "Billing and payments"
            case .MyReview :
                return "My Reviews"
            case .Accounts :
                return "Accounts"
            case .Support :
                return "Support"
            case .NOTIFICATIONS :
                return "Notifications"
            case .Feedback :
                return "Feedback"
            case .AboutXtraHelp :
                return "About XtraHelp"
            case .Logout :
                return "Logout"
              
            }
        }
        
        var img : UIImage {
            switch self {
            case .MYPROFILE:
                return  UIImage(named: "ic_SideMenuMyProfile") ?? UIImage()
            case .SUBSCRIPTION:
                return  UIImage(named: "ic_SideMenuSubscription") ?? UIImage()
            case .PaymentsBilling :
                return  UIImage(named: "ic_SideMenuPaymentBilling")  ?? UIImage()
            case .MyReview :
                return UIImage(named: "ic_SideMenuMyReviews")  ?? UIImage()
            case .Accounts :
                return  UIImage(named: "ic_SideMenuAccount")  ?? UIImage()
            case .Support :
                return  UIImage(named: "ic_SideMenuSupport")  ?? UIImage()
            case .NOTIFICATIONS :
                return  UIImage(named: "ic_SideMenuNotification")  ?? UIImage()
            case .Feedback :
                return  UIImage(named: "ic_SideMenuNotification")  ?? UIImage()
            case .AboutXtraHelp :
                return  UIImage(named: "ic_SideMenuNotification")  ?? UIImage()
            case .Logout :
                return  UIImage(named: "ic_SideMenuNotification")  ?? UIImage()
            }
        }
    }
    
    func prepareSections() {
       // self.configureProfileData()
        //self.imgProfile.roundedCornerRadius()
        self.sections.removeAll()
        self.sections = [.MYPROFILE,.PaymentsBilling,.NOTIFICATIONS,.Support]//[.MYPROFILE,.SUBSCRIPTION,.PaymentsBilling,.NOTIFICATIONS,.Support]
        self.BottomSections.removeAll()
        self.BottomSections = [.Feedback,.AboutXtraHelp,.Logout]
        //if let user = UserModel.getCurrentUserFromDefault() {
            //if user.invitation_status == InvitationStatus.Enable.rawValue {
               // sections = [.Profile,.Messages,.InviteBlackProfessionals,.Settings,.SendFeedback]
           //}
       //}
    }
}
// MARK: - UITableViewDataSource
extension AppSideMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        } else if section == 1 {
            return self.sections.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return cellForFeaturesSection(tableView, at: indexPath)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: SideMenuTopProfileCell.self)
            cell.selectionStyle = .none
            if let user = UserModel.getCurrentUserFromDefault() {
                cell.lblUserName?.text = "\(user.FirstName) \(user.LastName)".uppercased()
                cell.imgProfile?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                cell.lblAddress?.text = user.address
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: MenuCell.self)
            if self.sections.count > 0 {
                let obj = self.sections[indexPath.row]
                cell.lblMenuName?.text = obj.name.uppercased()
                cell.imgMenu?.image = obj.img
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: SideMenuBottomCell.self)
            cell.selectionStyle = .none
            if self.BottomSections.count > 0 {
                let obj = self.BottomSections[indexPath.row]
                cell.lblMenuName?.text = obj.name.uppercased()
                //if obj == .Logout {
                    cell.isLogout = obj == .Logout
                ///}
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension AppSideMenuViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 1 {
            //let rowType = self.sectionData(in: indexPath.row)
            if self.sections.count > 0 {
                self.didSelectFeaturesItem(self.sections[indexPath.row])
            }
        } else if indexPath.section == 2 {
            //let rowType = self.BottomSections(in: indexPath.row)
            if self.BottomSections.count > 0 {
                self.didSelectFeaturesItem(self.BottomSections[indexPath.row])
            }
        }
        /*let rowType = sectionData(in: indexPath.row)
        self.tblMenu?.isUserInteractionEnabled = false;
        didSelectFeaturesItem(rowType)
        tableView.deselectRow(at: indexPath, animated: true)
        self.hideLeftViewAnimated(self)
        perform(#selector(self.startUserIntraction), with: nil, afterDelay: 3.0)*/
    }
}



// MARK: - UITableView helpers
fileprivate extension AppSideMenuViewController
{
    
    func configureTableView() {
        self.tblMenu?.backgroundView?.backgroundColor = .clear
        self.tblMenu?.backgroundColor = .clear
        
        self.tblMenu?.register(MenuCell.self)
        self.tblMenu?.register(SideMenuTopProfileCell.self)
        self.tblMenu?.register(SideMenuBottomCell.self)
        
        self.tblMenu?.dataSource = self
        self.tblMenu?.delegate = self
        
        self.tblMenu?.estimatedRowHeight = 100.0
        self.tblMenu?.rowHeight = UITableView.automaticDimension
    }
    
    @objc func startUserIntraction(){
        self.tblMenu?.isUserInteractionEnabled = true;
    }
}
// MARK: - Private Methods
fileprivate extension AppSideMenuViewController {
    
    func showHomeViewController()
    {
        //appNavigationController?.push(HomeViewController.self)
    }
   
    func showFeedBackComposer() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["info@abc.com"])
            mailComposer.setSubject("abc Feedback")
            mailComposer.setMessageBody("", isHTML: false)
            DispatchQueue.main.async {
                self.present(mailComposer,animated: true,completion: nil)
            }
        }
        else {
            self.showMessage(AppConstant.FailureMessage.kMailNoteSetUp, themeStyle: .warning)
            //self.showAlert(with: AppConstant.FailureMessage.kMailNoteSetUp)
        }
    }
}
// MARK: - UITableView Cells definition
fileprivate extension AppSideMenuViewController {
    
    func didSelectFeaturesItem(_ rowType: RowType) {
        if rowType != .Logout {
            self.appNavigationController?.detachLeftSideMenu()
            self.hideLeftViewAnimated(self)
        }
        switch rowType
        {
        
        case .MYPROFILE:
            delay(seconds: 0.2){
                //self.appNavigationController?.push(ProfileViewController.self)
                self.appNavigationController?.push(SignupPersonalDetailViewController.self,configuration: { vc in
                    vc.isFromEditProfile = true
                })
            }
        case .SUBSCRIPTION:
            delay(seconds: 0.2){
                self.appNavigationController?.push(MembershipViewController.self,configuration: { vc in
                    vc.isFromSideMenu = true
                })
            }
        case .Accounts:
            delay(seconds: 0.2){
                //self.appNavigationController?.push(AccountViewController.self)
            }

        case .PaymentsBilling:
            delay(seconds: 0.2){
                self.appNavigationController?.push(PaymentBillingViewController.self)
            }
        case .MyReview:
            delay(seconds: 0.2){
                //self.appNavigationController?.push(MyReviewVC.self)
            }
        case .NOTIFICATIONS:
            delay(seconds: 0.2){
                self.appNavigationController?.push(NotificationSettingViewController.self)
            }
        case .Support:
            delay(seconds: 0.2){
                self.appNavigationController?.push(FAQViewController.self)
            }
        case .Feedback:
            delay(seconds: 0.2){
                self.appNavigationController?.push(FeedbackViewController.self)
            }
            break
        case .AboutXtraHelp:
            delay(seconds: 0.2){
                self.appNavigationController?.push(AboutUsViewController.self)
            }
            break
        case .Logout:
            self.showAlert(withTitle: "", with: AppConstant.AlertMessages.kLogout, firstButton: "Yes", firstHandler: { (action) in
                self.logout()
            }, secondButton: "No", secondHandler: nil)
            break
        }
  
    }

    
    
    func logoutAPICall() {
        /*UserModel.logoutUser(success: { (success) in
            appDelegate.clearUserDataForLogout()
            self.appNavigationController?.signOut()
        },failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })*/
    }
}

//MARK:- API Calling
extension AppSideMenuViewController {
    
    func logout() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.logoutUser(with: param) { (msg) in
                //self.showMessage(msg, themeStyle: .success)
                self.appNavigationController?.detachLeftSideMenu()
                self.hideLeftViewAnimated(self)
                appDelegate.clearUserDataForLogout()
                self.appNavigationController?.showLoginViewController(animationType: .fromRight)
            } failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.appNavigationController?.detachLeftSideMenu()
                self.hideLeftViewAnimated(self)
                appDelegate.clearUserDataForLogout()
                self.appNavigationController?.showLoginViewController(animationType: .fromRight)
                /*if statuscode == APIStatusCode.NoRecord.rawValue {
                    
                } else {
                    if !error.isEmpty {
                        self.showMessage(errorType.rawValue, themeStyle: .error)
                    }
                }*/
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension AppSideMenuViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}
// MARK: - AppNavigationControllerInteractable
extension AppSideMenuViewController: AppNavigationControllerInteractable { }

//MARK: - MFMailComposeViewControllerDelegate
extension AppSideMenuViewController : MFMailComposeViewControllerDelegate {
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
