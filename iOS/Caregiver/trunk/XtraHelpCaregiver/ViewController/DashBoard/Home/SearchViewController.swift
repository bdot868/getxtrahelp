//
//  SearchViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwSearchMain: UIView?
    @IBOutlet weak var vwSearch: SearchView?
    @IBOutlet weak var btnFilter: UIButton?
    @IBOutlet weak var btnClearSearch: UIButton?
    
    @IBOutlet weak var vwNoDataMain: UIView?
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    @IBOutlet weak var vwReceentSearchMain: UIStackView?
    @IBOutlet weak var cvReceentSearch: UICollectionView?
    @IBOutlet weak var constraintcvReceentSearchHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwSuggetionMain: UIView?
    @IBOutlet weak var cvSuggetion: UICollectionView?
    
    @IBOutlet weak var vwResultMain: UIView?
    @IBOutlet weak var tblResults: UITableView?
    @IBOutlet weak var constrainttblResultHeight: NSLayoutConstraint?
    
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet var lblHeader: [UILabel]?
    
    // MARK: - Variables
    //private var arrCategory : [String] = ["Job Name","Job No","Job","Job Name"]
    private var arrJob : [JobModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    private var arrSearch : [SearchHistoryModel] = []
    
    private var selectedLatitude : Double = 0.0
    private var selectedLongitude : Double = 0.0
   
    private var pageNoSearch : Int = 1
    private var totalPagesSearch : Int = 0
    private var isSearchClick : Bool = false
    private var isSearchAPICall : Bool = false
    
    var selectedCategory : JobCategoryModel?
    
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
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
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
}

