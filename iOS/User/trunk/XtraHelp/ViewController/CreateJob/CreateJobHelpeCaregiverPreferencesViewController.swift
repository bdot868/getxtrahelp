//
//  CreateJobHelpeCaregiverPreferencesViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobHelpeCaregiverPreferencesViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTopHeader: UILabel?
    @IBOutlet var lblSelectionText: [UILabel]?
    @IBOutlet weak var lblAdditionalQuestionHeader: UILabel?
    @IBOutlet weak var lblAdditionalQuestionSubHeader: UILabel?
    
    @IBOutlet weak var tblQuestion: UITableView?
    @IBOutlet weak var constraintTblQuestionsHeight: NSLayoutConstraint?
    
    @IBOutlet weak var btnAddQuestion: UIButton?
    @IBOutlet weak var btnOwnTransportationSelect: UIButton?
    @IBOutlet weak var btnNonSmokerSelect: UIButton?
    @IBOutlet weak var btnMinExperienceSelect: UIButton?
    @IBOutlet weak var btnHasCurrentEmploymentSelect: UIButton?
    
    @IBOutlet weak var vwMinExperience: ReusableView?
    
    //StartCAneclJob
    @IBOutlet weak var vwBottomJobCancelStartMain: UIView?
    @IBOutlet weak var vwJobCancelMain: UIView?
    @IBOutlet weak var vwJobStartMain: UIView?
    @IBOutlet weak var lblJobCancel: UILabel?
    @IBOutlet weak var lblJobStart: UILabel?
    
    // MARK: - Variables
    private var arrQuestion : [AdditionalQuestionModel] = []
    var paramDict : [String:Any] = [:]
    var selectedCategory : JobCategoryModel?
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.addTableviewOberver()
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
        self.removeTableviewObserver()
    }

}

// MARK: - Init Configure
extension CreateJobHelpeCaregiverPreferencesViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        let model = AdditionalQuestionModel.init(UserJobQuestionId: "", JobId: "", Question: "", Id: "", UserId: "", UserJobApplyId: "", Answer: "") //AdditionalQuestionModel.init(UserJobQuestionId: "", JobId: "", Question: "")
        self.arrQuestion.append(model)
        
        self.lblTopHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        
        self.lblAdditionalQuestionHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblAdditionalQuestionHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblAdditionalQuestionSubHeader?.textColor = UIColor.CustomColor.tutorialColor
        self.lblAdditionalQuestionSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.btnAddQuestion?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.btnAddQuestion?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        self.lblSelectionText?.forEach({
            $0.textColor = UIColor.CustomColor.commonLabelColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        })
        
        [self.lblJobCancel,self.lblJobStart].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size:15.0))
        })
        
        
        self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        
        self.tblQuestion?.register(CreateJobAddAdditionQuestionCell.self)
        self.tblQuestion?.estimatedRowHeight = 100.0
        self.tblQuestion?.rowHeight = UITableView.automaticDimension
        self.tblQuestion?.delegate = self
        self.tblQuestion?.dataSource = self
        
        self.vwMinExperience?.txtInput.keyboardType = .numberPad
        
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
    
}

//MARK: - Tableview Observer
extension CreateJobHelpeCaregiverPreferencesViewController {
    
