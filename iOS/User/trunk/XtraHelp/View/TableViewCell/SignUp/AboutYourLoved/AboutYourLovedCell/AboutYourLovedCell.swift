//
//  AboutYourLovedCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 07/12/21.
//

import UIKit

protocol AboutYourLovedCellEndEditingDelegate {
    func EndAboutEditing(text : String,cell : AboutYourLovedCell)
    func EndAllergiesEditing(text : String,cell : AboutYourLovedCell)
    func EndOtherCategoryEditing(text : String,cell : AboutYourLovedCell)
    func selectCategory(index : Int,obj : LovedCategoryModel,cell : AboutYourLovedCell)
    func selectSpecialities(index : Int,obj : LovedSpecialitiesModel,cell : AboutYourLovedCell)
    func selectCategoryAbout(obj : LovedCategoryModel)
    func selectCategoryOther(obj : [LovedCategoryModel],cell : AboutYourLovedCell)
}

class AboutYourLovedCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet var lblQuestion: [UILabel]?
    @IBOutlet weak var lblHeader: UILabel?
   
    @IBOutlet weak var vwAbout: ReusableTextview?
    @IBOutlet weak var vwDisabilities: ReusableView?
    @IBOutlet weak var btnDisabilities: UIButton?
    @IBOutlet weak var vwAllergiesMain: UIView?
    @IBOutlet weak var vwAllergies: ReusableView?
    @IBOutlet weak var vwCategoriesOther: ReusableView?
    @IBOutlet weak var vwCategoriesOtherMain: UIView?
    
    @IBOutlet weak var btnRemove: UIButton?
    
    @IBOutlet weak var btnBehavioral: SelectAppButton?
    @IBOutlet weak var btnNonBehavioral: SelectAppButton?
    
    @IBOutlet weak var btnVerbal: SelectAppButton?
    @IBOutlet weak var btnNonVerbal: SelectAppButton?
    
    @IBOutlet weak var btnAllergiesYes: SelectAppButton?
    @IBOutlet weak var btnAllergiesNo: SelectAppButton?
    
    @IBOutlet weak var vwCategoriesMain: UIStackView?
   // @IBOutlet weak var cvCategories: UICollectionView?
    //@IBOutlet weak var constraintcvCategoriesHeight: NSLayoutConstraint?
    @IBOutlet weak var tblCategories: UITableView?
    @IBOutlet weak var constraintTblCategoriesHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwSpecialitiesMain: UIStackView?
    @IBOutlet weak var cvSpecialities: UICollectionView?
    @IBOutlet weak var constraintcvSpecialitiesHeight: NSLayoutConstraint?
    
    
    
    // MARK: - Variables
    private var arrCategory : [LovedCategoryModel] = []
    private var arrSpecialities : [LovedSpecialitiesModel] = []
    var aboutYourLovedDelegate : AboutYourLovedCellEndEditingDelegate?
   
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblQuestion?.forEach({
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
            $0.textColor = UIColor.CustomColor.SubscriptuionSubColor
        })
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0))
        
        [self.cvSpecialities].forEach({
            $0?.register(AboutYourLovedSpecialitiesCell.self)
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        self.tblCategories?.register(AboutLoveCategoryTabelCell.self)
        self.tblCategories?.estimatedRowHeight = 60.0
        self.tblCategories?.rowHeight = UITableView.automaticDimension
        self.tblCategories?.delegate = self
        self.tblCategories?.dataSource = self
        
        self.btnRemove?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
        self.btnRemove?.setTitleColor(UIColor.CustomColor.resourceBtnColor, for: .normal)
        
        self.btnBehavioral?.isSelectBtn = true
        self.btnNonBehavioral?.isSelectBtn = false
        
        self.btnAllergiesNo?.isSelectBtn = true
        self.btnAllergiesYes?.isSelectBtn = false
        
        self.btnVerbal?.isSelectBtn = true
        self.btnNonVerbal?.isSelectBtn = false
        
        [self.vwAllergies,self.vwCategoriesOther].forEach({
            $0?.txtInput.delegate = self
        })
        
        self.vwAbout?.txtInput?.delegate = self
        
        self.addTableviewOberver()
    }
    
    func setAboutLoveData(arrcat : [LovedCategoryModel],arrSpe : [LovedSpecialitiesModel],indexpath : IndexPath,obj : AboutLovedModel){
        self.arrCategory = arrcat
        self.arrSpecialities = arrSpe
        self.lblHeader?.text = "Recipient \(self.getStringByNumber(value: "\(indexpath.row+1)"))"
        self.vwDisabilities?.txtInput.text = obj.lovedDisabilitiesTypeName
        self.btnVerbal?.isSelectBtn = obj.lovedVerbal == "1"
        self.btnNonVerbal?.isSelectBtn = obj.lovedVerbal == "2"
        self.btnBehavioral?.isSelectBtn = obj.lovedBehavioral == "1"
        self.btnNonBehavioral?.isSelectBtn = obj.lovedBehavioral == "2"
        self.vwCategoriesOther?.txtInput.text = obj.lovedOtherCategoryText
        self.vwAllergies?.txtInput.text = obj.allergies
        self.vwAbout?.txtInput?.text = obj.lovedAboutDesc
        //delay(seconds: 0.1) {
        DispatchQueue.main.async {
            //self.cvCategories?.reloadData()
            self.tblCategories?.reloadData()
            self.cvSpecialities?.reloadData()
            self.tblCategories?.layoutIfNeeded()
            //self.cvCategories?.layoutIfNeeded()
            self.cvSpecialities?.layoutIfNeeded()
        }
        self.btnAllergiesYes?.isSelectBtn = (obj.isAllergies) //|| obj.allergies.isEmpty)
        self.btnAllergiesNo?.isSelectBtn = !(obj.isAllergies)
        self.vwAllergiesMain?.isHidden = !obj.isAllergies//obj.isAllergies
        //}
    }
    
    private func getStringByNumber(value : String) -> String{
        if value == "1" {
            return "One"
        } else if value == "2" {
            return "Two"
        } else if value == "3" {
            return "Three"
        } else if value == "4" {
            return "Four"
        } else if value == "5" {
            return "Five"
        } else if value == "6" {
            return "Six"
        } else if value == "7" {
            return "Seven"
        } else if value == "8" {
            return "Eight"
        } else if value == "9" {
            return "Nine"
        } else if value == "10" {
            return "Ten"
        }
        return ""
    }
}

