//
//  ListCommonDataPopupViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 18/11/21.
//

import UIKit

protocol ListCommonDataDelegate {
    func selectHearAboutData(obj : HearAboutUsModel)
    func selectCertificateTypeData(obj : licenceTypeModel,selectIndex : Int)
    func selectWorkSpecialityData(obj : WorkSpecialityModel)
    func selectInsuranceTypeData(obj : InsuranceTypeModel,selectIndex : Int)
    func selectWorkMethodTransportationData(obj : WorkMethodOfTransportationModel)
    func selectDisabilitiesData(obj : [WorkDisabilitiesWillingTypeModel])
    func selectAdditionalQuestionData(obj : [AdditionalQuestionModel],isFromModifyQuestion : Bool)
    func selectSubstituteCaregiverData(obj : CaregiverListModel)
}

enum CommonEnumFromType {
    case HearAboutUs
    case CertificateLicence
    case WorkSpeciality
    case InsuranceType
    case WorkMethodTransportation
    case Disabilities
    case AdditionalQuestion
    case SubstituteJob
}

class ListCommonDataPopupViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwDataMain: UIView?
    @IBOutlet weak var vwSubBottom: UIView?
    
    @IBOutlet weak var tblData: UITableView?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    @IBOutlet weak var btnClose: UIButton?
    @IBOutlet weak var btnCloseTouch: UIButton?
    
    @IBOutlet weak var vwSearch: SearchView?
    
    // MARK: - Variables
    var delegate : ListCommonDataDelegate?
    private var arrHearAboutData : [HearAboutUsModel] = []
    var selectedHearAboutData : HearAboutUsModel?
    
    private var arCertificateTypeData : [licenceTypeModel] = []
    var selectedCertificateTypeData : licenceTypeModel?
    var selectedCertificateTypeIndex : Int = 0
    
    private var arrWorkSpecialityData : [WorkSpecialityModel] = []
    var selectedWorkSpecialityData : WorkSpecialityModel?
    
    private var arrInsuranceTypeData : [InsuranceTypeModel] = []
    var selectedInsuranceTypeData : InsuranceTypeModel?
    
    private var arrWorkMethodTransportationData : [WorkMethodOfTransportationModel] = []
    var selectedWorkMethodTransportationData : WorkMethodOfTransportationModel?
    
    private var arrDisabilitiesData : [WorkDisabilitiesWillingTypeModel] = []
    var selectedDisabilitiesData : [WorkDisabilitiesWillingTypeModel] = []
    
    var OpenFromType : CommonEnumFromType = .HearAboutUs
    var isFromModifyAdditionalQuestionJob : Bool = false
    
    private var selectedSubstituteCargiver : CaregiverListModel?
    
    var arrAddiotinalQuestion : [AdditionalQuestionModel] = []
    
    private var arrCaregiver : [CaregiverListModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    private var isSearchAPICall : Bool = false
    private var isSearchClick : Bool = false
    
    var isFromChatDetailCaregiverShare : Bool = false
    
    var appnav : UINavigationController?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.vwSub?.clipsToBounds = true
        self.vwSub?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 0, height: 0), opacity: 1)
        self.vwSub?.maskToBounds = false
    }
}

