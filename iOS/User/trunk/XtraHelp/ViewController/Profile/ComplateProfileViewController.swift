//
//  ComplateProfileViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 08/12/21.
//

import UIKit

class ComplateProfileViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet weak var lblUserName: UILabel?
    
    @IBOutlet weak var vwProfileRound: UIView?
    @IBOutlet weak var vwProfile: UIView?
    @IBOutlet weak var imgProfile: UIImageView?
    // MARK: - Variables
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var vwRatingMain: UIView?
    
    //PersonalDetail
    @IBOutlet weak var vwPersonalDetailMain: UIView?
    @IBOutlet weak var vwPersonalDetailSub: UIView?
    @IBOutlet var lblPersonalDetailHeader: [UILabel]?
    @IBOutlet weak var lblBio: UILabel?
    @IBOutlet weak var lblExperience: UILabel?
    @IBOutlet weak var lblTransportaionMethod: UILabel?
    @IBOutlet weak var lblDistanceWilling: UILabel?
    @IBOutlet weak var vwPDBio: UIStackView?
    @IBOutlet weak var vwPDSpeciality: UIStackView?
    @IBOutlet weak var vwPDExperience: UIStackView?
    @IBOutlet weak var vwPDTransportaionMethod: UIStackView?
    @IBOutlet weak var vwPDDistanceWilling: UIStackView?
    @IBOutlet weak var cvSpeciality: UICollectionView?
    @IBOutlet weak var constraintCVSpecialityHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwWorkExperienceMain: UIStackView?
    @IBOutlet weak var vwWorkExperienceSub: UIView?
    @IBOutlet weak var tblWorkExperience: UITableView?
    @IBOutlet weak var constraintTblExperienceHeight: NSLayoutConstraint?
    @IBOutlet weak var lblWorkExperienceHeader: UILabel?
    
    @IBOutlet weak var vwReviewsSub: UIStackView?
    @IBOutlet weak var tblReviews: UITableView?
    @IBOutlet weak var constraintTblReviewsHeight: NSLayoutConstraint?
    @IBOutlet weak var lblReviewsHeader: UILabel?
    @IBOutlet weak var vwSeeAllReviewsSub: UIView?
    @IBOutlet weak var btnSeeAllReviews: XtraHelpButton?
    
    // MARK: - Variables
    private var arrWorkExperience : [WorkExperienceModel] = []
    private var arrCategory : [JobCategoryModel] = []
    private var arrSpeciality : [String] = []
    var userProfileData : UserProfileModel?
    private var arrReviews : [RatingModel] = []
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.addTableviewOberver()
        self.configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.vwProfile?.roundedCornerRadius()
        self.imgProfile?.roundedCornerRadius()
        
        self.vwPersonalDetailSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        self.vwWorkExperienceSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }

    @IBAction func btnSeeAllReviewsClicked(_ sender: XtraHelpButton) {
        if let obj = self.userProfileData {
            self.appNavigationController?.push(SeeAllReviewListViewController.self,configuration: { vc in
                vc.caregiverId = obj.id
            })
        }
    }
}

// MARK: - Init Configure
extension ComplateProfileViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblUserName?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 24.0))
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.vwProfileRound?.backgroundColor = UIColor.CustomColor.gradiantColorBottom
        
        if let vw = self.vwProfileRound {
            vw.circleCorner = true
        }
        
        [self.cvSpeciality].forEach({
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        self.cvSpeciality?.register(CategoryListCell.self)
        
        //Personal Detail
        self.vwPersonalDetailSub?.backgroundColor = UIColor.CustomColor.tabBarColor
        self.vwWorkExperienceSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblPersonalDetailHeader?.forEach({
            $0.textColor = UIColor.CustomColor.whitecolor
            $0.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblBio,self.lblExperience,self.lblTransportaionMethod,self.lblDistanceWilling].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        
        [self.tblWorkExperience,self.tblReviews].forEach({
            $0?.estimatedRowHeight = 100.0
            $0?.rowHeight = UITableView.automaticDimension
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        self.tblWorkExperience?.register(WorkExperienceCell.self)
        self.tblReviews?.register(ReviewListCell.self)
        
        self.lblWorkExperienceHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))
        self.lblWorkExperienceHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblReviewsHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))
        self.lblReviewsHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        //self.setupESInfiniteScrollinWithTableView()
        self.setProfileData()
    }
    
    private func configureNavigationBar(){
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Profile", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension ComplateProfileViewController {
    
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.setProfileData()
        }
    }
}

