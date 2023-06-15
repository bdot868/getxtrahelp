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
    var selecetdTab : SegmentJobTabEnum = .All
    
    private var arrJob : [JobModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    var isFromHomeScreen : Bool = false
    
    var searchText : String = ""
    private let alertPicker = CustomeNavigateAlert()
    
    private var arrFilterJobCatagories : [JobCategoryModel] = []
    private var arrCaregiverSpecialities : [WorkSpecialityModel] = []
    private var filterNewestOldest : String = ""
    private var filterBehavioral : String = ""
    private var filterVerbal : String = ""
    private var filterAllergies : String = ""
    private var filterStartDistance : Int = 0
    private var filterEndDistance : Int = 100
    private var filterVaccinated: String = ""
    private var filterJobType: String = ""
    
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
        
        /*if XtraHelp.sharedInstance.isCallJobReloadData {
            XtraHelp.sharedInstance.isCallJobReloadData = false
            self.reloadJobData()
        }*/
        self.reloadJobData()
        
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
        
        self.alertPicker.viewController = self
        
        XtraHelp.sharedInstance.jobfilterdelegate = self
        
        if self.isFromHomeScreen {
            self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        }
        
        self.tblJob?.register(SessionTableCell.self)
        self.tblJob?.estimatedRowHeight = 100.0
        self.tblJob?.rowHeight = UITableView.automaticDimension
        self.tblJob?.delegate = self
        self.tblJob?.dataSource = self
        
        self.setupESInfiniteScrollinWithTableView()
        
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

//MARK: - filterJobDelegate
extension MyJobChildViewController : filterJobDelegate {
    
    func selectJobFilterData(arrCategories: [JobCategoryModel], arrSpecialities: [WorkSpecialityModel], filterNewestOldest: String, filterBehavioral: String, filterVerbal: String, filterAllergies: String, filterStartDistance: Int, filterEndDistance: Int, filterVaccinated: String, filterJobType: String) {
        
        self.arrFilterJobCatagories = arrCategories
        self.arrCaregiverSpecialities = arrSpecialities
        self.filterNewestOldest = filterNewestOldest
        self.filterBehavioral = filterBehavioral
        self.filterVerbal = filterVerbal
        self.filterAllergies = filterAllergies
        self.filterStartDistance = filterStartDistance
        self.filterEndDistance = filterEndDistance
        self.filterVaccinated = filterVaccinated
        self.filterJobType = filterJobType
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
        }
        
        tblJob?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getMyPostedJob()
                } else if self.pageNo <= self.totalPages {
                    self.getMyPostedJob(isshowloader: false)
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
            } else {
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
        let cell = tableView.dequeueReusableCell(for: indexPath, with: SessionTableCell.self)
        
        if self.arrJob.count > 0 {
            let obj = self.arrJob[indexPath.row]
            
            cell.isSelectedTab =  (self.selecetdTab == .Substitute || self.selecetdTab == .AwardJob) ? self.selecetdTab : obj.jobStatus//self.selecetdTab
            cell.setPostedJobData(obj: obj)
            
            cell.btnProfile?.isUserInteractionEnabled = self.selecetdTab == .Substitute
            
            cell.btnCancelSession?.tag = indexPath.row
            cell.btnCancelSession?.addTarget(self, action: #selector(self.btnCancelJobRequestClicked(_:)), for: .touchUpInside)
            
            cell.btnChat?.tag = indexPath.row
            cell.btnChat?.addTarget(self, action: #selector(self.btnChatClicked(_:)), for: .touchUpInside)
            
            cell.btnCalender?.tag = indexPath.row
            cell.btnCalender?.addTarget(self, action: #selector(self.btnDirectionClicked(_:)), for: .touchUpInside)
            
            cell.btnCall?.tag = indexPath.row
            cell.btnCall?.addTarget(self, action: #selector(self.btnCallClicked(_:)), for: .touchUpInside)
            
            cell.btnSessionApprove?.tag = indexPath.row
            cell.btnSessionApprove?.addTarget(self, action: #selector(self.btnApproveSubstitudeClicked(_:)), for: .touchUpInside)
            
            cell.btnSessionCancel?.tag = indexPath.row
            cell.btnSessionCancel?.addTarget(self, action: #selector(self.btnRejectSubstitudeClicked(_:)), for: .touchUpInside)
            
            //cell.btnProfile?.tag = indexPath.row
            //cell.btnProfile?.addTarget(self, action: #selector(self.btnProfileClicked(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if self.selecetdTab != .AwardJob {
            if self.arrJob.count > 0 {
                let obj = self.arrJob[indexPath.row]
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(JobDetailViewController.self,configuration: { vc in
                    vc.selecetdTab = self.selecetdTab == .Substitute ? self.selecetdTab : obj.jobStatus//self.selecetdTab
                    vc.selectedJobID = self.selecetdTab == .Substitute ? obj.userJobId : obj.userJobDetailId
                    vc.isFromTabbar = true
                    if self.selecetdTab == .Substitute {
                        vc.isFromNearestJob = true
                        vc.isFromTabbar = false
                        vc.isFromHomeScreen = true
                        vc.substitudeJobRequestID = obj.userJobSubstituteRequestId
                    }
                })
            }
        }
    }
    
    /*@objc func btnProfileClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
        }
    }*/
    
    @objc func btnApproveSubstitudeClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
           
            self.showAlert(withTitle: "", with: self.selecetdTab == .AwardJob ? "Are you sure want to accept this award job request?" : "Are you sure want to accept this request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                if self.selecetdTab == .AwardJob {
                    self.AcceptRejectAwardJobAPICall(isAccept: true, jobdata: obj)
                } else {
                    self.AcceptRejectJobSubstitudeAPICall(isAccept: true, jobdata: obj)
                }
            }, secondButton: ButtonTitle.No, secondHandler: nil)
            
        }
    }
    
    @objc func btnRejectSubstitudeClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            self.showAlert(withTitle: "", with: self.selecetdTab == .AwardJob ? "Are you sure want to reject this award job request?" : "Are you sure want to reject this request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                if self.selecetdTab == .AwardJob {
                    self.AcceptRejectAwardJobAPICall(isAccept: false, jobdata: obj)
                } else {
                    self.AcceptRejectJobSubstitudeAPICall(isAccept: false, jobdata: obj)
                }
            }, secondButton: ButtonTitle.No, secondHandler: nil)
        }
    }
    
    @objc func btnCancelJobRequestClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            
            self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .CancelJob
                vc.selectedjobData = obj
                vc.isFromJobTabCancelJob = true
                vc.delegate = self
            })
        }
    }
    
    @objc func btnChatClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                vc.chatUserID = obj.userId
                vc.chatUserName = obj.userFullName
                vc.chatUserImage = obj.profileImageThumbUrl
            })
        }
    }
    
    @objc func btnCallClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            if !obj.userPhone.isEmpty {
                guard let url = URL(string: "telprompt://\(obj.userPhone)"),
                      UIApplication.shared.canOpenURL(url) else {
                          return
                      }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func btnDirectionClicked(_ sender : UIButton){
        self.view.endEditing(true)
        if self.arrJob.count > 0 {
            let obj = self.arrJob[sender.tag]
            self.alertPicker.openMapNavigation(sender as Any, "Navigate to Job", AppoitnmentLatitude: obj.latitude.toDouble() ?? 0.0, AppoitnmentLongitude: obj.longitude.toDouble() ?? 0.0)
        }
    }
}

