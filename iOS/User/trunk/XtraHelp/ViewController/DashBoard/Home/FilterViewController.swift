//
//  FilterViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

protocol filterDelegate {
    func selectFilterData(arrCategories : [JobCategoryModel],filterNewestOldest : String,filterTopRated : String,  filterOnline : String, filterAvailability : String, filterCustmeDate : Date?, filterWorkingType: String, filterGender: String,filterStartAge: Int,filterEndAge: Int,filterStartDistance: Int,filterEndDistance: Int,filterVaccineted: String)
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
    @IBOutlet weak var btnSortTopRated: SelectAppButton?
    @IBOutlet weak var btnSortOnlineNow: SelectAppButton?
    @IBOutlet weak var btnWorkingFulltime: SelectAppButton?
    @IBOutlet weak var btnWorkingPartTime: SelectAppButton?
    
    @IBOutlet var lblHeader: [UILabel]?
    
    @IBOutlet weak var vwSJobTypeMain: UIView?
    
    @IBOutlet weak var vwFamilyVaccinatedMain: UIView?
    @IBOutlet weak var btnFamilyVaccinatedYes: SelectAppButton?
    @IBOutlet weak var btnFamilyVaccinatedNo: SelectAppButton?
    
    @IBOutlet weak var btnAvailabilityToday: SelectAppButton?
    @IBOutlet weak var btnAvailabilityTomorrow: SelectAppButton?
    
    @IBOutlet weak var vwCustomDate: ReusableView?
    
    @IBOutlet weak var btnMale: SelectAppButton?
    @IBOutlet weak var btnFeMale: SelectAppButton?
    @IBOutlet weak var btnOther: SelectAppButton?
    
    @IBOutlet weak var vwAgeMain: UIView?
    @IBOutlet weak var vwDistanceMain: UIView?
    
    @IBOutlet weak var ageSlider: RangeSlider?
    @IBOutlet weak var workDistanceSlider: RangeSlider?
    
    // MARK: - Variables
    private var arrCategory : [JobCategoryModel] = []
    var arrSelectedCategory : [JobCategoryModel] = []
   // private var availabilityCustomeDate : Date?
    
    private var arrFilterJobCatagories : [JobCategoryModel] = []
    var filterNewestOldest : String = ""
    var filterTopRated : String = ""
    var filterOnline : String = ""
    var filterAvailability : String = ""
    var filterCustmeDate : Date?
    var filterWorkingType : String = ""
    var filterGender : String = ""
    var filterStartAge: Int = 0
    var filterEndAge: Int = 100
    var filterStartDistance: Int = 0
    var filterEndDistance: Int = 100
    var filterVaccineted: String = ""
    
    var delegate : filterDelegate?
    var isFromCaregiverFilter : Bool = false
    
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
        
        //self.btnFamilyVaccinatedYes?.isSelectBtn = false
        //self.btnFamilyVaccinatedNo?.isSelectBtn = false
        
        /*delay(seconds: 0.3) {
                [self.SliderDistance].forEach({
                    $0?.textColor = UIColor.CustomColor.appColor//self.isFromSubjective ? UIColor.clear : UIColor.CustomColor.SliderTextColor
                    $0?.fontName = "Rubik-Bold"
                    $0?.fontSize = 11.0// self.isFromSubjective ? 0.0 : 11.0
                    $0?.minimumValue = 0.0
                    $0?.maximumValue = 100.0
                    $0?.minimumTrackTintColor = UIColor.CustomColor.appColor//self.isFromSubjective ? UIColor.clear : UIColor.CustomColor.registerColor
                    $0?.maximumTrackTintColor = UIColor.CustomColor.slidermaxColor//self.isFromSubjective ? UIColor.clear : UIColor.CustomColor.slidermaxColor
                    
                    $0?.addTarget(self, action: #selector(self.onSliderValChanged(slider:event:)), for: .valueChanged)
                    $0?.value = 0.0
                })
        }*/
        