//MARK: - Tableview Observer
extension ComplateProfileViewController {
    
    private func addTableviewOberver(){
        self.tblReviews?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.cvSpeciality?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblWorkExperience?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver(){
        if self.tblReviews?.observationInfo != nil {
            self.tblReviews?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.cvSpeciality?.observationInfo != nil {
            self.cvSpeciality?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.tblWorkExperience?.observationInfo != nil {
            self.tblWorkExperience?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            if obj == self.cvSpeciality && keyPath == ObserverName.kcontentSize {
                self.constraintCVSpecialityHeight?.constant = self.cvSpeciality?.contentSize.height ?? 0.0
            }
        }
        
        if let obj = object as? UITableView {
            if obj == self.tblWorkExperience && keyPath == ObserverName.kcontentSize {
                self.constraintTblExperienceHeight?.constant = self.tblWorkExperience?.contentSize.height ?? 0.0
                self.tblWorkExperience?.layoutIfNeeded()
            }
            if obj == self.tblReviews && keyPath == ObserverName.kcontentSize {
                self.constraintTblReviewsHeight?.constant = self.tblReviews?.contentSize.height ?? 0.0
                self.tblReviews?.layoutIfNeeded()
            }
        }
    }
    
}

//MARK:- UITableView Delegate
extension ComplateProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblWorkExperience {
            return self.arrWorkExperience.count
        }
        return self.arrReviews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblWorkExperience {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: WorkExperienceCell.self)
            cell.isFromWorkExperience = true
            
            if self.arrWorkExperience.count > 0 {
                cell.setWorkExperienceData(obj: self.arrWorkExperience[indexPath.row])
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, with: ReviewListCell.self)
        if self.arrReviews.count > 0 {
            cell.setReviewData(obj: self.arrReviews[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension ComplateProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSpeciality.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryListCell.self)
        cell.isFromProfile = true
        if self.arrSpeciality.count > 0{
            cell.lblCategoryName?.text = self.arrSpeciality[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var fontsize: CGFloat = 0.0
        if self.arrSpeciality.count > 0 {
            let obj = self.arrSpeciality[indexPath.row]
            fontsize = obj.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)))
        }
        
        return CGSize(width: fontsize + 40.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
}

// MARK: - API Call
extension ComplateProfileViewController {
    
    private func setProfileData(){
        if let obj = self.userProfileData {
            self.vwRating?.rating = Double(obj.ratingAverage) ?? 0.0
            self.lblUserName?.text = obj.fullName
            self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            //self.arrSpeciality = obj.workSpecialityName
            self.arrSpeciality = [obj.workSpecialityName]
            self.cvSpeciality?.reloadData()
            self.vwPDSpeciality?.isHidden = self.arrSpeciality.isEmpty
            
            self.arrWorkExperience = obj.workExperienceData
            self.tblWorkExperience?.reloadData()
            self.vwWorkExperienceMain?.isHidden = self.arrWorkExperience.isEmpty
            
            self.lblReviewsHeader?.text = "Reviews (\(obj.totalReview))"
            self.btnSeeAllReviews?.setTitle("Read all reviews (\(obj.totalReview))", for: .normal)
            self.arrReviews = obj.reviewData
            self.tblReviews?.reloadData()
            self.vwReviewsSub?.isHidden = obj.reviewData.isEmpty
            self.vwSeeAllReviewsSub?.isHidden = ((Int(obj.totalReview) ?? 0) < 5)
            
            self.lblExperience?.text = obj.totalYearWorkExperience
            self.lblTransportaionMethod?.text = obj.workMethodOfTransportationName
            self.lblDistanceWilling?.text = obj.workDistancewillingTravel
            
            self.lblExperience?.text = obj.totalYearWorkExperience//.doubleValue.convertDoubletoString(digits: 2)
            self.lblTransportaionMethod?.text = obj.workMethodOfTransportationName
            self.lblDistanceWilling?.text = obj.workDistancewillingTravel
            
            self.lblBio?.text = obj.caregiverBio
        }
    }
}

// MARK: - ViewControllerDescribable
extension ComplateProfileViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.Profile
    }
}

// MARK: - AppNavigationControllerInteractable
extension ComplateProfileViewController: AppNavigationControllerInteractable { }
