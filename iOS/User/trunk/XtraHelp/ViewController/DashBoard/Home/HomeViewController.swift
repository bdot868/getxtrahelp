//
//  HomeViewController.swift
//  XtraHelp
//
//  Created by wm-ioskp on 14/10/21.
//

import UIKit

class HomeViewController: UIViewController{
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwLocationMain: UIView?
    @IBOutlet weak var lblLocation: UILabel?
    @IBOutlet weak var btnChangeLocation: UIButton?
    
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet weak var lblFindCargiverHeader: UILabel?
    
    @IBOutlet weak var vwFindJobMain: UIView?
    @IBOutlet weak var lblFindJobHeader: UILabel?
    @IBOutlet weak var lblFindJobSubHeader: UILabel?
    @IBOutlet weak var vwCreateJobMain: UIView?
    
    @IBOutlet weak var vwUpcomingJobMain: UIView?
    @IBOutlet weak var cvUpcomingJob: UICollectionView?
    
    @IBOutlet weak var vwNearestJobMain: UIView?
    @IBOutlet weak var cvNearestJob: UICollectionView?
    
    @IBOutlet weak var vwCategoriesMain: UIView?
    @IBOutlet weak var cvCategories: UICollectionView?
    @IBOutlet weak var constraintcvCategoriesHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwResourcesMain: UIView?
    @IBOutlet weak var tblResources: UITableView?
    @IBOutlet weak var constrainttblResourcesHeight: NSLayoutConstraint?
    
    @IBOutlet var lblHeader: [UILabel]?
    @IBOutlet var btnViewAll: [UIButton]?
    
    // MARK: - Variables
    private var arrBlog : [ResourcesAndBlogsModel] = []
    private var arrUpcomingJob : [JobModel] = []
    private var arrOngoingJobs : [JobModel] = []
    private var arrNearestXaregiver : [CaregiverListModel] = []
    private var arrCategory : [JobCategoryModel] = []
    
    private var selectedLatitude : Double = 0.0
    private var selectedLongitude : Double = 0.0
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addTableviewOberver()
        self.appNavigationController?.attachLeftSideMenu()
        self.getUnreadNotificationsCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
}

// MARK: - Init Configure Methods
fileprivate extension HomeViewController{
    private func InitConfig(){
        
        self.updateLocationData()
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblLocation?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblLocation?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblFindCargiverHeader?.setFindJobHeaderAttributedTextLable(firstText: "Find a ", SecondText: "Caregiver")
        
        self.lblFindJobHeader?.textColor = UIColor.CustomColor.whitecolor
        self.lblFindJobHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        
        self.lblFindJobSubHeader?.textColor = UIColor.CustomColor.appColor
        self.lblFindJobSubHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        
        self.btnChangeLocation?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        self.btnChangeLocation?.setTitleColor(UIColor.CustomColor.tutorialColor, for: .normal)
        self.btnChangeLocation?.titleLabel?.textColor = UIColor.CustomColor.tutorialColor
        
        self.vwCreateJobMain?.backgroundColor = UIColor.CustomColor.whitecolor
        self.vwCreateJobMain?.cornerRadius = 10.0
        
        self.lblHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        })
        
        self.btnViewAll?.forEach({
            $0.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
            $0.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        })
        
        if let cvupcoming = self.cvUpcomingJob {
            cvupcoming.register(UpcomingJobCollectionCell.self)
            cvupcoming.dataSource = self
            cvupcoming.delegate = self
        }
        
        if let cvnearest = self.cvNearestJob {
            cvnearest.register(NearestCarGiverCollectionCell.self)
            cvnearest.dataSource = self
            cvnearest.delegate = self
        }
        if let cvcategory = self.cvCategories {
            cvcategory.register(HomeCategoriesCollectionCell.self)
            cvcategory.dataSource = self
            cvcategory.delegate = self
        }
        
        self.tblResources?.register(ResourcesBlogCell.self)
        self.tblResources?.estimatedRowHeight = 100.0
        self.tblResources?.rowHeight = UITableView.automaticDimension
        self.tblResources?.delegate = self
        self.tblResources?.dataSource = self
        
        self.setupESInfiniteScrollinWithTableView()
        
        delay(seconds: 0.2) {
            SVProgressHUD.dismiss()
            self.getDashboardData()
        }
    }
    
    private func updateLocationData(){
        delay(seconds: 0.1) {
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                self.selectedLatitude = coordinate.latitude
                self.selectedLongitude = coordinate.longitude
                
                XtraHelp.sharedInstance.getAddressFromLatLong(lat: coordinate.latitude, long: coordinate.longitude) { address, country, state, city, street, zipcode in
                    var mycity : String  = city//"\(city),\(country)"
                    if city.contains(" County") {
                        mycity = city.replace(string: " County", replacement: "")
                    } else if city.contains("County") {
                        mycity = city.replace(string: "County", replacement: "")
                    }
                    self.lblLocation?.text = XtraHelp.sharedInstance.selectedHomeAddress.isEmpty ? "\(mycity.isEmpty ? "" : "\(mycity), ")\(country)" : XtraHelp.sharedInstance.selectedHomeAddress
                    if !XtraHelp.sharedInstance.selectedHomeAddress.isEmpty {
                        //self.lblLocation?.text = XtraHelp.sharedInstance.selectedHomeAddress
                        self.selectedLatitude = XtraHelp.sharedInstance.selectedHomeLatitude
                        self.selectedLongitude = XtraHelp.sharedInstance.selectedHomeLongitude
                        
                    }
                    
                    //self.lblLocation?.text = XtraHelp.sharedInstance.selectedHomeAddress.isEmpty ? "\(mycity.isEmpty ? "" : "\(mycity), ")\(country)" : XtraHelp.sharedInstance.selectedHomeAddress
                }
            } else {
                self.lblLocation?.text = XtraHelp.sharedInstance.selectedHomeAddress
                self.selectedLatitude = XtraHelp.sharedInstance.selectedHomeLatitude
                self.selectedLongitude = XtraHelp.sharedInstance.selectedHomeLongitude
            }
        }
    }
}

