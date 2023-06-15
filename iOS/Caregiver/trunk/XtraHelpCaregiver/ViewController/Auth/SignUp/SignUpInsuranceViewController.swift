//
//  SignUpInsuranceViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 17/11/21.
//

import UIKit

class SignUpInsuranceViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet var lblTextHeader: [UILabel]?
    
    @IBOutlet weak var vwDataMain: UIView?
    
    @IBOutlet weak var btnYes: SelectAppButton?
    @IBOutlet weak var btnNo: SelectAppButton?
    
    @IBOutlet weak var btnAddMore: UIButton?
    
    @IBOutlet weak var tblData: UITableView?
    @IBOutlet weak var constraintTblDataHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwSaveNextMain: UIView?
    
    @IBOutlet weak var btnNext: XtraHelpButton?
    // MARK: - Variables
    private var arrData : [InsuranceModel] = []
    var isFromLogin : Bool = false
    private let imagePicker = ImagePicker()
    
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
extension SignUpInsuranceViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.imagePicker.viewController = self
        
        self.tblData?.register(CertificateCell.self)
        self.tblData?.estimatedRowHeight = 100.0
        self.tblData?.rowHeight = UITableView.automaticDimension
        self.tblData?.delegate = self
        self.tblData?.dataSource = self
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.btnAddMore?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.btnAddMore?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.lblTextHeader?.forEach({
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
            $0.textColor = UIColor.CustomColor.SubscriptuionSubColor
        })
        
        self.btnYes?.isSelectBtn = false
        self.btnNo?.isSelectBtn = true
        
        self.vwSaveNextMain?.isHidden = !self.isFromEditProfile
        self.btnNext?.setTitle(self.isFromEditProfile ? "Save" : "Next", for: .normal)
        
        if self.isFromEditProfile {
            //if let obj = self.selectedUserProfileData {
                self.getInsuranceAPICall()
           // }
        } else {
            self.addDefaultCInsurenceData()
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
    private func addDefaultCInsurenceData(){
        if let user = UserModel.getCurrentUserFromDefault() {
            let model = InsuranceModel.init(userinsuranceId: "", userid: user.id, insurancetypeId: "", insurancename: "", insurancenumber: "", expiredate: "", insuranceimagename: "", insuranceimageurl: "", insuranceImagethumburl: "", insuranceyypename: "")
            self.arrData.append(model)
            delay(seconds: 0.1) {
                self.tblData?.reloadData()
            }
        }
    }
}

//MARK: - Tableview Observer
extension SignUpInsuranceViewController {
    
