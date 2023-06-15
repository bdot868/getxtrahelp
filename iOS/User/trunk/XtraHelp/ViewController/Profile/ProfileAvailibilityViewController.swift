//
//  ProfileAvailibilityViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 08/12/21.
//

import UIKit

class ProfileAvailibilityViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet weak var calenderView: UIView?
    
    @IBOutlet weak var cvTime: UICollectionView?
    @IBOutlet weak var constraintCVTimeHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwRoundAvailableSub: UIView?
    @IBOutlet weak var vwRoundUnavailableSub: UIView?
    
    @IBOutlet var lblAvailabilityStatus: [UILabel]?
    @IBOutlet weak var lblAvilibilityDateStatus: UILabel?
    
    // MARK: - Variables
    var userProfileData : UserProfileModel?
    private var CalderHeaderCellViewXib : CalenderView?
    
    private var arrAvailibility : [CareGiverAvailibilityModel] = []
    private var arrSlotAvailibility : [CareGiverAvailibilitySlotModel] = []
   
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appNavigationController?.detachLeftSideMenu()
        self.configureNavigationBar()
        self.addTableviewOberver()
        
        self.CalderHeaderCellViewXib = UINib(nibName: "CalenderView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? CalenderView
        CalderHeaderCellViewXib?.frame = self.calenderView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        CalderHeaderCellViewXib?.isFromCaregiverAvailibility = true
        CalderHeaderCellViewXib?.delegate = self
        if let vw = self.CalderHeaderCellViewXib {
            self.calenderView?.addSubview(vw)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [self.vwRoundAvailableSub,self.vwRoundUnavailableSub].forEach({
            $0?.roundedCornerRadius()
        })
    }
    
}
// MARK: - Init Configure
extension ProfileAvailibilityViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblAvilibilityDateStatus?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 18.0))
        self.lblAvilibilityDateStatus?.textColor = UIColor.CustomColor.tabBarColor
       
        self.cvTime?.delegate = self
        self.cvTime?.dataSource = self
        self.cvTime?.register(TimeCell.self)
       // self.cvTime.register(supplementaryViewType: TimeHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        
        let alignedFlowLayout = self.cvTime?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        
        self.lblAvailabilityStatus?.forEach({
            $0.textColor = UIColor.CustomColor.commonLabelColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        })
        
        self.vwRoundAvailableSub?.backgroundColor = UIColor.CustomColor.tabBarColor
        self.vwRoundUnavailableSub?.backgroundColor = UIColor.CustomColor.timeUnavailableColor
        
        self.lblAvilibilityDateStatus?.text = Date().getFormattedString(format: AppConstant.DateFormat.k_EEEE_DD_MMM)
        
        self.geCareGiverAvailibility()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Availability", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: - Tableview Observer
extension ProfileAvailibilityViewController {
    
    private func addTableviewOberver() {
        self.cvTime?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvTime?.observationInfo != nil {
            self.cvTime?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            if obj == self.cvTime && keyPath == ObserverName.kcontentSize {
                self.constraintCVTimeHeight?.constant = self.cvTime?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension ProfileAvailibilityViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == self.cvTime ? 3 : 1
    }*/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSlotAvailibility.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TimeCell.self)
        /*if indexPath.row == 2 || indexPath.row == 3 {
            cell.vwMain?.backgroundColor = UIColor.CustomColor.tabBarColor
            cell.lblTitle?.textColor = UIColor.CustomColor.whitecolor
        } else {
            cell.vwMain?.backgroundColor = UIColor.CustomColor.timeUnavailableColor
            cell.lblTitle?.textColor = UIColor.CustomColor.timeUnavailableTExtColor
        }*/
        if self.arrSlotAvailibility.count > 0 {
            cell.setSloteData(obj: self.arrSlotAvailibility[indexPath.row])
        }
        return cell
    }
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == self.cvTime {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                if let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TimeHeaderView", for: indexPath) as? TimeHeaderView {
                    
                    //reusableview.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 25.0)
                    //reusableview.backgroundColor = UIColor.green
                    /*if indexPath.section == 0 {
                        reusableview.lblTitle.text = "Test"
                    }else if indexPath.section == 1 {
                        reusableview.lblTitle.text = "Test"
                    }else if indexPath.section == 2 {
                        reusableview.lblTitle.text = "Test"
                    }*/
                    
                    //do other header related calls or settups
                    return reusableview
                }
                
            default:  fatalError("Unexpected element kind")
            }
        }
        return UICollectionReusableView()
    }*/
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.cvTime {
            return CGSize(width: collectionView.frame.width, height: 40.0)
        }
        return CGSize.zero
    }*/
    
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
        
            return CGSize(width: (collectionView.frame.size.width/4) - 10, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - IBAction
extension ProfileAvailibilityViewController {
    
}

//MARK: - Tableview Observer
extension ProfileAvailibilityViewController : calenderViewDelegate {
    
    func selectCalenderDate(date: Date) {
        print("Date : \(date.getFormattedString(format: AppConstant.DateFormat.k_dd_MM_yyyy))")
        self.lblAvilibilityDateStatus?.text = date.getFormattedString(format: AppConstant.DateFormat.k_EEEE_DD_MMM)
        if self.arrAvailibility.count > 0 {
            let filter = self.arrAvailibility.filter({$0.date == date.getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
            if let first = filter.first {
                self.lblAvilibilityDateStatus?.text = first.dayAndDate
                self.arrSlotAvailibility = first.slot
                self.cvTime?.reloadData()
            } else {
                self.arrSlotAvailibility.removeAll()
                self.cvTime?.reloadData()
            }
        }
    }
    
    func selectMultipleCalenderDate(arr: [Date]) {
        
    }
    
    func deSelectMultipleCalenderDate(arr: [Date]) {
        
    }
}

//MARK:- API Call
extension ProfileAvailibilityViewController{
    
    private func geCareGiverAvailibility(){
        if let user = UserModel.getCurrentUserFromDefault(),let userdata = self.userProfileData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kcaregiverId : userdata.id
                
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CareGiverAvailibilityModel.getCaregiverAvailability(with: param) { arr, totalpage, msg in
                self.arrAvailibility = arr
                
                let todaydate : String = Date().getFormattedString(format: AppConstant.DateFormat.k_yyyy_MM_dd)
                
                let filter = self.arrAvailibility.filter({$0.date == todaydate})
                
                if filter.count > 0,let first = filter.first {
                    self.lblAvilibilityDateStatus?.text = first.dayAndDate
                    self.arrSlotAvailibility = first.slot
                    self.cvTime?.reloadData()
                    
                    self.CalderHeaderCellViewXib?.selectedDates = [first.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)]
                    
                } else if let first = self.arrAvailibility.first {
                    self.lblAvilibilityDateStatus?.text = first.dayAndDate
                    self.arrSlotAvailibility = first.slot
                    self.cvTime?.reloadData()
                    
                    self.CalderHeaderCellViewXib?.selectedDates = [first.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)]
                }
                
                self.CalderHeaderCellViewXib?.arrAvailibilitySelectedDates = self.arrAvailibility.map({$0.date.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd)})
            } failure: { statuscode, error, customError in
                self.arrSlotAvailibility.removeAll()
                self.cvTime?.reloadData()
                if !error.isEmpty {
                    //self.showMessage(error, themeStyle: .error)
                    //self.appNavigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension ProfileAvailibilityViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Profile
    }
}

// MARK: - AppNavigationControllerInteractable
extension ProfileAvailibilityViewController: AppNavigationControllerInteractable{}
