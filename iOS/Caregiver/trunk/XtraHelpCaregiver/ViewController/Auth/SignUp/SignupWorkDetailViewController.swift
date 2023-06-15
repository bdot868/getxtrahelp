//
//  SignupWorkDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit

enum WorkDetailEnum : Int {
    case Category
    case Speciality
    case MethodTransportation
    case DisabilitiesType
    case Experience
}

class SignupWorkDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet var lblTextHeader: [UILabel]?
    
    @IBOutlet weak var cvCategories: UICollectionView?
    @IBOutlet weak var constraintcvCategoriesHeight: NSLayoutConstraint?
    
    @IBOutlet weak var tblWorkPlace: UITableView?
    @IBOutlet weak var constraintTblWorkPlaceHeight: NSLayoutConstraint?
    
    @IBOutlet weak var btnAddWorkPlace: UIButton?
    @IBOutlet weak var SliderDistance: DBNumberedSlider?
    
    @IBOutlet weak var vwCategory: ReusableView?
    @IBOutlet weak var vwSpeciality: ReusableView?
    @IBOutlet weak var vwMethodTransportation: ReusableView?
    @IBOutlet weak var vwDisabilitiesType: ReusableView?
    @IBOutlet weak var vwExperience: ReusableView?
    @IBOutlet weak var vwInspired: ReusableTextview?
    @IBOutlet weak var vwBio: ReusableTextview?
    
    @IBOutlet weak var vwSaveNextMain: UIView?
    
    @IBOutlet weak var btnNext: XtraHelpButton?
    
    // MARK: - Variables
    private var arrCategory : [JobCategoryModel] = []
    private var arrWorkExperience : [WorkExperienceModel] = []
    private var arrExperienceYear: [String] = []
    var isMoveAnoherVC : Bool = true
    var isFromLogin : Bool = false
    private var distanceTravel : String = ""
    
    var selectedWorkSpecialityData : WorkSpecialityModel?
    var selectedInsuranceTypeData : InsuranceTypeModel?
    var selectedWorkMethodTransportationData : WorkMethodOfTransportationModel?
    var selectedDisabilitiesData : [WorkDisabilitiesWillingTypeModel] = []
    
    var isFromEditProfile : Bool = false
    var selectedUserProfileData : UserProfileModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.addTableviewOberver()
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
}

// MARK: - Init Configure
extension SignupWorkDetailViewController {
    
