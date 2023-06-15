//
//  JobDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class JobDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTopHeader: UILabel?
    @IBOutlet weak var lblJobName: UILabel?
    @IBOutlet weak var lblJobRemaningTime: UILabel?
    @IBOutlet weak var lblDateTimeValue: UILabel?
    @IBOutlet weak var lblCategoryValue: UILabel?
    @IBOutlet weak var lblTypeValue: UILabel?
    @IBOutlet weak var lblMilesCountValue: UILabel?
    @IBOutlet weak var lblJobPrice: UILabel?
    @IBOutlet weak var lblJobDesc: UILabel?
    
    @IBOutlet var lblHeader: [UILabel]?
    
    @IBOutlet weak var vwProfileLeftMain: UIView?
    @IBOutlet weak var vwProfileLeft: UIView?
    @IBOutlet weak var vwProfileRightMain: UIView?
    @IBOutlet weak var vwProfileRight: UIView?
    @IBOutlet weak var imgProfileLeft: UIImageView?
    @IBOutlet weak var imgProfileRight: UIImageView?
    
    @IBOutlet weak var cvPhotoVideo: UICollectionView?
    
    @IBOutlet weak var vwApplicant: UIView?
    @IBOutlet weak var cvApplicant: UICollectionView?
    @IBOutlet weak var lblApplicantHeader: UILabel?
    @IBOutlet weak var btnAllApplicant: UIButton?
    
    //PersonalDetail
    @IBOutlet weak var vwJobDataMain: UIView?
    @IBOutlet weak var vwJobDataSub: UIView?
    @IBOutlet weak var vwJobCategory: UIView?
    @IBOutlet weak var vwJobType: UIView?
    @IBOutlet weak var vwJobCategoryMain: UIView?
    @IBOutlet weak var vwJobTypeMain: UIView?
    
    @IBOutlet weak var vwJobMileSub: UIView?
    @IBOutlet weak var vwJobMileMain: UIView?
    @IBOutlet weak var vwJobDetailMain: UIView?
    
    @IBOutlet weak var tblPreferences: UITableView?
    @IBOutlet weak var constraintTblPreferencesHeight: NSLayoutConstraint?
    @IBOutlet weak var tblAdditionalQuestions: UITableView?
    @IBOutlet weak var constraintTblAdditionalQuestionsHeight: NSLayoutConstraint?
    
    @IBOutlet weak var btnBack: UIView?
    @IBOutlet weak var btnChat: UIView?
    
    @IBOutlet weak var stackPhotoVideoMain: UIStackView?
    @IBOutlet weak var stackPreferencesMain: UIStackView?
    @IBOutlet weak var stackAdditionalQuestionsMain: UIStackView?
    
    //Bottom
    @IBOutlet weak var btnApply: UIButton?
    @IBOutlet weak var vwBottomBtn: UIView?
    
    //Location
    @IBOutlet weak var vwLocationMain: UIView?
    @IBOutlet weak var vwMap: GMSMapView?
    
    @IBOutlet weak var stackJobComplated: UIStackView?
    @IBOutlet weak var lblJobComplated: UILabel?
    
    //Rating
    @IBOutlet weak var vwRatingMain: UIView?
    @IBOutlet weak var lblRatingHeader: UILabel?
    @IBOutlet weak var btnRatingDispute: UIButton?
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var lblRatingDesc: UILabel?
    
    //StartCAneclJob
    @IBOutlet weak var vwBottomJobCancelStartMain: UIView?
    @IBOutlet weak var vwJobCancelMain: UIView?
    @IBOutlet weak var vwJobStartMain: UIView?
    @IBOutlet weak var lblJobCancel: UILabel?
    @IBOutlet weak var lblJobStart: UILabel?
    
    //Request ImageVideo
    @IBOutlet weak var cvRequestPhotoVideo: UICollectionView?
    @IBOutlet weak var stackRequestPhotoVideo: UIStackView?
    @IBOutlet weak var vwRequestPhotoVideoCVMain: UIView?
    @IBOutlet weak var lbRequestPhotoVideoHeader: UILabel?
    @IBOutlet weak var btnRequestPhotoVideo: UIButton?
    
    // MARK: - Variables
    //private var arrCategory : [String] = ["Catagory Name","Catagory Name"]
   // private var arrSpeciality : [String] = ["Specialities","Specialities"]
    var selecetdTab : SegmentJobTabEnum = .Upcoming
    
    var selectedJobID : String = ""
    private var selectedJobData : JobModel?
    private var arrPhotoVideo : [AddPhotoVideoModel] = []
    private var arrRequestUploadedPhotoVideo : [AddPhotoVideoModel] = []
    private var arrAddiotinalQuestion : [AdditionalQuestionModel] = []
    private var arrApplicant : [JobApplicantsModel] = []
    
    private let alertPicker = CustomeNavigateAlert()
    
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.addTableviewOberver()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        /*delay(seconds: 0.2) {
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude)
            }
        }*/
        if XtraHelp.sharedInstance.isCallJobDetailReloadData {
            XtraHelp.sharedInstance.isCallJobDetailReloadData = false
            self.GetMyPostedJobDetailAPICall()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        [self.vwProfileLeft,self.vwProfileRight,self.imgProfileLeft,self.imgProfileRight].forEach({
            $0?.roundedCornerRadius()
        })
        
        self.vwJobDataMain?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        self.vwJobDetailMain?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        
        if let btn = self.btnApply {
            btn.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: btn.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            btn.roundCorners(corners: [.topLeft,.topRight], radius: btn.frame.height)
        }
        
        [self.vwJobCancelMain].forEach({
            $0?.roundCorners(corners: [.topRight], radius: ($0?.frame.width ?? 0.0)/2.0)
        })
        
        if let vw = self.vwJobStartMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            vw.roundCorners(corners: [.topLeft], radius: vw.frame.width / 2)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }

}

