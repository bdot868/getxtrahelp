//
//  BlogArticalViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 02/12/21.
//

import UIKit

class BlogArticalViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var cvArtical: UICollectionView?
    
    @IBOutlet weak var tblArtical: UITableView?
    @IBOutlet weak var constraintTblArticalHeight: NSLayoutConstraint?
    
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    private var arrBlog : [ResourcesAndBlogsModel] = []
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addTableviewOberver()
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
    }
}


// MARK: - Init Configure
extension BlogArticalViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.cvArtical?.delegate = self
        self.cvArtical?.dataSource = self
        self.cvArtical?.register(ArticalCollectionCell.self)
        
        self.tblArtical?.register(ResourcesBlogCell.self)
        self.tblArtical?.estimatedRowHeight = 100.0
        self.tblArtical?.rowHeight = UITableView.automaticDimension
        self.tblArtical?.delegate = self
        self.tblArtical?.dataSource = self
        
        //self.cvArtical?.isHidden = true
        
        self.setupESInfiniteScrollinWithTableView()
        self.getResurcesList()
    }
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Browse Article", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension BlogArticalViewController {
    
    private func reloadBlogData(){
        self.pageNo = 1
        self.arrBlog.removeAll()
        self.tblArtical?.reloadData()
        self.getResurcesList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.reloadBlogData()
        }
        
        scrollview?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getResurcesList()
                } else if self.pageNo <= self.totalPages {
                    self.getResurcesList(isshowloader: false)
                } else {
                    self.scrollview?.es.noticeNoMoreData()
                }
            } else {
                self.scrollview?.es.noticeNoMoreData()
            }
        }
        if let animator = self.scrollview?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.scrollview?.es.noticeNoMoreData()
            }
            else {
                self.scrollview?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.scrollview?.es.stopLoadingMore()
            self.scrollview?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

//MARK: - Tableview Observer
extension BlogArticalViewController {
    
    private func addTableviewOberver() {
        self.tblArtical?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblArtical?.observationInfo != nil {
            self.tblArtical?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblArtical && keyPath == ObserverName.kcontentSize {
                self.constraintTblArticalHeight?.constant = self.tblArtical?.contentSize.height ?? 0.0
                self.tblArtical?.layoutIfNeeded()
            }
        }
    }
}
//MARK:- UITableView Delegate
extension BlogArticalViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBlog.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: ResourcesBlogCell.self)
        if self.arrBlog.count > 0 {
            cell.setBlogData(obj: self.arrBlog[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrBlog.count > 0 {
            self.appNavigationController?.push(BlogArticalDetailViewController.self,configuration: { vc in
                vc.selectedBlogData = self.arrBlog[indexPath.row]
            })
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension BlogArticalViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ArticalCollectionCell.self)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 100.0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.appNavigationController?.push(BlogArticalDetailViewController.self)
    }
    
}

// MARK: - API
extension BlogArticalViewController {
    private func getResurcesList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "20",
                ksearch : "",
                kcategoryId : "",
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            ResourcesAndBlogsModel.getResourceList(with: param,isShowLoader : isshowloader, success: { (arr,totalpage,msg) in
                //self.arrResources = arr
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrBlog.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.tblArtical?.reloadData()
                
                self.lblNoData?.isHidden = self.arrBlog.count == 0 ?  false : true
                self.lblNoData?.text = msg
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false )
                self.lblNoData?.isHidden = self.arrBlog.count == 0 ?  false : true
                if !error.isEmpty {
                    //showMessage(error)
                    self.lblNoData?.text = error
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension BlogArticalViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension BlogArticalViewController: AppNavigationControllerInteractable { }
