//
//  ProfileViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 02/12/21.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblSuccessCount: UILabel?
    @IBOutlet weak var lblJobCount: UILabel?
    @IBOutlet weak var lblHoursCount: UILabel?
    
    @IBOutlet var lblSuccessJobHourHeader: [UILabel]?
    
    @IBOutlet weak var vwProfileRound: UIView?
    @IBOutlet weak var vwProfile: UIView?
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var vwRatingMain: UIView?
    
    @IBOutlet weak var cvCategory: UICollectionView?
    @IBOutlet weak var constraintCvCategoryHeight: NSLayoutConstraint?
    
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
    
    @IBOutlet weak var vwWorkExperienceSub: UIView?
    @IBOutlet weak var tblWorkExperience: UITableView?
    @IBOutlet weak var constraintTblExperienceHeight: NSLayoutConstraint?
    @IBOutlet weak var lblWorkExperienceHeader: UILabel?
    
    @IBOutlet weak var vwVaccinetedMain: UIView?
    @IBOutlet weak var imgVaccineted: UIImageView?
    
    // MARK: - Variables
    private var arrWorkExperience : [WorkExperienceModel] = []
    private var arrCategory : [JobCategoryModel] = []
    private var arrSpeciality : [String] = []
    private var userProfileData : UserProfileModel?
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.addTableviewOberver()
        self.configureNavigationBar()
        
        if XtraHelp.sharedInstance.isCallReloadProfileData {
            XtraHelp.sharedInstance.isCallReloadProfileData = false
            self.getCaregiverMyProfile()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.vwProfile?.roundedCornerRadius()
        self.imgProfile?.roundedCornerRadius()
        //self.vwProfileRound?.roundedCornerRadius()
        
        if let vw = self.vwProfileRound {
            //vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
            vw.cornerRadius = vw.frame.height / 2.0
        }
        
        self.vwVaccinetedMain?.clipsToBounds = true
        self.vwVaccinetedMain?.cornerRadius = (self.vwVaccinetedMain?.frame.width ?? 0.0) / 2
        self.vwVaccinetedMain?.shadow(UIColor.CustomColor.gradiantColorBottom, radius: 6.0, offset: CGSize(width: 4, height: 8), opacity: 0.5)
        self.vwVaccinetedMain?.maskToBounds = false
        
        self.vwPersonalDetailSub?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        self.vwWorkExperienceSub?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }

}

// MARK: - Init Configure
extension ProfileViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblUserName?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 33.0))
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        
        //self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        //self.lblSubHeader?.textColor = UIColor.CustomColor.textConnectLogin
    
        self.vwProfileRound?.backgroundColor = UIColor.CustomColor.gradiantColorBottom
        
        //delay(seconds: 0.3) {
            /*if let vw = self.vwProfileRound {
                //vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
                vw.circleCorner = true
            }*/
        //}
        
        [self.cvCategory,self.cvSpeciality].forEach({
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        self.cvCategory?.register(CategoryListCell.self)
        self.cvSpeciality?.register(CategoryListCell.self)
        
        self.lblSuccessJobHourHeader?.forEach({
            $0.textColor = UIColor.CustomColor.tabBarColor
            $0.font = UIFont.RubikBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblJobCount,self.lblHoursCount,self.lblSuccessCount].forEach({
            $0?.textColor = UIColor.CustomColor.commonLabelColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 29.0))
        })
        
        //Personal Detail
        self.vwPersonalDetailSub?.backgroundColor = UIColor.CustomColor.tabBarColor
        self.vwWorkExperienceSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        //
        self.lblPersonalDetailHeader?.forEach({
            $0.textColor = UIColor.CustomColor.whitecolor
            $0.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblBio,self.lblExperience,self.lblTransportaionMethod,self.lblDistanceWilling].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        })
        
        self.tblWorkExperience?.register(WorkExperienceCell.self)
        self.tblWorkExperience?.estimatedRowHeight = 100.0
        self.tblWorkExperience?.rowHeight = UITableView.automaticDimension
        self.tblWorkExperience?.delegate = self
        self.tblWorkExperience?.dataSource = self
        
        self.lblWorkExperienceHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))
        self.lblWorkExperienceHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        
        
        self.setupESInfiniteScrollinWithTableView()
        self.getCaregiverMyProfile()
    }
    
    private func configureNavigationBar(){
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.appColor, navigationItem: self.navigationItem)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.appColor, navigationItem: self.navigationItem, isHideBackButton: false, isShowRightBtn: true, RightBtnTitle: "Edit Profile")
        
        appNavigationController?.btnNextClickBlock = {
            self.appNavigationController?.push(SignupPersonalDetailViewController.self,configuration: { vc in
                vc.isFromEditProfile = true
                //vc.delegate = self
                vc.selectedUserProfileData = self.userProfileData
                
            })
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension ProfileViewController {
    
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.getCaregiverMyProfile()
        }
    }
}

