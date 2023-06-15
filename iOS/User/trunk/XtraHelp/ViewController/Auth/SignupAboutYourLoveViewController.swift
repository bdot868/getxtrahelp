//
//  SignupAboutYourLoveViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/12/21.
//

import UIKit

class SignupAboutYourLoveViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblNoReceiptionHeader: UILabel?
    
    @IBOutlet weak var vwDataMain: UIView?
    @IBOutlet weak var vwNoOfReceiption: ReusableView?
    
    @IBOutlet weak var tblData: UITableView?
    @IBOutlet weak var constraintTblDataHeight: NSLayoutConstraint?
    
    // MARK: - Variables
    private var arrData : [AboutLovedModel] = []
    var isFromLogin : Bool = false
    var selectedLovedDisabilitiesData : LovedDisabilitiesTypeModel?
    
    private var arrLovedCategory : [LovedCategoryModel] = []
    private var tempArrLovedCategory : [LovedCategoryModel] = []
    private var arrSpecialities : [LovedSpecialitiesModel] = []
    
    private var arrNoOfReceiptionData : [String] = ["1","2","3","4","5","6","7","8","9","10"]
    
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
extension SignupAboutYourLoveViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblData?.register(AboutYourLovedCell.self)
        self.tblData?.estimatedRowHeight = 100.0
        self.tblData?.rowHeight = UITableView.automaticDimension
        self.tblData?.delegate = self
        self.tblData?.dataSource = self
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblNoReceiptionHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        self.lblNoReceiptionHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        
        self.vwNoOfReceiption?.reusableViewDelegate = self
        
        self.getCommonDataAPICall()
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
    
    private func addDefaultAboutLovedData(isReloadTable : Bool = true){
        
        /*for i in stride(from: 0, to: self.arrLovedCategory.count, by: 1) {
            let obj = self.arrLovedCategory[i]
            obj.isSelectCategory = false
        }
        
        for i in stride(from: 0, to: self.arrSpecialities.count, by: 1) {
            let obj = self.arrSpecialities[i]
            obj.isSelectSpecialities = false
        }*/
        
        self.arrLovedCategory = self.tempArrLovedCategory.copy()
        //self.arrLovedCategory.filter({$0.isSelectCategory}).count > 0 ? self.tempArrLovedCategory :
        if let user = UserModel.getCurrentUserFromDefault() {
            let model = AboutLovedModel.init(loveddisabilitiestypeId: "", lovedaboutdesc: "", lovedothercategorytext: "", lovedbehavioral: "1", lovedverbal: "1", Allergies: "", lovedcategory: self.arrLovedCategory, lovedspecialities: self.arrSpecialities, loveddisabilitiestypename: "", useraboutlovedId: "", userid: user.id)//AboutLovedModel(loveddisabilitiestypeId: "", lovedaboutdesc: "", lovedothercategorytext: "", lovedbehavioral: "", lovedverbal: "", Allergies: "", lovedcategory: self.arrCategory, lovedspecialities: self.arrSpecialities)
            self.arrData.append(model)
            if isReloadTable {
                //delay(seconds: 0.1) {
                    self.tblData?.reloadData()
               // }
            }
        }
    }
}

