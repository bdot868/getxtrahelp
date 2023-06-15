//
//  FilterViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

protocol filterDelegate {
    func selectFilterData(arrCategories : [JobCategoryModel],arrSpecialities : [WorkSpecialityModel],filterNewestOldest : String,filterBehavioral : String, filterVerbal : String, filterAllergies : String, filterStartDistance : Int,filterEndDistance : Int, filterVaccinated: String, filterJobType: String)
}

class FilterViewController: UIViewController {

    // MARK: - IBOutlet
   
    @IBOutlet weak var vwCategoryMain: UIView?
    @IBOutlet weak var cvCategory: UICollectionView?
    @IBOutlet weak var constraintcvCategoryHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwSortByMain: UIView?
    @IBOutlet weak var cvSortBy: UICollectionView?
    @IBOutlet weak var constraintcvSortByHeight: NSLayoutConstraint?
    @IBOutlet weak var btnSortNewest: SelectAppButton?
    @IBOutlet weak var btnSortOldest: SelectAppButton?
    @IBOutlet weak var btnSortBehaviourasl: SelectAppButton?
    @IBOutlet weak var btnSortNonBehaviourasl: SelectAppButton?
    @IBOutlet weak var btnSortVerbal: SelectAppButton?
    @IBOutlet weak var btnSortNonVerbal: SelectAppButton?
    
    @IBOutlet weak var vwSpecialitiesMain: UIStackView?
    @IBOutlet weak var cvSpecialities: UICollectionView?
    @IBOutlet weak var constraintcvSpecialitiesHeight: NSLayoutConstraint?
    
    @IBOutlet var lblHeader: [UILabel]?
    
    @IBOutlet weak var vwSJobTypeMain: UIView?
    @IBOutlet weak var btnJobTypeOneTime: SelectAppButton?
    @IBOutlet weak var btnJobTypeRecurring: SelectAppButton?
    
    
    @IBOutlet weak var vwFamilyVaccinatedMain: UIView?
    @IBOutlet weak var btnFamilyVaccinatedYes: SelectAppButton?
    @IBOutlet weak var btnFamilyVaccinatedNo: SelectAppButton?
    
    @IBOutlet weak var vwDistanceMain: UIView?
    @IBOutlet weak var workDistanceSlider: RangeSlider?
    
    @IBOutlet weak var vwAllergies: ReusableView?
    
    // MARK: - Variables
    var delegate : filterDelegate?
    
    var arrSelectedCategory : [JobCategoryModel] = []
    var arrSelectedSpecialities : [WorkSpecialityModel] = []
    
