//
//  DashBoardViewController.swift
//  Chiry
//
//  Created by Wdev3 on 19/02/21.
//

import UIKit

class DashBoardViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwTabHome: TabBarItemView?
    @IBOutlet weak var vwTabMyjobs: TabBarItemView?
    @IBOutlet weak var vwTabCaregiver: TabBarItemView?
    @IBOutlet weak var vwTabFeed: TabBarItemView?
    @IBOutlet weak var vwBottom: UIView?
    @IBOutlet weak var vwContainer: UIView?
    @IBOutlet weak var vwShadow: UIView?
    
    @IBOutlet weak var vwChatMain: UIView?
    @IBOutlet weak var btnNavChat: NavigationButton?
    @IBOutlet weak var vwChatCountMain: UIView?
    @IBOutlet weak var lblChatCount: UILabel?
    
    @IBOutlet weak var vwNavNotificationMain: UIView?
    @IBOutlet weak var btnNavNotification: NavigationButton?
    @IBOutlet weak var vwNavNotificationCountMain: UIView?
    @IBOutlet weak var lblNavNotificationCount: UILabel?
    
    @IBOutlet weak var btnNavMenu: NavigationButton!
    
    // MARK: - Variables
    private var selectedTab : TabbarItemType = .Home
    
    var isHome  = false
    var isJob  = false
    var isCaregiver  = false
    var isFeed  = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setTabbarIndex()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.configureNavigationBar()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.appNavigationController?.attachLeftSideMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNotificationCountObserver(notification:)), name: NSNotification.Name(rawValue: NotificationPostname.kUpdateNotificationCount), object: nil)
    }
    
    @objc func setNotificationCountObserver(notification: Notification) {
        self.vwNavNotificationCountMain?.isHidden = XtraHelp.sharedInstance.unreadPushNotiCount == 0
        self.lblNavNotificationCount?.text = XtraHelp.sharedInstance.unreadPushNotiCount > 10 ? "9+" : "\(XtraHelp.sharedInstance.unreadPushNotiCount)"
        self.vwChatCountMain?.isHidden = XtraHelp.sharedInstance.unreadChatMsgCount == 0
        self.lblChatCount?.text = XtraHelp.sharedInstance.unreadChatMsgCount > 10 ? "9+" : "\(XtraHelp.sharedInstance.unreadChatMsgCount)"
    }
}