        [self.ageSlider,self.workDistanceSlider].forEach({
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
        
        
        //self.ageSlider?.isHighlighted = false
        
        self.ageSlider?.setValueChangedCallback { (minValue, maxValue) in
            print("rangeSlider1 min value:\(minValue)")
            self.filterStartAge = minValue
            print("rangeSlider1 max value:\(maxValue)")
            self.filterEndAge = maxValue
        }
        self.ageSlider?.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "\(minValue)"
        }
        self.ageSlider?.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "\(maxValue)"
        }
        self.ageSlider?.setMinAndMaxRange(0, maxRange: 100)
        
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
        
        //self.workDistanceSlider?.setMinAndMaxValue(15, maxValue: 50)
        
        self.vwCustomDate?.reusableViewDelegate = self
        
        if let dt = self.filterCustmeDate {
            self.vwCustomDate?.txtInput.text = dt.getFormattedString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
        }
        
        self.btnSortNewest?.isSelectBtn = self.filterNewestOldest == "1"
        self.btnSortOldest?.isSelectBtn = self.filterNewestOldest == "2"
        
        self.btnSortTopRated?.isSelectBtn = self.filterTopRated == "1"
        self.btnSortOnlineNow?.isSelectBtn = self.filterOnline == "1"
        
        self.btnAvailabilityToday?.isSelectBtn = self.filterAvailability == "1"
        self.btnAvailabilityTomorrow?.isSelectBtn = self.filterAvailability == "2"
        
        self.btnFamilyVaccinatedYes?.isSelectBtn = self.filterVaccineted == "1"
        self.btnFamilyVaccinatedNo?.isSelectBtn = self.filterVaccineted == "2"
        
        self.btnWorkingFulltime?.isSelectBtn = self.filterWorkingType == "1"
        self.btnWorkingPartTime?.isSelectBtn = self.filterWorkingType == "2"
        
        self.btnMale?.isSelectBtn = self.filterGender == "1"
        self.btnFeMale?.isSelectBtn = self.filterGender == "2"
        self.btnOther?.isSelectBtn = self.filterGender == "3"
        
        self.ageSlider?.setMinAndMaxValue(self.filterStartAge, maxValue: self.filterEndAge)
        self.workDistanceSlider?.setMinAndMaxValue(self.filterStartDistance, maxValue: self.filterEndDistance)
        if self.isFromCaregiverFilter {
            self.vwCategoryMain?.isHidden = true
            self.vwSortByMain?.isHidden = true
            self.vwSJobTypeMain?.isHidden = true
            self.vwDistanceMain?.isHidden = true
            self.vwCategoryMain?.isHidden = true
        } else {
            self.getJobCategoryListAPICall()
        }
        
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
            self.delegate?.selectFilterData(arrCategories: [], filterNewestOldest: "", filterTopRated: "", filterOnline: "", filterAvailability: "", filterCustmeDate: nil, filterWorkingType: "", filterGender: "", filterStartAge: 0, filterEndAge: 100, filterStartDistance: 0, filterEndDistance: 100, filterVaccineted: "")
            self.appNavigationController?.popViewController(animated: true)
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}
// MARK: - ReusableViewDelegate
extension FilterViewController : ReusableViewDelegate {
    func buttonClicked(_ sender: UIButton) {
        self.openCustomeDateDate(btn: sender)
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        
    }
    
    private func openCustomeDateDate(btn : UIButton){
        var selecteddate : Date = Date()
        if self.vwCustomDate?.txtInput.text != "" {
            selecteddate = (self.vwCustomDate?.txtInput.text ?? "").getDateFromString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
        }
        
        ActionSheetDatePicker.show(withTitle: "Select Date", datePickerMode: .date, selectedDate: selecteddate, minimumDate: Date(), maximumDate: nil, doneBlock: { (picker, indexes, values) in
            
            self.vwCustomDate?.txtInput.text = (indexes as? Date ?? Date()).getFormattedString(format: AppConstant.DateFormat.k_MM_dd_yyyy)
            self.filterCustmeDate = (indexes as? Date ?? Date())
            return
        }, cancel: { (actiosheet) in
            return
        }, origin: btn)
    }
}

//MARK: - Tableview Observer
extension FilterViewController {
    
