//
//  MyJobChildViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 27/11/21.
//

import UIKit

class MyJobChildViewController: UIViewController {


    // MARK: - IBOutlet
    @IBOutlet weak var tblJob: UITableView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    var selecetdTab : SegmentJobTabEnum = .Upcoming
    
    private var arrJob : [JobModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    private var searchText : String = ""
    var isFromHomeScreen : Bool = false
    
    private var arrFilterJobCatagories : [JobCategoryModel] = []
    private var filterNewestOldest : String = ""
    private var filterTopRated : String = ""
    private var filterOnline : String = ""
    private var filterAvailability : String = ""
    private var filterCustmeDate : Date?
    private var filterWorkingType : String = ""
    private var filterGender : String = ""
    private var filterStartAge: Int = 0
    private var filterEndAge: Int = 100
    private var filterStartDistance: Int = 0
    private var filterEndDistance: Int = 100
    private var filterVaccineted: String = ""
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isFromHomeScreen {
            self.configureNavigationBar()
        }
        
        //self.getMyPostedJob()
        self.reloadJobData()
       /* if XtraHelp.sharedInstance.isCallJobReloadData {
            XtraHelp.sharedInstance.isCallJobReloadData = false
            self.reloadJobData()
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchNotification(notification:)), name: Notification.Name(NotificationPostname.kSearchJobClick), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
    }
    
    @objc func searchNotification(notification: Notification) {
        if notification.object != nil {
            if let notificationdata : String = notification.object as? String {
                self.searchText = notificationdata
                self.reloadJobData()
            }
        }
    }
}

// MARK: - Init Configure
extension MyJobChildViewController {
    private func InitConfig(){
        
        XtraHelp.sharedInstance.careGiverDelegate = self
        
        if self.isFromHomeScreen {
            self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        }
        
        self.tblJob?.register(MyJobListCell.self)
        self.tblJob?.estimatedRowHeight = 100.0
        self.tblJob?.rowHeight = UITableView.automaticDimension
        self.tblJob?.delegate = self
        self.tblJob?.dataSource = self
        
        //if self.selecetdTab == .Posted {
            self.setupESInfiniteScrollinWithTableView()
            self.lblNoData?.isHidden = true
            //self.getMyPostedJob()
            
        /*} else {
            self.arrJob = []
            self.tblJob?.reloadData()
            self.lblNoData?.isHidden = false
            self.lblNoData?.text = "No Jobs Available!"
        }*/
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Upcoming Jobs", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - filterDelegate
extension MyJobChildViewController :  filterDelegate {
    func selectFilterData(arrCategories: [JobCategoryModel], filterNewestOldest: String, filterTopRated: String, filterOnline: String, filterAvailability: String, filterCustmeDate: Date?, filterWorkingType: String, filterGender: String, filterStartAge: Int, filterEndAge: Int, filterStartDistance: Int, filterEndDistance: Int, filterVaccineted: String) {
        self.arrFilterJobCatagories = arrCategories
        self.filterNewestOldest = filterNewestOldest
        self.filterTopRated = filterTopRated
        self.filterOnline = filterOnline
        self.filterAvailability = filterAvailability
        self.filterCustmeDate = filterCustmeDate
        self.filterWorkingType = filterWorkingType
        self.filterGender = filterGender
        self.filterStartAge = filterStartAge
        self.filterEndAge = filterEndAge
        self.filterStartDistance = filterStartDistance
        self.filterEndDistance = filterEndDistance
        self.filterVaccineted = filterVaccineted
        
        self.reloadJobData()
    }
}

//MARK: Pagination tableview Mthonthd
extension MyJobChildViewController {
    
    private func reloadJobData(){
        self.view.endEditing(true)
        //self.reloadFeedData()
        self.pageNo = 1
        self.arrJob.removeAll()
        self.tblJob?.reloadData()
        self.getMyPostedJob()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblJob?.es.addPullToRefresh {
            [unowned self] in
            self.reloadJobData()
            //self.tblFeed.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        }
        
        tblJob?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    //if self.isLoadingLikeTbl {
                    self.getMyPostedJob()
                    //}
                } else if self.pageNo <= self.totalPages {
                    //if self.isLoadingLikeTbl {
                    self.getMyPostedJob(isshowloader: false)
                    //}
                } else {
                    self.tblJob?.es.noticeNoMoreData()
                }
            } else {
                self.tblJob?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblJob?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblJob?.es.noticeNoMoreData()
            }
            else {
                self.tblJob?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblJob?.es.stopLoadingMore()
            self.tblJob?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

//MARK:- UITableView Delegate
extension MyJobChildViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJob.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: MyJobListCell.self)
        cell.isSelectedTab = self.selecetdTab
        if self.arrJob.count > 0 {
            cell.setPostedJobData(obj: self.arrJob[indexPath.row])
            
            cell.btnChat?.tag = indexPath.row
            cell.btnChat?.addTarget(self, action: #selector(self.btnChatClicked(_:)), for: .touchUpInside)
            
            cell.btnCall?.tag = indexPath.row
            cell.btnCall?.addTarget(self, action: #selector(self.btnCallClicked(_:)), for: .touchUpInside)
            
            cell.btnSessionApprove?.tag = indexPath.row
            cell.btnSessionApprove?.addTarget(self, action: #selector(self.btnApproveSubstitudeClicked(_:)), for: .touchUpInside)
            
            cell.btnSessionCancel?.tag = indexPath.row
            cell.btnSessionCancel?.addTarget(self, action: #selector(self.btnRejectSubstitudeClicked(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrJob.count > 0 {
            let obj = self.arrJob[indexPath.row]
            self.appNavigationController?.detachLeftSideMenu()
            if self.selecetdTab == .Substitute {
                self.appNavigationController?.push(ProfileViewController.self,configuration: { vc in
                    vc.selectedCaregiverID = obj.newCaregiverId
                })
            } else {
                self.appNavigationController?.push(JobDetailViewController.self,configuration: { vc in
                    vc.selecetdTab = self.selecetdTab
                    vc.selectedJobID = self.selecetdTab == .Posted ? obj.userJobId : obj.userJobDetailId
                })
            }
        }
        /*self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.OpenFromType = .AdditionalHours
        })*/
    }
    
    @objc func btnApproveSubstitudeClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            self.showAlert(withTitle: "", with: "Are you sure want to accept this request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                self.AcceptRejectJobSubstitudeAPICall(isAccept: true, jobdata: obj)
            }, secondButton: ButtonTitle.No, secondHandler: nil)
            
        }
    }
    
    @objc func btnRejectSubstitudeClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            self.showAlert(withTitle: "", with: "Are you sure want to reject this request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                self.AcceptRejectJobSubstitudeAPICall(isAccept: false, jobdata: obj)
            }, secondButton: ButtonTitle.No, secondHandler: nil)
        }
    }
    
    @objc func btnChatClicked(_ btn : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[btn.tag]
            self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                vc.chatUserID = obj.caregiverId
                vc.chatUserName = ""
                vc.chatUserImage = ""
            })
        }
    }
    
    @objc func btnCallClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            if !obj.caregiverPhone.isEmpty {
                guard let url = URL(string: "telprompt://\(obj.caregiverPhone)"),
                      UIApplication.shared.canOpenURL(url) else {
                          return
                      }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

extension MyJobChildViewController{
    
    private func getMyPostedJob(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "10",
                ksearch : self.searchText,
                ktype : self.selecetdTab.apiValue,
                kisFirst : self.filterNewestOldest,
                kisOnline : self.filterOnline,
                kisTopRated : self.filterTopRated,
                kgender : self.filterGender,
                kstartAgeRange : self.filterStartAge == 0 ? "" : "\(self.filterStartAge)",
                kendAgeRange : "\(self.filterEndAge)",//self.filterEndAge == 100 ? "" :"\(self.filterEndAge)",
                kstartMiles : self.filterStartDistance == 0 ? "" : "\(self.filterStartDistance)",
                kendMiles : "\(self.filterEndDistance)",//self.filterEndDistance == 100 ? "" : "\(self.filterEndDistance)",
                kisVaccinated : self.filterVaccineted,
                kisAvailable : self.filterAvailability,
                kcategory : (self.arrFilterJobCatagories.filter({$0.isSelectCategory})).map({$0.jobCategoryId})
            ]
            
            if let selcdate = self.filterCustmeDate {
                dict[kcustomDate] = selcdate.getFormattedString(format:AppConstant.DateFormat.k_yyyy_MM_dd)
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.getMyPostedJobList(with: param,isfromPostedJob: self.selecetdTab == .Posted ? true : false, isShowLoader: isshowloader,selectedTab : self.selecetdTab, success: { (arr,totalpage) in
               
                self.tblJob?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                
                self.totalPages = totalpage
                
                self.arrJob.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrJob.count == 0 ? false : true
                self.tblJob?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblJob?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                //self.tblJob?.es.stopPullToRefresh()
                self.hideFooterLoading(success: false)
                self.lblNoData?.isHidden = !self.arrJob.isEmpty
                self.lblNoData?.text = error
            })
        }
    }
    
    func AcceptRejectJobSubstitudeAPICall(isAccept : Bool = false,jobdata : JobModel) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(){
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                ksubstituteRequestId : jobdata.userJobSubstituteRequestId
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.AcceptRejectJobSubstitudeRequest(with: param, isAccept: isAccept) { msg in
                self.reloadJobData()
            } failure: { statuscode, error, customError in
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension MyJobChildViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension MyJobChildViewController: AppNavigationControllerInteractable { }