    private func addTableviewOberver() {
        self.tblData?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblData?.observationInfo != nil {
            self.tblData?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblData && keyPath == ObserverName.kcontentSize {
                self.constraintTblDataHeight?.constant = self.tblData?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension SignUpInsuranceViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(for: indexPath, with: CertificateCell.self)
        cell.setInsurenceData()
        if self.arrData.count > 0 {
            let obj = self.arrData[indexPath.row]
            cell.setInsuranceData(obj: obj)
            
            cell.certificateDelegate = self
            
            cell.btnRemove?.isHidden = (self.arrData.count == 1)
            
            cell.btnUpload?.tag = indexPath.row
            cell.btnUpload?.addTarget(self, action: #selector(self.btnUploadCertificatetClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectType?.tag = indexPath.row
            cell.btnSelectType?.addTarget(self, action: #selector(self.btnSelectTypeCertificatetClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectDateExpire?.tag = indexPath.row
            cell.btnSelectDateExpire?.addTarget(self, action: #selector(self.btnDateExpireClicked(_:)), for: .touchUpInside)
            
            cell.btnRemove?.tag = indexPath.row
            cell.btnRemove?.addTarget(self, action: #selector(self.btnDeleteClicked(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnDeleteClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            self.arrData.remove(at: btn.tag)
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnUploadCertificatetClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            //let obj = self.arrData[btn.tag]
            self.imagePicker.pickImage(btn, "Select Insurance") { (img,url) in
                //self.imgProfile?.image = img
                self.mediaAPICall(img: img,selectedIndex : btn.tag)
            }
        }
    }
    
    @objc func btnSelectTypeCertificatetClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.OpenFromType = .InsuranceType
                vc.selectedCertificateTypeIndex = btn.tag
                if !obj.insuranceTypeId.isEmpty {
                    let model = InsuranceTypeModel.init(insurancetypeId: obj.insuranceTypeId, Name: obj.insuranceTypeName)
                    vc.selectedInsuranceTypeData = model
                }
                
            })
        }
    }
    
    @objc func btnDateExpireClicked(_ sender : UIButton){
        var selectedDate : Date = Date()
        //selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        if self.arrData.count > 0 && sender.tag <= self.arrData.count {
            let obj = self.arrData[sender.tag]
            if obj.expireDate != "" {
                selectedDate = obj.expireDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).removeTimeStampFromDate()
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select Insurance Expire Date",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = ((date as? Date ?? Date()).removeTimeStampFromDate()).getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.issueDate = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
        
            if self.arrData.count > 0 && sender.tag <= self.arrData.count {
                let obj = self.arrData[sender.tag]
                if let selectdate = date as? Date {
                    print(selectdate.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd))
                    //let ftime = selectdate.removeTimeStampFromDate().getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    //let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    /*if !obj.expireDate.isEmpty && mainSeletedDate == (obj.expireDate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireSameDateIssue, themeStyle: .warning)
                        }
                    } else if !obj.expireDate.isEmpty && mainSeletedDate > (obj.expireDate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireGreterThenFromTime, themeStyle: .warning)
                        }
                    } else {*/
                        obj.expireDate = time
                        //self.tblData?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                        self.tblData?.reloadData()
                   // }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        //datePicker?.minuteInterval = 30
        //datePicker?.maximumDate = Date()
        datePicker?.minimumDate = Date()
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
}



//MARK: - CertificateCellEndEditingDelegate
extension SignUpInsuranceViewController: CertificateCellEndEditingDelegate {
    func EndCerNameEditing(text: String, cell: CertificateCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.insuranceName = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func EndCerNumberEditing(text: String, cell: CertificateCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.insuranceNumber = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func EndCerDescEditing(text: String, cell: CertificateCell) {
    }
}

//MARK: - Validation
extension SignUpInsuranceViewController: ListCommonDataDelegate {
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel,selectIndex : Int) {
        if self.arrData.count > 0 {
            let objdata = self.arrData[selectIndex]
            objdata.insuranceTypeId = obj.insuranceTypeId
            objdata.insuranceTypeName = obj.name
            self.tblData?.reloadData()
        }
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        
    }
    
    func selectDisabilitiesData(obj: [WorkDisabilitiesWillingTypeModel]) {
        
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

// MARK: - IBAction
extension SignUpInsuranceViewController {
    
    private func validateFields() -> String? {
        let filter = self.arrData.filter({!$0.insuranceName.isEmpty && !$0.insuranceTypeName.isEmpty && !($0.insuranceNumber.isEmpty) && !($0.expireDate.isEmpty) && !$0.insuranceImageUrl.isEmpty && !$0.insuranceImageName.isEmpty})
        if filter.isEmpty {
            if let firstData = self.arrData.first{
                if firstData.insuranceTypeName.isEmpty{
                    return AppConstant.ValidationMessages.kEmptyInsuranceType
                } else if firstData.insuranceName.isEmpty{
                    return AppConstant.ValidationMessages.kEmptyInsuranceName
                } else if firstData.insuranceNumber.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyInsuranceNumber
                } else if firstData.expireDate.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyInsuranceDateExpires
                } else if firstData.insuranceImageUrl.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyInsuranceImage
                } else if firstData.insuranceImageName.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyInsuranceImage
                }else {
                    return nil
                }
            }
            return nil
        }
        return nil
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.btnYes?.isSelectBtn ?? false {
            if let errMessage = self.validateFields() {
                self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
                return
            }
        }
        
        //self.appNavigationController?.push(AddAvailabilityViewController.self)
        let filter = self.arrData.filter({!$0.insuranceName.isEmpty && !$0.insuranceTypeName.isEmpty && !$0.insuranceNumber.isEmpty && !$0.expireDate.isEmpty && !$0.insuranceImageUrl.isEmpty && !$0.insuranceImageName.isEmpty})
        //if filter.count > 0 {
        var arrCer : [[String:Any]] = []
       
            if filter.count > 0 && (self.btnYes?.isSelectBtn ?? false){
                for i in stride(from: 0, to: self.arrData.count, by: 1) {
                    let obj = self.arrData[i]
                    let dic : [String:Any] = [
                        kinsuranceTypeId : obj.insuranceTypeId,
                        kinsuranceName : obj.insuranceName,
                        kinsuranceNumber : obj.insuranceNumber,
                        kexpireDate : obj.expireDate,
                        kinsuranceImage : obj.insuranceImageName
                    ]
                    arrCer.append(dic)
                    
                    if i == filter.count - 1 {
                        if self.isFromEditProfile {
                            self.saveInsurance(arrCer: arrCer,isSave: true)
                        } else {
                            self.saveInsurance(arrCer: arrCer,isSave: false)
                        }
                        
                    }
                }
            } else {
                if self.isFromEditProfile {
                    self.saveInsurance(arrCer: arrCer,isSave: true)
                } else {
                    self.saveInsurance(arrCer: arrCer,isSave: false)
                }
                //self.showMessage(AppConstant.ValidationMessages.kEmprtCertificateLicenses,themeStyle: .warning)
            }
    }
    
