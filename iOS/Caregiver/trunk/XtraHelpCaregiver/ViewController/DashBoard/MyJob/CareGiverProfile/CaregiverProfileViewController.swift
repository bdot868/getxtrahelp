//
//  CaregiverProfileViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 05/04/22.
//

import UIKit

class CaregiverProfileViewController: UIViewController {

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
    // MARK: - Variables
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var vwRatingMain: UIView?
    
    @IBOutlet weak var cvCategory: UICollectionView?
    @IBOutlet weak var constraintCvCategoryHeight: NSLayoutConstraint?
    
    //PersonalDetail
    @IBOutlet weak var vwPersonalDetailMain: UIView?
    @IBOutlet weak var vwPersonalDetailSub: UIView?
    @IBOutlet weak var lblComplateProfileHeader: UILabel?
    @IBOutlet weak var lblComplateProfileSubHeader: UILabel?
    @IBOutlet weak var imgLeftComplateProfile: UIImageView?
    
    @IBOutlet weak var vwWorkExperienceSub: UIView?
    @IBOutlet weak var lblAvailibilityHeader: UILabel?
    @IBOutlet weak var lblAvailibilitySubHeader: UILabel?
    @IBOutlet weak var imgLeftAvailibility: UIImageView?
    
    @IBOutlet weak var vwVaccinetedMain: UIView?
    @IBOutlet weak var imgVaccineted: UIImageView?
    
    @IBOutlet weak var vwNavMain: UIView?
    
    // MARK: - Variables
    private var arrCategory : [JobCategoryModel] = []
    private var userProfileData : UserProfileModel?
    
    //var selecetdJobApplicant : JobApplicantsModel?
    
    var selectedCaregiverID : String = ""
    var isFromHire : Bool = false
    var selectedJobID : String = ""
    
    var appnav : UINavigationController?
    var isfromSubstitude : Bool = false
    
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
        
        self.vwPersonalDetailSub?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        self.vwWorkExperienceSub?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        
        self.vwVaccinetedMain?.clipsToBounds = true
        self.vwVaccinetedMain?.cornerRadius = (self.vwVaccinetedMain?.frame.width ?? 0.0) / 2
        self.vwVaccinetedMain?.shadow(UIColor.CustomColor.gradiantColorBottom, radius: 6.0, offset: CGSize(width: 4, height: 8), opacity: 0.5)
        self.vwVaccinetedMain?.maskToBounds = false
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
}

// MARK: - Init Configure
extension CaregiverProfileViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblUserName?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 33.0))
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        
        //self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
        //self.lblSubHeader?.textColor = UIColor.CustomColor.textConnectLogin
    
        self.vwProfileRound?.backgroundColor = UIColor.CustomColor.gradiantColorBottom
        
        delay(seconds: 0.2) {
            if let vw = self.vwProfileRound {
                //vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
                //vw.circleCorner = true
                vw.cornerRadius = vw.frame.height / 2.0
            }
        }
        
        self.cvCategory?.delegate = self
        self.cvCategory?.dataSource = self
        self.cvCategory?.register(CategoryListCell.self)
        
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
        
        
        self.lblComplateProfileHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblComplateProfileHeader?.textColor = UIColor.CustomColor.whitecolor
        
        self.lblAvailibilityHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblAvailibilityHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblComplateProfileSubHeader?.textColor = UIColor.CustomColor.tutorialColor
        self.lblComplateProfileSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
        
        self.lblAvailibilitySubHeader?.textColor = UIColor.CustomColor.tutorialColor
        self.lblAvailibilitySubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
        
        self.imgLeftAvailibility?.tintColor = UIColor.CustomColor.tabBarColor
        self.imgLeftComplateProfile?.tintColor = UIColor.CustomColor.whitecolor
        
        self.vwNavMain?.isHidden = !self.isfromSubstitude
        
        self.setupESInfiniteScrollinWithTableView()
        self.getCaregiverMyProfile()
    }
    
    private func configureNavigationBar(){
        if self.isfromSubstitude {
            
            appNavigationController?.setNavigationBarHidden(true, animated: false)
            appNavigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            
            appNavigationController?.setNavigationBarHidden(true, animated: true)
            appNavigationController?.navigationBar.backgroundColor = UIColor.clear
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            
            appNavigationController?.appNavigationControllersetTitleWithBack(title: "", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
            
            navigationController?.navigationBar
                .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
            navigationController?.navigationBar.removeShadowLine()
        }
    }
}

//MARK: Pagination tableview Mthonthd
extension CaregiverProfileViewController {
    
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

//MARK: - Tableview Observer
extension CaregiverProfileViewController {
    
    private func addTableviewOberver(){
        self.cvCategory?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver(){
        if self.cvCategory?.observationInfo != nil {
            self.cvCategory?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
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
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension CaregiverProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryListCell.self)
        cell.isFromProfile = true
        if self.arrCategory.count > 0{
            cell.lblCategoryName?.text = self.arrCategory[indexPath.row].name
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
        if self.arrCategory.count > 0 {
            let obj = self.arrCategory[indexPath.row]
            fontsize = obj.name.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)))
        }
        return CGSize(width: fontsize + 40.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}

// MARK: - IBAction
extension CaregiverProfileViewController {
    @IBAction func btnComplateProfileClicked(_ sender: UIButton) {
        if let obj = self.userProfileData {
            self.appnav?.push(CaregiverComplateProfileViewController.self,configuration: { vc in
                vc.userProfileData = obj
                vc.appnav = self.appnav
                vc.isfromSubstitude = self.isfromSubstitude
            })
        }
    }
    @IBAction func btnAvailibilityClicked(_ sender: UIButton) {
        if let obj = self.userProfileData {
            self.appnav?.push(CaregiverProfileAvailibilityViewController.self,configuration: { vc in
                vc.userProfileData = obj
                vc.appnav = self.appnav
                vc.isfromSubstitude = self.isfromSubstitude
            })
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.appnav?.popViewController(animated: true)
    }
}

// MARK: - API Call
extension CaregiverProfileViewController {
    private func getCaregiverMyProfile(){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kcaregiverId : selectedCaregiverID
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            
            UserProfileModel.getCaregiverProfile(with: param, success: { (user,msg) in
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
            
            self.lblSuccessCount?.text = obj.successPercentage//.doubleValue.convertDoubletoString(digits: 2)
            self.lblJobCount?.text = obj.totalJobs
            self.lblHoursCount?.text = obj.totalJobsHours
            
            self.vwVaccinetedMain?.isHidden = obj.familyVaccinated == "2"
        }
    }
}

// MARK: - ViewControllerDescribable
extension CaregiverProfileViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CaregiverProfileViewController: AppNavigationControllerInteractable { }

