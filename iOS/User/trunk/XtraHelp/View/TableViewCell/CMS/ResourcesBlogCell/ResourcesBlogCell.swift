//
//  ResourcesBlogCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 26/11/21.
//

import UIKit

class ResourcesBlogCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwResourcesSub: UIView?
    @IBOutlet weak var vwResourcesMain: UIView?
    @IBOutlet weak var vwCatagoryMain: UIView?
    
    @IBOutlet weak var lblResourceName: UILabel?
    @IBOutlet weak var lblCatagory: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    @IBOutlet weak var imgResources: UIImageView?
    
    // MARK: - Variables
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let vw = self.vwCatagoryMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        }
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblResourceName?.textColor = UIColor.CustomColor.tabBarColor
        self.lblResourceName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.lblCatagory?.textColor = UIColor.CustomColor.whitecolor
        self.lblCatagory?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwCatagoryMain?.cornerRadius = 5.0
        
        self.vwResourcesSub?.cornerRadius = 8.0
        self.imgResources?.cornerRadius = 8.0
    }
    
    func setBlogData(obj : ResourcesAndBlogsModel){
        self.lblResourceName?.text = obj.title
        self.lblTime?.text = obj.createdDateFormat
        self.imgResources?.setImage(withUrl: obj.thumbImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblCatagory?.text = obj.categoryName
    }
}

// MARK: - NibReusable
extension ResourcesBlogCell : NibReusable {}