//MARK: - Tableview Observer
extension AboutYourLovedCell {
    
    private func addTableviewOberver() {
        self.tblCategories?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.cvSpecialities?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblCategories?.observationInfo != nil {
            self.tblCategories?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.cvSpecialities?.observationInfo != nil {
            self.cvSpecialities?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            /*if obj == self.cvCategories && keyPath == ObserverName.kcontentSize {
                self.constraintcvCategoriesHeight?.constant = self.cvCategories?.contentSize.height ?? 0.0
                self.cvCategories?.layoutIfNeeded()
            }*/
            if obj == self.cvSpecialities && keyPath == ObserverName.kcontentSize {
                self.constraintcvSpecialitiesHeight?.constant = self.cvSpecialities?.contentSize.height ?? 0.0
                self.cvSpecialities?.layoutIfNeeded()
            }
        }
        
        if let obj = object as? UITableView {
            if obj == self.tblCategories && keyPath == ObserverName.kcontentSize {
                self.constraintTblCategoriesHeight?.constant = self.tblCategories?.contentSize.height ?? 0.0
                self.tblCategories?.layoutIfNeeded()
            }
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension AboutYourLovedCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*if collectionView == self.cvCategories {
            return self.arrCategory.count
        }*/
        return self.arrSpecialities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AboutYourLovedSpecialitiesCell.self)
        /*if collectionView == self.cvCategories {
            if self.arrCategory.count > 0 {
                let obj = self.arrCategory[indexPath.row]
                cell.setCategoriesData(obj: obj)
            }
            cell.btnSelectMain?.tag = indexPath.row
            cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectAbout?.tag = indexPath.row
            cell.btnSelectAbout?.addTarget(self, action: #selector(self.btnSelectAboutCategoryClicked(_:)), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            return cell
        } else*/
        if collectionView == self.cvSpecialities {
            if self.arrSpecialities.count > 0 {
                let obj = self.arrSpecialities[indexPath.row]
                cell.setSpecialitiesData(obj: obj)
            }
            cell.btnSelectMain?.tag = indexPath.row
            cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectSpecialitiesClicked(_:)), for: .touchUpInside)
            cell.layoutIfNeeded()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /*if collectionView == self.cvCategories {
            return 10
        } else if collectionView == self.cvSpecialities {
            return 10
        }*/
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*if collectionView == self.cvCategories {
            if self.arrCategory.count > 0 {
                let obj = self.arrCategory[indexPath.row]
                return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: XtraHelp.sharedInstance.estimatedHeightOfLabel(text: obj.name) + 35.0)
            }
        } else*/ if collectionView == self.cvSpecialities {
            if self.arrSpecialities.count > 0 {
                let obj = self.arrSpecialities[indexPath.row]
                return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: XtraHelp.sharedInstance.estimatedHeightOfLabel(text: obj.name) + 35.0)
            }
        }
        return CGSize(width: 0 , height: 0)
    }
    
    @objc func btnSelectCategoryClicked(_ btn : UIButton){
        if self.arrCategory.count > 0 {
            let obj = self.arrCategory[btn.tag]
            obj.isSelectCategory = !obj.isSelectCategory
            
            if obj.lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) {
                self.vwCategoriesOtherMain?.isHidden = (obj.lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) && obj.isSelectCategory) ? false : true
            }
            /*if obj.lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) && obj.isSelectCategory {
                for i in stride(from: 0, to: self.arrCategory.count, by: 1) {
                    if !self.arrCategory[i].lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) {
                        self.arrCategory[i].isSelectCategory = false
                    }
                    if i == self.arrCategory.count - 1 {
                        self.aboutYourLovedDelegate?.selectCategoryOther(obj: self.arrCategory, cell: self)
                        self.cvCategories?.reloadData()
                    }
                }
            } else {
                for i in stride(from: 0, to: self.arrCategory.count, by: 1) {
                    
                    if self.arrCategory[i].lovedCategoryName.contains(XtraHelp.sharedInstance.OtherCategoryText) && self.arrCategory[i].isSelectCategory {
                        self.arrCategory[i].isSelectCategory = false
                    }
                }
                self.aboutYourLovedDelegate?.selectCategory(index: btn.tag, obj: obj, cell: self)
                self.cvCategories?.reloadData()
            }*/
            
            self.aboutYourLovedDelegate?.selectCategory(index: btn.tag, obj: obj, cell: self)
            self.tblCategories?.reloadData()
        }
    }
    
    @objc func btnSelectAboutCategoryClicked(_ btn : UIButton){
        if self.arrCategory.count > 0 {
            let obj = self.arrCategory[btn.tag]
            self.aboutYourLovedDelegate?.selectCategoryAbout(obj: obj)
        }
    }
    
    @objc func btnSelectSpecialitiesClicked(_ btn : UIButton){
        if self.arrSpecialities.count > 0 {
            let obj = self.arrSpecialities[btn.tag]
            obj.isSelectSpecialities = !obj.isSelectSpecialities
            self.aboutYourLovedDelegate?.selectSpecialities(index: btn.tag, obj: obj, cell: self)
            self.cvSpecialities?.reloadData()
        }
    }
}