    var arrFilterJobCatagories : [JobCategoryModel] = []
    var arrCaregiverSpecialities : [WorkSpecialityModel] = []
    var filterNewestOldest : String = ""
    var filterBehavioral : String = ""
    var filterVerbal : String = ""
    var filterAllergies : String = ""
    var filterStartDistance : Int = 0
    var filterEndDistance : Int = 100
    var filterVaccinated: String = ""
    var filterJobType: String = ""
    
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
fileprivate extension FilterViewController{
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
       
        self.lblHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        })
        
        if let cvnearest = self.cvSortBy {
            cvnearest.register(FilterSortByCell.self)
            cvnearest.dataSource = self
            cvnearest.delegate = self
        }
       
        self.cvCategory?.register(FilterCategoryCell.self)
        self.cvCategory?.delegate = self
        self.cvCategory?.dataSource = self
        if let vw = self.cvCategory {
            let alignedFlowLayout = vw.collectionViewLayout as? AlignedCollectionViewFlowLayout
            alignedFlowLayout?.horizontalAlignment = .left
            alignedFlowLayout?.verticalAlignment = .top
        }
        
        self.cvSpecialities?.register(FilterSpecialitiesCell.self)
        self.cvSpecialities?.delegate = self
        self.cvSpecialities?.dataSource = self
        
        self.btnFamilyVaccinatedYes?.isSelectBtn = false
        self.btnFamilyVaccinatedNo?.isSelectBtn = false
        
        self.btnJobTypeOneTime?.isSelectBtn = false
        self.btnJobTypeRecurring?.isSelectBtn = false
        
        [self.workDistanceSlider].forEach({
            $0?.minValue = 0
            $0?.maxValue = 100
            $0?.minRange = 0
            $0?.maxRange = 100
            $0?.displayTextFont = UIFont.RubikMedium(ofSize: 11.0)
            $0?.displayTextFontSize = 11.0
            $0?.trackTintColor = UIColor.CustomColor.progressBarBackColor
            $0?.trackHighlightTintColor = UIColor.CustomColor.appColor
            $0?.minValueThumbTintColor = UIColor.CustomColor.appColor
            $0?.maxValueThumbTintColor = UIColor.CustomColor.appColor
            $0?.thumbOutlineSize = 2.0
        })
        
        self.workDistanceSlider?.setValueChangedCallback { (minValue, maxValue) in
            print("workDistanceSlider min value:\(minValue)")
            self.filterStartDistance = minValue
            print("workDistanceSlider max value:\(maxValue)")
            self.filterEndDistance = maxValue
        }
        self.workDistanceSlider?.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "\(minValue)"
        }
        self.workDistanceSlider?.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "\(maxValue)"
        }
        self.workDistanceSlider?.setMinAndMaxRange(0, maxRange: 100)
        
        self.vwAllergies?.txtInput.text = self.filterAllergies
        
        self.btnSortNewest?.isSelectBtn = self.filterNewestOldest == "1"
        self.btnSortOldest?.isSelectBtn = self.filterNewestOldest == "2"
        
        self.btnSortBehaviourasl?.isSelectBtn = self.filterBehavioral == "1"
        self.btnSortNonBehaviourasl?.isSelectBtn = self.filterBehavioral == "2"
        
        self.btnSortVerbal?.isSelectBtn = self.filterVerbal == "1"
        self.btnSortNonVerbal?.isSelectBtn = self.filterVerbal == "2"
        
        self.btnFamilyVaccinatedYes?.isSelectBtn = self.filterVaccinated == "1"
        self.btnFamilyVaccinatedNo?.isSelectBtn = self.filterVaccinated == "2"
        
        self.btnJobTypeOneTime?.isSelectBtn = self.filterJobType == "1"
        self.btnJobTypeRecurring?.isSelectBtn = self.filterJobType == "2"
        
        /*if !self.filterDistance.isEmpty {
            delay(seconds: 0.35) {
                self.SliderDistance?.value = Float(self.filterDistance) ?? 0
            }
        }*/
        
        self.workDistanceSlider?.setMinAndMaxValue(self.filterStartDistance, maxValue: self.filterEndDistance)
       
        self.getJobCategoryListAPICall()
        self.getCommonDataAPICall()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "Filter"
        
        appNavigationController?.setFilterNavigationBar(navigationItem: self.navigationItem)
        
        appNavigationController?.btnLeftClickBlock = {
            self.appNavigationController?.popViewController(animated: true)
        }
        
        appNavigationController?.btnNextClickBlock = {
            self.delegate?.selectFilterData(arrCategories: [], arrSpecialities: [], filterNewestOldest: "", filterBehavioral: "", filterVerbal: "", filterAllergies: "", filterStartDistance: 0,filterEndDistance: 0, filterVaccinated: "", filterJobType: "")
            self.appNavigationController?.popViewController(animated: true)
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: - Tableview Observer
extension FilterViewController {
    
    private func addTableviewOberver() {
        self.cvCategory?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        //self.cvSortBy?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.cvSpecialities?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvCategory?.observationInfo != nil {
            self.cvCategory?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        /*if self.cvSortBy?.observationInfo != nil {
            self.cvSortBy?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }*/
        if self.cvSpecialities?.observationInfo != nil {
            self.cvSpecialities?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            if obj == self.cvCategory && keyPath == ObserverName.kcontentSize {
                self.constraintcvCategoryHeight?.constant = self.cvCategory?.contentSize.height ?? 0.0
                self.cvCategory?.layoutIfNeeded()
            }
            /*if obj == self.cvSortBy && keyPath == ObserverName.kcontentSize {
                self.constraintcvSortByHeight?.constant = self.cvSortBy?.contentSize.height ?? 0.0
                self.cvSortBy?.layoutIfNeeded()
            }*/
            if obj == self.cvSpecialities && keyPath == ObserverName.kcontentSize {
                self.constraintcvSpecialitiesHeight?.constant = self.cvSpecialities?.contentSize.height ?? 0.0
                self.cvSpecialities?.layoutIfNeeded()
            }
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension FilterViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvCategory {
            return self.arrFilterJobCatagories.count
        } else if collectionView == self.cvSortBy {
            return 10
        }
        return self.arrCaregiverSpecialities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvSortBy {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterSortByCell.self)
            cell.isSelelctSortCell = ((indexPath.row % 2) != 0)
            return cell
        } else if collectionView == self.cvCategory {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterCategoryCell.self)
            if self.arrFilterJobCatagories.count > 0 {
                cell.setCategoryData(obj: self.arrFilterJobCatagories[indexPath.row])
            }
            return cell
        } else if collectionView == self.cvSpecialities {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterSpecialitiesCell.self)
            if self.arrCaregiverSpecialities.count > 0 {
                cell.setSpecialitiesData(obj: self.arrCaregiverSpecialities[indexPath.row])
            }
            
            cell.btnSelectMain?.tag = indexPath.row
            cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cvSpecialities {
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cvSortBy {
            return 10
        } else if collectionView == self.cvCategory {
            return 10
        } else if collectionView == self.cvSpecialities {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvCategory {
            return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: 60.0)
        } else if collectionView == self.cvSortBy {
            return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: 60.0)
        } else if collectionView == self.cvSpecialities {
            if self.arrCaregiverSpecialities.count > 0 {
                let obj = self.arrCaregiverSpecialities[indexPath.row]
                return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: XtraHelp.sharedInstance.estimatedHeightOfLabel(text: obj.name) + 35.0)
            }
        }
        return CGSize(width: 0 , height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.row)
        if collectionView == self.cvCategory {
            if self.arrFilterJobCatagories.count > 0 {
                let obj = self.arrFilterJobCatagories[indexPath.row]
                obj.isSelectCategory = !obj.isSelectCategory
                self.cvCategory?.reloadData()
            }
        } else if collectionView == self.cvSortBy {
            
        }
    }
    
    @objc func btnSelectCategoryClicked(_ btn : UIButton){
        if self.arrCaregiverSpecialities.count > 0 {
            let obj = self.arrCaregiverSpecialities[btn.tag]
            obj.isSelectSpecialities = !obj.isSelectSpecialities
            self.cvSpecialities?.reloadData()
        }
    }
}