// MARK: - Init Configure
extension ListCommonDataPopupViewController {
    private func InitConfig(){
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.tblData?.register(CommonListCell.self)
        self.tblData?.register(FeedLikeCell.self)
        self.tblData?.register(AdditionalQuestionsCell.self)
        self.tblData?.estimatedRowHeight = 60.0
        self.tblData?.rowHeight = UITableView.automaticDimension
        self.tblData?.delegate = self
        self.tblData?.dataSource = self
        
        //delay(seconds: 0.2) {
        self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        //}
        self.vwSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        self.vwSubBottom?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        switch self.OpenFromType {
        case .HearAboutUs:
            self.lblHeader?.text = "How did you hear about us?"
            self.getCommonDataAPICall()
        case .CertificateLicence:
            self.lblHeader?.text = "Certifications/License Type"
            self.getCommonDataAPICall()
        case .WorkSpeciality:
            self.lblHeader?.text = "Work Speciality"
            self.getCommonDataAPICall()
        case .InsuranceType:
            self.lblHeader?.text = "Insurance Type"
            self.getCommonDataAPICall()
        case .WorkMethodTransportation:
            self.lblHeader?.text = "Method of Transportation"
            self.getCommonDataAPICall()
        case .Disabilities:
            self.lblHeader?.text = "Types of disabilities caregiver is willing to work"
            self.getCommonDataAPICall()
        case .AdditionalQuestion:
            self.lblHeader?.text = self.isFromModifyAdditionalQuestionJob ? "Modify Answers" : "Additional Questions"
            self.btnSubmit?.setTitle(self.isFromModifyAdditionalQuestionJob ? "Submit" : "Submit & Apply", for: .normal)
        case .SubstituteJob:
            
            self.lblHeader?.text = self.isFromChatDetailCaregiverShare ? "Suggest Caregiver" : "Substitute Caregiver"
            self.vwSearch?.isHidden = false
            self.vwSearch?.txtSearch?.delegate = self
            self.vwSearch?.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
            self.btnSubmit?.setTitle(self.isFromChatDetailCaregiverShare ? "Send" : "Submit", for: .normal)
            self.setupESInfiniteScrollinWithTableView()
            self.getCaregiverList()
        }
        
    }
}

//MARK: - Pagination tableview Mthonthd
extension ListCommonDataPopupViewController {
    
    private func reloadCaregiverData(){
        self.view.endEditing(true)
        //self.reloadFeedData()
        self.pageNo = 1
        self.arrCaregiver.removeAll()
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
            self.reloadCaregiverData()
        }
        
        tblData?.es.addInfiniteScrolling {
            
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

//MARK: - TextField Delegate
extension ListCommonDataPopupViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.vwSearch?.txtSearch == textField {
            if textField.returnKeyType == .search {
                self.isSearchClick = true
                self.isSearchAPICall = false
                self.vwSearch?.txtSearch?.text = textField.text ?? ""
                self.reloadCaregiverData()
            }
        }
        return true
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        if textField.text == "" || textField.isEmpty {
            self.isSearchClick = false
            self.isSearchAPICall = false
            textField.resignFirstResponder()
            self.reloadCaregiverData()
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
                            self.reloadCaregiverData()
                        }
                    }
                }
            }
        }
    }
}

