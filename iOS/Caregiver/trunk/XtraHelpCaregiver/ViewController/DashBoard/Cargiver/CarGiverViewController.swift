//
//  CarGiverViewController.swift
//  XtraHelp
//
//  Created by wm-ioskp on 04/10/21.
//

import UIKit

class CarGiverViewController: UIViewController {
  
    // MARK: - IBOutlet
    @IBOutlet weak var vwSearchMain: UIView?
    @IBOutlet weak var vwSearch: SearchView?
    @IBOutlet weak var vwContentMain: UIView?
    
    @IBOutlet weak var tblCareGiver: UITableView?
    
    @IBOutlet weak var btnFilter: UIButton?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var arrCareGiver : [CaregiverListModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
}

// MARK: - Init Configure
extension CarGiverViewController {
    private func InitConfig(){
        
        self.tblCareGiver?.register(SessionTableCell.self)
        self.tblCareGiver?.estimatedRowHeight = 100.0
        self.tblCareGiver?.rowHeight = UITableView.automaticDimension
        self.tblCareGiver?.delegate = self
        self.tblCareGiver?.dataSource = self
        
        self.setupESInfiniteScrollinWithTableView()
        self.getCaregiverList()
    }
}

//MARK: Pagination tableview Mthonthd
extension CarGiverViewController {
    
    private func reloadJobData(){
        self.view.endEditing(true)
        self.pageNo = 1
        self.arrCareGiver.removeAll()
        self.tblCareGiver?.reloadData()
        self.getCaregiverList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblCareGiver?.es.addPullToRefresh {
            [unowned self] in
            self.reloadJobData()
        }
        
        tblCareGiver?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getCaregiverList()
                } else if self.pageNo <= self.totalPages {
                    self.getCaregiverList(isshowloader: false)
                } else {
                    self.tblCareGiver?.es.noticeNoMoreData()
                }
            } else {
                self.tblCareGiver?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblCareGiver?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblCareGiver?.es.noticeNoMoreData()
            }
            else {
                self.tblCareGiver?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblCareGiver?.es.stopLoadingMore()
            self.tblCareGiver?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

//MARK:- UITableView Delegate
extension CarGiverViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrCareGiver.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(for: indexPath, with: SessionTableCell.self)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
}


// MARK: - IBAction
extension CarGiverViewController {
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        //let vc = loadVC(strStoryboardId: UIStoryboard.Name.myJob.rawValue, strVCId: "MyJobFilterVC") as! MyJobFilterVC
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- API
extension CarGiverViewController{
    
    private func getCaregiverList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "10",
                ksearch : ""
                
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CaregiverListModel.getCaregiverList(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage,msg)  in
                //self.arrResources = arr
                self.tblCareGiver?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrCareGiver.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrCareGiver.count == 0 ? false : true
                self.tblCareGiver?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblCareGiver?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                self.lblNoData?.isHidden = !self.arrCareGiver.isEmpty
                self.lblNoData?.text = error
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension CarGiverViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.carGiver
    }
}

// MARK: - AppNavigationControllerInteractable
extension CarGiverViewController: AppNavigationControllerInteractable { }
