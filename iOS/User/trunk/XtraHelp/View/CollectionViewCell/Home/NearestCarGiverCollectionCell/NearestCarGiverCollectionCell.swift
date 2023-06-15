//
//  NearestCarGiverCollectionCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 08/12/21.
//

import UIKit

class NearestCarGiverCollectionCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var vwProfileSub: UIView?
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var vwContentText: UIView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblCategory: UILabel?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    // MARK: - Variables
    var isFromJobDetail : Bool = false {
        didSet{
            self.lblCategory?.isHidden = true
            self.lblUserName?.textColor = UIColor.CustomColor.whitecolor
            self.lblUserName?.numberOfLines = 2
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.vwProfileSub?.cornerRadius = (self.vwProfileSub?.frame.height ?? 0) / 2
        self.imgProfile?.cornerRadius = (self.imgProfile?.frame.height ?? 0) / 2
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblCategory?.textColor = UIColor.CustomColor.HomeCategoryColor
        self.lblCategory?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
        
        self.lblUserName?.textColor = UIColor.CustomColor.HomeNearColor
        self.lblUserName?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))
        
    }
    
    func setJobApplicantData(obj : JobApplicantsModel){
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUserName?.text = obj.userFullName
        //self.lblCategory?.text = obj.categoryNames
    }
    
    func setNearestCaregiverData(obj : CaregiverListModel){
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUserName?.text = obj.fullName
        self.lblCategory?.text = obj.categoryNames
    }
}

// MARK: - NibReusable
extension NearestCarGiverCollectionCell: NibReusable { }