// MARK: - Init Configure
extension JobDetailViewController {
    
    private func InitConfig(){
        
        self.alertPicker.viewController = self
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        self.lblTopHeader?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.lblJobName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        self.lblJobName?.textColor = UIColor.CustomColor.whitecolor
        
        self.lblApplicantHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        self.lblApplicantHeader?.textColor = UIColor.CustomColor.whitecolor
        
        self.btnAllApplicant?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        self.btnAllApplicant?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.btnRequestPhotoVideo?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        self.btnRequestPhotoVideo?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.lblJobRemaningTime?.textColor = UIColor.CustomColor.jobRemainingColor
        self.lblJobRemaningTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblDateTimeValue?.textColor = UIColor.CustomColor.appColor
        self.lblDateTimeValue?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 10.0))
        
        self.lblJobDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblJobDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        
        self.lblMilesCountValue?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblMilesCountValue?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblJobPrice?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 25.0))
        self.lblJobPrice?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.lblJobComplated?.textColor = UIColor.CustomColor.ticketStausColor
        self.lblJobComplated?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblRatingHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        self.lblRatingHeader?.textColor = UIColor.CustomColor.whitecolor
        
        self.lblRatingDesc?.textColor = UIColor.CustomColor.whitecolor
        self.lblRatingDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwJobMileSub?.backgroundColor = UIColor.CustomColor.priceColor17
        self.vwJobMileSub?.cornerRadius = 5.0
        
        self.cvPhotoVideo?.delegate = self
        self.cvPhotoVideo?.dataSource = self
        self.cvPhotoVideo?.register(PhotoVideoCollectionCell.self)
        
        self.cvRequestPhotoVideo?.delegate = self
        self.cvRequestPhotoVideo?.dataSource = self
        self.cvRequestPhotoVideo?.register(PhotoVideoCollectionCell.self)
        
        if let cvapplicant = self.cvApplicant {
            cvapplicant.register(NearestCarGiverCollectionCell.self)
            cvapplicant.dataSource = self
            cvapplicant.delegate = self
        }
        
        self.lblHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.vwJobCategory,self.vwJobType].forEach({
            $0?.backgroundColor = UIColor.CustomColor.appColor
            $0?.cornerRadius = 10.0
        })
        
        [self.lblCategoryValue,self.lblTypeValue].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size:10.0))
        })
        
        [self.lblJobCancel,self.lblJobStart].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size:15.0))
        })
        
        self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        
        self.btnApply?.setTitleColor(UIColor.CustomColor.whitecolor, for: .normal)
        self.btnApply?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        
        self.btnRatingDispute?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        self.btnRatingDispute?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        
        self.vwJobDataMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        self.vwJobDetailMain?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        self.vwJobDataSub?.backgroundColor = UIColor.CustomColor.whitecolor
        self.vwJobDataSub?.cornerRadius = 20.0
        
        self.vwLocationMain?.cornerRadius = 20.0
        self.vwMap?.cornerRadius = 20.0
       
        self.tblPreferences?.register(PreferencesCell.self)
        self.tblAdditionalQuestions?.register(AdditionalQuestionsCell.self)
        
        [self.tblPreferences,self.tblAdditionalQuestions].forEach({
            $0?.estimatedRowHeight = 100.0
            $0?.rowHeight = UITableView.automaticDimension
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        switch self.selecetdTab {
        case .Posted:
            self.vwLocationMain?.isHidden = true
            self.vwBottomBtn?.isHidden = true
            //self.vwLocationMain?.isHidden = true
            self.vwBottomJobCancelStartMain?.isHidden = false
            
            self.lblJobCancel?.text = "Cancel Job"
            self.lblJobStart?.text = "Modify Answers"
            self.vwApplicant?.isHidden = false
            self.vwLocationMain?.isHidden = false
            self.vwJobStartMain?.isHidden = true
            break
        case .Completed:
            self.vwLocationMain?.isHidden = true
            self.vwProfileRightMain?.isHidden = true
            self.vwProfileLeftMain?.isHidden = false
            self.lblTopHeader?.textAlignment = .left
            self.btnChat?.isHidden = true
            self.stackJobComplated?.isHidden = false
            self.lblJobRemaningTime?.isHidden = true
            self.vwRatingMain?.isHidden = false
            self.vwBottomBtn?.isHidden = true
            self.vwBottomJobCancelStartMain?.isHidden = true
            
            break
        case .Upcoming:
            self.vwLocationMain?.isHidden = false
            self.vwProfileRightMain?.isHidden = true
            self.vwProfileLeftMain?.isHidden = false
            self.lblTopHeader?.textAlignment = .left
            self.btnChat?.isHidden = false
            self.vwLocationMain?.isHidden = false
            self.vwBottomBtn?.isHidden = true
            self.vwBottomJobCancelStartMain?.isHidden = false
            
            self.lblJobCancel?.text = "Cancel"
            self.lblJobStart?.text = "Add Hours"
            
            break
        case .Substitute:
            break
        }
        
        self.vwRating?.rating = 0
        
        self.GetMyPostedJobDetailAPICall()
    }
    
    private func setMapMarker(selLat : Double,selLong : Double,isUpdateValue : Bool = true){
        let coordinate = CLLocationCoordinate2D(latitude: selLat, longitude: selLong)
        self.vwMap?.clear()
        self.vwMap?.camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: 16.0)
        let marker: GMSMarker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "ic_pin_location")
        marker.position = coordinate
        marker.map = self.vwMap
    }
    
}

