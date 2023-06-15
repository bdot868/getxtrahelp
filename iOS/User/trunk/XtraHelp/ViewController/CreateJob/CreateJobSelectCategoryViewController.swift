//
//  CreateJobSelectCategoryViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobSelectCategoryViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTopHeader: UILabel?
    @IBOutlet weak var vwTop: UIView?
    
    //PersonalDetail
   
    @IBOutlet weak var tblCategory: UITableView?
    
    //StartCAneclJob
    @IBOutlet weak var vwBottomJobCancelStartMain: UIView?
    @IBOutlet weak var vwJobCancelMain: UIView?
    @IBOutlet weak var vwJobStartMain: UIView?
    @IBOutlet weak var lblJobCancel: UILabel?
    @IBOutlet weak var lblJobStart: UILabel?
    
    // MARK: - Variables
    private var arrCategory : [JobCategoryModel] = []
    private var arrSubCategory : [JobSubCategoryModel] = []
    private var selectedCategory : JobCategoryModel?
    var isFromHome : Bool = false
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
    }

}

// MARK: - Init Configure
extension CreateJobSelectCategoryViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTopHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        
        [self.lblJobCancel,self.lblJobStart].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size:15.0))
        })
        
        self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        
        self.tblCategory?.register(JobSubCategoryTableCell.self)
        self.tblCategory?.estimatedRowHeight = 100.0
        self.tblCategory?.rowHeight = UITableView.automaticDimension
        self.tblCategory?.register(headerFooterViewType: JobCategoryTableHeaderCell.self)
        self.tblCategory?.estimatedSectionHeaderHeight = 100.0
        self.tblCategory?.sectionHeaderHeight = UITableView.automaticDimension
        self.tblCategory?.delegate = self
        self.tblCategory?.dataSource = self
        
        self.vwTop?.isHidden = self.isFromHome
        //self.vwBottomJobCancelStartMain?.isHidden = self.isFromHome
        self.vwJobCancelMain?.isHidden = self.isFromHome
        
        self.getJobCategoryListAPICall()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        self.title = self.isFromHome ? "Categories" : ""
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
    
}

//MARK:- UITableView Delegate
extension CreateJobSelectCategoryViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.selectedCategory {
            let obj = self.arrCategory[section]
            return (obj.jobCategoryId == data.jobCategoryId) ? self.arrCategory[section].subCategory.count : 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: JobSubCategoryTableCell.self)
        if self.arrCategory.count > 0 &&  self.arrCategory[indexPath.section].subCategory.count > 0 {
            let obj = self.arrCategory[indexPath.section].subCategory[indexPath.row]
            cell.setCreateJobSubCategoriesData(obj: obj)
            cell.delegate = self
            /*if let data = self.selectedCategory {
                //cell.setSubCategoryData(obj: obj.subCategory)
                cell.btnSelect?.isHidden = !(data.jobCategoryId == obj.jobCategoryId)
                //cell.cvCategories?.isHidden = !(data.jobCategoryId == obj.jobCategoryId)
            } else {
                //cell.setSubCategoryData(obj: [])
                cell.btnSelect?.isHidden = true
                //cell.cvCategories?.isHidden = true
            }*/
            
            //cell.btnSelectMain?.tag = indexPath.row
            //cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
            
            //cell.btnSubCategory?.tag = indexPath.row
           // cell.btnSubCategory?.addTarget(self, action: #selector(self.btnCategoryDescClicked(_:)), for: .touchUpInside)
            
           // cell.layoutIfNeeded()
            //cell.updateConstraints()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = tableView.dequeueReusableHeaderFooterView(JobCategoryTableHeaderCell.self)
        if !self.arrCategory.isEmpty {
            let obj = self.arrCategory[section]
            hView?.setCategoryData(obj: obj)
            
            hView?.btnSelectMain?.tag = section
            hView?.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
            
            hView?.btnSubCategory?.tag = section
            hView?.btnSubCategory?.addTarget(self, action: #selector(self.btnCategoryDescClicked(_:)), for: .touchUpInside)
        }
        return hView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130.0//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnCategoryDescClicked(_ btn : UIButton){
        
        if self.arrCategory.count > 0 {
            self.appNavigationController?.present(PopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.selectedCategory = self.arrCategory[btn.tag]
                vc.isFromCategory = true
            })
        }
    }
    
    @objc func btnSelectCategoryClicked(_ btn : UIButton){
       // if !self.isFromHome {
        
        
            if self.arrCategory.count > 0 {
                if let obj = self.selectedCategory {
                    if obj.jobCategoryId != self.arrCategory[btn.tag].jobCategoryId {
                        self.selectedCategory = self.arrCategory[btn.tag]
                       // delay(seconds: 0.1) {
                            self.tblCategory?.reloadData()
                       // }
                    }
                } else {
                    self.selectedCategory = self.arrCategory[btn.tag]
                    self.tblCategory?.reloadData()
                }
            }
        /*} else {
            if self.arrCategory.count > 0 {
                let obj = self.arrCategory[btn.tag]
                self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.push(SearchViewController.self,configuration: { vc in
                    vc.selecetdCategory = obj
                })
            }
        }*/
    }
}

