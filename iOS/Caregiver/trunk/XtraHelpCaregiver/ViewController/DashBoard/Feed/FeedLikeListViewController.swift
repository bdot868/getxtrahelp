//
//  FeedLikeListViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class FeedLikeListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tblFeedLIke: UITableView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    private var arrUser : [FeedUserLikeModel] = []
    var selectedFeedData : FeedModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
}

// MARK: - Init Configure
extension FeedLikeListViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblFeedLIke?.register(FeedLikeCell.self)
        self.tblFeedLIke?.estimatedRowHeight = 100.0
        self.tblFeedLIke?.rowHeight = UITableView.automaticDimension
        self.tblFeedLIke?.delegate = self
        self.tblFeedLIke?.dataSource = self
        
        self.getFeedLikeUserList()
        
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Likes", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension FeedLikeListViewController {
    
    private func reloadJobData(){
        self.view.endEditing(true)
        //self.reloadFeedData()
        self.pageNo = 1
        
            self.arrUser.removeAll()
            self.tblFeedLIke?.reloadData()
            self.getFeedLikeUserList()
        
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblFeedLIke?.es.addPullToRefresh {
            [unowned self] in
            self.reloadJobData()
            //self.tblFeed.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        }
        
        tblFeedLIke?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getFeedLikeUserList()
                } else if self.pageNo <= self.totalPages {
                    self.getFeedLikeUserList(isshowloader: false)
                } else {
                    self.tblFeedLIke?.es.noticeNoMoreData()
                }
            } else {
                self.tblFeedLIke?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblFeedLIke?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblFeedLIke?.es.noticeNoMoreData()
            }
            else {
                self.tblFeedLIke?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblFeedLIke?.es.stopLoadingMore()
            self.tblFeedLIke?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

//MARK:- UITableView Delegate
extension FeedLikeListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: FeedLikeCell.self)
        if self.arrUser.count > 0 {
            cell.setLikeFeedUserData(obj: self.arrUser[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.appNavigationController?.push(MentorProfileViewController.self)
    }
}

// MARK: - ViewControllerDescribable
extension FeedLikeListViewController {
    
    private func getFeedLikeUserList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "20",
                ksearch : "",
                kuserFeedId : feeddata.id
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedUserLikeModel.getFeedLikeCommentUser(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage,msg) in
                //self.arrUser.append(contentsOf: arr)
                self.tblFeedLIke?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrUser.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrUser.count == 0 ? false : true
                self.tblFeedLIke?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblFeedLIke?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                self.lblNoData?.isHidden = self.arrUser.count == 0 ? false : true
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    
                    self.lblNoData?.text = error
                    self.tblFeedLIke?.reloadData()
                } else {
                    if !error.isEmpty {
                        self.showMessage(error, themeStyle: .error)
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                    }
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension FeedLikeListViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.FeedTab
    }
}

// MARK: - AppNavigationControllerInteractable
extension FeedLikeListViewController: AppNavigationControllerInteractable { }
