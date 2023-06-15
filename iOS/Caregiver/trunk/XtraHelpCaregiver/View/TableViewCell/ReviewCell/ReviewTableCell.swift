//
//  ReviewTableCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-ioskp on 26/10/21.
//

import UIKit

class ReviewTableCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwProfieMain: UIView?
    @IBOutlet weak var vwProfieSub: UIView?
    @IBOutlet weak var vwSepratorMain: UIView?
    @IBOutlet weak var vwRatingrMain: UIView?

    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblReviewDesc: UILabel?
    @IBOutlet weak var lblReviewTime: UILabel?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var vwRating: CosmosView!
    
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
        
        self.vwProfieSub?.cornerRadius = (self.vwProfieSub?.frame.height ?? 0.0) / 2
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblReviewDesc?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblReviewDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblReviewTime?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblReviewTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwSepratorMain?.backgroundColor = UIColor.CustomColor.borderColorSession
    }
    
    func setReviewData(obj : RatingModel){
        self.lblUserName?.text = obj.userFullName
        self.lblReviewDesc?.text = obj.feedback
        self.lblReviewTime?.text = obj.reviewDate
        
        self.vwRating.rating = Double(obj.rating) ?? 0.0
    }
}

// MARK: - NibReusable
extension ReviewTableCell: NibReusable{}
