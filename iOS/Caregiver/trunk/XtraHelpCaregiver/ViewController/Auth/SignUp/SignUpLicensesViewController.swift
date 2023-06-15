//
//  SignUpLicensesViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit

class SignUpLicensesViewController: UIViewController {

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
    private var arrData : [CertificationsLicenseModel] = []
    private let imagePicker = ImagePicker()
    private var selectedCertificateTypeData : licenceTypeModel?
    var isMoveAnoherVC : Bool = true
    var isFromLogin : Bool = false
    
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
        if XtraHelp.sharedInstance.isCallCertificateReloadData{
            XtraHelp.sharedInstance.isCallCertificateReloadData = false
            self.getCertificationsLicensesAPICall()
        }
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
}

// MARK: - Init Configure
extension SignUpLicensesViewController {
    
    private func InitConfig(){
        
        /*var isCallAPI : Bool = true
        
        if let user = UserModel.getCurrentUserFromDefault() {
            if isMoveAnoherVC {
                if user.profileStatus == .CertificationsLicenses || user.profileStatus == .YourAddress{
                    self.appNavigationController?.push(SignupLocationViewController.self,animated: false) { vc in
                        //vc.isFromDirect = false
                    }
                    //XtraHelp.sharedInstance.isCallCertificateReloadData = true
                    isCallAPI = false
                }
            }
        }*/
        
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
        
        //self.getCertificationsLicensesAPICall()
        //} else {
            /*if let user = UserModel.getCurrentUserFromDefault() {
                let model = CertificationsLicenseModel.init(usercertificationslicensesId: "", userid: user.id, licencetypeId: "", licencename: "", licencenumber: "", issuedate: "", expiredate: "", licencedescription: "", licenceimagename: "", licenceimageurl: "", licenceimagethumburl: "", licencetypename: "")
                self.arrData.append(model)
                self.tblData?.reloadData()
            }*/
        
        if self.isFromEditProfile {
            //if let obj = self.selectedUserProfileData {
                self.getCertificationsLicensesAPICall()
           // }
        } else {
            self.addDefaultCertificateData()
        }
        
            
        //}
        
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

//MARK: - Tableview Observer
extension SignUpLicensesViewController {
    
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
extension SignUpLicensesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: CertificateCell.self)
        if self.arrData.count > 0 {
            let obj = self.arrData[indexPath.row]
            cell.setCertificateData(obj: obj)
            
            cell.certificateDelegate = self
            
            cell.btnRemove?.isHidden = (self.arrData.count == 1)
            
            cell.btnUpload?.tag = indexPath.row
            cell.btnUpload?.addTarget(self, action: #selector(self.btnUploadCertificatetClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectType?.tag = indexPath.row
            cell.btnSelectType?.addTarget(self, action: #selector(self.btnSelectTypeCertificatetClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectDateIssue?.tag = indexPath.row
            cell.btnSelectDateIssue?.addTarget(self, action: #selector(self.btnDateIssueClicked(_:)), for: .touchUpInside)
            
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
            self.imagePicker.pickImage(btn, "Select Certificate") { (img,url) in
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
                vc.OpenFromType = .CertificateLicence
                vc.selectedCertificateTypeIndex = btn.tag
                if !obj.licenceTypeId.isEmpty {
                    let model = licenceTypeModel.init(licencetypeId: obj.licenceTypeId, Name: obj.licenceName)
                    vc.selectedCertificateTypeData = model
                }
                
            })
        }
    }
    
    @objc func btnDateIssueClicked(_ sender : UIButton){
        var selectedDate : Date = Date()
        //selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        if self.arrData.count > 0 && sender.tag <= self.arrData.count {
            let obj = self.arrData[sender.tag]
            if obj.issueDate != "" {
                selectedDate = obj.issueDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).removeTimeStampFromDate()
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select Date Issued",
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
                    let ftime = selectdate.removeTimeStampFromDate().getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    if !obj.expireDate.isEmpty && mainSeletedDate == (obj.expireDate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireSameDateIssue, themeStyle: .warning)
                        }
                    } else if !obj.expireDate.isEmpty && mainSeletedDate > (obj.expireDate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireGreterThenFromTime, themeStyle: .warning)
                        }
                    } else {
                        obj.issueDate = time
                        //self.tblData?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                        self.tblData?.reloadData()
                    }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        //datePicker?.minuteInterval = 30
        datePicker?.maximumDate = Date()
        //datePicker?.minimumDate = selectedDate
        //datePicker?.minuteInterval = self.switchHours.isOn ? 60 : 30
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
    
    @objc func btnDateExpireClicked(_ sender : UIButton){
        
        var selectedDate : Date = Date()
        let minimumSelectDate : Date = Date()
        //selectedDate = Date().rounded(minutes: 30, rounding: .ceil)
        if self.arrData.count > 0 && sender.tag <= self.arrData.count {
            let obj = self.arrData[sender.tag]
            if obj.issueDate.isEmpty {
                self.showMessage(AppConstant.ValidationMessages.kEmprtIssueDate, themeStyle: .warning)
                return
            }
            
            if obj.expireDate != "" {
                selectedDate = obj.expireDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).removeTimeStampFromDate()
            }
            
            /*if obj.issueDate != "" {
                minimumSelectDate = obj.issueDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).removeTimeStampFromDate()
                //selectedDate = minimumSelectDate
                if obj.expireDate.isEmpty {
                    var dayComponent    = DateComponents()
                    dayComponent.day    = 1 // For removing one day (yesterday): -1
                    let theCalendar     = Calendar.current
                    let nextDate        = theCalendar.date(byAdding: dayComponent, to: minimumSelectDate)
                    selectedDate = nextDate ?? minimumSelectDate
                }
            }*/
        }
        
        let datePicker = ActionSheetDatePicker(title: "Select Date Expires",
                                               datePickerMode: UIDatePicker.Mode.date,
                                               selectedDate: selectedDate,
                                               doneBlock: { picker, date, origin in
            print("picker = \(String(describing: picker))")
            print("date = \(String(describing: date))")
            print("origin = \(String(describing: origin))")
            
            let time = ((date as? Date ?? Date()).removeTimeStampFromDate()).getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
            /*if self.arrAvailibility.count > 0 && sender.tag <= self.arrAvailibility.count {
                let obj = self.arrAvailibility[sender.tag]
                obj.expireDate = time
                self.tblAvailibility?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
            }*/
            
            if self.arrData.count > 0 && sender.tag <= self.arrData.count {
                let obj = self.arrData[sender.tag]
                if let selectdate = date as? Date {
                    print(selectdate.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd))
                    let ftime = selectdate.removeTimeStampFromDate().getTimeString(inFormate: AppConstant.DateFormat.k_yyyy_MM_dd)
                    let mainSeletedDate = ftime.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                    
                    if !obj.issueDate.isEmpty && mainSeletedDate == (obj.issueDate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireSameDateIssue, themeStyle: .warning)
                        }
                    } else if !obj.issueDate.isEmpty && mainSeletedDate < (obj.issueDate.getStringToDateToStringToDate(firstformat: AppConstant.DateFormat.k_yyyy_MM_dd, secondformat: AppConstant.DateFormat.k_yyyy_MM_dd)) {
                        delay(seconds: 0.3) {
                            self.showMessage(AppConstant.ValidationMessages.kDateExpireLessThenDateIssue, themeStyle: .warning)
                        }
                    } else {
                        obj.expireDate = time
                        //self.tblData?.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                        self.tblData?.reloadData()
                    }
                }
            }
            return
        },cancel: { picker in
            return
        },origin: sender)
        //datePicker?.minuteInterval = 30//self.switchHours.isOn ? 60 : 30
        //datePicker?.countDownDuration = 60
        datePicker?.minimumDate = minimumSelectDate
        if #available(iOS 14.0, *) {
            //datePicker.st
            datePicker?.datePickerStyle = .wheels
        }
        
        datePicker?.show()
    }
}
//MARK: - CertificateCellEndEditingDelegate
extension SignUpLicensesViewController: CertificateCellEndEditingDelegate {
    func EndCerNameEditing(text: String, cell: CertificateCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.licenceName = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func EndCerNumberEditing(text: String, cell: CertificateCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.licenceNumber = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func EndCerDescEditing(text: String, cell: CertificateCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.licenceDescription = text
            }
            self.tblData?.reloadData()
        }
    }
}

