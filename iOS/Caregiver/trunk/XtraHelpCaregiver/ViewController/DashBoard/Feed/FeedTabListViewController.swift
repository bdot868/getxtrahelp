//
//  FeedTabListViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 26/11/21.
//

import UIKit

class FeedTabListViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var vwSearchMain: UIView?
    @IBOutlet weak var vwSearch: SearchView?
    @IBOutlet weak var vwContentMain: UIView?
   
    @IBOutlet weak var tblFeed: UITableView?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var btnWhatsYourMind: UIButton?
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var arrFeed : [FeedModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.appNavigationController?.attachLeftSideMenu()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let img = self.imgProfile {
            img.cornerRadius = img.frame.height/2
        }
    }
    
}

// MARK: - Init Configure
extension FeedTabListViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
       
        self.tblFeed?.register(FeedCell.self)
        self.tblFeed?.estimatedRowHeight = 100.0
        self.tblFeed?.rowHeight = UITableView.automaticDimension
        self.tblFeed?.delegate = self
        self.tblFeed?.dataSource = self
        
        if let user = UserModel.getCurrentUserFromDefault() {
            self.imgProfile?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        
        self.setupESInfiniteScrollinWithTableView()
        self.getFeedList()
    }
}

//MARK: Pagination tableview Mthonthd
extension FeedTabListViewController {
    
    private func reloadFeedData(){
        self.view.endEditing(true)
        self.pageNo = 1
        self.arrFeed.removeAll()
        self.tblFeed?.reloadData()
        self.getFeedList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblFeed?.es.addPullToRefresh {
            [unowned self] in
            self.reloadFeedData()
        }
        
        self.tblFeed?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getFeedList()
                } else if self.pageNo <= self.totalPages {
                    self.getFeedList(isshowloader: false)
                } else {
                    self.tblFeed?.es.noticeNoMoreData()
                }
            } else {
                self.tblFeed?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblFeed?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblFeed?.es.noticeNoMoreData()
            }
            else {
                self.tblFeed?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblFeed?.es.stopLoadingMore()
            self.tblFeed?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

//MARK:- UITableView Delegate
extension FeedTabListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFeed.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: FeedCell.self)
        
        if self.arrFeed.count > 0 {
            cell.setFeedData(obj: self.arrFeed[indexPath.row])
            
            cell.delegate = self
        }
        
        cell.btnCommentSelect?.tag = indexPath.row
        cell.btnCommentSelect?.addTarget(self, action: #selector(self.btnCommentClicked(_:)), for: .touchUpInside)
        
        cell.btnLikeSelect?.tag = indexPath.row
        cell.btnLikeSelect?.addTarget(self, action: #selector(self.btnLikeClicked(_:)), for: .touchUpInside)
        
        cell.btnMoreSelect?.tag = indexPath.row
        cell.btnMoreSelect?.addTarget(self, action: #selector(self.btnMoreClicked(_:)), for: .touchUpInside)
        
        /*cell.btnProfile?.tag = indexPath.row
        cell.btnProfile?.addTarget(self, action: #selector(self.btnProfileClicked(_:)), for: .touchUpInside)*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnProfileClicked(_ sender : UIButton){
        /*if self.arrFeed.count > 0 {
            let obj = self.arrFeed[sender.tag]
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(MentorProfileViewController.self,configuration: { vc in
                //vc.selectedFeedData = self.arrFeed[sender.tag]
                vc.selectedUserId = obj.userId
                if let user = UserModel.getCurrentUserFromDefault() {
                    vc.isfromSideMenu = user.id == obj.userId
                }
            })
        }*/
    }
    
    @objc func btnCommentClicked(_ sender : UIButton){
        if self.arrFeed.count > 0 {
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(FeedCommentViewController.self,configuration: { vc in
                vc.selectedFeedData = self.arrFeed[sender.tag]
            })
        }
    }
    
    @objc func btnLikeClicked(_ sender : UIButton){
        if self.arrFeed.count > 0 {
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(FeedLikeListViewController.self,configuration: { vc in
                vc.selectedFeedData = self.arrFeed[sender.tag]
                //vc.isFromJobApplicant = false
            })
        }
    }
    
    @objc func btnMoreClicked(_ sender : UIButton){
        if self.arrFeed.count > 0 {
            /*self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.present(PopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.isFromFeedTab = true
                vc.isFromFeedComment = false
                vc.feeddelegate = self
                vc.selectedFeedData = self.arrFeed[sender.tag]
            })*/
            let obj = self.arrFeed[sender.tag]
            let getDirectionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            //Open Apple Map
            let reportAction = UIAlertAction(title: "Report", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.present(FeedReportPopupViewController.self,configuration: { (vc) in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.selectedFeedData = obj
                })
            })
            
            //OPen Gogole Map
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.showAlert(withTitle: "", with: "Are you sure want to delete this feed?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                    self.deleteFeed(feedID: obj.id)
                }, secondButton: ButtonTitle.No, secondHandler: nil)
            })
            
            let editAction = UIAlertAction(title: "Edit", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
                self.appNavigationController?.push(CreateFeedPostViewController.self,configuration: { vc in
                    vc.selectedFeedData = obj
                    vc.isFromEdit = true
                    vc.delegate = self
                })
            })
            
            //cancel
            let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
     
            })
            
            getDirectionMenu.popoverPresentationController?.sourceView = sender as? UIView
            //        getDirectionMenu.popoverPresentationController?.permittedArrowDirections = .down
            
            if let user = UserModel.getCurrentUserFromDefault() {
                if (user.id == obj.userId) {
                    getDirectionMenu.addAction(editAction)
                    getDirectionMenu.addAction(deleteAction)
                } else {
                    getDirectionMenu.addAction(reportAction)
                }
            }
            
            getDirectionMenu.addAction(cancelAction)
            self.present(getDirectionMenu, animated: true, completion: nil)
        }
    }
}