//MARK:- UITableView Delegate
extension AboutYourLovedCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: AboutLoveCategoryTabelCell.self)
        if self.arrCategory.count > 0 {
            let obj = self.arrCategory[indexPath.row]
            cell.setCategoriesData(obj: obj)
            
            cell.btnSelectMain?.tag = indexPath.row
            cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
            
            cell.btnSelectAbout?.tag = indexPath.row
            cell.btnSelectAbout?.addTarget(self, action: #selector(self.btnSelectAboutCategoryClicked(_:)), for: .touchUpInside)
            
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

//MARK: - UITextField Delegate Methods
extension AboutYourLovedCell : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.vwAllergies?.txtInput {
            if let del = self.aboutYourLovedDelegate {
                del.EndAllergiesEditing(text: textField.text ?? "", cell: self)
            }
        } else if textField == self.vwCategoriesOther?.txtInput {
            if let del = self.aboutYourLovedDelegate {
                del.EndOtherCategoryEditing(text: textField.text ?? "", cell: self)
            }
        }
        return true
    }
}

//MARK: - UITextView Delegate Methods
extension AboutYourLovedCell : UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == self.vwAbout?.txtInput {
            if let del = self.aboutYourLovedDelegate {
                del.EndAboutEditing(text: textView.text ?? "", cell: self)
            }
        }
        return true
    }
}

// MARK: - NibReusable
extension AboutYourLovedCell: NibReusable { }