//MARK: - Tableview Observer
extension JobDetailViewController {
    
    private func addTableviewOberver() {
        self.tblPreferences?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblAdditionalQuestions?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblPreferences?.observationInfo != nil {
            self.tblPreferences?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.tblAdditionalQuestions?.observationInfo != nil {
            self.tblAdditionalQuestions?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblPreferences && keyPath == ObserverName.kcontentSize {
                self.constraintTblPreferencesHeight?.constant = self.tblPreferences?.contentSize.height ?? 0.0
                self.tblPreferences?.layoutIfNeeded()
            }
            if obj == self.tblAdditionalQuestions && keyPath == ObserverName.kcontentSize {
                self.constraintTblAdditionalQuestionsHeight?.constant = self.tblAdditionalQuestions?.contentSize.height ?? 0.0
                self.tblAdditionalQuestions?.layoutIfNeeded()
            }
        }
    }
}

//MARK:- UITableView Delegate
extension JobDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblAdditionalQuestions {
            return self.arrAddiotinalQuestion.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblAdditionalQuestions {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: AdditionalQuestionsCell.self)
            cell.isFromJobDetail = true
            if self.arrAddiotinalQuestion.count > 0 {
                let obj = self.arrAddiotinalQuestion[indexPath.row]
                cell.lblQuestionNumber?.text = "Question \(indexPath.row + 1)"
                cell.lblQuestion?.text = obj.question
                if !obj.answer.isEmpty {
                    cell.stackAnswerMain?.isHidden = false
                    cell.vwSeprator?.isHidden = true
                    cell.lblAnswer?.text = obj.answer
                } else {
                    cell.stackAnswerMain?.isHidden = true
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, with: PreferencesCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension JobDetailViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvApplicant {
            return self.arrApplicant.count
        } else if collectionView == self.cvRequestPhotoVideo {
            return self.arrRequestUploadedPhotoVideo.count
        }
        return self.arrPhotoVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvApplicant {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NearestCarGiverCollectionCell.self)
            cell.isFromJobDetail = true
            if self.arrApplicant.count > 0 {
                cell.setJobApplicantData(obj: self.arrApplicant[indexPath.row])
            }
            return cell
        } else if collectionView == self.cvRequestPhotoVideo {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoVideoCollectionCell.self)
            //cell.imgVideo?.isHidden = (indexPath.row == 0) || (indexPath.row == 4) || (indexPath.row == 5)
            if self.arrRequestUploadedPhotoVideo.count > 0 {
                let obj = self.arrRequestUploadedPhotoVideo[indexPath.row]
                cell.imgVideo?.isHidden = !obj.isVideo
                cell.imgPhoto?.setImage(withUrl: obj.isVideo ? obj.videoImage : obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoVideoCollectionCell.self)
        //cell.imgVideo?.isHidden = (indexPath.row == 0) || (indexPath.row == 4) || (indexPath.row == 5)
        if self.arrPhotoVideo.count > 0 {
            let obj = self.arrPhotoVideo[indexPath.row]
            cell.imgVideo?.isHidden = !obj.isVideo
            cell.imgPhoto?.setImage(withUrl: obj.isVideo ? obj.videoImage : obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
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
        if collectionView == self.cvApplicant {
           return CGSize(width: collectionView.frame.size.height * 0.8, height: collectionView.frame.size.height)
       }
        return CGSize(width: collectionView.frame.height / 1.2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.cvApplicant {
            if self.arrApplicant.count > 0 {
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(ProfileViewController.self,configuration: { vc in
                    vc.selectedCaregiverID = self.arrApplicant[indexPath.row].userId
                    vc.isFromHire = (self.arrApplicant.filter({$0.isHire == "1"}).isEmpty)
                    vc.selectedJobID = self.selectedJobID
                    vc.selecetdJobApplicant = self.arrApplicant[indexPath.row]
                })
            }
        } else if collectionView == self.cvRequestPhotoVideo {
            self.appNavigationController?.push(JobShowPhotoVideoViewController.self,configuration: { vc in
                vc.arrPhotoVideo = self.arrRequestUploadedPhotoVideo
                vc.selecetdIndex = indexPath.row
            })
        } else {
            self.appNavigationController?.push(JobShowPhotoVideoViewController.self,configuration: { vc in
                vc.arrPhotoVideo = self.arrPhotoVideo
                vc.selecetdIndex = indexPath.row
            })
        }
    }
}

// MARK: - IBAction
extension JobDetailViewController {

    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenLocationActionClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            self.alertPicker.openMapNavigation(sender as Any, "Navigate to Job", AppoitnmentLatitude: obj.latitude.toDouble() ?? 0.0, AppoitnmentLongitude: obj.longitude.toDouble() ?? 0.0)
        }
    }
    
    @IBAction func btnApplicantViewAllClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            self.appNavigationController?.push(FeedLikeListViewController.self,configuration: { vc in
                vc.isFromJobApplicant = true
                //vc.arrApplicant = self.arrApplicant
                vc.selectedJobData = obj
                vc.selectedJobID = self.selectedJobID
            })
        }
    }
    
