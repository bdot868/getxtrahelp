//
//  MyJobParentViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 27/11/21.
//

import UIKit

enum SegmentJobTabEnum : Int{
    case Upcoming
    case Posted
    case Completed
    case Substitute
    
    var apiValue : String{
        switch self {
        case .Upcoming:
            return "1"
        case .Completed:
            return "2"
        case .Posted:
            return "3"
        case .Substitute:
            return "4"
        }
    }
    
    var name : String{
        switch self {
        case .Upcoming:
            return "Upcoming"
        case .Completed:
            return "Completed"
        case .Posted:
            return "Posted"
        case .Substitute:
            return "Substitute"
        }
    }
}

class MyJobParentViewController: UIViewController {

    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var vwSegmentMain: UIView?
    @IBOutlet weak var vwSearchMain: UIView?
    @IBOutlet weak var vwSearch: SearchView?
    @IBOutlet weak var vwContentMain: UIView?
    @IBOutlet weak var vwContainerMain: UIView?
    
    @IBOutlet weak var vwSegmentUpcoming: SegmentTabView?
    @IBOutlet weak var vwSegmentCompleted: SegmentTabView?
    @IBOutlet weak var vwSegmentApplied: SegmentTabView?
    
    @IBOutlet weak var btnFilter: UIButton?
    
    @IBOutlet weak var lblTotalWorkTimeHeader: UILabel?
    @IBOutlet weak var lblTotalWorkTimeValue: UILabel?
    
    @IBOutlet weak var cvSegment: UICollectionView?
    
    let tabs = [
        ViewPagerTab(title: "Upcoming", image: nil),
        ViewPagerTab(title: "Posted", image: nil),
        ViewPagerTab(title: "Completed", image: nil),
        ViewPagerTab(title: "Substitute", image: nil)
    ]
    private var options = ViewPagerOptions()
    private var pager:ViewPager?
    
    // MARK: - Variables
    private var selecetdTab : SegmentJobTabEnum = .Upcoming
    
    private var arrSegment : [SegmentJobTabEnum] = [.Upcoming,.Posted,.Completed,.Substitute]
    
    private var arrFilterJobCatagories : [JobCategoryModel] = []
    private var filterNewestOldest : String = ""
    private var filterTopRated : String = ""
    private var filterOnline : String = ""
    private var filterAvailability : String = ""
    private var filterCustmeDate : Date?
    private var filterWorkingType : String = ""
    private var filterGender : String = ""
    private var filterStartAge: Int = 0
    private var filterEndAge: Int = 100
    private var filterStartDistance: Int = 0
    private var filterEndDistance: Int = 100
    private var filterVaccineted: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.appNavigationController?.attachLeftSideMenu()
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
    }
    
    deinit {
        print("Memory Deallocation")
    }
}

// MARK: - Init Configure
extension MyJobParentViewController {
    private func InitConfig(){
       
        
        self.vwSegmentUpcoming?.btnSelectTab?.tag = SegmentJobTabEnum.Upcoming.rawValue
        self.vwSegmentCompleted?.btnSelectTab?.tag = SegmentJobTabEnum.Completed.rawValue
        self.vwSegmentApplied?.btnSelectTab?.tag = SegmentJobTabEnum.Posted.rawValue
        
        [self.vwSegmentUpcoming,self.vwSegmentCompleted,self.vwSegmentApplied].forEach({
            $0?.segmentDelegate = self
        })
        
        self.cvSegment?.delegate = self
        self.cvSegment?.dataSource = self
        self.cvSegment?.register(JobSegmentCell.self)
       
        let alignedFlowLayout = self.cvSegment?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        
        
        
        self.options.tabType = .basic
        self.options.distribution = .normal
        
        // if let option = self.options {
        //ViewPager(viewController: self, containerView: self.vwContentMain)
        self.pager = ViewPager(viewController: self, containerView: self.vwContentMain)//ViewPager(viewController: self)
        self.options.tabViewHeight = 0.0
        self.options.isTabIndicatorAvailable = false
        self.pager?.setOptions(options: self.options)
        self.pager?.setDataSource(dataSource: self)
        self.pager?.setDelegate(delegate: self)
        self.pager?.build()
        
        if let obj = XtraHelp.sharedInstance.setJobEndSelecetdTab {
            XtraHelp.sharedInstance.setJobEndSelecetdTab = nil
            self.selecetdTab = obj
            self.setSelectedTab(obj: self.selecetdTab, index: self.selecetdTab.rawValue)
        }
        
        //self.setSelectedTab(obj: self.selecetdTab, index: 0)
        
        self.vwSearch?.txtSearch?.returnKeyType = .search
        self.vwSearch?.txtSearch?.delegate = self
        self.vwSearch?.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
        
        self.lblTotalWorkTimeValue?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTotalWorkTimeValue?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))
        
        self.lblTotalWorkTimeHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTotalWorkTimeHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 16.0))
    }
}

