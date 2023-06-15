//
//  NotificationViewController.swift
//  Chiry
//
//  Created by Wdev3 on 20/02/21.
//

import UIKit

class NotificationViewController: UIViewController {
    
 
    @IBOutlet weak var tblNotification: UITableView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    // MARK: - Variables
    private var arrNotification : [NotificationModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
}

// MARK: - Init Configure
extension NotificationViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblNotification?.register(NotificationCell.self)
        self.tblNotification?.estimatedRowHeight = 100.0
        self.tblNotification?.rowHeight = UITableView.automaticDimension
        self.tblNotification?.delegate = self
        self.tblNotification?.dataSource = self
        
        self.setupESInfiniteScrollinWithTableView()
        self.getNotificationsListList()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Notifications", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension NotificationViewController {
    
    private func reloadTableData(){
        self.pageNo = 1
        self.arrNotification.removeAll()
        self.tblNotification?.reloadData()
        self.getNotificationsListList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblNotification?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            //self.reloadFeedData()
            self.reloadTableData()
            //self.tblFeed.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        }
        
        self.tblNotification?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    //if self.isLoadingLikeTbl {
                    self.getNotificationsListList()
                    //}
                } else if self.pageNo <= self.totalPages {
                    //if self.isLoadingLikeTbl {
                    self.getNotificationsListList(isshowloader: false)
                    //}
                } else {
                    self.tblNotification?.es.noticeNoMoreData()
                }
            } else {
                self.tblNotification?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblNotification?.footer?.animator as? ESRefreshFooterAnimator {
            animator.noMoreDataDescription = ""
        }
    }
    
    /**
     This function is used to hide the footer infinte loading.
     - Parameter success: Used to know API reponse is succeed or fail.
     */
    //Harshad
    func hideFooterLoading(success: Bool) {
        if success {
            if self.pageNo == self.totalPages {
                self.tblNotification?.es.noticeNoMoreData()
            }
            else {
                self.tblNotification?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblNotification?.es.stopLoadingMore()
            self.tblNotification?.es.noticeNoMoreData()
            self.isLoading = true
        }
    }
}

//MARK:- UITableView Delegate
extension NotificationViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath, with: NotificationCell.self)
        if self.arrNotification.count > 0 {
            cell.setData(obj: self.arrNotification[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrNotification.count > 0 {
            let obj = self.arrNotification[indexPath.row]
            if obj.model == "acceptJobRequestByUser" {
                //if let modelid = obj.model_id as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self, configuration: { (vc) in
                        vc.selectedJobID = obj.model_id
                        vc.selecetdTab = .Upcoming
                        vc.isFromHomeScreen = true
                        vc.isFromHomeUpcomingScreen = true
                    })
                //}
            } else if obj.model == "rejectJobRequestByUser" {
                //if let modelid = msgdata[kmodel_id] as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self, configuration: { (vc) in
                        vc.selectedJobID = obj.model_id
                        //vc.selecetdTab = .Upcoming
                        vc.isFromTabbar = true
                        vc.isFromHomeScreen = true
                        vc.isFromNearestJob = true
                    })
                //}
            } else if obj.model == "caregiverSubstituteJobByCaregiver" {
               // if let modelid = msgdata[kmodel_id] as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self, configuration: { (vc) in
                        vc.selectedJobID = obj.model_id
                        vc.selecetdTab = .Upcoming
                        vc.isFromHomeScreen = true
                        vc.isFromHomeUpcomingScreen = true
                    })
               // }
            } else if obj.model == "addMoneyInYourWalletForUserJobPayment" {
               // if let modelid = msgdata[kmodel_id] as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self,configuration: { vc in
                        vc.selecetdTab = .Completed
                        vc.isFromTabbar = true
                        vc.selectedJobID = obj.model_id
                    })
               // }
            } else if obj.model == "sendJobImageRequest" {
                //if let modelid = msgdata[kmodel_id] as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self, configuration: { (vc) in
                        vc.selectedJobID = obj.model_id
                        vc.selecetdTab = .Upcoming
                        vc.isFromHomeScreen = true
                        vc.isFromHomeUpcomingScreen = true
                        vc.isFromRequestJobNotification = true
                        vc.requestImageVideoType = .Image
                    })
                //}
            } else if obj.model == "sendJobVideoRequest" {
                //if let modelid = msgdata[kmodel_id] as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self, configuration: { (vc) in
                        vc.selectedJobID = obj.model_id
                        vc.selecetdTab = .Upcoming
                        vc.isFromHomeScreen = true
                        vc.isFromHomeUpcomingScreen = true
                        vc.isFromRequestJobNotification = true
                        vc.requestImageVideoType = .Video
                    })
               // }
            } else if obj.model == "ongoingJobMediaRequestOfCaregiver" {
                //if let modelid = msgdata[kmodel_id] as? Int {
                    self.appNavigationController?.detachLeftSideMenu()
                    self.appNavigationController?.push(JobDetailViewController.self, configuration: { (vc) in
                        vc.selectedJobID = obj.model_id
                        vc.selecetdTab = .Upcoming
                        vc.isFromHomeScreen = true
                        vc.isFromHomeUpcomingScreen = true
                        vc.isFromRequestJobNotification = true
                        vc.requestImageVideoType = .All
                    })
                //}
            } else if obj.model == "cancelUpcomingJobByAutoSystemForCaregiver" {
                //if let modelid = msgdata[kmodel_id] as? Int {
                self.appNavigationController?.detachLeftSideMenu()
                XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                XtraHelp.sharedInstance.setJobEndSelecetdTab = .Upcoming
                self.appNavigationController?.showDashBoardViewController()
                //}
            } else if obj.model == "sendAwardJobRequestByUser" {
                self.appNavigationController?.detachLeftSideMenu()
                XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                XtraHelp.sharedInstance.setJobEndSelecetdTab = .AwardJob
                self.appNavigationController?.showDashBoardViewController()
            }
        }
    }
}

extension NotificationViewController {
    
    private func getNotificationsListList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "15",
                ksearch : ""
                
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            NotificationModel.getNotificationsListAPICall(with: param, isShowLoader: isshowloader, success: { (arr, totalpage,msg) in
                self.tblNotification?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrNotification.append(contentsOf: arr)
                
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.tblNotification?.reloadData()
                self.lblNoData?.isHidden = (self.arrNotification.count > 0) ? true : false
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblNotification?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false )
                
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    //self.vwContent.isHidden = false
                    self.lblNoData?.isHidden = (self.arrNotification.count > 0) ? true : false
                } else {
                    if !error.isEmpty {
                       // self.showAlert(withTitle: errorType.rawValue, with: error)
                        self.showMessage(error, themeStyle: .error)
                    }
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension NotificationViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension NotificationViewController: AppNavigationControllerInteractable { }
      
