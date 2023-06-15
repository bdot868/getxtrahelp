//
//  SessionTableCell.swift
//  Momentor
//
//  Created by wmdevios-h on 17/09/21.
//

import UIKit

class SessionTableCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwProfileSub: UIView?
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var vwChatMain: UIView?
    @IBOutlet weak var vwCancelSessionMain: UIView?
    @IBOutlet weak var vwRatingMain: UIView?
    @IBOutlet weak var vwCalenderMain: UIView?
    @IBOutlet weak var vwSessionCalenderMain: UIView?
    @IBOutlet weak var vwSessionCalenderSub: UIView?
    @IBOutlet weak var vwSessionApproveMain: UIView?
    @IBOutlet weak var vwSessionApproveSub: UIView?
    @IBOutlet weak var vwSessionCancelMain: UIView?
    @IBOutlet weak var vwSessionCancelSub: UIView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblChat: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    
    @IBOutlet weak var btnChat: UIButton?
    @IBOutlet weak var btnCancelSession: UIButton?
    @IBOutlet weak var btnCalender: UIButton?
    @IBOutlet weak var btnSessionApprove: UIButton?
    @IBOutlet weak var btnSessionCalender: UIButton?
    @IBOutlet weak var btnSessionCancel: UIButton?
    
    @IBOutlet weak var imgProfile: UIImageView?
    @IBOutlet weak var btnProfile: UIButton?
    
    @IBOutlet weak var stackMentorSessionButtons: UIStackView?
    
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var vwSeprator: UIView?
    
    @IBOutlet weak var vwCallMain: UIView?
    @IBOutlet weak var btnCall: UIButton?
    
    // MARK: - Variables
    var isSelectedTab : SegmentJobTabEnum = .Upcoming {
        didSet {
            switch isSelectedTab {
            case .All:
                break
            case .Upcoming:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = false
                self.vwCallMain?.isHidden = false
                self.vwCalenderMain?.isHidden = false//!(Momentor.sharedInstance.selectedUserType == .Mentor)
                self.stackMentorSessionButtons?.isHidden = true
                self.vwSessionApproveMain?.isHidden = true
                self.vwSessionCancelMain?.isHidden = true
                self.vwSessionCalenderMain?.isHidden = true
                break
            case .Completed:
                self.vwRatingMain?.isHidden = false
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = true
                self.vwCallMain?.isHidden = true
                self.lblTime?.isHidden = true
                self.stackMentorSessionButtons?.isHidden = true
                self.vwSessionApproveMain?.isHidden = true
                self.vwSessionCancelMain?.isHidden = true
                self.vwSessionCalenderMain?.isHidden = true
                break
            case .Applied:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = false
                self.vwChatMain?.isHidden = true
                self.vwCallMain?.isHidden = true
                self.stackMentorSessionButtons?.isHidden = true
                self.vwSessionApproveMain?.isHidden = true
                self.vwSessionCancelMain?.isHidden = true
                self.vwSessionCalenderMain?.isHidden = true
                break
            case .Substitute:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = true
                self.vwCallMain?.isHidden = true
                self.vwCalenderMain?.isHidden = true
                self.stackMentorSessionButtons?.isHidden = false
                self.vwSessionApproveMain?.isHidden = false
                self.vwSessionCancelMain?.isHidden = false
                self.vwSessionCalenderMain?.isHidden = true
                break
            case .AwardJob:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = true
                self.vwCallMain?.isHidden = true
                self.vwCalenderMain?.isHidden = true
                self.stackMentorSessionButtons?.isHidden = false
                self.vwSessionApproveMain?.isHidden = false
                self.vwSessionCancelMain?.isHidden = false
                self.vwSessionCalenderMain?.isHidden = true
                break
            }
        }
    }
    
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
        
        self.vwSeprator?.cornerRadius = (self.vwSeprator?.frame.height ?? 0) / 2
        
        [self.vwSessionApproveSub,self.vwSessionCalenderSub,self.vwSessionCancelSub].forEach({
            //$0?.cornerRadius = ($0?.frame.height ?? 0) / 2
            
            $0?.clipsToBounds = true
            $0?.backgroundColor = UIColor.CustomColor.whitecolor
            $0?.cornerRadius = ($0?.frame.height ?? 0) / 2
            $0?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize.zero, opacity: 1)
            $0?.maskToBounds = false
        })
    }
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblChat?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblChat?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 17.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.appColor
        self.lblTime?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwSeprator?.backgroundColor = UIColor.CustomColor.borderColorSession
    }
    
    func setPostedJobData(obj : JobModel){
        self.lblUserName?.text = (self.isSelectedTab == .Substitute || self.isSelectedTab == .AwardJob) ? obj.jobName : obj.name
        self.lblChat?.text = obj.userFullName
        self.lblTime?.text = obj.startDateTime
        
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        
        self.vwRating?.rating = Double(obj.jobRating) ?? 0.0
       // self.lblApplication?.setApplicationCountHeaderAttributedTextLable(firstText: "\(obj.totalApplication)\n", SecondText: "Applications")
    }
}

// MARK: - NibReusable
extension SessionTableCell: NibReusable { }
