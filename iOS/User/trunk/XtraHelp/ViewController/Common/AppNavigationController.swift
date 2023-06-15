//
//  AppNavigationController.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import ViewControllerDescribable
import SVProgressHUD

protocol AppNavigationControllerMenuDelegate: class {
    func appNavigationController(_ appNavigationController: AppNavigationController,
                                 setLeftMenuEnabled isLeftMenuEnabled: Bool)
    
    func appNavigationController(_ appNavigationController: AppNavigationController,
                                 setLeftMenuSwipeEnabled isLeftMenuSwipeEnabled: Bool)
    
    func appNavigationControllerWasInvokedUpdateMenu(_ appNavigationController: AppNavigationController)
}

protocol AppNavigationControllerButtonDelegate: class {
    func btnMoreClicked()
}


class AppNavigationController: UINavigationController {
    
    weak var menuDelegate: AppNavigationControllerMenuDelegate?
    
    weak var btnDelegate : AppNavigationControllerButtonDelegate?
    
    var titleBarButtonItem = UIBarButtonItem()
    
    let lblHomeDashboardAddress : UILabel = UILabel()
    
    var btnNextClickBlock : (() -> ())?
    var btnAddCardClickBlock : (() -> ())?
    var btnMoreClickBlock : (() -> ())?
    var btnLeftClickBlock : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        preloadFlow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(tokenExpire(notification:)), name: NSNotification.Name(rawValue: NotificationPostname.KAuthenticationTokenExpire), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OpenNotificationDetails(notification:)), name: NSNotification.Name(rawValue: NotificationPostname.kPushNotification), object: nil)
        //self.showAlert(with: "App Navigation Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func tokenExpire(notification: Notification) {
        SVProgressHUD.dismiss()
        if let notificationdata : String = notification.object as? String {
            self.AuthTokenExpire(msg: notificationdata)
        }
    }
    
    @objc func OpenNotificationDetails(notification: Notification) {
        if notification.object != nil {
            if let notificationdata : [String : Any] = notification.object as? [String : Any] {
                print(notificationdata)
                //print("g")
                /*if let msgdic = notificationdata["messages"] as? [String:Any] {
                    print(msgdic)
                    if let msgdata = msgdic["messageData"] as? [String:Any] {
                        print(msgdata)
                        print(msgdata[kmodel_id])
                    }
                }*/
                if let msgdic = notificationdata["messages"] as? [String:Any], let msgdata = msgdic["messageData"] as? [String:Any] {
                    if let modeldtata = msgdata["model"] as? String {
                        if modeldtata == "cancelUpcomingJobByCaregiver" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(JobDetailViewController.self,configuration: { vc in
                                    vc.selecetdTab = .Posted
                                    vc.selectedJobID = "\(modelid)"
                                })
                            }
                        } else if modeldtata == "addMoneyInYourWalletForUserJobPayment" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(JobDetailViewController.self,configuration: { vc in
                                    vc.selecetdTab = .Completed
                                    vc.selectedJobID = "\(modelid)"
                                })
                            }
                        } else if modeldtata == "applyUserJobByCaregiver" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(JobDetailViewController.self,configuration: { vc in
                                    vc.selecetdTab = .Posted
                                    vc.selectedJobID = "\(modelid)"
                                })
                            }
                        } else if modeldtata == "alertUserMessageBeforeStartjobOf30Mint" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(JobDetailViewController.self,configuration: { vc in
                                    vc.selecetdTab = .Upcoming
                                    vc.selectedJobID = "\(modelid)"
                                })
                            }
                        } else if modeldtata == "caregiverSubstituteJobRequestByCaregiverToUser" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                                XtraHelp.sharedInstance.setJobEndSelecetdTab = .Substitute
                                self.showDashBoardViewController()
                            }
                        } else if modeldtata == "declineExtraTimeRequestOfCurrentJobByCaregiver" || modeldtata == "acceptExtraTimeRequestOfCurrentJobByCaregiver" || modeldtata == "transactionSuccessForAdditionaHoursJobPayment" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(JobDetailViewController.self,configuration: { vc in
                                    vc.selecetdTab = .Upcoming
                                    vc.selectedJobID = "\(modelid)"
                                })
                            }
                        } else if modeldtata == "transactionFailForJobPayment" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(JobDetailViewController.self,configuration: { vc in
                                    vc.selecetdTab = .Upcoming
                                    vc.selectedJobID = "\(modelid)"
                                })
                            }
                        } else if modeldtata == "cancelUpcomingJobByAutoSystemForUser" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                                XtraHelp.sharedInstance.setJobEndSelecetdTab = .Upcoming
                                self.showDashBoardViewController()
                            }
                        } else if modeldtata == "acceptAwardJobRequestByCaregiver" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(PaymentBillingViewController.self,configuration: { vc in
                                    vc.isFromAwardJobPayment = true
                                    vc.awardJobID = "\(modelid)"
                                })
                            }
                        }
                        else if modeldtata == "userCaregiverChatPushNotification" {
                            if let modelid = msgdata[kmodel_id] as? Int {
                                self.detachLeftSideMenu()
                                self.push(ChatDetailViewController.self,configuration: { vc in
                                    vc.chatUserID = "\(modelid)"
                                    vc.chatUserName = ""
                                    vc.chatUserImage = ""
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}
// MARK: - ViewControllerDescribable
extension AppNavigationController: ViewControllerDescribable
{
    static var storyboardName: StoryboardNameDescribable
    {
        return UIStoryboard.Name.main
    }
}
// MARK: - SideAnimatable
extension AppNavigationController: SideAnimatable { }

// MARK: - Public helpers
extension AppNavigationController {
    
    func AuthTokenExpire(msg : String = AppConstant.AlertMessages.AuthTokenExpire) {
       // self.showMessage(AppConstant.AlertMessages.AuthTokenExpire, themeStyle: .warning)
        self.showMessage(msg, themeStyle: .warning)
        //self.showAlert(withTitle: "", with: AppConstant.AlertMessages.AuthTokenExpire, firstButton: ButtonTitle.OK, firstHandler: { (UIAlertAction) in
            self.detachLeftSideMenu()
            appDelegate.clearUserDataForLogout()
            self.showLoginViewController(animationType: .fromRight)
       // }, secondButton: nil, secondHandler: nil)
    }
    
    func signOut() {
        detachLeftSideMenu()
       // showSignInViewController(animationType: .fromRight)
        appDelegate.clearUserDataForLogout()
    }
    
    func updateMenu() {
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
    }
}
// MARK: - UI helpers
extension AppNavigationController {
    func configureUI() {
        clearBackBarButtonItem()
        
        navigationBar
            .makeTranslucent()
            .configure(barTintColor: .clear, tintColor: UIColor.CustomColor.appColor)
//        navigationBar
//        .makeTranslucent()
//        .configure(barTintColor: .clear, tintColor: #colorLiteral(red: 1, green: 0.7725490196, blue: 0.3254901961, alpha: 1))
        //self.view.layer.borderColor = UIColor.CustomColor.appColor as! CGColor
    }
    
    func preloadFlow() {
        //showTutorialViewController(animationType: .fromRight)
        if UserDefaults.isUserLogin {
         XtraHelp.sharedInstance.currentUser =  UserModel.getCurrentUserFromDefault()
            if let user = UserModel.getCurrentUserFromDefault() {
                //if !user.token.isEmpty {
                    print("Login Token : \(user.token)")
                    self.detachLeftSideMenu()
                    if user.profileStatus == .Default || user.profileStatus == .Subscription {
                        /*self.push(MembershipViewController.self,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } else if user.profileStatus == .Subscription {*/
                        self.push(SignupPersonalDetailViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } else if user.profileStatus == .PersonalDetails {
                        self.push(SignupAboutYourLoveViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } else if user.profileStatus == .AboutYouLoveOne {
                        self.push(SignupLocationViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } /*else if user.profileStatus == .YourAddress {
                        self.push(SignupWorkDetailViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } else if user.profileStatus == .WorkDetails {
                        self.push(SignUpInsuranceViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } else if user.profileStatus == .Insurance {
                        self.push(AddAvailabilityViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                        })
                    } else if user.profileStatus == .SetAvailabilityAndUnderReview {
                        self.push(ProfileSuccessViewController.self,animated: true,configuration: { (vc) in
                            vc.isFromLogin = true
                            vc.SuccessSignup = true
                        })
                    }*/ else {
                        WebSocketChat.shared.connectSocket()
                        self.attachLeftSideMenu()
                        self.showDashBoardViewController()
                    }
               /* } else {
                    showTutorialViewController(animationType: .fromRight)
                }*/
            } else {
                showTutorialViewController(animationType: .fromRight)
            }
        } else {
            showTutorialViewController(animationType: .fromRight)
        }
    }
    
    func setUpLoginNavigationTitle(btntitle : String,btnTitleColor : UIColor,navigationItem : UINavigationItem) {
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_BackWhiteChat"), target: self, action: #selector(self.backbuttonClicked(sender:)))
        
        //let rightbtn = UIBarButtonItem.makBarButtonItem(with: btntitle, color: btnTitleColor, font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
        
        navigationItem.rightBarButtonItems = []
        navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
     
    func setUpFilterNavigationTitle(navigationItem : UINavigationItem) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.commonLabelColor,NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))]
        
        let leftbtn = UIBarButtonItem.makBarButtonItem(with: "Cancel", color: UIColor.CustomColor.filterBtnLogin, font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0)), target: self, action: #selector(self.leftNextbuttonClicked(sender:)))
        
        let rightbtn = UIBarButtonItem.makBarButtonItem(with: "Reset", color: UIColor.CustomColor.filterBtnLogin, font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
        
        navigationItem.rightBarButtonItems = [rightbtn]
        navigationItem.leftBarButtonItems = [leftbtn]
    }
    
    
     func setUpNavigationTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isHideBackButton : Bool = false,isShowRightBtn : Bool = false,RightBtnTitle : String = "",isfromDirect : Bool = false) {
         
         self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
         
        //let fontSize: CFloat = DeviceType.IS_PAD ? 28 : 22
        //let img = #imageLiteral(resourceName: "ic_BackImg")
        //let backBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(backbuttonClicked(sender:)))
         let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_NavBackTabColor"), target: self, action: isfromDirect ? #selector(self.backLoginButtonClicked(sender:)) : #selector(self.backbuttonClicked(sender:)))
        
        //itemWithProfilePic(colorfulImage: #imageLiteral(resourceName: "UserProfileNav"), target: self, action: #selector(profilebuttonClicked(sender:)),url: UserModel.getCurrentUserFromDefault()?.profileimage ?? "")
        //let titleBarButtonItem = UIBarButtonItem.makBarButtonDisableItem(with: title, color: UIColor.black, font: UIFont.PoppinsBold(ofSize: GetAppFontSize(size: 22.0)), target: self, action: #selector(titlebuttonClicked(sender:)))
        
        if isHideBackButton {
            navigationItem.leftBarButtonItems = []
        } else {
            navigationItem.leftBarButtonItems = [backBarButtonItem]
        }
        
        
         if !isShowRightBtn {
             navigationItem.rightBarButtonItems = []
         } else {
             let rightbtn = UIBarButtonItem.makBarButtonItem(with: RightBtnTitle, color: TitleColor, font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
             navigationItem.rightBarButtonItems = [rightbtn]
         }
        //} else {
            //navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
        //}
        //navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
        
    }
    
    
    func setUpProfileCaregiverNavigationTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isHideBackButton : Bool = false,isShowRightBtn : Bool = false,RightBtnTitle : String = "",isfromDirect : Bool = false) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
       //let fontSize: CFloat = DeviceType.IS_PAD ? 28 : 22
       //let img = #imageLiteral(resourceName: "ic_BackImg")
       //let backBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(backbuttonClicked(sender:)))
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_NavBackTabColor"), target: self, action: isfromDirect ? #selector(self.backLoginButtonClicked(sender:)) : #selector(self.backbuttonClicked(sender:)))
       
       //itemWithProfilePic(colorfulImage: #imageLiteral(resourceName: "UserProfileNav"), target: self, action: #selector(profilebuttonClicked(sender:)),url: UserModel.getCurrentUserFromDefault()?.profileimage ?? "")
       //let titleBarButtonItem = UIBarButtonItem.makBarButtonDisableItem(with: title, color: UIColor.black, font: UIFont.PoppinsBold(ofSize: GetAppFontSize(size: 22.0)), target: self, action: #selector(titlebuttonClicked(sender:)))
       
       if isHideBackButton {
           navigationItem.leftBarButtonItems = []
       } else {
           navigationItem.leftBarButtonItems = [backBarButtonItem]
       }
       
       
        if !isShowRightBtn {
            navigationItem.rightBarButtonItems = []
        } else {
            let rightbtn = UIBarButtonItem.itemWithCustomRightTitle(textBtn : "Hire",target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
            //UIBarButtonItem.makBarButtonItem(with: RightBtnTitle, color: TitleColor, font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
            
            navigationItem.rightBarButtonItems = [rightbtn]
        }
       //} else {
           //navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
       //}
       //navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
       
   }
    
    func setUpBackWithTitleNavigationBar(title : String,TitleColor : UIColor,navigationItem : UINavigationItem) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_LeftArrowWhite"), target: self, action: #selector(self.backbuttonClicked(sender:)))
        navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
    
   
    /*func appNavigationControllersetUpBackWithTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem) {
        
        self.setUpNavigationBackWithTitleButton(title: title, TitleColor: TitleColor, navigationItem: navigationItem)
    }*/
    
    func setUpBackWithTitlePaymentNavigationBar(title : String,TitleColor : UIColor,navigationItem : UINavigationItem) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_BackImg"), target: self, action: #selector(self.backbuttonClicked(sender:)))
        navigationItem.leftBarButtonItems = [backBarButtonItem]
        
        let addCardBarButtonItem = UIBarButtonItem.btnWithPic(colorfulImage: #imageLiteral(resourceName: "ic_AddCard"), target: self, action: #selector(self.addCardbuttonClicked(sender:)))
        navigationItem.rightBarButtonItems = [addCardBarButtonItem]
    }
    
    func setUpBackWithTitleNavigationBarWithColor(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isShowBackButton : Bool = true,isShowDirectHome : Bool = false) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : TitleColor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        if isShowBackButton{
            let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_LeftArrowWhite"), target: self, action: isShowDirectHome ? #selector(self.directHomeButtonClicked(sender:)) : #selector(self.backbuttonClicked(sender:)))
            navigationItem.leftBarButtonItems = [backBarButtonItem]
        } else {
            navigationItem.leftBarButtonItems = []
            navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    func setUpNavigationBackWithTitleButton(title : String,TitleColor : UIColor,navigationItem : UINavigationItem) {
        
        let titleBarButtonItem = UIBarButtonItem.makBarTestButtonDisableItem(with: title, color: TitleColor, font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0)), target: self, action: #selector(titlebuttonClicked(sender:)))
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_NavBackTabColor"), target: self, action: #selector(self.backbuttonClicked(sender:)))
        
        navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
    }
     
     func setUpNavigationBackWhiteButton(navigationItem : UINavigationItem) {
         
         let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_NavWhiteBlog"), target: self, action: #selector(self.backbuttonClicked(sender:)))
         
         navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
     }
    
    func setUpBackTitleRightBackBtnNavigationBar(title : String,TitleColor : UIColor,rightBtntitle : String,rightBtnColor : UIColor,navigationItem : UINavigationItem) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let titleBarButtonItem = UIBarButtonItem.makBarTestButtonDisableItem(with: title, color: TitleColor, font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0)), target: self, action: #selector(titlebuttonClicked(sender:)))
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_NavBackTabColor"), target: self, action: #selector(self.backbuttonClicked(sender:)))
        navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
        
        let rightbtn = UIBarButtonItem.makBarButtonItem(with: rightBtntitle, color: rightBtnColor, font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
        
        navigationItem.rightBarButtonItems = [rightbtn]
        //navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
    
    func setUpLinkdinNavigationTitle(title : String,navigationItem : UINavigationItem,RightBtnTitle : String = "") {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.whitecolor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_NavWhiteBlog"), target: self, action: #selector(self.backbuttonClicked(sender:)))
        navigationItem.leftBarButtonItems = [backBarButtonItem]
       
        let rightbtn = UIBarButtonItem.makBarButtonItem(with: RightBtnTitle, color: UIColor.CustomColor.whitecolor, font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
        navigationItem.rightBarButtonItems = [rightbtn]
   }
    
    func setUpBackTitleandRightButtonColorNavigationBar(titlecolor : UIColor, buttontitle : String,ButtonColor : UIColor,isMoveDashboard : Bool ,isShowRightButton : Bool,navigationItem : UINavigationItem) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titlecolor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_LeftArrowWhite"), target: self, action: isMoveDashboard ? #selector(self.dashboardBackbuttonClicked(sender:)) : #selector(self.backbuttonClicked(sender:)))
        navigationItem.leftBarButtonItems = [backBarButtonItem]
        
        if isShowRightButton {
            let rightbtn = UIBarButtonItem.makBarButtonItem(with: buttontitle, color: ButtonColor, font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
            
            navigationItem.rightBarButtonItems = [rightbtn]
        }
        navigationItem.leftBarButtonItems = [backBarButtonItem]
    }
    
    func setUpTabbarNavigationTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isHideMsgButton : Bool = false) {
        
        let titleBarButtonItem = UIBarButtonItem.makBarButtonDisableItem(with: title, color: UIColor.black, font: UIFont.RubikBold(ofSize: GetAppFontSize(size: 22.0)), target: self, action: #selector(titlebuttonClicked(sender:)))
        
        let menuBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .plain, target: self, action: #selector(menubuttonClicked(sender:)))
        let msgBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Navmessages"), style: .plain, target: self, action: #selector(self.messagebuttonClicked(sender:)))
        
        if isHideMsgButton {
            navigationItem.leftBarButtonItems = [titleBarButtonItem]
            navigationItem.rightBarButtonItems = [menuBarButtonItem]
        } else {
            navigationItem.leftBarButtonItems = [titleBarButtonItem]
            navigationItem.rightBarButtonItems = [menuBarButtonItem,msgBarButtonItem]
        }
        //navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem]
        
    }
    
    func setUpNavigationTitleDashBoard(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isShowTitleButton : Bool = false,isShowReferButton : Bool = false,isHideLogo : Bool = true) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.whitecolor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "sidemenu"), target: self, action: #selector(self.menubuttonClicked(sender:)))
        //itemWithProfilePic(colorfulImage: #imageLiteral(resourceName: "UserProfileNav"), target: self, action: #selector(profilebuttonClicked(sender:)),url: UserModel.getCurrentUserFromDefault()?.profileimage ?? "")
        let titleBarButtonItem = UIBarButtonItem.makBarButtonDisableItem(with: title, color: UIColor.CustomColor.tabBarColor, font: UIFont.RubikBold(ofSize: GetAppFontSize(size: 15.0)), target: self, action: #selector(titlebuttonClicked(sender:)))
        let logoXtra = UIBarButtonItem.itemWithCustomPic(colorfulImage: #imageLiteral(resourceName: "Logo_Login"), target: self, action: #selector(titlebuttonClicked(sender:)))
        
        if !isShowTitleButton {
            if isHideLogo {
                navigationItem.leftBarButtonItems = [backBarButtonItem,logoXtra]
            } else {
                let btnlogo = UIBarButtonItem.btnWithLogoPic(colorfulImage: #imageLiteral(resourceName: "ic_MenuChiryLogo"), target: self, action: #selector(self.logobuttonClicked(sender:)))
                navigationItem.leftBarButtonItems = [backBarButtonItem,btnlogo,logoXtra]
            }
        } else {
            navigationItem.leftBarButtonItems = [backBarButtonItem,titleBarButtonItem,logoXtra]
        }
        
        
        let notificationBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "notification"), target: self, action: #selector(self.notificationbuttonClicked(sender:)))
       
        let newref = UIBarButtonItem.itemWithBackPic(colorfulImage:  #imageLiteral(resourceName: "Message"), target: self, action: #selector(self.referbuttonClicked(sender:)))
     
        
        if isShowReferButton {
            navigationItem.rightBarButtonItems = [notificationBarButtonItem,newref]//[notificationBarButtonItem,referBarButtonItem]
        } else {
            navigationItem.rightBarButtonItems = [notificationBarButtonItem,newref]//[notificationBarButtonItem]
        }
    }
    
    /*func setUpBackTitleandRightButtonColorNavigationBar(titlecolor : UIColor, buttontitle : String,ButtonColor : UIColor,isMoveDashboard : Bool ,isShowRightButton : Bool,navigationItem : UINavigationItem,isMoreButtonRight : Bool) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : titlecolor,NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))]
        
        let backBarButtonItem = UIBarButtonItem.itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_BackImg"), target: self, action: isMoveDashboard ? #selector(self.dashboardBackbuttonClicked(sender:)) : #selector(self.backbuttonClicked(sender:)))
        navigationItem.leftBarButtonItems = [backBarButtonItem]
        
        if isShowRightButton {
            if isMoreButtonRight {
                let rightbtn = UIBarButtonItem.btnWithPic(colorfulImage: #imageLiteral(resourceName: "ic_Morebtn"), target: self, action: #selector(self.moreButtonClicked(sender:)))
                //itemWithBackPic(colorfulImage: #imageLiteral(resourceName: "ic_Morebtn"), target: self, action: isMoveDashboard ? #selector(self.dashboardBackbuttonClicked(sender:)) : #selector(self.backbuttonClicked(sender:)))
                navigationItem.rightBarButtonItems = [rightbtn]
            } else {
                let rightbtn = UIBarButtonItem.makBarButtonItem(with: buttontitle, color: ButtonColor, font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0)), target: self, action: #selector(self.rightNextbuttonClicked(sender:)))
                
                navigationItem.rightBarButtonItems = [rightbtn]
            }
        }
        navigationItem.leftBarButtonItems = [backBarButtonItem]
    }*/
    
    
    func setUpHomeNavigationTitle(title : String,TitleColor : UIColor,font : UIFont,navigationItem : UINavigationItem) {
        let img = #imageLiteral(resourceName: "side-menu")
        let menuBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(menubuttonClicked))

        self.lblHomeDashboardAddress.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 100, height: self.navigationBar.frame.height)
        //label.font = UIFont(name: "Arial-BoldMT", size: 16)
        lblHomeDashboardAddress.text = title
        lblHomeDashboardAddress.font = font
        lblHomeDashboardAddress.textAlignment = .left
        lblHomeDashboardAddress.textColor = TitleColor
        lblHomeDashboardAddress.backgroundColor = UIColor.clear
        
        self.titleBarButtonItem = UIBarButtonItem(customView: lblHomeDashboardAddress)
        navigationItem.leftBarButtonItems = [menuBarButtonItem,self.titleBarButtonItem]
    }
    
    @objc func rightNextbuttonClicked(sender: UIBarButtonItem) {
        //self.view.endEditing(true)
        self.btnNextClickBlock?()
    }
    
    @objc func messagebuttonClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    @objc func logobuttonClicked(sender: UIBarButtonItem) {
    }
    
    @objc func menubuttonClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        //sideMenuController?.showLeftViewAnimated(sender: self)
        //sideMenuController?.toggleLeftView(sender: self)
        //sideMenuController?.showLeftView()
        self.showLeftViewAnimated(self)
        //self.showRightViewAnimated(self)
        
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
        //self.showRightView(self)
    }
     
    @objc func leftNextbuttonClicked(sender: UIBarButtonItem) {
        //self.view.endEditing(true)
        self.btnLeftClickBlock?()
    }
    
    @objc func moreButtonClicked(sender: UIBarButtonItem) {
        if let del = self.btnDelegate {
            del.btnMoreClicked()
        }
        self.btnMoreClickBlock?()
    }
    
    @objc func titlebuttonClicked(sender: UIBarButtonItem) {
    }
    
    @objc func referbuttonClicked(sender: UIBarButtonItem) {
        
    }
    
    @objc func notificationbuttonClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
//        detachLeftSideMenu()
        //self.showNotificationViewController(animationType: .fromRight)
        self.push(NotificationViewController.self)
    }
    
    @objc func dashboardBackbuttonClicked(sender: UIBarButtonItem) {
        //self.showDashBoardViewController()
    }
    
    @objc func backbuttonClicked(sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
    
    @objc func directHomeButtonClicked(sender: UIBarButtonItem) {
        self.showDashBoardViewController()
    }
     
     @objc func backLoginButtonClicked(sender: UIBarButtonItem) {
         appDelegate.clearUserDataForLogout()
         self.showLoginViewController(animationType: .fromRight, configuration: nil)
     }
    
    @objc func addCardbuttonClicked(sender: UIBarButtonItem) {
        //self.push(AddCardViewController.self)
        self.btnAddCardClickBlock?()
    }
}

// MARK: - Presentation
extension AppNavigationController {
    
    
    func appNavigationControllersetUpDashBoardTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isShowtitleButton : Bool = false,isShowreferButton : Bool = false, titleImage : UIImage) {
        
        //self.setUpTabbarNavigationTitle(title: title, TitleColor: TitleColor, navigationItem: navigationItem, isHideMsgButton: isHideMsgButton)
        self.setUpNavigationTitleDashBoard(title: title, TitleColor: TitleColor, navigationItem: navigationItem, isShowTitleButton: isShowtitleButton, isShowReferButton: isShowreferButton)
        self.attachLeftSideMenu()
    }
    
    func attachLeftSideMenu() {
        menuDelegate?.appNavigationController(self, setLeftMenuEnabled: true)
        menuDelegate?.appNavigationController(self, setLeftMenuSwipeEnabled: true)
        
        //menuDelegate?.app
    }
    func openSideMenu(){
        self.showLeftViewAnimated(self)
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
    }
    
    func detachLeftSideMenu() {
        self.hideLeftViewAnimated(self)
        //sideMenuController?.showLeftViewAnimated(self)
        //hideRightViewAnimated(self)
        
        menuDelegate?.appNavigationController(self, setLeftMenuEnabled: false)
        menuDelegate?.appNavigationController(self, setLeftMenuSwipeEnabled: false)
    }
    
    func showTutorialViewController(animationType: SideAnimationType,
                                  configuration: ((TutorialViewController) -> Void)? = nil) {
        let signInViewController = TutorialViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        detachLeftSideMenu()
    }
    
    func showLoginViewController(animationType: SideAnimationType,
                                  configuration: ((LoginViewController) -> Void)? = nil) {
        let signInViewController = LoginViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        detachLeftSideMenu()
    }
    
    func showDashBoardViewController() {
        
        let dashController = DashBoardViewController.instantiated { [unowned self] dashController in
            _ = self.viewControllers.first as? DashBoardViewController
        }
        setViewControllers([dashController], animated: true)
        attachLeftSideMenu()
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
        
        
    }
    
    /*func showDashboardController() {
        
        let dashController = HomeViewController.instantiated { [unowned self] dashController in
            _ = self.viewControllers.first as? HomeViewController
        }
        setViewControllers([dashController], animated: true)
        attachLeftSideMenu()
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
    }
    
    func showAccountSetupController() {
        
        let dashController = AccountSetupViewController.instantiated { [unowned self] dashController in
            _ = self.viewControllers.first as? AccountSetupViewController
        }
        setViewControllers([dashController], animated: true)
        detachLeftSideMenu()
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
    }
    
    func showTaBarController() {
        
        let dashController = TabBarViewController.instantiated { [unowned self] dashController in
            _ = self.viewControllers.first as? TabBarViewController
        }
        setViewControllers([dashController], animated: true)
        attachLeftSideMenu()
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
    }*/
    
    /*func showSignInViewController(animationType: SideAnimationType,
                                  configuration: ((LoginViewController) -> Void)? = nil) {
        let signInViewController = LoginViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        detachLeftSideMenu()
    }
    
    func showWelcomeViewController(animationType: SideAnimationType,
                                  configuration: ((WelcomeViewController) -> Void)? = nil) {
        let signInViewController = WelcomeViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        detachLeftSideMenu()
    }
    
    
    func showNotificationViewController(animationType: SideAnimationType,
                                  configuration: ((NotificationViewController) -> Void)? = nil) {
        let signInViewController = NotificationViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        detachLeftSideMenu()
    }
    
    func showDocumentReportViewController(animationType: SideAnimationType,
                                  configuration: ((DocumentReportListViewController) -> Void)? = nil) {
        let signInViewController = DocumentReportListViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        detachLeftSideMenu()
    }
    
    */
    
    /*func showDashBoardViewController(animationType: SideAnimationType,
                                  configuration: ((DashBoardViewController) -> Void)? = nil) {
        let signInViewController = DashBoardViewController.instantiated ()
        
        setViewController(signInViewController, with: animationType) { vc in
            configuration?(vc)
        }
        
        attachLeftSideMenu()
        menuDelegate?.appNavigationControllerWasInvokedUpdateMenu(self)
    }*/
}

