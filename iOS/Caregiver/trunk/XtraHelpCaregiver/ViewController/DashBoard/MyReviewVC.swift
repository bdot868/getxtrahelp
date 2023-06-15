//
//  MyReviewVC.swift
//  XtraHelpCaregiver
//
//  Created by wm-ioskp on 26/10/21.
//

import UIKit

class MyReviewVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tblReviews: UITableView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    private var arrReview : [RatingModel] = []
    var caregiverId : String = ""
    
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
extension MyReviewVC {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblReviews?.register(ReviewTableCell.self)
        self.tblReviews?.estimatedRowHeight = 100.0
        self.tblReviews?.rowHeight = UITableView.automaticDimension
        self.tblReviews?.delegate = self
        self.tblReviews?.dataSource = self
        
        self.setupESInfiniteScrollinWithTableView()
        self.getCaregiverReviewList()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Reviews", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension MyReviewVC {
    
    private func reloadJobData(){
        self.view.endEditing(true)
        //self.reloadFeedData()
        self.pageNo = 1
        self.arrReview.removeAll()
        self.tblReviews?.reloadData()
        self.getCaregiverReviewList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblReviews?.es.addPullToRefresh {
            [unowned self] in
            self.reloadJobData()
            //self.tblFeed.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        }
        
        tblReviews?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getCaregiverReviewList()
                } else if self.pageNo <= self.totalPages {
                    self.getCaregiverReviewList(isshowloader: false)
                } else {
                    self.tblReviews?.es.noticeNoMoreData()
                }
            } else {
                self.tblReviews?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblReviews?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblReviews?.es.noticeNoMoreData()
            }
            else {
                self.tblReviews?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblReviews?.es.stopLoadingMore()
            self.tblReviews?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

//MARK:- UITableView Delegate
extension MyReviewVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrReview.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: ReviewTableCell.self)
        if self.arrReview.count > 0 {
            cell.setReviewData(obj: self.arrReview[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

// MARK: - ViewControllerDescribable
extension MyReviewVC {
    
    private func getCaregiverReviewList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault(){
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "25",
                ksearch : "",
                kcaregiverId : user.id
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            RatingModel.getCaregiverReviewList(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage,msg) in
                //self.arrUser.append(contentsOf: arr)
                self.tblReviews?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrReview.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrReview.count == 0 ? false : true
                self.tblReviews?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblReviews?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                self.lblNoData?.isHidden = self.arrReview.count == 0 ? false : true
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    self.lblNoData?.text = error
                    self.tblReviews?.reloadData()
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
extension MyReviewVC: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.DashBoard
    }
}

// MARK: - AppNavigationControllerInteractable
extension MyReviewVC: AppNavigationControllerInteractable { }