// MARK: - Init Configure Methods
fileprivate extension SearchViewController{
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.btnClearSearch?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
        self.btnClearSearch?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
       
        self.lblHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        })
        
        if let cvnearest = self.cvSuggetion {
            cvnearest.register(NearestJobCollectionCell.self)
            cvnearest.dataSource = self
            cvnearest.delegate = self
        }
       
        self.cvReceentSearch?.register(CategoryListCell.self)
        self.cvReceentSearch?.delegate = self
        self.cvReceentSearch?.dataSource = self
        if let vw = self.cvReceentSearch {
            let alignedFlowLayout = vw.collectionViewLayout as? AlignedCollectionViewFlowLayout
            alignedFlowLayout?.horizontalAlignment = .left
            alignedFlowLayout?.verticalAlignment = .top
        }
        
        self.tblResults?.register(JobSearchResultCell.self)
        self.tblResults?.estimatedRowHeight = 100.0
        self.tblResults?.rowHeight = UITableView.automaticDimension
        self.tblResults?.delegate = self
        self.tblResults?.dataSource = self
        
        self.vwSearch?.txtSearch?.delegate = self
        self.vwSearch?.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
        
        self.setupESInfiniteScrollinWithTableView()
        self.getSearchList()
        
        delay(seconds: 0.2) {
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                self.selectedLatitude = coordinate.latitude
                self.selectedLongitude = coordinate.longitude
                self.getMyPostedJob()
            }
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        self.title = "Find Jobs"
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension SearchViewController {
    
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.reloadSearchData()
            self.reloadJobResultSearchData()
        }
        
        self.scrollview?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getMyPostedJob()
                } else if self.pageNo <= self.totalPages {
                    self.getMyPostedJob(isshowloader: false)
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

// MARK: - IBAction
extension SearchViewController {
    @IBAction func btnClearClicked(_ sender: Any) {
        self.showAlert(withTitle: "", with: AlertTitles.kDeleteSearchHistory, firstButton: ButtonTitle.Yes, firstHandler: { (alert) in
            self.clearUserSearchHistory()
        }, secondButton: ButtonTitle.No, secondHandler: nil)
    }
    
    @IBAction func btnFilterClicked(_ sender: Any) {
        self.appNavigationController?.push(FilterViewController.self,configuration: { vc in
            vc.arrSelectedCategory = self.arrFilterJobCatagories
            vc.arrSelectedSpecialities = self.arrCaregiverSpecialities
            vc.filterNewestOldest = self.filterNewestOldest
            vc.filterBehavioral = self.filterBehavioral
            vc.filterVerbal = self.filterVerbal
            vc.filterAllergies = self.filterAllergies
            vc.filterStartDistance = self.filterStartDistance
            vc.filterEndDistance = self.filterEndDistance
            vc.filterVaccinated = self.filterVaccinated
            vc.filterJobType = self.filterJobType
            vc.delegate = self
        })
    }
}

extension SearchViewController :  filterDelegate {
    func selectFilterData(arrCategories: [JobCategoryModel], arrSpecialities: [WorkSpecialityModel], filterNewestOldest: String, filterBehavioral: String, filterVerbal: String, filterAllergies: String, filterStartDistance : Int,filterEndDistance : Int, filterVaccinated: String, filterJobType: String) {
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
        self.reloadJobResultSearchData()
    }
}

//MARK: - Tableview Observer
extension SearchViewController {
    
    private func addTableviewOberver() {
        self.cvReceentSearch?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblResults?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvReceentSearch?.observationInfo != nil {
            self.cvReceentSearch?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.tblResults?.observationInfo != nil {
            self.tblResults?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            if obj == self.cvReceentSearch && keyPath == ObserverName.kcontentSize {
                self.constraintcvReceentSearchHeight?.constant = self.cvReceentSearch?.contentSize.height ?? 0.0
                self.cvReceentSearch?.layoutIfNeeded()
            }
        }
        if let obj = object as? UITableView {
            if obj == self.tblResults && keyPath == ObserverName.kcontentSize {
                self.constrainttblResultHeight?.constant = self.tblResults?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJob.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: JobSearchResultCell.self)
        if self.arrJob.count > 0 {
            cell.setPostedJobData(obj: self.arrJob[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrJob.count > 0 {
            let obj = self.arrJob[indexPath.row]
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(JobDetailViewController.self,configuration: { vc in
                vc.selectedJobID = obj.userJobId
                vc.selecetdTab = .All
                vc.isFromHomeScreen = true
            })
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension SearchViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvSuggetion {
            return 5
        }
        return self.arrSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvSuggetion {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NearestJobCollectionCell.self)
            
            return cell
        } else if collectionView == self.cvReceentSearch {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryListCell.self)
            if self.arrSearch.count > 0 {
                cell.lblCategoryName?.text = self.arrSearch[indexPath.row].keyword
                
                cell.btnClose?.tag = indexPath.row
                cell.btnClose?.addTarget(self, action: #selector(self.btnDeleteCatgoryClicked(_:)), for: .touchUpInside)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cvSuggetion {
            return 10
        } else if collectionView == self.cvReceentSearch {
            return 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvReceentSearch {
            var fontsize: CGFloat = 0.0
            if self.arrSearch.count > 0 {
                let obj = self.arrSearch[indexPath.row]
                fontsize = obj.keyword.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)))
            }
            
            return CGSize(width: fontsize + 65.0, height: 50.0)
        } else if collectionView == self.cvSuggetion {
            return CGSize(width: collectionView.frame.size.width * 0.8, height: collectionView.frame.size.height)
        }
        return CGSize(width: 0 , height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.row)
        /*if collectionView == self.cvSuggetion {
            if self.arrJob.count > 0 {
                let obj = self.arrJob[indexPath.row]
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(JobDetailViewController.self,configuration: { vc in
                    vc.selectedJobID = obj.userJobId
                    vc.selecetdTab = .All
                    vc.isFromHomeScreen = true
                })
            }
        }*/
    }
    
    @objc func btnDeleteCatgoryClicked(_ btn : UIButton){
        if self.arrSearch.count > 0 {
            let obj = self.arrSearch[btn.tag]
            self.removeUserSearchHistory(searchhistoryid: obj.userSarchHistoryId)
            self.arrSearch.removeAll(where: {$0.userSarchHistoryId == obj.userSarchHistoryId })
            self.cvReceentSearch?.reloadData()
        }
    }
}

//MARK: - TextField Delegate
extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.vwSearch?.txtSearch == textField {
            if textField.returnKeyType == .search {
                self.isSearchClick = true
                self.isSearchAPICall = false
                self.vwSearch?.txtSearch?.text = textField.text ?? ""
                self.reloadJobResultSearchData()
                self.reloadSearchData()
            }
        }
        return true
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        if textField.text == "" || textField.isEmpty {
            self.isSearchClick = false
            self.isSearchAPICall = false
            //textField.resignFirstResponder()
            self.reloadJobResultSearchData()
            self.reloadSearchData()
        } else {
            if !self.isSearchAPICall {
                if self.isSearchClick {
                    self.isSearchClick = false
                }
                self.isSearchAPICall = true
                delay(seconds: 1.0) {
                    if !self.isSearchClick {
                        self.isSearchAPICall = false
                        if textField.text != "" {
                            self.reloadJobResultSearchData()
                            self.reloadSearchData()
                        }
                    }
                }
            }
        }
    }
    
    private func reloadJobResultSearchData(){
        //self.vwNearMeProvider.isHidden = true
        self.totalPages = 0
        self.pageNo = 1
        self.arrJob.removeAll()
        self.tblResults?.reloadData()
        self.getMyPostedJob()
    }
    
    private func reloadSearchData(){
        //self.vwRecentSearch.isHidden = true
        self.totalPagesSearch = 0
        self.pageNoSearch = 1
        self.arrSearch.removeAll()
        self.cvReceentSearch?.reloadData()
        self.getSearchList()
    }
}

// MARK: - API Call
extension SearchViewController {
    private func getSearchList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNoSearch)",
                klimit : "20",
                ksearch : self.vwSearch?.txtSearch?.text ?? ""
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            SearchHistoryModel.getUserSearchHistory(with: param, isShowLoader: isshowloader, success: { (arr,totalpage) in
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                //self.refreshControl.endRefreshing()
                self.totalPagesSearch = totalpage
                
                self.arrSearch.append(contentsOf: arr)
                
                if self.arrSearch.count > 5 {
                    let arraySlice = self.arrSearch.prefix(5)
                    let newArray = Array(arraySlice)
                    self.arrSearch = newArray
                }
                
                self.pageNoSearch = self.pageNoSearch + 1
                //delay(seconds: 0.2) {
                    self.cvReceentSearch?.reloadData()
               // }
                
                
                self.vwReceentSearchMain?.isHidden = self.arrSearch.isEmpty //|| !(self.vwSearch?.txtSearch?.isEmpty ?? false)) ? true : false
                //self.lblNoData.isHidden = (self.arrDoctor.isEmpty && (self.arrSearch.isEmpty || !self.vwSearch.txtSearch.isEmpty)) ? false : true
                //self.lblNearMeProviderHeader.text = self.vwSearch.txtSearch.isEmpty ? "Near Me" : "Search Results"
            }, failure: {[unowned self] (statuscode,error, errorType) in
                //self.refreshControl.endRefreshing()
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                //self.lblNearMeProviderHeader.text = self.vwSearch.txtSearch.isEmpty ? "Near Me" : "Search Results"
                self.pageNoSearch = self.pageNoSearch + 1
                self.vwReceentSearchMain?.isHidden = self.arrSearch.isEmpty
                //self.lblNoData.isHidden = (self.arrDoctor.isEmpty && (self.arrSearch.isEmpty || !self.vwSearch.txtSearch.isEmpty)) ? false : true
            })
        }
    }
    
    private func getMyPostedJob(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "10",
                ksearch : self.vwSearch?.txtSearch?.text ?? "",
                klatitude : "\(self.selectedLatitude)",
                klongitude : "\(self.selectedLongitude)",
                //kcategory : [],
                kisFirst : self.filterNewestOldest,
                kisBehavioral : self.filterBehavioral,
                kisVerbal : self.filterVerbal,
                kallergiesName : self.filterAllergies,
                kspecialitieId : self.arrCaregiverSpecialities.filter({$0.isSelectSpecialities}).map({$0.workSpecialityId}),
                kisFamilyVaccinated : self.filterVaccinated,
                kisJobType : self.filterJobType,
                kstartMiles : self.filterStartDistance == 0 ? "" : "\(self.filterStartDistance)",
                kendMiles : self.filterEndDistance == 100 ? "" : "\(self.filterEndDistance)"
            ]
            
            if let category = self.selectedCategory {
                self.arrFilterJobCatagories.append(category)
            }
            let arrdata = self.arrFilterJobCatagories.removingDuplicates()
            dict[kcategory] = (arrdata.filter({$0.isSelectCategory})).map({$0.jobCategoryId})
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.kgetUserJobList(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage,totalWorkHours) in
                //self.arrResources = arr
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrJob.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                
                self.vwNoDataMain?.isHidden = !self.arrJob.isEmpty
                self.lblNoData?.text = "No Jobs Available!"
                
                self.tblResults?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                self.tblResults?.reloadData()
                self.vwNoDataMain?.isHidden = !self.arrJob.isEmpty
                self.lblNoData?.text = error
            })
        }
    }
    
    private func clearUserSearchHistory(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            SearchHistoryModel.clearUserSearchHistory(with: param,success: { (msg) in
                self.arrSearch.removeAll()
                self.vwReceentSearchMain?.isHidden = true
                self.cvReceentSearch?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func removeUserSearchHistory(searchhistoryid : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserSearchHistoryId : searchhistoryid
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            SearchHistoryModel.removeUserSearchHistory(with: param,success: { (msg) in
                //self.showMessage(msg, themeStyle: .success)
                //self.reloadSearchData()
                self.vwReceentSearchMain?.isHidden = self.arrSearch.isEmpty
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension SearchViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Home
    }
}

// MARK: - AppNavigationControllerInteractable
extension SearchViewController: AppNavigationControllerInteractable { }