    private func InitConfig(){
        self.arrExperienceYear = XtraHelp.sharedInstance.getExperienceYear()
        XtraHelp.sharedInstance.isCallLocationReloadData = true
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.cvCategories?.register(CategoryListCell.self)
        self.cvCategories?.delegate = self
        self.cvCategories?.dataSource = self
        if let vw = self.cvCategories {
            let alignedFlowLayout = vw.collectionViewLayout as? AlignedCollectionViewFlowLayout
            alignedFlowLayout?.horizontalAlignment = .left
            alignedFlowLayout?.verticalAlignment = .top
        }
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblTextHeader?.forEach({
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
            $0.textColor = UIColor.CustomColor.SubscriptuionSubColor
        })
        
        self.btnAddWorkPlace?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.btnAddWorkPlace?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.tblWorkPlace?.register(WorkExperienceCell.self)
        self.tblWorkPlace?.estimatedRowHeight = 100.0
        self.tblWorkPlace?.rowHeight = UITableView.automaticDimension
        self.tblWorkPlace?.delegate = self
        self.tblWorkPlace?.dataSource = self
        
        self.vwSaveNextMain?.isHidden = !self.isFromEditProfile
        self.btnNext?.setTitle(self.isFromEditProfile ? "Save" : "Next", for: .normal)
        
        delay(seconds: 0.3) {
                [self.SliderDistance].forEach({
                    $0?.textColor = UIColor.CustomColor.tabBarColor//self.isFromSubjective ? UIColor.clear : UIColor.CustomColor.SliderTextColor
                    $0?.fontName = "Rubik-Bold"
                    $0?.fontSize = 11.0// self.isFromSubjective ? 0.0 : 11.0
                    $0?.minimumValue = 0.0
                    $0?.maximumValue = 100.0
                    $0?.minimumTrackTintColor = UIColor.CustomColor.appColor//self.isFromSubjective ? UIColor.clear : UIColor.CustomColor.registerColor
                    $0?.maximumTrackTintColor = UIColor.CustomColor.slidermaxColor//self.isFromSubjective ? UIColor.clear : UIColor.CustomColor.slidermaxColor
                    
                    $0?.addTarget(self, action: #selector(self.onSliderValChanged(slider:event:)), for: .valueChanged)
                    $0?.value = 0.0
                })
        }
        
        [self.vwCategory,self.vwExperience,self.vwSpeciality,self.vwDisabilitiesType,self.vwMethodTransportation].forEach({
            $0?.reusableViewDelegate = self
        })
        
        self.vwCategory?.btnSelect.tag = WorkDetailEnum.Category.rawValue
        self.vwExperience?.btnSelect.tag = WorkDetailEnum.Experience.rawValue
        self.vwSpeciality?.btnSelect.tag = WorkDetailEnum.Speciality.rawValue
        self.vwDisabilitiesType?.btnSelect.tag = WorkDetailEnum.DisabilitiesType.rawValue
        self.vwMethodTransportation?.btnSelect.tag = WorkDetailEnum.MethodTransportation.rawValue
        
        if self.isFromEditProfile {
            self.getWorkDetails()
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isFromDirect : self.isFromLogin)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - UISlider Delegates
extension SignupWorkDetailViewController : ReusableViewDelegate {
    func rightButtonClicked(_ sender: UIButton) {
        
    }

    func buttonClicked(_ sender: UIButton) {
        
        switch WorkDetailEnum.init(rawValue: sender.tag) ?? .Category {
        case .Category:
            self.appNavigationController?.push(SignupCategoryListViewController.self,configuration: { vc in
                vc.delegate = self
                vc.arrSelectedCategory = self.arrCategory.map({$0.jobCategoryId})
            })
        case .Speciality:
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.OpenFromType = .WorkSpeciality
                if let data = self.selectedWorkSpecialityData {
                    vc.selectedWorkSpecialityData = data
                }
            })
        case .MethodTransportation:
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.OpenFromType = .WorkMethodTransportation
                if let data = self.selectedWorkMethodTransportationData {
                    vc.selectedWorkMethodTransportationData = data
                }
            })
        case .DisabilitiesType:
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.OpenFromType = .Disabilities
               // if let data = self.selectedDisabilitiesData {
                vc.selectedDisabilitiesData = self.selectedDisabilitiesData
                //}
            })
        case .Experience:
            self.openExperiencePicker(btn: sender)
            break
        }
        
    }
    
    private func openExperiencePicker(btn : UIButton){
        var selecetdIndex : Int = 0
        for i in stride(from: 0, to: self.arrExperienceYear.count, by: 1){
            if (self.vwExperience?.txtInput.text ?? "") == self.arrExperienceYear[i] {
                selecetdIndex = i
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Select Experince", rows: self.arrExperienceYear, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            self.vwExperience?.txtInput.text = self.arrExperienceYear[indexes]
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: btn)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
}

//MARK: - Validation
extension SignupWorkDetailViewController: ListCommonDataDelegate {
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        self.selectedWorkSpecialityData = obj
        self.vwSpeciality?.txtInput.text = obj.name
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel,selectIndex : Int) {
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        self.selectedWorkMethodTransportationData = obj
        self.vwMethodTransportation?.txtInput.text = obj.name
    }
    
    func selectDisabilitiesData(obj: [WorkDisabilitiesWillingTypeModel]) {
        self.selectedDisabilitiesData = obj
        self.vwDisabilitiesType?.txtInput.text = obj.map({$0.name}).joined(separator: " ,")
    }
    
    func selectHearAboutData(obj: HearAboutUsModel) {
    }
    
    func selectCertificateTypeData(obj: licenceTypeModel,selectIndex : Int) {
    }
    
    func selectAdditionalQuestionData(obj: [AdditionalQuestionModel],isFromModifyQuestion : Bool) {
        
    }
    
    func selectSubstituteCaregiverData(obj: CaregiverListModel) {
        
    }
}

// MARK: - UISlider Delegates
extension SignupWorkDetailViewController : jobCategoryDelegate {
    func selectedCategories(arr: [JobCategoryModel]) {
        self.arrCategory = arr
        self.cvCategories?.reloadData()
    }
}