// MARK: - FeedCellDelegate
/*extension FeedTabListViewController : feedPopupDelegate {
    func feedCommentReport(btn: UIButton, obj: FeedUserLikeModel) {
        
    }
    
    func feedCommentDelete(btn: UIButton, obj: FeedUserLikeModel) {
        
    }
    
    func feedReport(btn: UIButton, obj: FeedModel) {
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.present(FeedReportPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.selectedFeedData = obj
        })
    }
    
    func feedDelete(btn: UIButton, obj: FeedModel) {
        self.showAlert(withTitle: "", with: "Are you sure want to delete this feed?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
            self.deleteFeed(feedID: obj.id)
        }, secondButton: ButtonTitle.No, secondHandler: nil)
    }
}*/

// MARK: - FeedCellDelegate
extension FeedTabListViewController : FeedCellDelegate {
    func btnMoreSelect(btn: UIButton, cell: FeedCell) {
        
    }
    
    func btnLikeSelect(btn: UIButton,cell : FeedCell) {
        self.view.endEditing(true)
        if let indexpath = self.tblFeed?.indexPath(for: cell) {
            if self.arrFeed.count > 0 {
                let obj = self.arrFeed[indexpath.row]
                var count : Int = Int(obj.totalLikes) ?? 0
                if btn.isSelected {
                    count = count + 1
                } else {
                    count = count - 1
                }
                obj.isLiked = btn.isSelected ? "1" : "0"
                obj.totalLikes = "\(count)"
                self.setFeedLikeUnlike(isLike: btn.isSelected ? "1" : "0", feedID: self.arrFeed[indexpath.row].id)
                self.tblFeed?.reloadData()
            }
        }
    }
}

// MARK: - IBAction
extension FeedTabListViewController {
    @IBAction func btnWhatsYourMindClicked(_ sender: UIButton) {
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(CreateFeedPostViewController.self,configuration: { vc in
            vc.delegate = self
        })
    }
}

// MARK: - IBAction
extension FeedTabListViewController : FeedDelegate{
    func updateFeedData() {
        self.reloadFeedData()
    }
}

//MARK:- API Call
extension FeedTabListViewController{
    
    private func getFeedList(isshowloader :Bool = true){
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
            
            FeedModel.getFeedList(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage,msg) in
                //self.arrFeed.append(contentsOf: arr)
                self.tblFeed?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrFeed.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrFeed.count == 0 ? false : true
                self.tblFeed?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblFeed?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    /*self.lblNoData?.isHidden = self.arrFeed.count == 0 ? false : true
                    self.lblNoData?.text = error
                    self.tblFeed?.reloadData()*/
                    
                    self.lblNoData?.text = error
                    if pageNo == 1 {
                        self.arrFeed.removeAll()
                    }
                    self.lblNoData?.isHidden = self.arrFeed.count == 0 ? false : true
                    self.tblFeed?.reloadData()
                } else {
                    if !error.isEmpty {
                        self.showMessage(error, themeStyle: .error)
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                    }
                }
            })
        }
    }
    
    private func setFeedLikeUnlike(isLike : String,feedID : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserFeedId : feedID
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.setFeedLikeUnlike(with: param, success: { (msg) in
                
            }, failure: { (statuscode,error, errorType) in
                print(error)
            })
        }
    }
    
    private func deleteFeed(feedID : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kfeedId : feedID,
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.deleteFeed(with: param, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                self.reloadFeedData()
            }, failure: { (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension FeedTabListViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.FeedTab
    }
}

// MARK: - AppNavigationControllerInteractable
extension FeedTabListViewController: AppNavigationControllerInteractable { }

