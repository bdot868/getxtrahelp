//
//  JobDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

enum RequestPhotoVideoEnum : Int {
    case Image
    case Video
    case All
}

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
    
    @IBOutlet weak var vwCancelBottomArrowSub: UIView?
    @IBOutlet weak var vwStartJobBottomArrowSub: UIView?
    
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
    var selecetdTab : SegmentJobTabEnum = .All
    var selectedJobID : String = ""
    private var selectedJobData : JobModel?
    private var arrPhotoVideo : [AddPhotoVideoModel] = []
    private var arrAddiotinalQuestion : [AdditionalQuestionModel] = []
    private var arrRequestUploadedPhotoVideo : [AddPhotoVideoModel] = []
    
    var substitudeJobRequestID : String = ""
    
    private let alertPicker = CustomeNavigateAlert()
    var isFromTabbar : Bool = false
    var isFromHomeScreen : Bool = false
    var isFromNearestJob : Bool = false
    var isFromHomeUpcomingScreen : Bool = false
    var isFromRequestJobNotification : Bool = false
    var requestImageVideoType : RequestPhotoVideoEnum = .Image
    
    private let imagePicker = ImagePicker()
    private let videoPicker = VideoPicker()
    
    var isFromJobAddHoursRequest : Bool = false
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.addTableviewOberver()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if XtraHelp.sharedInstance.isCallJobDetailReloadData {
            XtraHelp.sharedInstance.isCallJobDetailReloadData = false
            self.GetMyPostedJobDetailAPICall()
        }
        
        /*delay(seconds: 0.2) {
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude)
            }
        }*/
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
        //if self.selecetdTab != .Substitute {
            if let vw = self.vwJobStartMain {
                vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
                vw.roundCorners(corners: [.topLeft], radius: vw.frame.width / 2)
            }
        /*} else {
            if let vw = self.vwJobStartMain {
                //vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
                vw.roundCorners(corners: [.topLeft], radius: vw.frame.width / 2)
            }
        }*/
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
        
        self.imagePicker.viewController = self
        self.videoPicker.viewController = self
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        self.lblTopHeader?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.lblJobName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        self.lblJobName?.textColor = UIColor.CustomColor.whitecolor
        
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
        
        self.btnRequestPhotoVideo?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 10.0))
        self.btnRequestPhotoVideo?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.cvPhotoVideo?.delegate = self
        self.cvPhotoVideo?.dataSource = self
        self.self.cvPhotoVideo?.register(PhotoVideoCollectionCell.self)
        
        self.cvRequestPhotoVideo?.delegate = self
        self.cvRequestPhotoVideo?.dataSource = self
        self.cvRequestPhotoVideo?.register(PhotoVideoCollectionCell.self)
        
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
        case .All:
            self.vwLocationMain?.isHidden = false
            self.vwBottomBtn?.isHidden = false
            break
        case .Applied:
            self.vwLocationMain?.isHidden = true
            self.vwBottomBtn?.isHidden = true
            self.vwLocationMain?.isHidden = false
            self.vwBottomJobCancelStartMain?.isHidden = false
            
            self.lblJobCancel?.text = "Cancel Application"
            self.lblJobStart?.text = "Modify Answers"
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
            break
        case .Substitute:
            self.vwBottomBtn?.isHidden = true
            self.vwLocationMain?.isHidden = false
            self.vwBottomJobCancelStartMain?.isHidden = true
            
            //self.vwCancelBottomArrowSub?.isHidden = true
            //self.vwStartJobBottomArrowSub?.isHidden = true
            
            //self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.ticketStausColor
            //self.vwJobStartMain?.backgroundColor = UIColor.CustomColor.resourceBtnColor
            
            //self.lblJobCancel?.text = "Reject"
            //self.lblJobStart?.text = "Accept"
            
            break
        case .AwardJob:
            break
        }
        
        self.GetMyPostedJobDetailAPICall()
    }
    
    private func setMapMarker(selLat : Double,selLong : Double,isShowMarker : Bool = true){
        let coordinate = CLLocationCoordinate2D(latitude: selLat, longitude: selLong)
        self.vwMap?.clear()
        self.vwMap?.camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: 16.0)
        if isShowMarker {
            let marker: GMSMarker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "ic_pin_location")
            marker.position = coordinate
            marker.map = self.vwMap
        }
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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblAdditionalQuestions {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: AdditionalQuestionsCell.self)
            cell.isFromJobDetail = true
            if self.arrAddiotinalQuestion.count > 0 {
                let obj = self.arrAddiotinalQuestion[indexPath.row]
                cell.lblQuestionNumber?.text = "Question \(indexPath.row + 1)"
                cell.lblQuestion?.text = obj.question
                cell.lblAnswer?.text = obj.answer
                cell.lblAnswer?.isHidden = obj.answer.isEmpty
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
        /*if collectionView == self.cvApplicant {
            return 8
        }*/
        if collectionView == self.cvRequestPhotoVideo {
            return self.arrRequestUploadedPhotoVideo.count
        }
        return self.arrPhotoVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*if collectionView == self.cvApplicant {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: NearestCarGiverCollectionCell.self)
            cell.isFromJobDetail = true
            return cell
        }*/
        if collectionView == self.cvRequestPhotoVideo {
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
       /* if collectionView == self.cvApplicant {
           return CGSize(width: collectionView.frame.size.height * 0.8, height: collectionView.frame.size.height)
       }*/
        return CGSize(width: collectionView.frame.height / 1.2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*if collectionView == self.cvApplicant {
         } else {*/
        if collectionView == self.cvRequestPhotoVideo {
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
    @IBAction func btnApplyClicked(_ sender: XtraHelpButton) {
        
        self.showAlert(withTitle: "", with: AppConstant.AlertMessages.kApplyJob, firstButton: ButtonTitle.Yes, firstHandler: { alrt in
            if self.arrAddiotinalQuestion.count > 0 {
                self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.OpenFromType = .AdditionalQuestion
                    vc.arrAddiotinalQuestion = self.arrAddiotinalQuestion
                    vc.delegate = self
                })
            } else {
                self.ApplyJobModifyAnswerAPICall()
            }
        }, secondButton: ButtonTitle.No, secondHandler: nil)
    }
    
    @IBAction func btnOpenLocationActionClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            if obj.isHire == "1" {
                self.alertPicker.openMapNavigation(sender as Any, "Navigate to Job", AppoitnmentLatitude: obj.latitude.toDouble() ?? 0.0, AppoitnmentLongitude: obj.longitude.toDouble() ?? 0.0)
            }
        }
    }
    
    @IBAction func btnDisputeRatingClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        switch self.selecetdTab {
        case .All:
            
            break
        case .Applied:
            self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .CancelJob
                if let obj = self.selectedJobData {
                    vc.selectedjobData = obj
                }
                vc.delegate = self
            })
            break
        case .Completed:
           
            break
        case .Upcoming:
            self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .SubstituteJob
                if let obj = self.selectedJobData {
                    vc.selectedjobData = obj
                }
                vc.delegate = self
            })
            break
        case .Substitute:
            self.showAlert(withTitle: "", with: "Are you sure want to reject this request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                self.AcceptRejectJobSubstitudeAPICall(isAccept: false, substitudeRequestID: self.substitudeJobRequestID)
            }, secondButton: ButtonTitle.No, secondHandler: nil)
            break
        case .AwardJob:
            break
        }
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        
        switch self.selecetdTab {
        case .All:
            
            break
        case .Applied:
            self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.OpenFromType = .AdditionalQuestion
                vc.isFromModifyAdditionalQuestionJob = true
                vc.delegate = self
                if let obj = self.selectedJobData {
                    vc.arrAddiotinalQuestion = obj.questions
                }
            })
            break
        case .Completed:
           
            break
        case .Upcoming:
            if let obj = self.selectedJobData {
                if obj.startJobStatus == .NotStarted {
                    self.appNavigationController?.push(VerificationViewController.self,configuration: { (vc) in
                        vc.isFromjobStart = true
                        vc.delegate = self
                        if let obj = self.selectedJobData {
                            vc.selectedJobData = obj
                        }
                    })
                } else if obj.startJobStatus == .Ongoing {
                    self.appNavigationController?.push(JobStartViewController.self,configuration: { vc in
                        vc.selectedJobData = obj
                        vc.selectedPrevJobData = obj
                    })
                }
                
            }
            break
        case .Substitute:
            self.showAlert(withTitle: "", with: "Are you sure want to accept this request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                self.AcceptRejectJobSubstitudeAPICall(isAccept: true, substitudeRequestID: self.substitudeJobRequestID)
            }, secondButton: ButtonTitle.No, secondHandler: nil)
            break
        case .AwardJob:
            break
        }
    }
    
    @IBAction func btnChatClicked(_ sender: UIButton) {
        if let obj = self.selectedJobData {
            self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                vc.chatUserID = obj.userId
                vc.chatUserName = obj.userFullName
                vc.chatUserImage = obj.profileImageThumbUrl
            })
        }
    }
    
    @IBAction func btnUploadRequestedClicked(_ sender: UIButton) {
        let alertmenu = UIAlertController(title: "Select Photo/Video", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { alert in
            self.imagePicker.pickImage(sender, "Select Image") { (img,url) in
                self.mediaAPICall(img: img)
            }
        }
        
        let videoAction = UIAlertAction(title: "Video", style: .default) { alert in
            self.videoPicker.isAllowsEditing = false
            self.videoPicker.pickImage(sender,Title: "Select Video") { (data,url)  in
                //self.videoData = data
                
                AVAsset(url: url).generateThumbnail { [weak self] (image) in
                    DispatchQueue.main.async {
                        guard let image = image else { return }
                        //self?.thumnailImg = image
                        self?.videomediaAPICall(img: image, videodata: data)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .cancel) { alert in
            
        }
    
        alertmenu.popoverPresentationController?.sourceView = sender as? UIView
        alertmenu.addAction(photoAction)
        alertmenu.addAction(videoAction)
        alertmenu.addAction(cancelAction)
        self.present(alertmenu, animated: true, completion: nil)
    }
}

//MARK : - Verification Delegate
extension JobDetailViewController : verificationDelegate {
    func verifyJobCode(jobdata : JobModel) {
        if let obj = self.selectedJobData {
            self.appNavigationController?.push(JobStartViewController.self,configuration: { vc in
                vc.selectedJobData = jobdata
                vc.selectedPrevJobData = obj
                vc.isfromVerification = true
            })
        }
    }
}

//MARK : - JobCancelSubstituteDelegate
extension JobDetailViewController : JobCancelSubstituteDelegate {
    func cancelJob(selectedjobData : JobModel) {
        if let obj = self.selectedJobData {
            if obj.jobStatus == .Upcoming {
                self.cancelJobRequestORJobAPICall(isfromJobRequest: false)
            } else if obj.jobStatus == .Applied || self.isFromHomeScreen {
                self.cancelJobRequestORJobAPICall(isfromJobRequest: true)
            }
        }
    }
    
    func substituteJob() {
        /*self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.OpenFromType = .SubstituteJob
            vc.appnav = self.appNavigationController
            vc.delegate = self
        })*/
        let st = UIStoryboard.getStoryboard(for: "Auth")
        let vc = st.getViewController(with: "ListCommonDataPopupViewController") as! ListCommonDataPopupViewController
        //vc.modalPresentationStyle = .fullScreen
        //vc.modalTransitionStyle = .crossDissolve
        vc.OpenFromType = .SubstituteJob
        vc.appnav = self.appNavigationController
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        vc.appnav = navController
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: true) {
            
        }
        /*navController.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.OpenFromType = .SubstituteJob
            vc.appnav = self.appNavigationController
            vc.delegate = self
        })*/
    }
}

//MARK : - ListCommonDataDelegate
extension JobDetailViewController : ListCommonDataDelegate {
    func selectHearAboutData(obj: HearAboutUsModel) {
        
    }
    
    func selectCertificateTypeData(obj: licenceTypeModel, selectIndex: Int) {
        
    }
    
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel, selectIndex: Int) {
        
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        
    }
    
    func selectDisabilitiesData(obj: [WorkDisabilitiesWillingTypeModel]) {
        
    }
    
    func selectAdditionalQuestionData(obj: [AdditionalQuestionModel],isFromModifyQuestion : Bool) {
        if isFromModifyQuestion {
            self.arrAddiotinalQuestion = obj
            self.tblAdditionalQuestions?.reloadData()
            self.ApplyJobModifyAnswerAPICall(isfromModifyAnswer: true)
        } else {
            self.arrAddiotinalQuestion = obj
            self.ApplyJobModifyAnswerAPICall()
        }
    }
    
    func selectSubstituteCaregiverData(obj: CaregiverListModel) {
        self.caregiverSubstituteJobAPICall(caregiverid: obj.id)
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
            
            if self.isFromNearestJob {
                dict[kjobId] = self.selectedJobID
            } else {
                if self.isFromHomeUpcomingScreen || self.isFromTabbar {
                    dict[kuserJobDetailId] = self.selectedJobID
                } else {
                    dict[kjobId] = self.selectedJobID
                }
            }
            let param : [String:Any] = [
                kData : dict
            ]
            JobModel.getMyPostedJobDetail(with: param,isFromJobTab : self.isFromHomeUpcomingScreen ? true : !self.isFromHomeScreen, success: { (model, msg) in
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
            
            self.lblTopHeader?.text = obj.userFullName
            self.imgProfileLeft?.setImage(withUrl: obj.profileImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            self.imgProfileRight?.setImage(withUrl: obj.profileImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            
            self.lblJobName?.text = obj.name
            self.lblJobRemaningTime?.text = obj.createdDateFormat
            self.lblDateTimeValue?.text = obj.startDateTime
            self.lblCategoryValue?.text = obj.CategoryName
            self.lblTypeValue?.text = obj.isJob.name//obj.isJob == "1" ? "One Time" : "Recurring"
            self.lblJobPrice?.setPriceTextLable(firstText: obj.formatedPrice, SecondText: "/hr")//.text = obj.formatedPrice
            self.lblJobDesc?.text = obj.jobDesc
            self.lblMilesCountValue?.text = "\(obj.distance) mi"
            
            if !obj.latitude.isEmpty && !obj.longitude.isEmpty {
                let coordinate = CLLocationCoordinate2D(latitude: obj.latitude.toDouble() ?? 0.0, longitude: obj.longitude.toDouble() ?? 0.0)
                self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude, isShowMarker: obj.isHire == "1")
                
            }
            
            self.arrAddiotinalQuestion = obj.questions
            self.tblAdditionalQuestions?.reloadData()
            self.stackAdditionalQuestionsMain?.isHidden = self.arrAddiotinalQuestion.isEmpty
            
            self.arrPhotoVideo = obj.media
            self.cvPhotoVideo?.reloadData()
            self.stackPhotoVideoMain?.isHidden = self.arrPhotoVideo.isEmpty
            
            self.arrRequestUploadedPhotoVideo = obj.uploadedMedia
            self.cvRequestPhotoVideo?.reloadData()
            self.vwRequestPhotoVideoCVMain?.isHidden = self.arrRequestUploadedPhotoVideo.isEmpty
            
            self.stackPreferencesMain?.isHidden = true
            
            /*if self.selecetdTab == .All {
                self.vwBottomBtn?.isHidden = (obj.isJobApply == "1")
                if obj.isJobApply == "1" {
                    self.vwBottomJobCancelStartMain?.isHidden = false
                    self.lblJobCancel?.text = "Cancel Application"
                    self.lblJobStart?.text = "Modify Answers"
                }
            }*/
            if self.selecetdTab != .Substitute {
                self.selecetdTab = obj.jobStatus
            }
            if self.isFromHomeScreen {
                //self.selecetdTab = obj.jobStatus
                if obj.isJobApply == "1" {
                    self.selecetdTab = .Applied
                }
            }
            
            self.stackRequestPhotoVideo?.isHidden = !(self.selecetdTab == .Upcoming)
            
            switch self.selecetdTab {
            case .All:
                self.vwLocationMain?.isHidden = false
                self.vwBottomBtn?.isHidden = false
                break
            case .Applied:
                self.vwLocationMain?.isHidden = true
                self.vwBottomBtn?.isHidden = true
                self.vwLocationMain?.isHidden = false
                self.vwBottomJobCancelStartMain?.isHidden = false
                
                self.lblJobCancel?.text = "Cancel Application"
                self.lblJobStart?.text = "Modify Answers"
                
                self.vwJobStartMain?.isHidden = obj.questions.isEmpty
                //self.vwJobStartMain?.layoutIfNeeded()
                //self.vwJobCancelMain?.layoutIfNeeded()
                delay(seconds: 0.1) {
                    if let vw = self.vwJobCancelMain {
                        vw.roundCorners(corners: [.topRight], radius: (vw.frame.width )/2.0)
                    }
                }
                
                //self.vwJobCancelMain?.layoutIfNeeded()
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
                
                self.lblRatingDesc?.text = obj.jobFeedback
                self.vwRating?.rating = Double(obj.jobRating) ?? 0
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
                
                if self.isFromJobAddHoursRequest {
                    self.getRequestAddJobHoursDetailAPICall()
                }
                
                break
            case .Substitute:
                self.vwLocationMain?.isHidden = false
                self.vwBottomBtn?.isHidden = true
                break
            case .AwardJob:
                break
            }
            
            if obj.startJobStatus == .Ongoing {
                self.lblJobStart?.text = obj.startJobStatus.name
            }
            
            if self.isFromRequestJobNotification {
                if self.requestImageVideoType == .Image {
                    self.imagePicker.pickImage(self.btnChat, "Select Image") { (img,url) in
                        self.mediaAPICall(img: img)
                    }
                    
                } else if self.requestImageVideoType == .Video {
                    self.videoPicker.isAllowsEditing = false
                    self.videoPicker.pickImage(self.btnChat,Title: "Select Video") { (data,url)  in
                        //self.videoData = data
                        
                        AVAsset(url: url).generateThumbnail { [weak self] (image) in
                            DispatchQueue.main.async {
                                guard let image = image else { return }
                                //self?.thumnailImg = image
                                self?.videomediaAPICall(img: image, videodata: data)
                            }
                        }
                    }
                } else if self.requestImageVideoType == .All {
                    let alertmenu = UIAlertController(title: "Select Photo/Video", message: nil, preferredStyle: .actionSheet)
                    
                    let photoAction = UIAlertAction(title: "Photo", style: .default) { alert in
                        self.imagePicker.pickImage(self.btnChat, "Select Image") { (img,url) in
                            self.mediaAPICall(img: img)
                        }
                    }
                    
                    let videoAction = UIAlertAction(title: "Video", style: .default) { alert in
                        self.videoPicker.isAllowsEditing = false
                        self.videoPicker.pickImage(self.btnChat,Title: "Select Video") { (data,url)  in
                            //self.videoData = data
                            
                            AVAsset(url: url).generateThumbnail { [weak self] (image) in
                                DispatchQueue.main.async {
                                    guard let image = image else { return }
                                    //self?.thumnailImg = image
                                    self?.videomediaAPICall(img: image, videodata: data)
                                }
                            }
                        }
                    }
                    
                    let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .cancel) { alert in
                        
                    }
                
                    alertmenu.popoverPresentationController?.sourceView = self.btnChat as? UIView
                    alertmenu.addAction(photoAction)
                    alertmenu.addAction(videoAction)
                    alertmenu.addAction(cancelAction)
                    self.present(alertmenu, animated: true, completion: nil)
                }
            }
        }
    }
    
    func ApplyJobModifyAnswerAPICall(isfromModifyAnswer : Bool = false) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            var arr : [[String:Any]] = []
            for i in stride(from: 0, to: self.arrAddiotinalQuestion.count, by: 1){
                let obj = self.arrAddiotinalQuestion[i]
                if !obj.answer.isEmpty {
                    let dict : [String:Any] = [
                        kquestionId : obj.userJobQuestionId,
                        kanswer : obj.answer
                    ]
                    arr.append(dict)
                }
            }
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kjobId : jobdata.userJobId,
                kquestionsAnswer : arr
            ]
            
            if isfromModifyAnswer {
                dict[kuserJobApplyId] = jobdata.userJobApplyId
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            JobModel.applyUserJob(with: param,isFromModifyAnswer: isfromModifyAnswer, success: { ( msg) in
                if !isfromModifyAnswer {
                    XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                    self.appNavigationController?.push(JobSuccessViewController.self)
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    
    func cancelJobRequestORJobAPICall(isfromJobRequest : Bool = false) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobApplyId : jobdata.userJobApplyId
            ]
           
            if !isfromJobRequest {
                dict[kjobId] = jobdata.userJobId
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.cancelJobRequestORJob(with: param,isJobRequest: isfromJobRequest, success: { ( msg) in
                XtraHelp.sharedInstance.isCallJobReloadData = true
                XtraHelp.sharedInstance.isCallHomeReloadData = true
                self.navigationController?.popViewController(animated: true)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    
    func caregiverSubstituteJobAPICall(caregiverid : String) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobApplyId : jobdata.userJobApplyId,
                kjobId : jobdata.userJobId,
                kcaregiverId : caregiverid
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.caregiverSubstituteJob(with: param, success: { ( msg) in
                XtraHelp.sharedInstance.isCallJobReloadData = true
                self.showMessage(msg,themeStyle: .success,presentationStyle: .bottom)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
    
    private func mediaAPICall(img : UIImage) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadCertificateMedia(with: dict, image: img, success: { (msg,urldata) in
            //let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: urldata, MediaName: msg, isvideo: false, VideoImage: "", videothumpimg: UIImage(), MediaNameThumbUrl: "", VideoImageUrl: "", VideoImageThumbUrl: "")
            
            //self.arrPhotoVideo.append(model)
            //self.cvPhotoVideo?.reloadData()
            //self.uploadJobMedia(medianame: msg, videoimg: "")
            self.uploadJobMedia(medianame: msg, videoimg: urldata, isfromVideo: false, videoImg: UIImage(), mediaUrl: urldata)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func videomediaAPICall(img : UIImage,videodata : NSData) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        AddPhotoVideoModel.addVideoAPI(with: videodata, image: nil, param: dict, success: { (msg,urldata,videoThumnailurl) in
            //let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: urldata, MediaName: msg, isvideo: true, VideoImage: videoThumnailurl, videothumpimg: img, MediaNameThumbUrl: "", VideoImageUrl: videoThumnailurl, VideoImageThumbUrl: videoThumnailurl)
           // self.arrPhotoVideo.append(model)
           // self.cvPhotoVideo?.reloadData()
            //self.uploadJobMedia(medianame: msg, videoimg: videoThumnailurl)
            self.uploadJobMedia(medianame: msg, videoimg: videoThumnailurl, isfromVideo: true, videoImg: img, mediaUrl: urldata)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    func uploadJobMedia(medianame : String,videoimg : String,isfromVideo : Bool,videoImg : UIImage,mediaUrl : String) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(),let jobdata = self.selectedJobData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobDetailId : jobdata.userJobDetailId,
                kmediaName : medianame,
                kvideoImage : videoimg
            ]
           
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.uploadJobMedia(with: param) { msg in
                if isfromVideo {
                    let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: mediaUrl, MediaName: medianame, isvideo: true, VideoImage: videoimg, videothumpimg: videoImg, MediaNameThumbUrl: "", VideoImageUrl: videoimg, VideoImageThumbUrl: videoimg)
                    self.arrRequestUploadedPhotoVideo.append(model)
                    self.cvRequestPhotoVideo?.reloadData()
                    self.vwRequestPhotoVideoCVMain?.isHidden = self.arrRequestUploadedPhotoVideo.isEmpty
                } else {
                    let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: videoimg, MediaName: medianame, isvideo: false, VideoImage: "", videothumpimg: UIImage(), MediaNameThumbUrl: "", VideoImageUrl: "", VideoImageThumbUrl: "")
                    self.arrRequestUploadedPhotoVideo.append(model)
                    self.cvRequestPhotoVideo?.reloadData()
                    self.vwRequestPhotoVideoCVMain?.isHidden = self.arrRequestUploadedPhotoVideo.isEmpty
                }
                
                self.showMessage(msg,themeStyle: .success,presentationStyle: .bottom)
            } failure: { statuscode, error, customError in
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            }
        }
    }
    
    func AcceptRejectJobSubstitudeAPICall(isAccept : Bool = false,substitudeRequestID : String) {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault(){
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                ksubstituteRequestId : substitudeRequestID
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.AcceptRejectJobSubstitudeRequest(with: param, isAccept: isAccept) { msg in
                self.showMessage(msg, themeStyle: .success)
                self.appNavigationController?.popViewController(animated: true)
            } failure: { statuscode, error, customError in
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            }
        }
    }
    
    func getRequestAddJobHoursDetailAPICall() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobDetailId : self.selectedJobID
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.getRequestAddJobHoursDetail(with: param, success: { model, str in
                self.isFromJobAddHoursRequest = false
                
                self.appNavigationController?.present(JobCancelSubstitutePopupViewController.self,configuration: { (vc) in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.OpenFromType = .AdditionalHours
                    //if let obj = self.selectedJobData {
                        vc.selectedjobData = model
                    //}
                    vc.delegate = self
                })
                
            }, failure: {[unowned self] (statuscode,error, errorType) in
                self.isFromJobAddHoursRequest = false
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                    self.navigationController?.popViewController(animated: true)
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