//MARK:- SegmentTabDelegate
extension MyJobParentViewController : SegmentTabDelegate {
    
    func tabSelect(_ sender: UIButton) {
        self.setSelectedTab(obj: SegmentJobTabEnum(rawValue: sender.tag) ?? .Upcoming, index: sender.tag)
    }
    
    private func setSelectedTab(obj : SegmentJobTabEnum, isUpdateVC : Bool = true,index : Int){
        /*switch obj {
        case .Upcoming:
            self.vwSegmentUpcoming?.isSelectTab = true
            self.vwSegmentCompleted?.isSelectTab = false
            self.vwSegmentApplied?.isSelectTab = false
            self.selecetdTab = .Upcoming
            break
        case .Completed:
            self.vwSegmentUpcoming?.isSelectTab = false
            self.vwSegmentCompleted?.isSelectTab = true
            self.vwSegmentApplied?.isSelectTab = false
            self.selecetdTab = .Completed
            break
        case .Posted:
            self.vwSegmentUpcoming?.isSelectTab = false
            self.vwSegmentCompleted?.isSelectTab = false
            self.vwSegmentApplied?.isSelectTab = true
            self.selecetdTab = .Posted
            break
        case .Substitute:
            break
        }*/
        self.cvSegment?.reloadData()
        self.cvSegment?.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: true)
        
        if isUpdateVC {
            self.pager?.displayViewController(atIndex: obj.rawValue)
        }
    }
    
    /*func tabSelect(_ sender: UIButton) {
        self.setSelectedTab(obj: SegmentSessionTabEnum(rawValue: sender.tag) ?? .Upcoming)
        switch SegmentSessionTabEnum(rawValue: sender.tag) ?? .Upcoming {
        case .All:
            self.selecetdTab = .All
        case .Upcoming:
            self.selecetdTab = .Upcoming
            break
        case .Completed:
            self.selecetdTab = .Completed
            break
        case .Applied:
            self.selecetdTab = .Applied
            break
        }
        
        self.setSelectedTab(obj: self.selecetdTab)
        
    }*/
    
    /*private func setSelectedTab(obj : SegmentSessionTabEnum){
        switch obj {
        case .All:
            self.vwSegmentAll?.isSelectTab = true
            self.vwSegmentUpcoming?.isSelectTab = false
            self.vwSegmentCompleted?.isSelectTab = false
            self.vwSegmentApplied?.isSelectTab = false
            self.selecetdTab = .All
        case .Upcoming:
            self.vwSegmentAll?.isSelectTab = false
            self.vwSegmentUpcoming?.isSelectTab = true
            self.vwSegmentCompleted?.isSelectTab = false
            self.vwSegmentApplied?.isSelectTab = false
            self.selecetdTab = .Upcoming
            break
        case .Completed:
            self.vwSegmentAll?.isSelectTab = false
            self.vwSegmentUpcoming?.isSelectTab = false
            self.vwSegmentCompleted?.isSelectTab = true
            self.vwSegmentApplied?.isSelectTab = false
            self.selecetdTab = .Completed
            break
        case .Applied:
            self.vwSegmentAll?.isSelectTab = false
            self.vwSegmentUpcoming?.isSelectTab = false
            self.vwSegmentCompleted?.isSelectTab = false
            self.vwSegmentApplied?.isSelectTab = true
            self.selecetdTab = .Applied
            break
        }
    }*/
}
// MARK: - ViewPagerDataSource
extension MyJobParentViewController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        
        if let vc = self.storyboard?.getViewController(with: VCIdentifier.MyJobChildViewController) as? MyJobChildViewController {
            vc.selecetdTab = SegmentJobTabEnum(rawValue: position) ?? .Upcoming
            
            return vc
        }
        return UIViewController()
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