//MARK: - ReusableView Delegate
extension SignupAboutYourLoveViewController : ReusableViewDelegate {
    func buttonClicked(_ sender: UIButton) {
        
        var selecetdIndex : Int = 0
        for i in stride(from: 0, to: self.arrNoOfReceiptionData.count, by: 1){
            if (self.vwNoOfReceiption?.txtInput.text ?? "") == self.arrNoOfReceiptionData[i] {
                selecetdIndex = i
                break
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Number of Recipients", rows: self.arrNoOfReceiptionData, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            //self.selectedGender = self.arrGender[indexes]
            self.vwNoOfReceiption?.txtInput.text = self.arrNoOfReceiptionData[indexes]
            let numberdata : Int = Int(self.arrNoOfReceiptionData[indexes]) ?? 0
            
            if numberdata != self.arrData.count {
                if numberdata > self.arrData.count {
                    let count = numberdata - self.arrData.count
                    for i in stride(from: 0, to: count, by: 1) {
                        self.addDefaultAboutLovedData(isReloadTable: (i == count - 1))
                    }
                    //self.addDefaultAboutLovedData(isReloadTable: true)
                } else if numberdata < self.arrData.count {
                    var temparr = self.arrData
                    //self.arrData.removeAll(where: {numberdata})
                    for i in stride(from: 0, to: self.arrData.count, by: 1) {
                        if i >= numberdata {
                            temparr.removeLast()
                           
                            //self.arrData.remove
                            //self.addDefaultAboutLovedData(isReloadTable: (i == numberdata - 1))
                        }
                        if i == self.arrData.count - 1 {
                            self.arrData = temparr
                            self.tblData?.reloadData()
                        }
                    }
                } else {
                    for i in stride(from: 0, to: numberdata, by: 1) {
                        self.addDefaultAboutLovedData(isReloadTable: (i == numberdata - 1))
                    }
                }
            }
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        
    }
    
}


//MARK: - Tableview Observer
extension SignupAboutYourLoveViewController {
    
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
extension SignupAboutYourLoveViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(for: indexPath, with: AboutYourLovedCell.self)
        //cell.setInsurenceData()
        if self.arrData.count > 0 {
            let obj = self.arrData[indexPath.row]
            cell.setAboutLoveData(arrcat: obj.lovedCategory, arrSpe: obj.lovedSpecialities,indexpath : indexPath,obj : obj)
            
            cell.layoutIfNeeded()
            
            cell.btnDisabilities?.tag = indexPath.row
            cell.btnDisabilities?.addTarget(self, action: #selector(self.btnSelectLovedDisabilitiesClicked(_:)), for: .touchUpInside)
            cell.aboutYourLovedDelegate = self
            
            cell.btnBehavioral?.tag = indexPath.row
            cell.btnBehavioral?.addTarget(self, action: #selector(self.btnSelectBehavioralClicked(_:)), for: .touchUpInside)
            
            cell.btnNonBehavioral?.tag = indexPath.row
            cell.btnNonBehavioral?.addTarget(self, action: #selector(self.btnSelectNonBehavioralClicked(_:)), for: .touchUpInside)
            
            cell.btnVerbal?.tag = indexPath.row
            cell.btnVerbal?.addTarget(self, action: #selector(self.btnSelectVerbalClicked(_:)), for: .touchUpInside)
            
            cell.btnNonVerbal?.tag = indexPath.row
            cell.btnNonVerbal?.addTarget(self, action: #selector(self.btnSelectNonVerbalClicked(_:)), for: .touchUpInside)
            
            cell.btnRemove?.tag = indexPath.row
            cell.btnRemove?.addTarget(self, action: #selector(self.btnDeleteClicked(_:)), for: .touchUpInside)
            
            cell.btnAllergiesYes?.tag = indexPath.row
            cell.btnAllergiesYes?.addTarget(self, action: #selector(self.btnSelectYesAllergiesClicked(_:)), for: .touchUpInside)
            
            cell.btnAllergiesNo?.tag = indexPath.row
            cell.btnAllergiesNo?.addTarget(self, action: #selector(self.btnSelectNoAllergiesClicked(_:)), for: .touchUpInside)
            
            //cell.setInsuranceData(obj: obj)
            
            /*cell.certificateDelegate = self
            
            cell.btnUpload?.tag = indexPath.row
            cell.btnUpload?.addTarget(self, action: #selector(self.btnUploadCertificatetClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectType?.tag = indexPath.row
            cell.btnSelectType?.addTarget(self, action: #selector(self.btnSelectTypeCertificatetClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectDateExpire?.tag = indexPath.row
            cell.btnSelectDateExpire?.addTarget(self, action: #selector(self.btnDateExpireClicked(_:)), for: .touchUpInside)*/
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func btnDeleteClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            self.arrData.remove(at: btn.tag)
            self.tblData?.reloadData()
            
            self.vwNoOfReceiption?.txtInput.text = self.arrData.isEmpty ? "" : "\(self.arrData.count)"
        }
    }
    
    @objc func btnSelectYesAllergiesClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            obj.isAllergies = true
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectNoAllergiesClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            obj.isAllergies = false
            obj.allergies = ""
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectBehavioralClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            obj.lovedBehavioral = "1"
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectNonBehavioralClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            obj.lovedBehavioral = "2"
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectVerbalClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            obj.lovedVerbal = "1"
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectNonVerbalClicked(_ btn : UIButton){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            obj.lovedVerbal = "2"
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectLovedDisabilitiesClicked(_ btn : UIButton){
        //for i in stride(from: 0, to: self.arrData.count, by: 1){
        if self.arrData.count > 0 {
            let obj = self.arrData[btn.tag]
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                vc.OpenFromType = .LovedDisabilities
                vc.selectedLovedDisabilitiesIndex = btn.tag
                if !obj.lovedDisabilitiesTypeId.isEmpty {
                    let model = LovedDisabilitiesTypeModel.init(loveddisabilitiestypeId: obj.lovedDisabilitiesTypeId, Name: obj.lovedDisabilitiesTypeName)//licenceTypeModel.init(licencetypeId: obj.licenceTypeId, Name: obj.licenceName)
                    vc.selectedLovedDisabilitiesData = model
                }
            })
        }
    }
}
//MARK: - CertificateCellEndEditingDelegate
extension SignupAboutYourLoveViewController: AboutYourLovedCellEndEditingDelegate {
    func selectCategoryOther(obj: [LovedCategoryModel], cell: AboutYourLovedCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let myobj = self.arrData[indexpath.row]
                if myobj.lovedCategory.count > 0 {
                    myobj.lovedCategory = obj
                    self.tblData?.reloadData()
                }
            }
        }
    }
    
    func EndAboutEditing(text: String, cell: AboutYourLovedCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.lovedAboutDesc = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func EndAllergiesEditing(text: String, cell: AboutYourLovedCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.allergies = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func EndOtherCategoryEditing(text: String, cell: AboutYourLovedCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let obj = self.arrData[indexpath.row]
                obj.lovedOtherCategoryText = text
            }
            self.tblData?.reloadData()
        }
    }
    
    func selectCategory(index: Int, obj: LovedCategoryModel, cell: AboutYourLovedCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let myobj = self.arrData[indexpath.row]
                
                /*for i in stride(from: 0, to: myobj.lovedCategory.count, by: 1) {
                    if myobj.lovedCategory[i].lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) {
                        myobj.lovedCategory[i].isSelectCategory = false
                    }
                }*/
                
                if myobj.lovedCategory.count > 0 && index <= myobj.lovedCategory.count {
                    myobj.lovedCategory[index] = obj
                    self.tblData?.reloadData()
                }
            }
        }
    }
    
    func selectSpecialities(index: Int, obj: LovedSpecialitiesModel, cell: AboutYourLovedCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrData.count > 0 {
                let myobj = self.arrData[indexpath.row]
                if myobj.lovedSpecialities.count > 0 && index <= myobj.lovedSpecialities.count {
                    myobj.lovedSpecialities[index] = obj
                    self.tblData?.reloadData()
                }
            }
        }
    }
    
    func selectCategoryAbout(obj: LovedCategoryModel) {
        self.appNavigationController?.present(PopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.selectedLovedCategory = obj
            vc.isFromLovedAbout = true
        })
    }
}

//MARK: - Validation
extension SignupAboutYourLoveViewController: ListCommonDataDelegate {
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel,selectIndex : Int) {
        
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        
    }
    
    func selectDisabilitiesData(obj: WorkDisabilitiesWillingTypeModel) {
        
    }
    
    func selectHearAboutData(obj: HearAboutUsModel) {
        
    }
    
    func selectCertificateTypeData(obj: licenceTypeModel,selectIndex : Int) {
        
    }
    
    func selectLovedDisabilitiesData(obj: LovedDisabilitiesTypeModel,selectIndex : Int) {
        if self.arrData.count > 0 {
            let objdata = self.arrData[selectIndex]
            objdata.lovedDisabilitiesTypeId = obj.lovedDisabilitiesTypeId
            objdata.lovedDisabilitiesTypeName = obj.name
            DispatchQueue.main.async {
                self.tblData?.reloadData()
            }
        }
    }
}

// MARK: - IBAction
extension SignupAboutYourLoveViewController {
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        
        let filter = self.arrData.filter({!$0.lovedDisabilitiesTypeId.isEmpty && !$0.lovedAboutDesc.isEmpty && !($0.allergies.isEmpty && $0.isAllergies) && !($0.lovedCategory.filter({$0.isSelectCategory}).isEmpty) && !($0.lovedSpecialities.filter({$0.isSelectSpecialities}).isEmpty)})
        print(filter.count)
        var arrMain : [[String:Any]] = []
        for i in stride(from: 0, to: filter.count, by: 1) {
            let obj = filter[i]
            let dict : [String:Any] = [
                klovedDisabilitiesTypeId : obj.lovedDisabilitiesTypeId,
                klovedAboutDesc : obj.lovedAboutDesc,
                klovedOtherCategoryText : obj.lovedOtherCategoryText,
                klovedBehavioral : obj.lovedBehavioral,
                klovedVerbal : obj.lovedVerbal,
                kallergies : obj.allergies,
                klovedCategory : obj.lovedCategory.filter({$0.isSelectCategory}).map({$0.lovedCategoryId}),
                klovedSpecialities : obj.lovedSpecialities.filter({$0.isSelectSpecialities}).map({$0.lovedSpecialitiesId})
            ]
            arrMain.append(dict)
            if i == filter.count - 1 {
                self.saveAboutLovedAPICall(arr : arrMain)
            }
        }
    }
    