//MARK: - Tableview Observer
extension HomeViewController {
    
    private func addTableviewOberver() {
        //self.cvCategories?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblResources?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        /*if self.cvCategories?.observationInfo != nil {
            self.cvCategories?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }*/
        if self.tblResources?.observationInfo != nil {
            self.tblResources?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        /*if let obj = object as? UICollectionView {
            if obj == self.cvCategories && keyPath == ObserverName.kcontentSize {
                self.constraintcvCategoriesHeight?.constant = self.cvCategories?.contentSize.height ?? 0.0
            }
        }*/
        if let obj = object as? UITableView {
            if obj == self.tblResources && keyPath == ObserverName.kcontentSize {
                self.constrainttblResourcesHeight?.constant = self.tblResources?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK: Pagination tableview Mthonthd
extension HomeViewController {
    
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.getDashboardData()
        }
    }
}

// MARK: - IBAction
fileprivate extension HomeViewController {
    
    @IBAction func btnViewAllUpcomingJobClicked(_ sender: Any){
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(MyJobChildViewController.self,configuration: { vc in
            vc.isFromHomeScreen = true
            vc.selecetdTab = .Upcoming
        })
    }
    
    @IBAction func btnSearchJob(_ sender: UIButton){
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(SearchViewController.self,configuration: { (vc) in
            vc.arrNearestXaregiver = self.arrNearestXaregiver
        })
    }
    
    @IBAction func btnCreateJob(_ sender: UIButton){
        self.appNavigationController?.detachLeftSideMenu()
        if UserDefaults.isShowCreateJobTutorial {
            self.appNavigationController?.present(CreateJobTutorialViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
            })
        } else {
            self.appNavigationController?.push(CreateJobSelectCategoryViewController.self)
        }
    }
    
    @IBAction func btnViewAllResouceBlogClicked(_ sender: Any){
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(BlogArticalViewController.self)
    }
    
    @IBAction func btnViewAllCategoryClicked(_ sender: Any){
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(CreateJobSelectCategoryViewController.self,configuration: { vc in
            vc.isFromHome = true
        })
    }
    
    @IBAction func btnViewAllSuggestedClicked(_ sender: UIButton){
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(SearchViewController.self,configuration: { (vc) in
            vc.arrNearestXaregiver = self.arrNearestXaregiver
        })
    }
    
    @IBAction func btnChangeLocationClicked(_ sender: UIButton){
        //self.appNavigationController?.push(SignupLocationViewController.self)
        self.view.endEditing(true)
        
        let filter = GMSAutocompleteFilter()
        //filter.type = .address
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        placePickerController.autocompleteFilter = filter
        present(placePickerController, animated: true, completion: nil)
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print("Place name: \(place.name)")
        //print("Place ID: \(place.placeID)")
        //print("Place attributions: \(place.attributions)")
        //dismiss(animated: true, completion: nil)
        //self.vwLocation?.clear()
        dismiss(animated: true) {
            DispatchQueue.main.async { [self] in
                self.selectedLatitude = place.coordinate.latitude
                self.selectedLongitude = place.coordinate.longitude
                //self.lblLocation?.text = place.formattedAddress ?? ""
                //self.zipcode = ""
                var countryname = ""
                var cityname : String = ""
                //var addressShort : String = ""
                for addressComponent in (place.addressComponents)! {
                    for type in (addressComponent.types){
                        print("Type : \(type) = \(addressComponent.name)")
                        switch(type){
                            case "street_number":
                                //self.streetname = addressComponent.name
                                print("Street : \(addressComponent.name)")
                                //addressShort = addressComponent.name
                            
                            case "route":
                                //addressShort = addressShort + "\(addressShort.isEmpty ? "\(addressComponent.name)" : ",\(addressComponent.name)")"
                                print("Route : \(addressComponent.name)")
                            case "premise":
                                //addressShort = addressShort + "\(addressShort.isEmpty ? "\(addressComponent.name)" : ",\(addressComponent.name)")"
                                print("premise : \(addressComponent.name)")
                            case "neighborhood":
                                print("neighborhood : \(addressComponent.name)")
                                //addressShort = addressShort + ",\(addressComponent.name)"
                            case "country":
                                countryname = addressComponent.name
                                print("Contry : \(countryname)")
                            //case "postal_code":
                                 //self.zipcode = addressComponent.name
                            case "administrative_area_level_2":
                                cityname = addressComponent.name
                                print("City : \(cityname)")
                            case "administrative_area_level_1":
                                //self.statename = addressComponent.name
                                print("State : \(addressComponent.name)")
                            break
                            //case "street_number":
                                
                        default:
                            break
                        }
                    }
                }
                //print(addressShort)
                var mycity : String  = cityname//"\(city),\(country)"
                if cityname.contains(" County") {
                    mycity = cityname.replace(string: " County", replacement: "")
                } else if cityname.contains("County") {
                    mycity = cityname.replace(string: "County", replacement: "")
                }
                self.lblLocation?.text = "\(mycity.isEmpty ? "" : "\(mycity), ")\(countryname)"
                XtraHelp.sharedInstance.selectedHomeAddress = "\(mycity.isEmpty ? "" : "\(mycity), ")\(countryname)"
                XtraHelp.sharedInstance.selectedHomeLatitude = self.selectedLatitude
                XtraHelp.sharedInstance.selectedHomeLongitude = self.selectedLongitude
                //self.lblLocation?.text = addressShort.isEmpty ? (place.formattedAddress ?? "") : addressShort
                self.getDashboardData()
            }
        }
        
    }
    
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

//MARK:- UITableView Delegate
extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
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
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(BlogArticalDetailViewController.self,configuration: { vc in
                vc.selectedBlogData = self.arrBlog[indexPath.row]
            })
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvUpcomingJob {
            return self.arrUpcomingJob.count
        } else if collectionView == self.cvNearestJob {
            return self.arrNearestXaregiver.count
        } else if collectionView == self.cvCategories {
            return self.arrCategory.count
        } /*else if collectionView == self.cvResources {
            return 10
        }*/
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvUpcomingJob {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UpcomingJobCollectionCell.self)
            cell.setUpComingJobData(obj: self.arrUpcomingJob[indexPath.row])
            
            cell.btnChat?.tag = indexPath.row
            cell.btnChat?.addTarget(self, action: #selector(self.btnChatClicked(_:)), for: .touchUpInside)
            return cell
        } else if collectionView == self.cvNearestJob {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NearestCarGiverCollectionCell.self)
            if self.arrNearestXaregiver.count > 0 {
                cell.setNearestCaregiverData(obj: self.arrNearestXaregiver[indexPath.row])
            }
            return cell
        } else if collectionView == self.cvCategories {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeCategoriesCollectionCell.self)
            //cell.lblCategoryName?.text = "Catagory Name"
            cell.lblCategoryPrice?.isHidden = false
            if self.arrCategory.count > 0 {
                cell.setCategoryData(obj: self.arrCategory[indexPath.row])
            }
            return cell
        } 
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cvUpcomingJob {
            return 0
        } else if collectionView == self.cvNearestJob {
            return 0
        } else if collectionView == self.cvCategories {
            return 5
        } /*else if collectionView == self.cvResources {
            return 15
        }*/
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvUpcomingJob {
            return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
        } else if collectionView == self.cvNearestJob {
            return CGSize(width: collectionView.frame.size.height * 0.8, height: collectionView.frame.size.height)
        } else if collectionView == self.cvCategories {
            return CGSize(width: (collectionView.frame.size.width/2), height: collectionView.frame.size.height)
        } /*else if collectionView == self.cvResources {
            return CGSize(width: collectionView.frame.size.width * 0.8, height: collectionView.frame.size.height)
        }*/
        return CGSize(width: 0 , height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.cvNearestJob {
            if self.arrNearestXaregiver.count > 0 {
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(ProfileViewController.self,configuration: { vc in
                    vc.selectedCaregiverID = self.arrNearestXaregiver[indexPath.row].id
                })
            }
        } else if collectionView == self.cvUpcomingJob {
            if self.arrUpcomingJob.count > 0 {
                let obj = self.arrUpcomingJob[indexPath.row]
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(JobDetailViewController.self,configuration: { vc in
                    vc.selecetdTab = .Upcoming
                    vc.selectedJobID = obj.userJobDetailId
                })
            }
        } else if collectionView == self.cvCategories {
            if self.arrCategory.count > 0 {
                let obj = self.arrCategory[indexPath.row]
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(SearchViewController.self,configuration: { vc in
                    vc.selecetdCategory = obj
                })
            }
        }
    }
    
    @objc func btnChatClicked(_ sender : UIButton){
        if self.arrUpcomingJob.count > 0 {
            let obj = self.arrUpcomingJob[sender.tag]
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                vc.chatUserID = obj.caregiverId
                vc.chatUserName = obj.userFullName
                vc.chatUserImage = obj.profileImageThumbUrl
            })
        }
    }
}