    private func addTableviewOberver() {
        self.cvCategory?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        //self.cvSortBy?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        //self.cvSpecialities?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvCategory?.observationInfo != nil {
            self.cvCategory?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        /*if self.cvSortBy?.observationInfo != nil {
            self.cvSortBy?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.cvSpecialities?.observationInfo != nil {
            self.cvSpecialities?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }*/
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
            }
            if obj == self.cvSpecialities && keyPath == ObserverName.kcontentSize {
                self.constraintcvSpecialitiesHeight?.constant = self.cvSpecialities?.contentSize.height ?? 0.0
                self.cvSpecialities?.layoutIfNeeded()
            }*/
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension FilterViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvCategory {
            return self.arrCategory.count
        } /*else if collectionView == self.cvSortBy {
            return 0
        }
        return self.arrSpecialities.count*/
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*if collectionView == self.cvSortBy {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterSortByCell.self)
            cell.isSelelctSortCell = ((indexPath.row % 2) != 0)
            return cell
        } else*/
        if collectionView == self.cvCategory {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterCategoryCell.self)
            if self.arrCategory.count > 0 {
                cell.setCategoryData(obj: self.arrCategory[indexPath.row])
            }
            return cell
        }
        /*} else if collectionView == self.cvSpecialities {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FilterSpecialitiesCell.self)
            if self.arrSpecialities.count > 0 {
                cell.setSpecialitiesData(obj: self.arrSpecialities[indexPath.row])
            }
            
            cell.btnSelectMain?.tag = indexPath.row
            cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
            return cell
        }*/
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        /*if collectionView == self.cvSpecialities {
            return 5
        }*/
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.cvSortBy {
            return 10
        } else if collectionView == self.cvCategory {
            return 10
        } /*else if collectionView == self.cvSpecialities {
            return 5
        }*/
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
        } /*else if collectionView == self.cvSpecialities {
            if self.arrSpecialities.count > 0 {
                let obj = self.arrSpecialities[indexPath.row]
                return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: XtraHelp.sharedInstance.estimatedHeightOfLabel(text: obj.name) + 35.0)
            }
        }*/
        return CGSize(width: 0 , height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.row)
        if collectionView == self.cvCategory {
            if self.arrCategory.count > 0 {
                let obj = self.arrCategory[indexPath.row]
                obj.isSelectCategory = !obj.isSelectCategory
                self.cvCategory?.reloadData()
            }
        } else if collectionView == self.cvSortBy {
            
        }
    }
}

// MARK: - IBAction
extension FilterViewController {
    
