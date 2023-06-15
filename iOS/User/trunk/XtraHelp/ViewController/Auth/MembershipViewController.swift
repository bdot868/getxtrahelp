//
//  MembershipViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

enum MembershipPlanEnum : Int{
    case Silver
    case Gold
    case Premium
    
    var apiValue : String{
        switch self {
        case .Silver:
            return "0"
        case .Gold:
            return "1"
        case .Premium:
            return "2"
        }
    }
    
    var tabName : String{
        switch self {
        case .Silver:
            return "Silver"
        case.Gold:
            return "Gold"
        case .Premium:
            return "Premium"
        }
    }
    
    var colorname : UIColor{
        
        switch self {
        case .Silver:
            return #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        case.Gold:
            return #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        case .Premium:
            return #colorLiteral(red: 0.831372549, green: 0.831372549, blue: 0.831372549, alpha: 1)
        }
    }
    
    var membershipDescData : [String]{
        
        switch self {
        case .Silver:
            return ["14 days free trial","Basic listing (above free)","Video intro","Up to 3 - Skills & Categories","6 monthly sessions","Max 20 people in a session","Referral Program","6 monthly sessions","Accounting Tools and Resources","2 Blogs a month","In app social feed"]
        case.Gold:
            return ["14 days free trial","Listing at the top","2-3 Videos","Access to Dashboard","Up to 5 - S & C","12 monthly sessions","Workshops","Accounting Tools and Resources","Max 50 people in a session","Referral Program","Marketing Tools","Max 50 people in a session","Referral Program","Marketing Tools","5 Blogs a month","In app social feed"]
        case .Premium:
            return ["14 days free trial","Special (tick) and priority listing","Success manager - (once a month)","5 Videos","Access to Dashboard","Up to 15 - S &C","30 monthly session","Accounting Tools and Resources","Workshops (5)","Max 100 people in a session","Referral Program","Marketing Tools","10 Blogs a month","In app social feed"]
        }
    }
}

class MembershipViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var cvPlan: FSPagerView?
    
    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var tblMembership: UITableView?
    
    @IBOutlet weak var constraintTblMemberShipDescHeight: NSLayoutConstraint?
    
    @IBOutlet weak var btnSubscribe: XtraHelpButton!
    @IBOutlet weak var btnContinueFree: UIButton?
    // MARK: - Variables
    private var arrPlan : [MembershipPlanEnum] = [.Silver,.Gold,.Premium]
    private var arrMembershipDesc : [String] = ["14 days free trial","Basic listing (above free)","Video intro","Up to 3 - Skills & Categories","6 monthly sessions","Max 20 people in a session","Referral Program","6 monthly sessions","Accounting Tools and Resources","2 Blogs a month","In app social feed"]
    var isFromLogin : Bool = false
    var isFromSideMenu : Bool = false
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}

// MARK: - Init Configure
extension MembershipViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblMembership?.register(MembershipContentCell.self)
        self.tblMembership?.estimatedRowHeight = 100.0
        self.tblMembership?.rowHeight = UITableView.automaticDimension
        self.tblMembership?.delegate = self
        self.tblMembership?.dataSource = self
        
        self.btnContinueFree?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.btnContinueFree?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 9.0))
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        
        self.cvPlan?.dataSource = self
        self.cvPlan?.delegate = self
        self.cvPlan?.register(UINib.init(nibName: CellIdentifier.kMembershipPriceCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.kMembershipPriceCell)
        self.cvPlan?.interitemSpacing = 30.0
        self.cvPlan?.transformer = FSPagerViewTransformer(type: .linear)
        
        if let cv = self.cvPlan {
            cv.itemSize = CGSize(width: ScreenSize.SCREEN_WIDTH - 90.0, height: cv.frame.height)
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isFromDirect: self.isFromLogin)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: - Tableview Observer
extension MembershipViewController {
    
    private func addTableviewOberver() {
        self.tblMembership?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblMembership?.observationInfo != nil {
            self.tblMembership?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblMembership && keyPath == ObserverName.kcontentSize {
                self.constraintTblMemberShipDescHeight?.constant = self.tblMembership?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension MembershipViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMembershipDesc.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: MembershipContentCell.self)
        if self.arrMembershipDesc.count > 0 {
            cell.lblSubDesc?.text = self.arrMembershipDesc[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - FSPagerView Delegage & Datasource
extension MembershipViewController : FSPagerViewDataSource,FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.arrPlan.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.kMembershipPriceCell, at: index) as? MembershipPriceCell {
            if self.arrPlan.count > 0 {
                cell.setMembershipData(obj: self.arrPlan[index])
            }
            cell.layoutIfNeeded()
            return cell
        }
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
       
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        print(targetIndex)
        if self.arrPlan.count > 0 {
            self.arrMembershipDesc = self.arrPlan[targetIndex].membershipDescData
            self.tblMembership?.reloadData()
        }
    }
}

// MARK: - IBAction
extension MembershipViewController {
    @IBAction func btnSubscribeClicked(_ sender: XtraHelpButton) {
        //self.appNavigationController?.push(SignupPersonalDetailViewController.self)
        if isFromSideMenu {
            self.appNavigationController?.popViewController(animated: true)
        } else {
            self.updateProfileStatus()
        }
    }
    @IBAction func btnContinueFreeClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(SignupPersonalDetailViewController.self)
        if isFromSideMenu {
            self.appNavigationController?.popViewController(animated: true)
        } else {
            self.updateProfileStatus()
        }
    }
}

//MARK : - API Call
extension MembershipViewController{
    
    func updateProfileStatus() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kprofileStatus : "1"
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.saveSignupProfileDetails(with: param,type: .Subscription, success: { (model, msg) in
                self.appNavigationController?.push(SignupPersonalDetailViewController.self,configuration: { (vc) in
                    vc.isFromLogin = true
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
extension MembershipViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension MembershipViewController: AppNavigationControllerInteractable { }