    @IBAction func btnApplyClicked(_ sender: XtraHelpButton) {
        self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.OpenFromType = .AdditionalQuestion
        })
    }
    
    @IBAction func btnDisputeRatingClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            self.appNavigationController?.push(GiveRatingReviewViewController.self,configuration: { vc in
                vc.selectedJobData = obj
            })
        }
    }
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        switch self.selecetdTab {
        case .Posted:
            self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .CancelJob
                vc.cancelJobDelegate = self
            })
            break
        case .Completed:
            self.navigationController?.popViewController(animated: true)
            break
        case .Upcoming:
            self.navigationController?.popViewController(animated: true)
            break
        case .Substitute:
            break
        }
    }
    @IBAction func btnChatClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                vc.chatUserID = obj.caregiverId
                vc.chatUserName = ""
                vc.chatUserImage = ""
            })
        }
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        
        switch self.selecetdTab {
        case .Posted:
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .AdditionalQuestion
                vc.isFromModifyAdditionalQuestionJob = true
            })
            break
        case .Completed:
            
            break
        case .Upcoming:
            if let obj = self.selectedJobData {
                self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.OpenFromType = .AddHours
                    vc.selectedJobData = obj
                })
            }
            break
        case .Substitute:
            break
        }
    }
    
    @IBAction func btnRequestPhotoVideoClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .RequestImageVideo
                vc.selectedJobData = obj
            })
        }
    }
}

