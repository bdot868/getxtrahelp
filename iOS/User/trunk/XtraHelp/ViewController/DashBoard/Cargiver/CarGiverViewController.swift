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
 
    @IBOutlet weak var tblData: UITableView?
    
    @IBOutlet weak var btnFilter: UIButton?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var arrCareGiver : [CaregiverListModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
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
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.appNavigationController?.attachLeftSideMenu()
    }

}

// MARK: - Init Configure
extension CarGiverViewController {
    private func InitConfig(){
        
        self.tblData?.register(MyJobListCell.self)
        self.tblData?.estimatedRowHeight = 100.0
        self.tblData?.rowHeight = UITableView.automaticDimension
        self.tblData?.delegate = self
        self.tblData?.dataSource = self
        
        self.vwSearch?.txtSearch?.delegate = self
        self.vwSearch?.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
        
        self.setupESInfiniteScrollinWithTableView()
        self.getCaregiverList()
    }
}

//MARK: Pagination tableview Mthonthd
extension CarGiverViewController {
    
    private func reloadCarGiverData(){
        self.view.endEditing(true)
        self.pageNo = 1
        self.arrCareGiver.removeAll()
        self.tblData?.reloadData()
        self.getCaregiverList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblData?.es.addPullToRefresh {
            [unowned self] in
            self.reloadCarGiverData()
        }
        
        self.tblData?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getCaregiverList()
                } else if self.pageNo <= self.totalPages {
                    self.getCaregiverList(isshowloader: false)
                } else {
                    self.tblData?.es.noticeNoMoreData()
                }
            } else {
                self.tblData?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblData?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblData?.es.noticeNoMoreData()
            }
            else {
                self.tblData?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblData?.es.stopLoadingMore()
            self.tblData?.es.noticeNoMoreData()
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
        let cell = tableView.dequeueReusableCell(for: indexPath, with: MyJobListCell.self)
        cell.isFromCareGiver = true
        if self.arrCareGiver.count > 0 {
            cell.setCateGiverData(obj: self.arrCareGiver[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.arrCareGiver.count > 0 {
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(ProfileViewController.self,configuration: { vc in
                vc.selectedCaregiverID = self.arrCareGiver[indexPath.row].id
            })
        }
    }
}

// MARK: - IBAction
extension CarGiverViewController {
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(FilterViewController.self,configuration: { vc in
            vc.isFromCaregiverFilter = true
            vc.arrSelectedCategory = self.arrFilterJobCatagories
            vc.filterNewestOldest = self.filterNewestOldest
            vc.filterTopRated = self.filterTopRated
            vc.filterOnline = self.filterOnline
            vc.filterAvailability = self.filterAvailability
            vc.filterCustmeDate = self.filterCustmeDate
            vc.filterWorkingType = self.filterWorkingType
            vc.filterGender = self.filterGender
            vc.filterStartAge = self.filterStartAge
            vc.filterEndAge = self.filterEndAge
            vc.filterStartDistance = self.filterStartDistance
            vc.filterEndDistance = self.filterEndDistance
            vc.filterVaccineted = self.filterVaccineted
            vc.delegate = self
        })
    }
}

// MARK: - filterDelegate
extension CarGiverViewController :  filterDelegate {
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
        
        self.reloadCarGiverData()
    }
}

extension CarGiverViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(textField.isEmpty) {
            self.reloadCarGiverData()
        }
        return true
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        if textField.isEmpty {
            self.reloadCarGiverData()
        }
    }
}

//MARK:- API
extension CarGiverViewController{
    
    private func getCaregiverList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "15",
                ksearch : self.vwSearch?.txtSearch?.text ?? "",
                kisFirst : self.filterNewestOldest,
                kisOnline : self.filterOnline,
                kisTopRated : self.filterTopRated,
                kgender : self.filterGender,
                kstartAgeRange : self.filterStartAge == 0 ? "" : "\(self.filterStartAge)",
                kendAgeRange : self.filterEndAge == 100 ? "" :"\(self.filterEndAge)",
                kstartMiles : self.filterStartDistance == 0 ? "" : "\(self.filterStartDistance)",
                kendMiles : self.filterEndDistance == 100 ? "" : "\(self.filterEndDistance)",
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
            
            CaregiverListModel.getCaregiverList(with: param, isShowLoader: isshowloader,isMyCaregiverList : true,  success: { (arr,totalpage,msg)  in
                //self.arrResources = arr
                self.tblData?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrCareGiver.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrCareGiver.count == 0 ? false : true
                self.tblData?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblData?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
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