    private func validateFields() -> String? {
        if self.vwNoOfReceiption?.txtInput.isEmpty ?? false {
            return "Please select number of recipients needing care"
        }
        let filter = self.arrData.filter({!$0.lovedDisabilitiesTypeId.isEmpty && !$0.lovedAboutDesc.isEmpty && !($0.allergies.isEmpty && $0.isAllergies) && !($0.lovedCategory.filter({$0.isSelectCategory}).isEmpty) && !($0.lovedSpecialities.filter({$0.isSelectSpecialities}).isEmpty)})
        if filter.isEmpty {
            if let firstData = self.arrData.first{
                if firstData.lovedDisabilitiesTypeName.isEmpty{
                    return AppConstant.ValidationMessages.kDisabilityTypeEmpty
                } else if firstData.lovedAboutDesc.isEmpty{
                    return AppConstant.ValidationMessages.kEmptyAboutLoved
                } else if firstData.lovedCategory.filter({$0.isSelectCategory}).isEmpty {
                    return AppConstant.ValidationMessages.kEmptyCategoryLoved
                } else if !(firstData.lovedCategory.filter({$0.isSelectCategory == true && ($0.lovedCategoryName == XtraHelp.sharedInstance.OtherCategoryText) && (firstData.lovedOtherCategoryText.isEmpty)}).isEmpty) {
                    return AppConstant.ValidationMessages.kEmptyOtherCategoryLoved
                } else if firstData.allergies.isEmpty && firstData.isAllergies {
                    return AppConstant.ValidationMessages.kEmptyAllergiesLoved
                } else if firstData.lovedSpecialities.filter({$0.isSelectSpecialities}).isEmpty {
                    return AppConstant.ValidationMessages.kEmptyspecialities
                } else {
                    return nil
                }
            }
            return nil
        }
        return nil
    }
}

