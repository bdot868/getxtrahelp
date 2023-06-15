//
//  ListCommonDataPopupViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

protocol ListCommonDataDelegate {
    func selectHearAboutData(obj : HearAboutUsModel)
    func selectCertificateTypeData(obj : licenceTypeModel,selectIndex : Int)
    func selectWorkSpecialityData(obj : WorkSpecialityModel)
    func selectInsuranceTypeData(obj : InsuranceTypeModel,selectIndex : Int)
    func selectWorkMethodTransportationData(obj : WorkMethodOfTransportationModel)
    func selectDisabilitiesData(obj : WorkDisabilitiesWillingTypeModel)
    func selectLovedDisabilitiesData(obj : LovedDisabilitiesTypeModel,selectIndex : Int)
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
    case LovedDisabilities
    case ShowQuestionAnswerCareGiver
}

class ListCommonDataPopupViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwDataMain: UIView?
    @IBOutlet weak var vwSubBottom: UIView?
    @IBOutlet weak var vwButtomBottom: UIView?
    
    @IBOutlet weak var tblData: UITableView?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    @IBOutlet weak var btnClose: UIButton?
    @IBOutlet weak var btnCloseTouch: UIButton?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
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
    var selectedDisabilitiesData : WorkDisabilitiesWillingTypeModel?
    
    private var arrLovedDisabilitiesData : [LovedDisabilitiesTypeModel] = []
    var selectedLovedDisabilitiesData : LovedDisabilitiesTypeModel?
    var selectedLovedDisabilitiesIndex : Int = 0
    
    var OpenFromType : CommonEnumFromType = .HearAboutUs
    var isFromModifyAdditionalQuestionJob : Bool = false
    
    var selecetdApplicant : JobApplicantsModel?
    private var arrApplicantQuetionAnswerData : [AdditionalQuestionModel] = []
    
    private var selectedSubstituteCargiverIndex : Int?
    
    
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
            self.lblHeader?.text = "Certifications/Licenses Type"
            self.getCommonDataAPICall()
        case .WorkSpeciality:
            self.lblHeader?.text = "Work Speciality"
            self.getCommonDataAPICall()
        case .InsuranceType:
            self.lblHeader?.text = "Insurance Type"
            self.getCommonDataAPICall()
        case .WorkMethodTransportation:
            self.lblHeader?.text = "Work Method of Transportation"
            self.getCommonDataAPICall()
        case .Disabilities:
            self.lblHeader?.text = "Types of disabilities caregiver is willing to work"
            self.getCommonDataAPICall()
        case .AdditionalQuestion:
            self.lblHeader?.text = self.isFromModifyAdditionalQuestionJob ? "Modify Answers" : "Additional Questions"
            self.btnSubmit?.setTitle(self.isFromModifyAdditionalQuestionJob ? "Submit" : "Submit & Apply", for: .normal)
        case .SubstituteJob:
            self.lblHeader?.text = "Substitute Caregiver"
            self.btnSubmit?.setTitle("Submit", for: .normal)
        case .LovedDisabilities:
            self.lblHeader?.text = "Types of disabilities your loved one"
            self.btnSubmit?.setTitle("Submit", for: .normal)
            self.getCommonDataAPICall()
        case .ShowQuestionAnswerCareGiver:
            if let obj = self.selecetdApplicant {
                self.lblHeader?.text = "\(obj.userFullName)"
            }
            self.vwButtomBottom?.isHidden = true
            self.applicantApplyJobQueAnsList()
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
            return 3
        case .SubstituteJob:
            return 10
        case .LovedDisabilities:
            return self.arrLovedDisabilitiesData.count
        case .ShowQuestionAnswerCareGiver:
            return self.arrApplicantQuetionAnswerData.count
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
                if let data = self.selectedDisabilitiesData {
                    cell.btnSelect?.isSelected = (data.workDisabilitiesWillingTypeId == obj.workDisabilitiesWillingTypeId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectDisabilitiesClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .AdditionalQuestion:
            let cell = tableView.dequeueReusableCell(for: indexPath, with: AdditionalQuestionsCell.self)
            return cell
        case .SubstituteJob:
            let cell = tableView.dequeueReusableCell(for: indexPath, with: FeedLikeCell.self)
            cell.isFromSubstituteJob = true
            if let data = self.selectedSubstituteCargiverIndex {
                cell.btnSelect?.isSelected = (indexPath.row == data)
            } else {
                cell.btnSelect?.isSelected = false
            }
            
            cell.btnSelectMain?.tag = indexPath.row
            cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectSubstituteCargiverClicked(_:)), for: .touchUpInside)
            return cell
        case .LovedDisabilities:
            if self.arrLovedDisabilitiesData.count > 0 {
                let obj = self.arrLovedDisabilitiesData[indexPath.row]
                cell.lblName?.text = obj.name
                if let data = self.selectedLovedDisabilitiesData {
                    cell.btnSelect?.isSelected = (data.lovedDisabilitiesTypeId == obj.lovedDisabilitiesTypeId)
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMain?.tag = indexPath.row
                cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectLovedDisabilitiesClicked(_:)), for: .touchUpInside)
            }
            return cell
        case .ShowQuestionAnswerCareGiver:
            let cell = tableView.dequeueReusableCell(for: indexPath, with: AdditionalQuestionsCell.self)
            cell.isFromJobApplicant = true
            if self.arrApplicantQuetionAnswerData.count > 0 {
                let obj = self.arrApplicantQuetionAnswerData[indexPath.row]
                cell.setApplicantQuesAnsData(obj: obj)
                cell.lblQuestionNumber?.text = "Question \(indexPath.row + 1)"
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnSelectSubstituteCargiverClicked(_ btn : UIButton){
        self.selectedSubstituteCargiverIndex = btn.tag
        self.tblData?.reloadData()
    }
    
    @objc func btnSelectLovedDisabilitiesClicked(_ btn : UIButton){
        if self.arrLovedDisabilitiesData.count > 0 {
            let obj = self.arrLovedDisabilitiesData[btn.tag]
            self.selectedLovedDisabilitiesData = obj
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
            self.selectedDisabilitiesData = obj
            self.tblData?.reloadData()
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
            if let data = self.selectedDisabilitiesData {
                self.dismiss(animated: true) {
                    self.delegate?.selectDisabilitiesData(obj: data)
                }
            }
        case .AdditionalQuestion:
            self.dismiss(animated: true) {
                if !self.isFromModifyAdditionalQuestionJob {
                   // self.appNavigationController?.push(JobSuccessViewController.self)
                }
            }
        case .SubstituteJob:
            self.dismiss(animated: true) {
            }
        case .LovedDisabilities:
            if let data = self.selectedLovedDisabilitiesData {
                self.dismiss(animated: true) {
                    self.delegate?.selectLovedDisabilitiesData(obj: data, selectIndex: self.selectedLovedDisabilitiesIndex)
                }
            }
        case .ShowQuestionAnswerCareGiver:
            break
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
        
        CommonModel.getCommonData(with: param, success: { (arrHearAbout,arrlicenceType,arrInsuranceType,arrWorkSpeciality,arrWorkMethodOfTransportation,arrWorkDisabilitiesWillingType,arrLovedDisabilitiesTypeModel,arrlovedCategory,arrlovedSpecialities,message) in
            switch self.OpenFromType {
            case .HearAboutUs:
                self.arrHearAboutData = arrHearAbout
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
            case .AdditionalQuestion:
                break
            case .SubstituteJob:
                break
            case .LovedDisabilities:
                self.arrLovedDisabilitiesData = arrLovedDisabilitiesTypeModel
            case .ShowQuestionAnswerCareGiver:
                break
            }
            self.tblData?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func applicantApplyJobQueAnsList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault(), let obj = self.selecetdApplicant {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserId : obj.userId,
                kjobId : obj.jobId
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            AdditionalQuestionModel.applicantApplyJobQueAnsList(with: param,isShowLoader: isshowloader,  success: { (arr,totalpage) in
    
                self.arrApplicantQuetionAnswerData = arr
                self.lblNoData?.isHidden = self.arrApplicantQuetionAnswerData.count == 0 ? false : true
                self.tblData?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.lblNoData?.isHidden = !self.arrApplicantQuetionAnswerData.isEmpty
                self.lblNoData?.text = error
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