//MARK:- UITableView Delegate
extension ListCommonDataPopupViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.OpenFromType {
        case .HearAboutUs:
            return self.arrHearAboutData.count
        case .CertificateLicence:
            return self.arCertificateTypeData.count
        case .WorkSpeciality:
            return self.arrWorkSpecialityData.count
        case .InsuranceType:
            return self.arrInsuranceTypeData.count
        case .WorkMethodTransportation:
            return self.arrWorkMethodTransportationData.count
        case .Disabilities:
            return self.arrDisabilitiesData.count
        case .AdditionalQuestion:
            return self.arrAddiotinalQuestion.count
        case .SubstituteJob:
            return self.arrCaregiver.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: CommonListCell.self)
        switch self.OpenFromType {
        case .HearAboutUs:
            if self.arrHearAboutData.count > 0 {
                let obj = self.arrHearAboutData[indexPath.row]
                cell.lblName?.text = obj.name
                if let data = self.selectedHearAboutData {
                    cell.btnSelect?.isSelected = (data.hearAboutUsId == obj.hearAboutUsId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectHearAboutClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .CertificateLicence:
            if self.arCertificateTypeData.count > 0 {
                let obj = self.arCertificateTypeData[indexPath.row]
                cell.lblName?.text = obj.name
                if let data = self.selectedCertificateTypeData {
                    cell.btnSelect?.isSelected = (data.licenceTypeId == obj.licenceTypeId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCertificateTypeClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .WorkSpeciality:
            if self.arrWorkSpecialityData.count > 0 {
                let obj = self.arrWorkSpecialityData[indexPath.row]
                cell.lblName?.text = obj.name
                if let data = self.selectedWorkSpecialityData {
                    cell.btnSelect?.isSelected = (data.workSpecialityId == obj.workSpecialityId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectWorkSpecialityClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .InsuranceType:
            if self.arrInsuranceTypeData.count > 0 {
                let obj = self.arrInsuranceTypeData[indexPath.row]
                cell.lblName?.text = obj.name
                if let data = self.selectedInsuranceTypeData {
                    cell.btnSelect?.isSelected = (data.insuranceTypeId == obj.insuranceTypeId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectInsuranceTypeClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .WorkMethodTransportation:
            if self.arrWorkMethodTransportationData.count > 0 {
                let obj = self.arrWorkMethodTransportationData[indexPath.row]
                cell.lblName?.text = obj.name
                if let data = self.selectedWorkMethodTransportationData {
                    cell.btnSelect?.isSelected = (data.workMethodOfTransportationId == obj.workMethodOfTransportationId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectWorkMethodTransportationClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .Disabilities:
            if self.arrDisabilitiesData.count > 0 {
                let obj = self.arrDisabilitiesData[indexPath.row]
                cell.lblName?.text = obj.name
                //if let data = self.selectedDisabilitiesData {
                    //cell.btnSelect?.isSelected = (data.workDisabilitiesWillingTypeId == obj.workDisabilitiesWillingTypeId)
                //} else {
                cell.btnSelect?.isSelected = obj.isSelectDisabilitiesWilling
               // }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectDisabilitiesClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .AdditionalQuestion:
            let cell = tableView.dequeueReusableCell(for: indexPath, with: AdditionalQuestionsCell.self)
            if self.arrAddiotinalQuestion.count > 0 {
                let obj = self.arrAddiotinalQuestion[indexPath.row]
                cell.lblQuestion?.text = obj.question
                cell.lblQuestionNumber?.text = "Question \(indexPath.row + 1)"
                cell.vwAnswer?.txtInput?.text = obj.answer
                cell.delegate = self
                
                cell.layoutIfNeeded()
            }
            return cell
        case .SubstituteJob:
            let cell = tableView.dequeueReusableCell(for: indexPath, with: FeedLikeCell.self)
            cell.isFromSubstituteJob = true
            if self.arrCaregiver.count > 0 {
                let obj = self.arrCaregiver[indexPath.row]
                cell.lblUsername?.text = "\(obj.firstName) \(obj.lastName)"
                cell.imgProfilemage?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                if let data = self.selectedSubstituteCargiver {
                    cell.btnSelect?.isSelected = obj.id == data.id
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnProfile?.isUserInteractionEnabled = true
                cell.btnProfile?.isHidden = false
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectSubstituteCargiverClicked(_:)), for: .touchUpInside)
                
                cell.btnProfile?.tag = indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(self.btnProfileCargiverClicked(_:)), for: .touchUpInside)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnProfileCargiverClicked(_ btn : UIButton){
        if self.arrCaregiver.count > 0 {
            let obj = self.arrCaregiver[btn.tag]
            
            /*let nav = UINavigationController(rootViewController: self)
            UIApplication.shared.keyWindow?.rootViewController = nav
            nav.push(CaregiverProfileViewController.self,configuration: { vc in
                vc.selectedCaregiverID = obj.id
            })*/
            
            /*self.presentingViewController?.navigationController?.push(CaregiverProfileViewController.self,configuration: { vc in
                vc.selectedCaregiverID = obj.id
            })*/
            
            self.appnav?.push(CaregiverProfileViewController.self,configuration: { vc in
                vc.selectedCaregiverID = obj.id
                vc.isfromSubstitude = true
                vc.appnav = self.appnav
            })
            /*self.appNavigationController?.present(CaregiverProfileViewController.self,configuration: { vc in
                vc.selectedCaregiverID = obj.id
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
            })*/
        }
    }
    
    @objc func btnSelectSubstituteCargiverClicked(_ btn : UIButton){
        if self.arrCaregiver.count > 0 {
            let obj = self.arrCaregiver[btn.tag]
            self.selectedSubstituteCargiver = obj
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectHearAboutClicked(_ btn : UIButton){
        if self.arrHearAboutData.count > 0 {
            let obj = self.arrHearAboutData[btn.tag]
            self.selectedHearAboutData = obj
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectCertificateTypeClicked(_ btn : UIButton){
        if self.arCertificateTypeData.count > 0 {
            let obj = self.arCertificateTypeData[btn.tag]
            self.selectedCertificateTypeData = obj
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectWorkSpecialityClicked(_ btn : UIButton){
        if self.arrWorkSpecialityData.count > 0 {
            let obj = self.arrWorkSpecialityData[btn.tag]
            self.selectedWorkSpecialityData = obj
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectInsuranceTypeClicked(_ btn : UIButton){
        if self.arrInsuranceTypeData.count > 0 {
            let obj = self.arrInsuranceTypeData[btn.tag]
            self.selectedInsuranceTypeData = obj
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectWorkMethodTransportationClicked(_ btn : UIButton){
        if self.arrWorkMethodTransportationData.count > 0 {
            let obj = self.arrWorkMethodTransportationData[btn.tag]
            self.selectedWorkMethodTransportationData = obj
            self.tblData?.reloadData()
        }
    }
    
    @objc func btnSelectDisabilitiesClicked(_ btn : UIButton){
        if self.arrDisabilitiesData.count > 0 {
            let obj = self.arrDisabilitiesData[btn.tag]
            //self.selectedDisabilitiesData = obj
            obj.isSelectDisabilitiesWilling = !obj.isSelectDisabilitiesWilling
            self.tblData?.reloadData()
        }
    }
}

// MARK: - IBAction
extension ListCommonDataPopupViewController : JobAddAdditionQuestionCellEndEditingDelegate {
    
    func EndQuestionEditing(text: String, cell: AdditionalQuestionsCell) {
        if let indexpath = self.tblData?.indexPath(for: cell) {
            if self.arrAddiotinalQuestion.count > 0 {
                self.arrAddiotinalQuestion[indexpath.row].answer = text
                DispatchQueue.main.async {
                    self.tblData?.reloadData()
                }
                //self.tblData?.reloadData()
            }
        }
    }
}

// MARK: - IBAction
extension ListCommonDataPopupViewController {
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
       
        switch self.OpenFromType {
        case .HearAboutUs:
            if let data = self.selectedHearAboutData {
                self.dismiss(animated: true) {
                    self.delegate?.selectHearAboutData(obj: data)
                }
            }
        case .CertificateLicence:
            if let data = self.selectedCertificateTypeData {
                self.dismiss(animated: true) {
                    self.delegate?.selectCertificateTypeData(obj: data, selectIndex: self.selectedCertificateTypeIndex)
                }
            }
        case .WorkSpeciality:
            if let data = self.selectedWorkSpecialityData {
                self.dismiss(animated: true) {
                    self.delegate?.selectWorkSpecialityData(obj: data)
                }
            }
        case .InsuranceType:
            if let data = self.selectedInsuranceTypeData {
                self.dismiss(animated: true) {
                    self.delegate?.selectInsuranceTypeData(obj: data, selectIndex: self.selectedCertificateTypeIndex)
                }
            }
        case .WorkMethodTransportation:
            if let data = self.selectedWorkMethodTransportationData {
                self.dismiss(animated: true) {
                    self.delegate?.selectWorkMethodTransportationData(obj: data)
                }
            }
        case .Disabilities:
            let filter = self.arrDisabilitiesData.filter({$0.isSelectDisabilitiesWilling})
            if filter.count > 0 {
                self.dismiss(animated: true) {
                    self.delegate?.selectDisabilitiesData(obj: filter)
                }
            } else {
                self.showMessage(AppConstant.ValidationMessages.kEmptyTypesofdisabilitiescaregiveriswillingtowork,presentationStyle: .top)
            }
        case .AdditionalQuestion:
            self.view.endEditing(true)
            /*let filter = self.arrAddiotinalQuestion.filter({!$0.answer.isEmpty})
            if filter.count == self.arrAddiotinalQuestion.count {
                self.dismiss(animated: true) {
                    //if !self.isFromModifyAdditionalQuestionJob {
                        self.delegate?.selectAdditionalQuestionData(obj: filter, isFromModifyQuestion: self.isFromModifyAdditionalQuestionJob)
                   // }
                }
            } else {
                self.showMessage(AppConstant.ValidationMessages.kEmptyAdditionalQuestionAnswer,presentationStyle: .top)
            }*/
            /*self.dismiss(animated: true) {
                if !self.isFromModifyAdditionalQuestionJob {
                    self.appNavigationController?.push(JobSuccessViewController.self)
                }
            }*/
            self.dismiss(animated: true) {
                self.delegate?.selectAdditionalQuestionData(obj: self.arrAddiotinalQuestion, isFromModifyQuestion: self.isFromModifyAdditionalQuestionJob)
            }
        case .SubstituteJob:
            if let data = self.selectedSubstituteCargiver {
                self.dismiss(animated: true) {
                    self.delegate?.selectSubstituteCaregiverData(obj: data)
                }
            } else {
                self.showMessage("Please select substitute caregiver",presentationStyle: .top)
            }
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ListCommonDataPopupViewController {
    private func getCommonDataAPICall() {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        CommonModel.getCommonData(with: param, success: { (arrhearAboutUs,arrlicenceType,arrInsuranceType,arrWorkSpeciality,arrWorkMethodOfTransportation,arrWorkDisabilitiesWillingType,message) in
            switch self.OpenFromType {
            case .HearAboutUs:
                self.arrHearAboutData = arrhearAboutUs
            case .CertificateLicence:
                self.arCertificateTypeData = arrlicenceType
            case .WorkSpeciality:
                self.arrWorkSpecialityData = arrWorkSpeciality
            case .InsuranceType:
                self.arrInsuranceTypeData = arrInsuranceType
            case .WorkMethodTransportation:
                self.arrWorkMethodTransportationData = arrWorkMethodOfTransportation
            case .Disabilities:
                self.arrDisabilitiesData = arrWorkDisabilitiesWillingType
                //let selctedDisabilityId : [String] = self.selectedDisabilitiesData.map({$0.workDisabilitiesWillingTypeId})
                for i in stride(from: 0, to: self.arrDisabilitiesData.count, by: 1) {
                    let obj = self.arrDisabilitiesData[i]
                    if self.selectedDisabilitiesData.contains(where: {obj.workDisabilitiesWillingTypeId == $0.workDisabilitiesWillingTypeId}) {
                        obj.isSelectDisabilitiesWilling = true
                    }
                }
            case .AdditionalQuestion:
                break
            case .SubstituteJob:
                break
            }
            self.tblData?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func getCaregiverList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "20",
                ksearch : self.vwSearch?.txtSearch?.text ?? ""
                
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CaregiverListModel.getCaregiverList(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage,msg) in
                
                self.tblData?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrCaregiver.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = !self.arrCaregiver.isEmpty
                self.tblData?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblData?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                //if statuscode == APIStatusCode.NoRecord.rawValue {
                self.lblNoData?.isHidden = !self.arrCaregiver.isEmpty
                    self.lblNoData?.text = error
                    self.tblData?.reloadData()
                //} else {
                    //if !error.isEmpty {
                       // self.showMessage(error, themeStyle: .error)
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                    //}
                //}
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension ListCommonDataPopupViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension ListCommonDataPopupViewController: AppNavigationControllerInteractable { }