// MARK: - UISlider Delegates
extension SignupWorkDetailViewController  {
    @objc func onSliderValChanged(slider: DBNumberedSlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                break
                // handle drag began
            case .moved:
                break
                // handle drag moved
            case .ended:
                let value  = round(slider.value)
                if value > 0 {
                    self.distanceTravel = "\(Int(value))"
                } else {
                    self.distanceTravel = ""
                }
               // self.distanceTravel = convertvalue
                break
                // handle drag ended
            default:
                break
            }
        }
    }
}

//MARK: - Tableview Observer
extension SignupWorkDetailViewController {
    
    private func addTableviewOberver() {
        self.cvCategories?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblWorkPlace?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvCategories?.observationInfo != nil {
            self.cvCategories?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.tblWorkPlace?.observationInfo != nil {
            self.tblWorkPlace?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            if obj == self.cvCategories && keyPath == ObserverName.kcontentSize {
                self.constraintcvCategoriesHeight?.constant = self.cvCategories?.contentSize.height ?? 0.0
            }
        }
        if let obj = object as? UITableView {
            if obj == self.tblWorkPlace && keyPath == ObserverName.kcontentSize {
                self.constraintTblWorkPlaceHeight?.constant = self.tblWorkPlace?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension SignupWorkDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrWorkExperience.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: WorkExperienceCell.self)
        if self.arrWorkExperience.count > 0 {
            cell.setWorkExperienceData(obj: self.arrWorkExperience[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension SignupWorkDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryListCell.self)
        
        if self.arrCategory.count > 0{
            cell.lblCategoryName?.text = self.arrCategory[indexPath.row].name
            
            cell.btnClose?.tag = indexPath.row
            cell.btnClose?.addTarget(self, action: #selector(self.btnDeleteCatgoryClicked(_:)), for: .touchUpInside)
        }
        
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
        
        var fontsize: CGFloat = 0.0
        if self.arrCategory.count > 0 {
            let obj = self.arrCategory[indexPath.row]
            fontsize = obj.name.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)))
        }
        
        return CGSize(width: fontsize + 80.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func btnDeleteCatgoryClicked(_ btn : UIButton){
        if self.arrCategory.count > 0 {
            let obj = self.arrCategory[btn.tag]
            self.arrCategory.removeAll(where: {$0.jobCategoryId == obj.jobCategoryId})
            self.cvCategories?.reloadData()
        }
    }
}

// MARK: - IBAction
extension SignupWorkDetailViewController {
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(SignUpInsuranceViewController.self)
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        if self.isFromEditProfile {
            self.saveWorkDetail(isSave: true)
        } else {
            self.saveWorkDetail(isSave: false)
        }
        
    }
    
    @IBAction func btnSaveNextClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        self.saveWorkDetail(isSave: false)
    }
    
    @IBAction func btnAddWorkPlaceClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(SignupLocationViewController.self)
        /*self.arrWorkExperience.append("")
        self.tblWorkPlace?.reloadData()*/
        self.appNavigationController?.present(AddWorkExperienceViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
        })
    }
}
// MARK: - AddWork Experience Delegate
extension SignupWorkDetailViewController : AddWorkExperienceDelegate {
    func addWorkExperinec(obj : WorkExperienceModel) {
        self.arrWorkExperience.append(obj)
        self.tblWorkPlace?.reloadData()
    }
}

//MARK: - Validation
extension SignupWorkDetailViewController {
    private func validateFields() -> String? {
        if self.arrCategory.isEmpty{
            return AppConstant.ValidationMessages.kEmptyJobCategory
        } else if self.vwSpeciality?.txtInput.isEmpty ?? false{
            return AppConstant.ValidationMessages.kEmptySpeciality
        } else if self.distanceTravel.isEmpty {
            return AppConstant.ValidationMessages.kEmptyMaximumdistanceyourewillingtotravel
        } else if self.vwMethodTransportation?.txtInput.isEmpty ?? false {
            return AppConstant.ValidationMessages.kEmptyyourmethodoftransportation
        } else if self.vwDisabilitiesType?.txtInput.isEmpty ?? false {
            return AppConstant.ValidationMessages.kEmptyTypesofdisabilitiescaregiveriswillingtowork
        } else if self.vwExperience?.txtInput.isEmpty ?? false {
            return AppConstant.ValidationMessages.kEmptyYearsofexperience
        } else {
            return nil
        }
    }
}

//MARK : - API Call
extension SignupWorkDetailViewController{
    