//MARK : - API Call
extension JobDetailViewController : JobCancelSubstitutePopupDelegate{
    func cancelJob() {
        //if let obj = self.selectedJobData {
        self.cancelMyPostedJobAPICall()
        //}
    }
}

//MARK : - API Call
extension JobDetailViewController{
    
    func GetMyPostedJobDetailAPICall() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault() {
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                //kjobId : self.selectedJobID
            ]
            
            if self.selecetdTab == .Posted {
                dict[kjobId] =  self.selectedJobID
            } else {
                dict[kuserJobDetailId] = self.selectedJobID
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            JobModel.getMyPostedJobDetail(with: param,isFromRelatedjobDetail : (self.selecetdTab == .Posted) ? false : true ,success: { (model, msg) in
                self.selectedJobData = model
                self.setJobData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    private func setJobData(){
        if let obj = self.selectedJobData {
            
            if let user = UserModel.getCurrentUserFromDefault() {
                self.imgProfileLeft?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                self.imgProfileRight?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                self.lblTopHeader?.text = "\(user.FirstName) \(user.LastName)"
            }
            
            self.lblJobName?.text = obj.name
            self.lblJobRemaningTime?.text = obj.createdDateFormat
            self.lblDateTimeValue?.text = obj.startDateTime
            self.lblCategoryValue?.text = obj.CategoryName
            self.lblTypeValue?.text = obj.isJob == "1" ? "One Time" : "Recurring"
            //self.lblJobPrice?.text = obj.formatedPrice
            self.lblJobPrice?.setPriceTextLable(firstText: obj.formatedPrice, SecondText: "/hr")
            self.lblJobDesc?.text = obj.jobDesc
            let rate = Double(obj.jobRating) ?? 0
            self.vwRating?.rating = rate
            self.lblRatingDesc?.text = obj.jobFeedback
            
            
            self.btnRatingDispute?.setTitle((rate == 0 || obj.jobFeedback.isEmpty) ? "Add Review" : "Edit Review", for: .normal)
            
            self.lblMilesCountValue?.text = "OTP \(obj.verificationCode)"
            
            if !obj.latitude.isEmpty && !obj.longitude.isEmpty {
                let coordinate = CLLocationCoordinate2D(latitude: obj.latitude.toDouble() ?? 0.0, longitude: obj.longitude.toDouble() ?? 0.0)
                self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude)
            }
            
            self.arrAddiotinalQuestion = obj.questions
            self.tblAdditionalQuestions?.reloadData()
            self.stackAdditionalQuestionsMain?.isHidden = self.arrAddiotinalQuestion.isEmpty
            
            self.arrApplicant = obj.applicants
            self.cvApplicant?.reloadData()
            self.vwApplicant?.isHidden = self.arrApplicant.isEmpty
            
            self.arrPhotoVideo = obj.media
            self.cvPhotoVideo?.reloadData()
            self.stackPhotoVideoMain?.isHidden = self.arrPhotoVideo.isEmpty
            
            self.arrRequestUploadedPhotoVideo = obj.uploadedMedia
            
            if obj.startJobStatus == .Ongoing || obj.startJobStatus == .Completed {
                self.vwRequestPhotoVideoCVMain?.isHidden = self.arrRequestUploadedPhotoVideo.isEmpty
                self.btnRequestPhotoVideo?.isHidden = obj.startJobStatus == .Completed
                self.stackRequestPhotoVideo?.isHidden = false
            }
            self.cvRequestPhotoVideo?.reloadData()
            
            self.stackPreferencesMain?.isHidden = true
            //self.stackRequestPhotoVideo?.isHidden = !(self.selecetdTab == .Upcoming)
            
            if obj.startJobStatus == .Ongoing {
                self.vwJobStartMain?.isHidden = false
                self.lblJobStart?.text = "Add Hours"
                self.vwJobCancelMain?.isHidden = true
            } else if obj.startJobStatus == .NotStarted {
                self.vwJobStartMain?.isHidden = true
            }
        }
    }
    
    func cancelMyPostedJobAPICall() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobId : jobdata.userJobId
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.cancelMyPostedJob(with: param, success: { ( msg) in
                XtraHelp.sharedInstance.isCallJobReloadData = true
                //XtraHelp.sharedInstance.isCallHomeReloadData = true
                self.navigationController?.popViewController(animated: true)
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
extension JobDetailViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension JobDetailViewController: AppNavigationControllerInteractable { }