    @IBAction func btnSaveNextClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.btnYes?.isSelectBtn ?? false {
            if let errMessage = self.validateFields() {
                self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
                return
            }
        }
        
        //self.appNavigationController?.push(AddAvailabilityViewController.self)
        let filter = self.arrData.filter({!$0.insuranceName.isEmpty && !$0.insuranceTypeName.isEmpty && !$0.insuranceNumber.isEmpty && !$0.expireDate.isEmpty && !$0.insuranceImageUrl.isEmpty && !$0.insuranceImageName.isEmpty})
        //if filter.count > 0 {
        var arrCer : [[String:Any]] = []
       
            if filter.count > 0 && (self.btnYes?.isSelectBtn ?? false){
                for i in stride(from: 0, to: self.arrData.count, by: 1) {
                    let obj = self.arrData[i]
                    let dic : [String:Any] = [
                        kinsuranceTypeId : obj.insuranceTypeId,
                        kinsuranceName : obj.insuranceName,
                        kinsuranceNumber : obj.insuranceNumber,
                        kexpireDate : obj.expireDate,
                        kinsuranceImage : obj.insuranceImageName
                    ]
                    arrCer.append(dic)
                    
                    if i == filter.count - 1 {
                        self.saveInsurance(arrCer: arrCer,isSave: false)
                    }
                }
            } else {
                self.saveInsurance(arrCer: arrCer,isSave: false)
                //self.showMessage(AppConstant.ValidationMessages.kEmprtCertificateLicenses,themeStyle: .warning)
            }
    }
    
    @IBAction func btnAddMoreClicked(_ sender: UIButton) {
        //self.arrData.append("")
        if self.arrData.count > 0 {
            if let obj = self.arrData.last {
                if obj.insuranceName.isEmpty || obj.insuranceTypeName.isEmpty || obj.insuranceNumber.isEmpty || obj.expireDate.isEmpty || obj.insuranceImageUrl.isEmpty || obj.insuranceImageName.isEmpty {
                    self.showMessage(AppConstant.ValidationMessages.kEmprtInsurance,themeStyle: .warning)
                } else {
                    self.addDefaultCInsurenceData()
                }
            }
        }
    }
   
    @IBAction func btnYesClicked(_ sender: SelectAppButton) {
        self.btnYes?.isSelectBtn = true
        self.btnNo?.isSelectBtn = false
        self.vwDataMain?.isHidden = false
    }
    @IBAction func btnNoClicked(_ sender: SelectAppButton) {
        self.btnYes?.isSelectBtn = false
        self.btnNo?.isSelectBtn = true
        self.vwDataMain?.isHidden = true
    }
}

// MARK: - API Call
extension SignUpInsuranceViewController {
    private func mediaAPICall(img : UIImage,selectedIndex : Int) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadCertificateMedia(with: dict, image: img, success: { (imgname,imgurl) in
            if self.arrData.count > 0 {
                let obj = self.arrData[selectedIndex]
                obj.insuranceImageUrl = imgurl
                obj.insuranceImageName = imgname
                self.tblData?.reloadData()
            }
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    private func saveInsurance(arrCer : [[String:Any]],isSave : Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                //kprofileStatus : "6",
                khaveInsurance : (self.btnYes?.isSelectBtn ?? false) ? "1" : "2",
                kinsurance : arrCer
            ]
            
            if !self.isFromEditProfile {
                dict[kprofileStatus] = "6"
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.saveSignupProfileDetails(with: param,type: .Insurance, success: { (model, msg) in
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
                    self.appNavigationController?.push(MyCalenderViewController.self,animated: false) { vc in
                        vc.isFromEditProfile = self.isFromEditProfile
                        if let user = self.selectedUserProfileData {
                            vc.selectedUserProfileData = user
                        }
                        if self.isFromEditProfile {
                            XtraHelp.sharedInstance.isCallReloadProfileData = true
                        }
                    }
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    private func getInsuranceAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            InsuranceModel.getInsurance(with: param, success: { (arrcer,msg) in
                self.arrData = arrcer
                /*if self.arrData.isEmpty {
                    self.addDefaultCInsurenceData()
                } else {
                    self.tblData?.reloadData()
                }*/
                
                
                self.vwDataMain?.isHidden = self.arrData.isEmpty
                if self.arrData.isEmpty {
                    self.btnYes?.isSelectBtn = false
                    self.btnNo?.isSelectBtn = true
                    self.addDefaultCInsurenceData()
                } else {
                    self.btnYes?.isSelectBtn = true
                    self.btnNo?.isSelectBtn = false
                    self.tblData?.reloadData()
                }
                
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if self.arrData.isEmpty {
                    self.addDefaultCInsurenceData()
                }
            })
        }
    }
}


// MARK: - ViewControllerDescribable
extension SignUpInsuranceViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignUpInsuranceViewController: AppNavigationControllerInteractable { }