// MARK: - API
extension HomeViewController {
    private func getDashboardData(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                ktimezone : XtraHelp.sharedInstance.localTimeZoneIdentifier,
                klatitude : "\(self.selectedLatitude)",
                klongitude : "\(self.selectedLongitude)",
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            DashboardModel.getCaregiverDashboard(with: param, success:  { (arrOnGoing,arrUpcoming,arrNearest,arrCategory,arrResourcesAndBlogs,message) in
                
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                
                self.arrCategory = arrCategory
                self.cvCategories?.reloadData()
                self.vwCategoriesMain?.isHidden = self.arrCategory.isEmpty
                
                self.arrUpcomingJob = arrUpcoming
                self.cvUpcomingJob?.reloadData()
                self.vwUpcomingJobMain?.isHidden = self.arrUpcomingJob.isEmpty
                
                self.arrNearestXaregiver = arrNearest
                self.cvNearestJob?.reloadData()
                self.vwNearestJobMain?.isHidden = self.arrNearestXaregiver.isEmpty
                
                self.arrBlog = arrResourcesAndBlogs
                self.tblResources?.reloadData()
                self.vwResourcesMain?.isHidden = self.arrBlog.isEmpty
                
            }, failure: {(statuscode,error, errorType) in
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                print(error)
            })
        }
    }
    
    func getUnreadNotificationsCount() {
        if let user = UserModel.getCurrentUserFromDefault() {
    
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CommonModel.getUnreadNotificationsCountAPICall(with: param,isShowLoader: false, success: { (unreadPushNoti,unreadChatMsg) in
                XtraHelp.sharedInstance.unreadPushNotiCount = unreadPushNoti
                XtraHelp.sharedInstance.unreadChatMsgCount = unreadChatMsg
                
                NotificationCenter.default.post(name: Notification.Name(NotificationPostname.kUpdateNotificationCount), object: nil, userInfo: nil)
            }, failure: {(statuscode,error, errorType) in
                print(error)
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension HomeViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension HomeViewController: AppNavigationControllerInteractable { }