// MARK: - Init Configure
extension DashBoardViewController {
    private func InitConfig(){
        isHome = true
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.vwTabHome?.lblTabName.text = TabbarItemType.Home.name
        self.vwTabHome?.imgTab.image = TabbarItemType.Home.img
        self.vwTabHome?.btnSelect.tag = TabbarItemType.Home.rawValue
        
        self.vwTabMyjobs?.lblTabName.text = TabbarItemType.MyJobs.name
        self.vwTabMyjobs?.imgTab.image = TabbarItemType.MyJobs.img
        self.vwTabMyjobs?.btnSelect.tag = TabbarItemType.MyJobs.rawValue
        
        self.vwTabCaregiver?.lblTabName.text = TabbarItemType.MyCalender.name
        self.vwTabCaregiver?.imgTab.image = TabbarItemType.MyCalender.img
        self.vwTabCaregiver?.btnSelect.tag = TabbarItemType.MyCalender.rawValue
        
        self.vwTabFeed?.lblTabName.text = TabbarItemType.Feed.name
        self.vwTabFeed?.imgTab.image = TabbarItemType.Feed.img
        self.vwTabFeed?.btnSelect.tag = TabbarItemType.Feed.rawValue
        
        [self.vwTabHome,self.vwTabMyjobs,self.vwTabCaregiver,self.vwTabFeed].forEach({
            $0?.delegate = self
        })
        self.vwBottom?.backgroundColor = UIColor.CustomColor.tabBarColor
        delay(seconds: 0.1, execute: {
            self.vwBottom?.clipsToBounds = true
            self.vwShadow?.clipsToBounds = true
            self.vwShadow?.shadow(UIColor.CustomColor.blackColor, radius: 3.0, offset: CGSize(width: 0, height: -5), opacity:0.16)
            self.vwShadow?.maskToBounds = false
            self.vwBottom?.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        })
        
        [self.vwChatCountMain,self.vwNavNotificationCountMain].forEach({
            $0?.cornerRadius = 4.0
            $0?.backgroundColor = UIColor.CustomColor.btnBackColor
        })
        
        [self.lblChatCount,self.lblNavNotificationCount].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        })
        
        if let obj = XtraHelp.sharedInstance.isMoveToTabbarScreen {
            XtraHelp.sharedInstance.isMoveToTabbarScreen = nil
            self.selectedTab = obj
        }
        
        self.setTabbarIndex()
        
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetUpDashBoardTitle(title: "", TitleColor: .clear, navigationItem: self.navigationItem, isShowtitleButton: false, isShowreferButton: true, titleImage: #imageLiteral(resourceName: "Plus"))
        //self.title = "Appointments"
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.clear, tintColor: UIColor.CustomColor.borderColor)
        navigationController?.navigationBar.removeShadowLine()
    }
    
    
    private func setTabbarIndex() {
        switch self.selectedTab {
        case .Home:
            self.setHomeTab()
            break;
        case .MyJobs:
            self.setMyjobTab()
            break;
        case .MyCalender:
            self.setCaregiverTab()
            break;
        case .Feed:
            self.setFeedTab()
            break;
        }
    }
    
    private func setHomeTab() {
        
        self.removeChild()
        self.selectedTab = .Home
        self.vwTabHome?.isSelectedTab = true
        self.vwTabMyjobs?.isSelectedTab = false
        self.vwTabCaregiver?.isSelectedTab = false
        self.vwTabFeed?.isSelectedTab = false
        
        self.title = ""
        
        let st = UIStoryboard.getStoryboard(for: UIStoryboard.Name.Home.rawValue)
        
     
        if let vc = st.getViewController(with: VCIdentifier.HomeViewController) as? HomeViewController,let contentvw = self.vwContainer {
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: contentvw.frame.width, height: contentvw.frame.height)//self.vwContainer.frame
            vc.view.backgroundColor = UIColor.clear
            contentvw.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    private func setMyjobTab() {
        
        self.removeChild()
        self.selectedTab = .MyJobs
        
        self.vwTabHome?.isSelectedTab = false
        self.vwTabMyjobs?.isSelectedTab = true
        self.vwTabCaregiver?.isSelectedTab = false
        self.vwTabFeed?.isSelectedTab = false
        
        self.title = ""
        
        let st = UIStoryboard.getStoryboard(for: UIStoryboard.Name.myJob.rawValue)
     
        if let vc = st.getViewController(with: VCIdentifier.MyJobParentViewController) as? MyJobParentViewController,let contentvw = self.vwContainer {
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: contentvw.frame.width, height: contentvw.frame.height)//self.vwContainer.frame
            vc.view.backgroundColor = UIColor.clear
            contentvw.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    private func setCaregiverTab() {
        
        self.removeChild()
        self.selectedTab = .MyCalender
        
        self.vwTabHome?.isSelectedTab = false
        self.vwTabMyjobs?.isSelectedTab = false
        self.vwTabCaregiver?.isSelectedTab = true
        self.vwTabFeed?.isSelectedTab = false

        self.title = ""
        
        let st = UIStoryboard.getStoryboard(for: UIStoryboard.Name.MyCalender.rawValue)

        if let vc = st.getViewController(with: VCIdentifier.MyCalenderViewController) as? MyCalenderViewController,let contentvw = self.vwContainer {
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: contentvw.frame.width, height: contentvw.frame.height)//self.vwContainer.frame
            vc.view.backgroundColor = UIColor.clear
            vc.isFromTabbar = true
            contentvw.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
  private func setFeedTab() {
        //appNavigationController?.appNavigationControllersetUpDashBoardTitle(title: "", TitleColor: .clear, navigationItem: self.navigationItem, isShowtitleButton: false, isShowreferButton: true, titleImage: #imageLiteral(resourceName: "FeedTab"))
      self.removeChild()
      self.selectedTab = .Feed
      
      self.vwTabHome?.isSelectedTab = false
      self.vwTabMyjobs?.isSelectedTab = false
      self.vwTabCaregiver?.isSelectedTab = false
      self.vwTabFeed?.isSelectedTab = true
        
       // isFeed = true
        /*if isFeed
        {
            isFeed = false
            self.vwTabFeed.imgTab.image = TabbarItemType.Feed.Selectimg
            self.vwTabFeed.selectImg.isHidden = false
            self.vwTabCaregiver.imgTab.image = TabbarItemType.MyCalender.img
            self.vwTabMyjobs.imgTab.image = TabbarItemType.MyJobs.img
            self.vwTabHome.imgTab.image = TabbarItemType.Home.img
            self.vwTabHome.selectImg.isHidden = true
            self.vwTabMyjobs.selectImg.isHidden = true
            self.vwTabCaregiver.selectImg.isHidden = true
        }else
        {
            self.vwTabFeed.selectImg.isHidden = true
            self.vwTabFeed.imgTab.image = TabbarItemType.Feed.img
        }*/
        
        
        self.title = ""
        
        let st = UIStoryboard.getStoryboard(for: UIStoryboard.Name.FeedTab.rawValue)
        
        if let vc = st.getViewController(with: VCIdentifier.FeedViewController) as? FeedTabListViewController,let contentvw = self.vwContainer {
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: contentvw.frame.width, height: contentvw.frame.height)//self.vwContainer.frame
            vc.view.backgroundColor = UIColor.clear
            contentvw.addSubview(vc.view)
            vc.didMove(toParent: self)
        
        }
    }
}

// MARK: - IBAction
extension DashBoardViewController {
    @IBAction func btnNavMenuClicked(_ sender: NavigationButton) {
        self.appNavigationController?.openSideMenu()
    }
    
    @IBAction func btnNavChatClicked(_ sender: NavigationButton) {
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(ChatListViewController.self)
    }
    
    @IBAction func btnNavNotificationClicked(_ sender: NavigationButton) {
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(NotificationViewController.self)
    }
}

// MARK: - ViewControllerDescribable
extension DashBoardViewController : TabbarItemDelegate {
    func selectTabButton(_ sender: UIButton) {
        self.selectedTab = TabbarItemType(rawValue: sender.tag) ?? .Home
        self.setTabbarIndex()
    }
}

// MARK: - ViewControllerDescribable
extension DashBoardViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.DashBoard
    }
}

// MARK: - AppNavigationControllerInteractable
extension DashBoardViewController: AppNavigationControllerInteractable { }