// MARK: - IBAction
extension CreateJobSelectCategoryViewController : JobSubCategoryDelegate {
    func selectSubCategoryData(isSelectSubCategory: Bool, cell: JobSubCategoryTableCell) {
        if let indexpath = self.tblCategory?.indexPath(for: cell) {
            if self.arrCategory.count > 0 {
                let objCat = self.arrCategory[indexpath.section]
                if objCat.subCategory.count > 0 {
                    let objSubCat = objCat.subCategory[indexpath.row]
                    objSubCat.isSelectSubCategory = isSelectSubCategory
                }
            }
        }
    }
}

// MARK: - IBAction
extension CreateJobSelectCategoryViewController {
    
    private func validateFields() -> String? {
        if let data = self.selectedCategory {
            let filter = self.arrCategory.filter({$0.jobCategoryId == data.jobCategoryId}).filter({$0.subCategory.filter({$0.isSelectSubCategory}).count > 0})
            return filter.count > 0 ? nil : AppConstant.ValidationMessages.kEmptyJobSubCategory
            
        }
        return AppConstant.ValidationMessages.kEmptyJobCategory
    }
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage, themeStyle: .warning,presentationStyle: .top)
            return
        }
        if let data = self.selectedCategory,let user = UserModel.getCurrentUserFromDefault() {
            let arrCat = self.arrCategory.filter({$0.jobCategoryId == data.jobCategoryId})
            if let first = arrCat.first {
                let subarr : [String] = first.subCategory.filter({$0.isSelectSubCategory}).map({$0.jobSubCategoryId})
                if self.isFromHome {
                    self.appNavigationController?.push(SearchViewController.self,configuration: { vc in
                        vc.selecetdCategory = data
                    })
                } else {
                    let paramDict : [String:Any] = [
                        kcategoryId : data.jobCategoryId,
                        ksubCategoryId : subarr,
                        klangType : XtraHelp.sharedInstance.languageType,
                        ktoken : user.token
                    ]
                    self.appNavigationController?.push(CreateJobHelpeCaregiverPreferencesViewController.self,configuration: { vc in
                        vc.paramDict = paramDict
                        if let catObj = self.selectedCategory {
                            vc.selectedCategory = catObj
                        }
                    })
                }
            }
            
        }
    }
    
    @IBAction func btnFAQClicked(_ sender: UIButton) {
        self.appNavigationController?.push(FAQViewController.self)
    }
}

// MARK: - API Call
extension CreateJobSelectCategoryViewController {
    private func getJobCategoryListAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                ksearch : ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobCategoryModel.getJobCategoryList(with: param, success: { (arr,msg) in
                self.arrCategory = arr
                //DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.tblCategory?.reloadData()
                    self.tblCategory?.beginUpdates()
                    self.tblCategory?.endUpdates()
                    self.tblCategory?.layoutIfNeeded()
                }
                   // self.tblCategory?.layoutIfNeeded()
                //}
                
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension CreateJobSelectCategoryViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateJobSelectCategoryViewController: AppNavigationControllerInteractable { }