// MARK: - ViewPagerDelegate
extension MyJobParentViewController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        self.selecetdTab = SegmentJobTabEnum(rawValue: index) ?? .Upcoming
        self.setSelectedTab(obj: self.selecetdTab,isUpdateVC : false, index: index)
        print("Moved to page \(index)")
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension MyJobParentViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSegment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JobSegmentCell.self)
        
        if self.arrSegment.count > 0{
            let obj = self.arrSegment[indexPath.row]
            cell.lblTabName?.text = obj.name
            cell.isSelectTab = obj == self.selecetdTab
            cell.isHideRightDotView = (indexPath.row == self.arrSegment.count - 1)
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
        if self.arrSegment.count > 0 {
            let obj = self.arrSegment[indexPath.row]
            fontsize = obj.name.widthOfString(usingFont: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0)))
        }
        
        return CGSize(width: fontsize + 40.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if self.arrSegment.count > 0 {
            self.selecetdTab = self.arrSegment[indexPath.row]
            //self.cvSegment?.reloadData()
            
            self.setSelectedTab(obj: self.arrSegment[indexPath.row], index: indexPath.row)
            
            //self.cvSegment?.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension MyJobParentViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if !(textField.isEmpty) {
            //self.reloadCarGiverData()
            NotificationCenter.default.post(name: Notification.Name(NotificationPostname.kSearchJobClick), object: textField.text ?? "", userInfo: nil)
        }
        return true
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        if textField.isEmpty {
            //self.reloadCarGiverData()
            NotificationCenter.default.post(name: Notification.Name(NotificationPostname.kSearchJobClick), object: textField.text ?? "", userInfo: nil)
        }
    }
}

// MARK: - IBAction
extension MyJobParentViewController {
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.push(FilterViewController.self,configuration: { vc in
            vc.arrSelectedCategory = self.arrFilterJobCatagories
            vc.filterNewestOldest = self.filterNewestOldest
            vc.filterTopRated = self.filterTopRated
            vc.filterOnline = self.filterOnline
            vc.filterAvailability = self.filterAvailability
            vc.filterCustmeDate = self.filterCustmeDate
            vc.filterWorkingType = self.filterWorkingType
            vc.filterGender = self.filterGender
            vc.filterStartAge = self.filterStartAge
            vc.filterEndAge = self.filterEndAge
            vc.filterStartDistance = self.filterStartDistance
            vc.filterEndDistance = self.filterEndDistance
            vc.filterVaccineted = self.filterVaccineted
            vc.delegate = self
        })
    }
}
// MARK: - filterDelegate
extension MyJobParentViewController :  filterDelegate {
    func selectFilterData(arrCategories: [JobCategoryModel], filterNewestOldest: String, filterTopRated: String, filterOnline: String, filterAvailability: String, filterCustmeDate: Date?, filterWorkingType: String, filterGender: String, filterStartAge: Int, filterEndAge: Int, filterStartDistance: Int, filterEndDistance: Int, filterVaccineted: String) {
        self.arrFilterJobCatagories = arrCategories
        self.filterNewestOldest = filterNewestOldest
        self.filterTopRated = filterTopRated
        self.filterOnline = filterOnline
        self.filterAvailability = filterAvailability
        self.filterCustmeDate = filterCustmeDate
        self.filterWorkingType = filterWorkingType
        self.filterGender = filterGender
        self.filterStartAge = filterStartAge
        self.filterEndAge = filterEndAge
        self.filterStartDistance = filterStartDistance
        self.filterEndDistance = filterEndDistance
        self.filterVaccineted = filterVaccineted
        
        XtraHelp.sharedInstance.careGiverDelegate?.selectFilterData(arrCategories: arrCategories, filterNewestOldest: filterNewestOldest, filterTopRated: filterTopRated, filterOnline: filterOnline, filterAvailability: filterAvailability, filterCustmeDate: filterCustmeDate, filterWorkingType: filterWorkingType, filterGender: filterGender, filterStartAge: filterStartAge, filterEndAge: filterEndAge, filterStartDistance: filterStartDistance, filterEndDistance: filterEndDistance, filterVaccineted: filterVaccineted)
    }
}

// MARK: - ViewControllerDescribable
extension MyJobParentViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension MyJobParentViewController: AppNavigationControllerInteractable { }