//MARK: - Validation
extension SignUpLicensesViewController: ListCommonDataDelegate {
    func selectAdditionalQuestionData(obj: [AdditionalQuestionModel],isFromModifyQuestion : Bool) {
        
    }
    
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel,selectIndex : Int) {
        
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        
    }
    
    func selectDisabilitiesData(obj: [WorkDisabilitiesWillingTypeModel]) {
        
    }
    
    func selectHearAboutData(obj: HearAboutUsModel) {
        
    }
    
    func selectCertificateTypeData(obj: licenceTypeModel,selectIndex : Int) {
        if self.arrData.count > 0 {
            let objdata = self.arrData[selectIndex]
            objdata.licenceTypeId = obj.licenceTypeId
            objdata.licenceTypeName = obj.name
            self.tblData?.reloadData()
        }
    }
    func selectSubstituteCaregiverData(obj: CaregiverListModel) {
        
    }
}

// MARK: - IBAction
extension SignUpLicensesViewController {
    
    private func validateFields() -> String? {
        let filter = self.arrData.filter({!$0.licenceName.isEmpty && !$0.licenceTypeName.isEmpty && !$0.licenceNumber.isEmpty && !($0.issueDate.isEmpty) && !($0.expireDate.isEmpty) && !$0.licenceImageUrl.isEmpty && !$0.licenceImageName.isEmpty})
        if filter.isEmpty {
            if let firstData = self.arrData.first{
                if firstData.licenceTypeName.isEmpty{
                    return AppConstant.ValidationMessages.kEmptyLicenceType
                } else if firstData.licenceName.isEmpty{
                    return AppConstant.ValidationMessages.kEmptyLicenceName
                } else if firstData.licenceNumber.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyLicenceNumber
                } else if firstData.issueDate.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyLicenceDateIssued
                } else if firstData.expireDate.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyLicenceDateExpires
                } else if firstData.licenceImageUrl.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyLicenceImage
                } else if firstData.licenceImageName.isEmpty {
                    return AppConstant.ValidationMessages.kEmptyLicenceImage
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
        
        let filter = self.arrData.filter({!$0.licenceName.isEmpty && !$0.licenceTypeName.isEmpty && !$0.licenceNumber.isEmpty && !$0.issueDate.isEmpty && !$0.expireDate.isEmpty && !$0.licenceImageUrl.isEmpty && !$0.licenceImageName.isEmpty})
        //if filter.count > 0 {
        var arrCer : [[String:Any]] = []
        
        if filter.count > 0 && (self.btnYes?.isSelectBtn ?? false){
            for i in stride(from: 0, to: self.arrData.count, by: 1) {
                let obj = self.arrData[i]
                let dic : [String:Any] = [
                    klicenceTypeId : obj.licenceTypeId,
                    klicenceName : obj.licenceName,
                    klicenceNumber : obj.licenceNumber,
                    kissueDate : obj.issueDate,
                    kexpireDate : obj.expireDate,
                    klicenceImage : obj.licenceImageName,
                    kdescription : obj.licenceDescription
                ]
                arrCer.append(dic)
                
                if i == filter.count - 1 {
                    if self.isFromEditProfile {
                        self.saveCertificationsLicenses(arrCer: arrCer,isSave: true)
                    } else {
                        self.saveCertificationsLicenses(arrCer: arrCer,isSave: false)
                    }
                }
            }
        } else {
            if self.isFromEditProfile {
                self.saveCertificationsLicenses(arrCer: arrCer,isSave: true)
            } else {
                self.saveCertificationsLicenses(arrCer: arrCer,isSave: false)
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
        let filter = self.arrData.filter({!$0.licenceName.isEmpty && !$0.licenceTypeName.isEmpty && !$0.licenceNumber.isEmpty && !$0.issueDate.isEmpty && !$0.expireDate.isEmpty && !$0.licenceImageUrl.isEmpty && !$0.licenceImageName.isEmpty})
        //if filter.count > 0 {
        var arrCer : [[String:Any]] = []
        
        if filter.count > 0 && (self.btnYes?.isSelectBtn ?? false){
            for i in stride(from: 0, to: self.arrData.count, by: 1) {
                let obj = self.arrData[i]
                let dic : [String:Any] = [
                    klicenceTypeId : obj.licenceTypeId,
                    klicenceName : obj.licenceName,
                    klicenceNumber : obj.licenceNumber,
                    kissueDate : obj.issueDate,
                    kexpireDate : obj.expireDate,
                    klicenceImage : obj.licenceImageName,
                    kdescription : obj.licenceDescription
                ]
                arrCer.append(dic)
                
                if i == filter.count - 1 {
                    self.saveCertificationsLicenses(arrCer: arrCer,isSave: false)
                }
            }
        } else {
            self.saveCertificationsLicenses(arrCer: arrCer,isSave: false)
            //self.showMessage(AppConstant.ValidationMessages.kEmprtCertificateLicenses,themeStyle: .warning)
        }
        //}
    }
    
    @IBAction func btnAddMoreClicked(_ sender: UIButton) {
        
        if self.arrData.count > 0 {
            if let obj = self.arrData.last {
                if obj.licenceName.isEmpty || obj.licenceTypeName.isEmpty || obj.licenceNumber.isEmpty || obj.issueDate.isEmpty || obj.expireDate.isEmpty || obj.licenceImageUrl.isEmpty || obj.licenceImageName.isEmpty {
                    self.showMessage(AppConstant.ValidationMessages.kEmprtCertificateLicenses,themeStyle: .warning)
                } else {
                    self.addDefaultCertificateData()
                }
            }
        }
    }
    
    private func addDefaultCertificateData(){
        if let user = UserModel.getCurrentUserFromDefault() {
            let model = CertificationsLicenseModel.init(usercertificationslicensesId: "", userid: user.id, licencetypeId: "", licencename: "", licencenumber: "", issuedate: "", expiredate: "", licencedescription: "", licenceimagename: "", licenceimageurl: "", licenceimagethumburl: "", licencetypename: "")
            self.arrData.append(model)
            delay(seconds: 0.1) {
                self.tblData?.reloadData()
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
extension SignUpLicensesViewController {
    private func mediaAPICall(img : UIImage,selectedIndex : Int) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadCertificateMedia(with: dict, image: img, success: { (imgname,imgurl) in
            if self.arrData.count > 0 {
                let obj = self.arrData[selectedIndex]
                obj.licenceImageUrl = imgurl
                obj.licenceImageName = imgname
                self.tblData?.reloadData()
            }
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    private func saveCertificationsLicenses(arrCer : [[String:Any]],isSave : Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                //kprofileStatus : "3",
                khaveCertificationsOrLicenses : (self.btnYes?.isSelectBtn ?? false) ? "1" : "2",
                kcertificationsOrLicenses : arrCer
            ]
            if !self.isFromEditProfile {
                dict[kprofileStatus] = "3"
            }
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.saveSignupProfileDetails(with: param,type: .CertificationsLicenses, success: { (model, msg) in
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
                    self.appNavigationController?.push(SignupLocationViewController.self,animated: false) { vc in
                        vc.isMoveAnoherVC = false
                        vc.isFromEditProfile = self.isFromEditProfile
                        if self.isFromEditProfile {
                            XtraHelp.sharedInstance.isCallReloadProfileData = true
                        }
                        if let user = self.selectedUserProfileData {
                            vc.selectedUserProfileData = user
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
    private func getCertificationsLicensesAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CertificationsLicenseModel.getCertificationsLicenses(with: param, success: { (arrcer,msg) in
                self.arrData = arrcer
                self.vwDataMain?.isHidden = self.arrData.isEmpty
                if self.arrData.isEmpty {
                    self.btnYes?.isSelectBtn = false
                    self.btnNo?.isSelectBtn = true
                    self.addDefaultCertificateData()
                } else {
                    self.btnYes?.isSelectBtn = true
                    self.btnNo?.isSelectBtn = false
                    self.tblData?.reloadData()
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                if self.arrData.isEmpty {
                    self.addDefaultCertificateData()
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension SignUpLicensesViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignUpLicensesViewController: AppNavigationControllerInteractable { }