    private func addTableviewOberver() {
        self.tblQuestion?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblQuestion?.observationInfo != nil {
            self.tblQuestion?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblQuestion && keyPath == ObserverName.kcontentSize {
                self.constraintTblQuestionsHeight?.constant = self.tblQuestion?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension CreateJobHelpeCaregiverPreferencesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrQuestion.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: CreateJobAddAdditionQuestionCell.self)
        if self.arrQuestion.count > 0 {
            let obj = self.arrQuestion[indexPath.row]
            cell.vwQuestion.txtInput.text = obj.question
            cell.lblQuestion?.text = "Question \(indexPath.row + 1)"
            
            cell.btnRemove?.isHidden = (self.arrQuestion.count == 1)
            
            cell.btnRemove?.tag = indexPath.row
            cell.btnRemove?.addTarget(self, action: #selector(self.btnDeleteQuestionClicked(_:)), for: .touchUpInside)
            
            cell.delegate = self
            
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    @objc func btnDeleteQuestionClicked(_ btn : UIButton){
        if self.arrQuestion.count > 0 {
            self.arrQuestion.remove(at: btn.tag)
            self.tblQuestion?.reloadData()
        }
    }
}

// MARK: - IBAction
extension CreateJobHelpeCaregiverPreferencesViewController : CreateJobAddAdditionQuestionCellEndEditingDelegate {
    
    func EndQuestionEditing(text: String, cell: CreateJobAddAdditionQuestionCell) {
        if let indexpath = self.tblQuestion?.indexPath(for: cell) {
            if self.arrQuestion.count > 0 {
                self.arrQuestion[indexpath.row].question = text
            }
            self.tblQuestion?.reloadData()
        }
    }
}

// MARK: - IBAction
extension CreateJobHelpeCaregiverPreferencesViewController {
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(CreateJobJobDetailViewController.self)
        if (self.btnMinExperienceSelect?.isSelected ?? false) && (self.vwMinExperience?.txtInput.isEmpty ?? false) {
            self.showMessage(AppConstant.ValidationMessages.kEmptyExperience, themeStyle: .warning,presentationStyle: .top)
            return
        }
        var arr : [[String:Any]] = []
        
        if self.arrQuestion.count > 0 {
            let filter =  self.arrQuestion.filter({!$0.question.isEmpty})
            for i in stride(from: 0, to: filter.count, by: 1) {
                let obj = filter[i]
                if !obj.question.isEmpty {
                    let dic : [String:Any] = [
                        kname : obj.question
                    ]
                    arr.append(dic)
                }
            }
        }
        
        self.paramDict[kownTransportation] = (self.btnOwnTransportationSelect?.isSelected ?? false) ? "1" : "0"
        self.paramDict[knonSmoker] = (self.btnNonSmokerSelect?.isSelected ?? false) ? "1" : "0"
        self.paramDict[kcurrentEmployment] = (self.btnHasCurrentEmploymentSelect?.isSelected ?? false) ? "1" : "0"
        self.paramDict[kminExperience] = (self.btnMinExperienceSelect?.isSelected ?? false) ? "1" : "0"
        self.paramDict[kyearExperience] = self.vwMinExperience?.txtInput.text ?? ""
        self.paramDict[kadditionalQuestions] = arr
        
        self.appNavigationController?.push(CreateJobJobDetailViewController.self,configuration: { vc in
            vc.paramDict = self.paramDict
            if let catObj = self.selectedCategory {
                vc.selectedCategory = catObj
            }
        })
    }
    
    @IBAction func btnOwnTransportationClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.btnOwnTransportationSelect?.isSelected = !(self.btnOwnTransportationSelect?.isSelected ?? false)
    }
    @IBAction func btnNonSmokerClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.btnNonSmokerSelect?.isSelected = !(self.btnNonSmokerSelect?.isSelected ?? false)
    }
    @IBAction func btnMinExperienceClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.btnMinExperienceSelect?.isSelected = !(self.btnMinExperienceSelect?.isSelected ?? false)
        self.vwMinExperience?.isHidden = !(self.btnMinExperienceSelect?.isSelected ?? false)
        if (self.btnMinExperienceSelect?.isSelected ?? false) {
            self.vwMinExperience?.txtInput.becomeFirstResponder()
        } else {
            self.vwMinExperience?.txtInput.resignFirstResponder()
        }
    }
    
    @IBAction func btnHasCurrentEmploymentClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.btnHasCurrentEmploymentSelect?.isSelected = !(self.btnHasCurrentEmploymentSelect?.isSelected ?? false)
    }
    
    @IBAction func btnAddQuestionClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let model = AdditionalQuestionModel.init(UserJobQuestionId: "", JobId: "", Question: "", Id: "", UserId: "", UserJobApplyId: "", Answer: "")
        self.arrQuestion.append(model)
        self.tblQuestion?.reloadData()
    }
}

// MARK: - API Call
extension CreateJobHelpeCaregiverPreferencesViewController {
    
}

// MARK: - ViewControllerDescribable
extension CreateJobHelpeCaregiverPreferencesViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateJobHelpeCaregiverPreferencesViewController: AppNavigationControllerInteractable { }

