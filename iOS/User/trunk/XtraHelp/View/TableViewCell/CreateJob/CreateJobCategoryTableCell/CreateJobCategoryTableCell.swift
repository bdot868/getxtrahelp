//
//  CreateJobCategoryTableCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobCategoryTableCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    @IBOutlet weak var vwOverlay: UIView?
    
    @IBOutlet weak var lblCategoryName: UILabel?
    @IBOutlet weak var lblCategoryPrice: UILabel?
    
    @IBOutlet weak var imgCategory: UIImageView?
    
    @IBOutlet weak var stackTextCategory: UIStackView?
    
    @IBOutlet weak var btnSelect: UIButton?
    @IBOutlet weak var btnSelectMain: UIButton?
    @IBOutlet weak var btnSubCategory: UIButton?
    
    @IBOutlet weak var cvCategories: UICollectionView?
    @IBOutlet weak var constraintcvCategoriesHeight: NSLayoutConstraint?
    
    // MARK: - Variables
    private var arrSubCategory : [JobSubCategoryModel] = []
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        self.vwMain?.cornerRadius = 20.0
        self.imgCategory?.cornerRadius = 20.0
        self.vwOverlay?.cornerRadius = 20.0
        self.vwOverlay?.backgroundColor = UIColor.CustomColor.black50Per
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.whitecolor
        self.lblCategoryName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblCategoryPrice?.textColor = UIColor.CustomColor.CategoryPricecolor
        self.lblCategoryPrice?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        //self.vwMain?.borderWidth = 2.0
        
        self.cvCategories?.register(AboutYourLovedSpecialitiesCell.self)
        self.cvCategories?.delegate = self
        self.cvCategories?.dataSource = self
        
        self.addTableviewOberver()
    }
    
    func setCategoryData(obj : JobCategoryModel){
        self.lblCategoryName?.text = obj.name
        self.imgCategory?.setImage(withUrl: obj.imageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        
        self.lblCategoryPrice?.isHidden = true
        
        //self.setSubCategoryData(obj: obj.subCategory)
    }
    
    func setSubCategoryData(obj : [JobSubCategoryModel]){
        self.arrSubCategory = obj
        DispatchQueue.main.async {
            self.cvCategories?.reloadData()
            //self.cvCategories?.layoutIfNeeded()
        }
    }
    
}

//MARK: - Tableview Observer
extension CreateJobCategoryTableCell {
    
    private func addTableviewOberver() {
        self.cvCategories?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.cvCategories?.observationInfo != nil {
            self.cvCategories?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UICollectionView {
            if obj == self.cvCategories && keyPath == ObserverName.kcontentSize {
                self.constraintcvCategoriesHeight?.constant = self.cvCategories?.contentSize.height ?? 0.0
                self.cvCategories?.layoutIfNeeded()
            }
        }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension CreateJobCategoryTableCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AboutYourLovedSpecialitiesCell.self)
        cell.vwSelectAbout?.isHidden = true
        if self.arrSubCategory.count > 0 && indexPath.row < self.arrSubCategory.count{
            let obj = self.arrSubCategory[indexPath.row]
            cell.setCreateJobSubCategoriesData(obj: obj)
        }
        cell.btnSelectMain?.tag = indexPath.row
        cell.btnSelectMain?.addTarget(self, action: #selector(self.btnSelectCategoryClicked(_:)), for: .touchUpInside)
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if self.arrSubCategory.count > 0 {
                let obj = self.arrSubCategory[indexPath.row]
                return CGSize(width: (collectionView.frame.size.width / 2) - 10.0, height: XtraHelp.sharedInstance.estimatedHeightOfLabel(text: obj.name) + 35.0)
            }
        return CGSize(width: 0 , height: 0)
    }
    
    @objc func btnSelectCategoryClicked(_ btn : UIButton){
        if self.arrSubCategory.count > 0 {
            let obj = self.arrSubCategory[btn.tag]
            obj.isSelectSubCategory = !obj.isSelectSubCategory
            self.cvCategories?.reloadData()
        }
    }
}

// MARK: - NibReusable
extension CreateJobCategoryTableCell : NibReusable {}