    @IBAction func btnFamilyVaccinatedYesClicked(_ sender: SelectAppButton) {
        self.btnFamilyVaccinatedYes?.isSelectBtn = (self.btnFamilyVaccinatedYes?.isSelectBtn ?? false) ? false : true
        self.btnFamilyVaccinatedNo?.isSelectBtn = false
        self.filterVaccineted = (self.btnFamilyVaccinatedYes?.isSelectBtn ?? false) ? "1" : ""
    }
    @IBAction func btnFamilyVaccinatedNoClicked(_ sender: SelectAppButton) {
        self.btnFamilyVaccinatedNo?.isSelectBtn = (self.btnFamilyVaccinatedNo?.isSelectBtn ?? false) ? false : true
        self.btnFamilyVaccinatedYes?.isSelectBtn = false
        self.filterVaccineted = (self.btnFamilyVaccinatedNo?.isSelectBtn ?? false) ? "2" : ""
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
    
    @IBAction func btnSortTopRatedClicked(_ sender: SelectAppButton) {
        self.btnSortTopRated?.isSelectBtn = (self.btnSortTopRated?.isSelectBtn ?? false) ? false : true
        self.filterTopRated = (self.btnSortTopRated?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnSortOnlineClicked(_ sender: SelectAppButton) {
        self.btnSortOnlineNow?.isSelectBtn = (self.btnSortOnlineNow?.isSelectBtn ?? false) ? false : true
        self.filterOnline = (self.btnSortOnlineNow?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnSortFullTimeClicked(_ sender: SelectAppButton) {
        self.btnWorkingFulltime?.isSelectBtn = (self.btnWorkingFulltime?.isSelectBtn ?? false) ? false : true
        self.btnWorkingPartTime?.isSelectBtn = false
        self.filterWorkingType = (self.btnWorkingFulltime?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnSortPartTimeClicked(_ sender: SelectAppButton) {
        self.btnWorkingPartTime?.isSelectBtn = (self.btnWorkingPartTime?.isSelectBtn ?? false) ? false : true
        self.btnWorkingFulltime?.isSelectBtn = false
        self.filterWorkingType = (self.btnWorkingPartTime?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnAvailabilityTodayClicked(_ sender: SelectAppButton) {
        self.btnAvailabilityToday?.isSelectBtn = (self.btnAvailabilityToday?.isSelectBtn ?? false) ? false : true
        self.btnAvailabilityTomorrow?.isSelectBtn = false
        self.filterAvailability = (self.btnAvailabilityToday?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnnAvailabilityTommorowClicked(_ sender: SelectAppButton) {
        self.btnAvailabilityTomorrow?.isSelectBtn = (self.btnAvailabilityTomorrow?.isSelectBtn ?? false) ? false : true
        self.btnAvailabilityToday?.isSelectBtn = false
        self.filterAvailability = (self.btnAvailabilityTomorrow?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnMaleClicked(_ sender: SelectAppButton){
        self.btnMale?.isSelectBtn = (self.btnMale?.isSelectBtn ?? false) ? false : true
        self.btnFeMale?.isSelectBtn = false
        self.btnOther?.isSelectBtn = false
        self.filterGender = (self.btnMale?.isSelectBtn ?? false) ? "1" : ""
    }
    
    @IBAction func btnFeMaleClicked(_ sender: SelectAppButton) {
        self.btnFeMale?.isSelectBtn = (self.btnFeMale?.isSelectBtn ?? false) ? false : true
        self.btnMale?.isSelectBtn = false
        self.btnOther?.isSelectBtn = false
        self.filterGender = (self.btnFeMale?.isSelectBtn ?? false) ? "2" : ""
    }
    
    @IBAction func btnOtherClicked(_ sender: SelectAppButton) {
        self.btnOther?.isSelectBtn = (self.btnOther?.isSelectBtn ?? false) ? false : true
        self.btnFeMale?.isSelectBtn = false
        self.btnMale?.isSelectBtn = false
        self.filterGender = (self.btnOther?.isSelectBtn ?? false) ? "3" : ""
    }
    
    @IBAction func btnApplyFilterClicked(_ sender: UIButton) {
        if let selctdate = self.filterCustmeDate {
            self.delegate?.selectFilterData(arrCategories: self.arrFilterJobCatagories.filter({$0.isSelectCategory}), filterNewestOldest: self.filterNewestOldest, filterTopRated: self.filterTopRated, filterOnline: self.filterOnline, filterAvailability: self.filterAvailability, filterCustmeDate: selctdate, filterWorkingType: self.filterWorkingType, filterGender: self.filterGender, filterStartAge: self.filterStartAge, filterEndAge: self.filterEndAge, filterStartDistance: self.filterStartDistance, filterEndDistance: self.filterEndDistance, filterVaccineted: self.filterVaccineted)
        } else {
            self.delegate?.selectFilterData(arrCategories: self.arrFilterJobCatagories.filter({$0.isSelectCategory}), filterNewestOldest: self.filterNewestOldest, filterTopRated: self.filterTopRated, filterOnline: self.filterOnline, filterAvailability: self.filterAvailability, filterCustmeDate: nil, filterWorkingType: self.filterWorkingType, filterGender: self.filterGender, filterStartAge: self.filterStartAge, filterEndAge: self.filterEndAge, filterStartDistance: self.filterStartDistance, filterEndDistance: self.filterEndDistance, filterVaccineted: self.filterVaccineted)
        }
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
                self.arrCategory = arr
                self.cvCategory?.reloadData()
                
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
                
            }, failure: {(statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showMessage(error,themeStyle : .error)
                }
            })
        }
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