// MARK: - IBAction
extension FilterViewController {
    
    @IBAction func btnJobTypeOneTimeClicked(_ sender: SelectAppButton) {
        self.btnJobTypeOneTime?.isSelectBtn = (self.btnJobTypeOneTime?.isSelectBtn ?? false) ? false : true
        self.btnJobTypeRecurring?.isSelectBtn = false
        self.filterJobType = (self.btnJobTypeOneTime?.isSelectBtn ?? false) ? "1" : ""
    }
    @IBAction func btnJobTypeRecurringClicked(_ sender: SelectAppButton) {
        self.btnJobTypeOneTime?.isSelectBtn = false
        self.btnJobTypeRecurring?.isSelectBtn = (self.btnJobTypeRecurring?.isSelectBtn ?? false) ? false : true
        self.filterJobType = (self.btnJobTypeRecurring?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnFamilyVaccinatedYesClicked(_ sender: SelectAppButton) {
        self.btnFamilyVaccinatedYes?.isSelectBtn = (self.btnFamilyVaccinatedYes?.isSelectBtn ?? false) ? false : true
        self.btnFamilyVaccinatedNo?.isSelectBtn = false
        self.filterVaccinated = (self.btnFamilyVaccinatedYes?.isSelectBtn ?? false) ? "1" : ""
    }
    @IBAction func btnFamilyVaccinatedNoClicked(_ sender: SelectAppButton) {
        self.btnFamilyVaccinatedNo?.isSelectBtn = (self.btnFamilyVaccinatedNo?.isSelectBtn ?? false) ? false : true
        self.btnFamilyVaccinatedYes?.isSelectBtn = false
        self.filterVaccinated = (self.btnFamilyVaccinatedNo?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnSortNewestClicked(_ sender: SelectAppButton) {
        self.btnSortNewest?.isSelectBtn = (self.btnSortNewest?.isSelectBtn ?? false) ? false : true
        self.btnSortOldest?.isSelectBtn = false
        self.filterNewestOldest = (self.btnSortNewest?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnSortOldestClicked(_ sender: SelectAppButton) {
        self.btnSortOldest?.isSelectBtn = (self.btnSortOldest?.isSelectBtn ?? false) ? false : true
        self.btnSortNewest?.isSelectBtn = false
        self.filterNewestOldest = (self.btnSortOldest?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnSortBehaviouralClicked(_ sender: SelectAppButton) {
        self.btnSortBehaviourasl?.isSelectBtn = (self.btnSortBehaviourasl?.isSelectBtn ?? false) ? false : true
        self.btnSortNonBehaviourasl?.isSelectBtn = false
        self.filterBehavioral = (self.btnSortBehaviourasl?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnSortNonBehaviouralClicked(_ sender: SelectAppButton) {
        self.btnSortNonBehaviourasl?.isSelectBtn = (self.btnSortNonBehaviourasl?.isSelectBtn ?? false) ? false : true
        self.btnSortBehaviourasl?.isSelectBtn = false
        self.filterBehavioral = (self.btnSortNonBehaviourasl?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnSortVerbalClicked(_ sender: SelectAppButton) {
        self.btnSortVerbal?.isSelectBtn = (self.btnSortVerbal?.isSelectBtn ?? false) ? false : true
        self.btnSortNonVerbal?.isSelectBtn = false
        self.filterVerbal = (self.btnSortVerbal?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnSortNonVerbalClicked(_ sender: SelectAppButton) {
        self.btnSortNonVerbal?.isSelectBtn = (self.btnSortNonVerbal?.isSelectBtn ?? false) ? false : true
        self.btnSortVerbal?.isSelectBtn = false
        self.filterVerbal = (self.btnSortNonVerbal?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnApplyFilterClicked(_ sender: UIButton) {
        self.delegate?.selectFilterData(arrCategories: self.arrFilterJobCatagories.filter({$0.isSelectCategory}), arrSpecialities: self.arrCaregiverSpecialities.filter({$0.isSelectSpecialities}), filterNewestOldest: self.filterNewestOldest, filterBehavioral: self.filterBehavioral, filterVerbal: self.filterVerbal, filterAllergies: self.vwAllergies?.txtInput.text ?? "", filterStartDistance: self.filterStartDistance,filterEndDistance: self.filterEndDistance, filterVaccinated: self.filterVaccinated, filterJobType: self.filterJobType)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - API Call
extension FilterViewController {
    private func getJobCategoryListAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                ksearch : ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobCategoryModel.getJobCategoryList(with: param, success: { (arr,msg) in
                self.arrFilterJobCatagories = arr
                let selectedcatID : [String] = self.arrSelectedCategory.map({$0.jobCategoryId})
                if !selectedcatID.isEmpty {
                    for i in stride(from: 0, to: self.arrFilterJobCatagories.count, by: 1) {
                        let obj = self.arrFilterJobCatagories[i]
                        if selectedcatID.contains(obj.jobCategoryId) {
                            obj.isSelectCategory = true
                        }
                        if i == self.arrFilterJobCatagories.count - 1 {
                            self.cvCategory?.reloadData()
                        }
                    }
                } else {
                    self.cvCategory?.reloadData()
                }
            }, failure: { (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    
    private func getCommonDataAPICall() {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        CommonModel.getCommonData(with: param, success: { (arrhearAboutUs,arrlicenceType,arrInsuranceType,arrWorkSpeciality,arrWorkMethodOfTransportation,arrWorkDisabilitiesWillingType,message) in
            
            self.arrCaregiverSpecialities = arrWorkSpeciality
            
            let selectedSpecialitiesID : [String] = self.arrSelectedSpecialities.map({$0.workSpecialityId})
            if !selectedSpecialitiesID.isEmpty {
                for i in stride(from: 0, to: self.arrCaregiverSpecialities.count, by: 1) {
                    let obj = self.arrCaregiverSpecialities[i]
                    if selectedSpecialitiesID.contains(obj.workSpecialityId) {
                        obj.isSelectSpecialities = true
                    }
                    if i == self.arrCaregiverSpecialities.count - 1 {
                        self.cvSpecialities?.reloadData()
                    }
                }
            } else {
                self.cvSpecialities?.reloadData()
            }
            
            //self.cvSpecialities?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
}

// MARK: - ViewControllerDescribable
extension FilterViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Home
    }
}

// MARK: - AppNavigationControllerInteractable
extension FilterViewController: AppNavigationControllerInteractable { }
