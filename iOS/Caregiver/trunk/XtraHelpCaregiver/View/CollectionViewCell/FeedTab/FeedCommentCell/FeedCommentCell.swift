//
//  FeedCommentCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 25/10/21.
//

import UIKit

class FeedCommentCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblUsername: UILabel?
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblCommentDesc: UILabel?
    @IBOutlet weak var lblReportHeader: UILabel?
    
    @IBOutlet weak var vwProfilemageSub: UIView?
    @IBOutlet weak var vwReportCommentMain: ShadowRadiousView?
    @IBOutlet weak var vwCommentSub: UIView?
    
    @IBOutlet weak var imgProfilemage: UIImageView?
    
    @IBOutlet weak var btnMoreSelect: UIButton?
    @IBOutlet weak var btnReportComment: UIButton?
    
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
        if let img = self.imgProfilemage {
            img.cornerRadius = img.frame.height / 2.0
        }
        
        if let vw = self.vwProfilemageSub {
            vw.cornerRadius = vw.frame.height / 2.0
        }
        
        if let vw = self.vwCommentSub {
            vw.clipsToBounds = true
            vw.backgroundColor = UIColor.CustomColor.whitecolor
            vw.cornerRadius = 6.0
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 3.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblUsername?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUsername?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblDate?.textColor = UIColor.CustomColor.tutorialColor
        self.lblDate?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
        
        self.lblCommentDesc?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblCommentDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblReportHeader?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblReportHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        
        self.vwReportCommentMain?.cornerRadius = 5.0
        //self.vwCommentSub?.cornerRadius = 6.0
    }
    
    func setCommentFeedUserData(obj : FeedUserLikeModel){
        self.imgProfilemage?.setImage(withUrl: obj.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUsername?.text = obj.name
        self.lblDate?.text = obj.formatedCreatedDate
        self.lblCommentDesc?.text = obj.comment.decodingEmoji()
        
    }
}

// MARK: - NibReusable
extension FeedCommentCell: NibReusable { }