    func saveWorkDetail(isSave : Bool = true) {
        
        var arrWork : [[String:Any]] = []
        for i in stride(from: 0, to: self.arrWorkExperience.count, by: 1) {
            let obj = self.arrWorkExperience[i]
            let dict : [String:Any] = [
                kworkPlace : obj.workPlace,
                kstartDate : obj.startDate.getDateFromString(format: AppConstant.DateFormat.k_MMMMyyyy).getTimeString(inFormate: AppConstant.DateFormat.k_MM_yyyy),
                kendDate : obj.endDate.isEmpty ? "" : obj.endDate.getDateFromString(format: AppConstant.DateFormat.k_MMMMyyyy).getTimeString(inFormate: AppConstant.DateFormat.k_MM_yyyy),
                kleavingReason : obj.leavingReason,
                kdescription : obj.workDescription
            ]
            arrWork.append(dict)
        }
        
        //self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let speciality = self.selectedWorkSpecialityData, let methodTransportation = self.selectedWorkMethodTransportationData {
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                //kprofileStatus : "5",
                kjobCategory : self.arrCategory.map({$0.jobCategoryId}),
                kworkSpecialityId : speciality.workSpecialityId,
                kmaxDistanceTravel : self.distanceTravel,
                kworkMethodOfTransportationId : methodTransportation.workMethodOfTransportationId,
                kworkDisabilitiesWillingType : self.selectedDisabilitiesData.map({$0.workDisabilitiesWillingTypeId}),
                kexperienceOfYear : self.vwExperience?.txtInput.text ?? "",
                kinspiredYouBecome : self.vwInspired?.txtInput?.text ?? "",
                kbio : self.vwBio?.txtInput?.text ?? "",
                kworkExperience : arrWork
            ]
            
            if !self.isFromEditProfile {
                dict[kprofileStatus] = "5"
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.saveSignupProfileDetails(with: param,type: .WorkDetails, success: { (model, msg) in
                if isSave {
                    if self.isFromEditProfile {
                        XtraHelp.sharedInstance.isCallReloadProfileData = true
                    }
                    if let nav = self.navigationController {
                        for controller in nav.viewControllers as Array {
                            if controller.isKind(of: ProfileViewController.self) {
                                nav.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    
                } else {
                    self.appNavigationController?.push(SignUpInsuranceViewController.self,configuration: { (vc) in
                        vc.isFromEditProfile = self.isFromEditProfile
                        if let user = self.selectedUserProfileData {
                            vc.selectedUserProfileData = user
                        }
                        if self.isFromEditProfile {
                            XtraHelp.sharedInstance.isCallReloadProfileData = true
                        }
                    })
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    
    private func getWorkDetails(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            WorkDetailModel.getWorkDetails(with: param, success: { (workdetaildata,msg) in
                
                self.arrCategory = workdetaildata.categoryData
                self.cvCategories?.reloadData()
                
                self.arrWorkExperience = workdetaildata.workExperienceData
                self.tblWorkPlace?.reloadData()
                
                self.selectedDisabilitiesData = workdetaildata.workDisabilitiesWillingTypeData
                self.vwDisabilitiesType?.txtInput.text = workdetaildata.workDisabilitiesWillingTypeData.map({$0.name}).joined(separator: " ,")
                
                self.selectedWorkSpecialityData = WorkSpecialityModel.init(WorkSpecialityId: workdetaildata.workSpecialityId, Name: workdetaildata.workSpecialityName)
                self.vwSpeciality?.txtInput.text = workdetaildata.workSpecialityName
                
                self.distanceTravel = workdetaildata.maxDistanceTravel
                delay(seconds: 0.2) {
                    self.SliderDistance?.value = Float(workdetaildata.maxDistanceTravel) ?? 0.0
                }
                
                self.selectedWorkMethodTransportationData = WorkMethodOfTransportationModel.init(WorkMethodOfTransportationId: workdetaildata.workMethodOfTransportationId, Name: workdetaildata.workMethodOfTransportationName)
                self.vwMethodTransportation?.txtInput.text = workdetaildata.workMethodOfTransportationName
                
                self.vwExperience?.txtInput.text = workdetaildata.experienceOfYear
                
                self.vwInspired?.txtInput?.text = workdetaildata.inspiredYouBecome
                self.vwBio?.txtInput?.text = workdetaildata.bio
                
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension SignupWorkDetailViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignupWorkDetailViewController: AppNavigationControllerInteractable { }