// MARK: - AppSideMenuViewControllerDelegate
extension AppNavigationController: AppSideMenuViewControllerDelegate {
    func appSideMenuViewControllerDidChooseHome(_ sideMenuViewController: AppSideMenuViewController) {
        sideMenuController?.hideLeftViewAnimated(self)
    }
    func appNavigationControllerLogin(btntitle : String,btnTitleColor : UIColor,navigationItem : UINavigationItem) {
        self.setUpLoginNavigationTitle(btntitle: btntitle, btnTitleColor: btnTitleColor, navigationItem: navigationItem)
    }
    
    func appNavigationControllerBlogDetail(navigationItem : UINavigationItem) {
        self.setUpNavigationBackWhiteButton(navigationItem: navigationItem)
    }
    
    func appNavigationControllerLinkdnTitle(title : String,navigationItem : UINavigationItem,RightBtnTitle : String = "") {
        self.setUpLinkdinNavigationTitle(title: title, navigationItem: navigationItem, RightBtnTitle: RightBtnTitle)
    }
    
    func appNavigationControllerTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isHideBackButton : Bool = false,isShowRightBtn : Bool = false,RightBtnTitle : String = "",isFromDirect : Bool = false) {
        self.setUpNavigationTitle(title: title, TitleColor: TitleColor, navigationItem: navigationItem,isHideBackButton: isHideBackButton,isShowRightBtn : isShowRightBtn,RightBtnTitle : RightBtnTitle,isfromDirect : isFromDirect)
    }
    
    //setUpProfileCaregiverNavigationTitle
    func appCaregiverProfileNavigationControllerTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isHideBackButton : Bool = false,isShowRightBtn : Bool = false,RightBtnTitle : String = "",isFromDirect : Bool = false) {
        self.setUpProfileCaregiverNavigationTitle(title: title, TitleColor: TitleColor, navigationItem: navigationItem,isHideBackButton: isHideBackButton,isShowRightBtn : isShowRightBtn,RightBtnTitle : RightBtnTitle,isfromDirect : isFromDirect)
    }
    
    func appNavigationControllersetUpTabbarTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isHideMsgButton : Bool = false) {
        
        self.setUpTabbarNavigationTitle(title: title, TitleColor: TitleColor, navigationItem: navigationItem, isHideMsgButton: isHideMsgButton)
    }
    
    func appNavigationControllersetTitleWithBack(title : String,TitleColor : UIColor,navigationItem : UINavigationItem) {
        
        self.setUpNavigationBackWithTitleButton(title: title, TitleColor: TitleColor, navigationItem: navigationItem)
    }
    
    func appNavigationControllersetTitleWithBackWithColor(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isshowBackButton : Bool,isShowDirectHome : Bool = false) {
        
        self.setUpBackWithTitleNavigationBarWithColor(title: title, TitleColor: TitleColor, navigationItem: navigationItem,isShowBackButton: isshowBackButton,isShowDirectHome: isShowDirectHome)
    }
    
    func appNavigationControllersetUpDashBoardTitle(title : String,TitleColor : UIColor,navigationItem : UINavigationItem,isShowtitleButton : Bool = false,isShowreferButton : Bool = false,isHideLogo : Bool = true) {
        
        //self.setUpTabbarNavigationTitle(title: title, TitleColor: TitleColor, navigationItem: navigationItem, isHideMsgButton: isHideMsgButton)
        self.setUpNavigationTitleDashBoard(title: title, TitleColor: TitleColor, navigationItem: navigationItem, isShowTitleButton: isShowtitleButton, isShowReferButton: isShowreferButton,isHideLogo : isHideLogo)
        self.attachLeftSideMenu()
    }

    func appNavigationControllersetTitleAndButtonColor(Titlecolor : UIColor, Buttontitle : String,buttonColor : UIColor,navigationItem : UINavigationItem,ismoveDashboard : Bool = false,isShowRightButton : Bool = true) {
    
        self.setUpBackTitleandRightButtonColorNavigationBar(titlecolor: Titlecolor, buttontitle: Buttontitle, ButtonColor: buttonColor, isMoveDashboard: ismoveDashboard, isShowRightButton: isShowRightButton, navigationItem: navigationItem)
    }
    
    func appHomeNavigationControllerTitle(title : String,TitleColor : UIColor,font : UIFont = UIFont.systemFont(ofSize: CGFloat(DeviceType.IS_PAD ? 28 : 24)),navigationItem : UINavigationItem) {
        self.setUpHomeNavigationTitle(title: title, TitleColor: TitleColor, font: font, navigationItem: navigationItem)
    }
    
    func setNavigationBackTitleRightBackBtnNavigationBar(title : String,TitleColor : UIColor,rightBtntitle : String,rightBtnColor : UIColor,navigationItem : UINavigationItem) {
        
        self.setUpBackTitleRightBackBtnNavigationBar(title: title, TitleColor: TitleColor, rightBtntitle: rightBtntitle, rightBtnColor: rightBtnColor, navigationItem: navigationItem)
    }
    
    func setFilterNavigationBar(navigationItem : UINavigationItem) {
        self.setUpFilterNavigationTitle(navigationItem: navigationItem)
    }
    
}

