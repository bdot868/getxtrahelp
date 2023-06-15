//
//  JobSearchResultCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

class JobSearchResultCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    @IBOutlet weak var vwProfileSub: UIView?
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var vwTypeMain: UIView?
    @IBOutlet weak var vwCatagoryMain: UIView?
    @IBOutlet weak var vwTypeSub: UIView?
    @IBOutlet weak var vwCatagorySub: UIView?
    @IBOutlet weak var vwMileMain: UIView?
    @IBOutlet weak var vwMileSub: UIView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblChat: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var lblCatagory: UILabel?
    @IBOutlet weak var lblType: UILabel?
    @IBOutlet weak var lblJobPrice: UILabel?
    @IBOutlet weak var lblJobMile: UILabel?
    
    @IBOutlet weak var imgProfile: UIImageView?
   
    // MARK: - Variables
    
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
        self.vwProfileSub?.cornerRadius = (self.vwProfileSub?.frame.height ?? 0) / 2
        self.imgProfile?.cornerRadius = (self.imgProfile?.frame.height ?? 0) / 2
        
        [self.vwCatagoryMain,self.vwTypeMain].forEach({
            $0?.cornerRadius = ($0?.frame.height ?? 0) / 2
        })
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblChat?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblChat?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.appColor
        self.lblTime?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 10.0))
        
        [self.lblCatagory,self.lblType].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        })
        
        [self.vwCatagorySub,self.vwTypeSub].forEach({
            $0?.backgroundColor = UIColor.CustomColor.appColor
            $0?.cornerRadius = 15.0
        })
        
        self.vwMileSub?.backgroundColor = UIColor.CustomColor.priceColor17
        self.vwMileSub?.cornerRadius = 5.0
        
        self.vwMain?.cornerRadius = 20.0
        self.vwMain?.backgroundColor = UIColor.CustomColor.whitecolor
        
        self.lblJobPrice?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblJobPrice?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.lblJobMile?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblJobMile?.textColor = UIColor.CustomColor.tabBarColor
    }
    
    func setPostedJobData(obj : JobModel){
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUserName?.text = obj.userFullName
        self.lblChat?.text = obj.name
        self.lblTime?.text = obj.startDateTime
        self.lblType?.text = obj.isJob.name //== "1" ? "One Time" : "Recurring"
        self.lblCatagory?.text = obj.CategoryName
        self.lblJobMile?.text = "\(obj.distance) mi"
        //self.lblJobPrice?.setPriceTextLable(firstText: obj.formatedPrice, SecondText: "\hr")//.text = obj.formatedPrice
        self.lblJobPrice?.setPriceTextLable(firstText: obj.formatedPrice, SecondText: "/hr")
    }
}

// MARK: - NibReusable
extension JobSearchResultCell: NibReusable { }