// MARK: - API Call
extension SignupAboutYourLoveViewController {
    private func getCommonDataAPICall() {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        CommonModel.getCommonData(with: param, success: { (arrHearAbout,arrlicenceType,arrInsuranceType,arrWorkSpeciality,arrWorkMethodOfTransportation,arrWorkDisabilitiesWillingType,arrLovedDisabilitiesTypeModel,arrlovedCategory,arrlovedSpecialities,message) in
            
            self.arrLovedCategory = arrlovedCategory
            self.arrLovedCategory.append(LovedCategoryModel.init(userlovedcategoryId: "", userid: "", lovedcategoryId: "", Name: XtraHelp.sharedInstance.OtherCategoryText, lovecatdescription: "", lovedcategoryname: XtraHelp.sharedInstance.OtherCategoryText, isselectcategory: false))
            self.tempArrLovedCategory = self.arrLovedCategory.copy()
            //self.tempArrLovedCategory = arrlovedCategory
            self.arrSpecialities = arrlovedSpecialities
            //self.tblData?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func saveAboutLovedAPICall(arr : [[String:Any]]) {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                klovedOne : arr,
                kprofileStatus : "3"
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.saveAboutLoved(with: param, success: { (model, msg) in
                self.appNavigationController?.push(SignupLocationViewController.self,configuration: { vc in
                    //vc.isMoveAnoherVC = false
                })
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension SignupAboutYourLoveViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignupAboutYourLoveViewController: AppNavigationControllerInteractable { }