//MARK : - JobCancelSubstituteDelegate
extension MyJobChildViewController : JobCancelSubstituteDelegate {
    func cancelJob(selectedjobData : JobModel) {
        //if let obj = selectedjobData {
            if selectedjobData.jobStatus == .Upcoming {
                self.cancelJobRequestORJobAPICall(isfromJobRequest: false,jobdata: selectedjobData)
            } else if selectedjobData.jobStatus == .Applied {
                self.cancelJobRequestORJobAPICall(isfromJobRequest: true,jobdata: selectedjobData)
            }
        //}
    }
    
    func substituteJob() {
    }
}

//MARK:- API
extension MyJobChildViewController{
    
    private func getMyPostedJob(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "15",
                ksearch : self.searchText,
                ktype : self.selecetdTab.apiValue,
                kisFirst : self.filterNewestOldest,
                kisBehavioral : self.filterBehavioral,
                kisVerbal : self.filterVerbal,
                kallergiesName : self.filterAllergies,
                kspecialitieId : self.arrCaregiverSpecialities.filter({$0.isSelectSpecialities}).map({$0.workSpecialityId}),
                kisFamilyVaccinated : self.filterVaccinated,
                kisJobType : self.filterJobType,
                kstartMiles : self.filterStartDistance == 0 ? "" : "\(self.filterStartDistance)",
                kendMiles : self.filterEndDistance == 0 ? "" : "\(self.filterEndDistance)",
                kcategory : (self.arrFilterJobCatagories.filter({$0.isSelectCategory})).map({$0.jobCategoryId})
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.kgetUserJobList(with: param, isShowLoader: isshowloader,isFromMyJobTab: true,selectedTab : self.selecetdTab,  success: { (arr,totalpage,totalWorkHours) in
                //self.arrResources = arr
                self.tblJob?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrJob.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrJob.count == 0 ? false : true
                self.tblJob?.reloadData()
                //self.tblJob?.beginUpdates()
                //self.tblJob?.endUpdates()
                //self.tblJob?.layoutIfNeeded()
                if self.selecetdTab != .Substitute {
                    NotificationCenter.default.post(name: Notification.Name(NotificationPostname.kUpdateWorkHoursCount), object: totalWorkHours, userInfo: nil)
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblJob?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                self.lblNoData?.isHidden = !self.arrJob.isEmpty
                self.lblNoData?.text = error
            })
        }
    }
    
    func cancelJobRequestORJobAPICall(isfromJobRequest : Bool = false,jobdata : JobModel) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(){
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobApplyId : jobdata.userJobApplyId
            ]
           
            if !isfromJobRequest {
                dict[kjobId] = jobdata.userJobId
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.cancelJobRequestORJob(with: param,isJobRequest: isfromJobRequest, success: { ( msg) in
                self.reloadJobData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
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
    
    func AcceptRejectAwardJobAPICall(isAccept : Bool = false,jobdata : JobModel) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(){
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobAwardId : jobdata.userJobAwardId
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.AcceptRejectJobAwardRequest(with: param, isAccept: isAccept) { msg in
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
