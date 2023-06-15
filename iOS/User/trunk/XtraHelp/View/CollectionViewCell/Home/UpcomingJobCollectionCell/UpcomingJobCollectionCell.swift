//
//  UpcomingJobCollectionCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 26/11/21.
//

import UIKit

class UpcomingJobCollectionCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwProfileSub: UIView?
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var vwChatMain: UIView?
    @IBOutlet weak var vwMapMain: UIView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblChat: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    @IBOutlet weak var btnChat: UIButton?
    @IBOutlet weak var btnMap: UIButton?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    // MARK: - Variables
    
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
        self.lblChat?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblChat?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 17.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.appColor
        self.lblTime?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
    }
    
    func setUpComingJobData(obj : JobModel){
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUserName?.text = obj.userFullName
        self.lblChat?.text = obj.name
        self.lblTime?.text = obj.startDateTime
    }
}

// MARK: - NibReusable
extension UpcomingJobCollectionCell: NibReusable { }