//MARK: - UpdateProfile Delegate
extension ProfileViewController : updateProfileDelegate {
    
    func reloadProfileData() {
        self.getCaregiverMyProfile()
    }
}

//MARK: - Tableview Observer
extension ProfileViewController {
    
    private func addTableviewOberver() {
        self.cvCategory?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.cvSpeciality?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblWorkExperience?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvCategory?.observationInfo != nil {
            self.cvCategory?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
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
            if obj == self.cvCategory && keyPath == ObserverName.kcontentSize {
                self.constraintCvCategoryHeight?.constant = self.cvCategory?.contentSize.height ?? 0.0
            }
            if obj == self.cvSpeciality && keyPath == ObserverName.kcontentSize {
                self.constraintCVSpecialityHeight?.constant = self.cvSpeciality?.contentSize.height ?? 0.0
            }
        }
        
        if let obj = object as? UITableView {
            if obj == self.tblWorkExperience && keyPath == ObserverName.kcontentSize {
                self.constraintTblExperienceHeight?.constant = self.tblWorkExperience?.contentSize.height ?? 0.0
                self.tblWorkExperience?.layoutIfNeeded()
            }
        }
    }
}

//MARK:- UITableView Delegate
extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrWorkExperience.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: WorkExperienceCell.self)
        cell.isFromWorkExperience = true
        
        if self.arrWorkExperience.count > 0 {
            cell.setWorkExperienceData(obj: self.arrWorkExperience[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension ProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvCategory {
            return self.arrCategory.count
        }
        return self.arrSpeciality.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryListCell.self)
        cell.isFromProfile = true
        if collectionView == self.cvCategory {
            if self.arrCategory.count > 0{
                cell.lblCategoryName?.text = self.arrCategory[indexPath.row].name
            }
        } else {
            if self.arrSpeciality.count > 0{
                cell.lblCategoryName?.text = self.arrSpeciality[indexPath.row]
            }
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
        if collectionView == self.cvCategory {
            if self.arrCategory.count > 0 {
                let obj = self.arrCategory[indexPath.row]
                fontsize = obj.name.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)))
            }
        } else {
            if self.arrSpeciality.count > 0 {
                let obj = self.arrSpeciality[indexPath.row]
                fontsize = obj.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)))
            }
        }
        
        return CGSize(width: fontsize + 40.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - API Call
extension ProfileViewController {
    private func getCaregiverMyProfile(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserProfileModel.getCaregiverMyProfile(with: param, success: { (user,msg) in
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.userProfileData = user
                self.setProfileData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                    self.appNavigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    private func setProfileData(){
        if let obj = self.userProfileData {
            self.vwRating?.rating = Double(obj.ratingAverage) ?? 0.0
            self.lblUserName?.text = obj.fullName
            self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            //self.arrSpeciality = obj.workSpecialityName
            self.arrCategory = obj.categoryData
            self.cvCategory?.reloadData()
            
            self.arrSpeciality = [obj.workSpecialityName] //append(obj.workSpecialityName)
            self.cvSpeciality?.reloadData()
            
            self.arrWorkExperience = obj.workExperienceData
            self.tblWorkExperience?.reloadData()
            
            self.lblExperience?.text = obj.totalYearWorkExperience
            self.lblTransportaionMethod?.text = obj.workMethodOfTransportationName
            self.lblDistanceWilling?.text = obj.workDistancewillingTravel
            
            self.lblSuccessCount?.text = obj.successPercentage//.doubleValue.convertDoubletoString(digits: 2)
            self.lblJobCount?.text = obj.totalJobs
            self.lblHoursCount?.text = obj.totalJobsHours
            
            self.lblBio?.text = obj.caregiverBio
            
            self.vwVaccinetedMain?.isHidden = obj.familyVaccinated == "2"
        }
    }
}

// MARK: - ViewControllerDescribable
extension ProfileViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension ProfileViewController: AppNavigationControllerInteractable { }
