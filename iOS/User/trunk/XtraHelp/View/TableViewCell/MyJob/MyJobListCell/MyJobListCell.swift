//
//  MyJobListCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 08/12/21.
//

import UIKit

class MyJobListCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwProfileSub: UIView?
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var vwChatMain: UIView?
    @IBOutlet weak var vwChatSub: UIView?
    @IBOutlet weak var vwOTP: UIView?
    @IBOutlet weak var vwCancelSessionMain: UIView?
    @IBOutlet weak var vwRatingMain: UIView?
    @IBOutlet weak var vwCalenderMain: UIView?
    @IBOutlet weak var vwSessionCalenderMain: UIView?
    @IBOutlet weak var vwSessionCalenderSub: UIView?
    @IBOutlet weak var vwSessionApproveMain: UIView?
    @IBOutlet weak var vwSessionApproveSub: UIView?
    @IBOutlet weak var vwSessionCancelMain: UIView?
    @IBOutlet weak var vwSessionCancelSub: UIView?
    @IBOutlet weak var vwApplicationMain: UIView?
    
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblChat: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var lblOTP: UILabel?
    @IBOutlet weak var lblApplication: UILabel?
    
    @IBOutlet weak var btnChat: UIButton?
    @IBOutlet weak var btnCancelSession: UIButton?
    @IBOutlet weak var btnCalender: UIButton?
    @IBOutlet weak var btnSessionApprove: UIButton?
    @IBOutlet weak var btnSessionCalender: UIButton?
    @IBOutlet weak var btnSessionCancel: UIButton?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var stackMentorSessionButtons: UIStackView?
    
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var vwSeprator: UIView?
    
    @IBOutlet weak var vwCaregiverRateMain: UIView?
    @IBOutlet weak var vwCaregiverRating: CosmosView?
    @IBOutlet weak var lblCaregiverRating: UILabel?
    
    @IBOutlet weak var vwCallSub: UIView?
    @IBOutlet weak var btnCall: UIButton?
    
    // MARK: - Variables
    var isSelectedTab : SegmentJobTabEnum = .Upcoming {
        didSet {
            switch isSelectedTab {
            case .Upcoming:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = false
                self.vwCalenderMain?.isHidden = false
                
                break
            case .Completed:
                self.vwRatingMain?.isHidden = false
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = true
                self.lblTime?.isHidden = true
                break
            case .Posted:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = true
                self.lblChat?.isHidden = true
                self.lblChat?.text = ""
                self.vwApplicationMain?.isHidden = false
                self.imgProfile?.image = UIImage(named: "ic_MyJobUser") ?? UIImage()
                break
            case .Substitute:
                self.vwRatingMain?.isHidden = true
                self.vwCancelSessionMain?.isHidden = true
                self.vwChatMain?.isHidden = true
                self.lblTime?.isHidden = false
                self.stackMentorSessionButtons?.isHidden = false
                self.vwSessionApproveMain?.isHidden = false
                self.vwCancelSessionMain?.isHidden = false
                break
            }
        }
    }
    
    var isFromCareGiver : Bool = false {
        didSet{
            self.vwApplicationMain?.isHidden = false
            self.lblUserName?.textColor = UIColor.CustomColor.textConnectLogin
            self.lblUserName?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
            
            self.lblChat?.textColor = UIColor.CustomColor.commonLabelColor
            self.lblChat?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 15.0))
            
            self.lblTime?.textColor = UIColor.CustomColor.verificationTextColor
            self.lblTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
            
            self.lblApplication?.setApplicationCountHeaderAttributedTextLable(firstText: "0\n", SecondText: "Jobs")
        }
    }
    
    var isFromJobApplicant : Bool = false {
        didSet{
            self.vwRatingMain?.isHidden = false
            self.vwCancelSessionMain?.isHidden = true
            self.vwChatMain?.isHidden = true
            self.lblTime?.isHidden = true
            self.stackMentorSessionButtons?.isHidden = false
            self.vwSessionApproveMain?.isHidden = false
            self.vwCancelSessionMain?.isHidden = false
            self.lblApplication?.textColor = UIColor.CustomColor.appColor
            self.lblApplication?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
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
        
        [self.vwSessionCancelSub,self.vwSessionApproveSub,self.vwSessionCalenderSub].forEach({
            $0?.clipsToBounds = true
            //self.cornerRadius(4.0)
            $0?.cornerRadius = ($0?.frame.height ?? 0) / 2
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            $0?.shadow(UIColor.CustomColor.shadowColorTenPerBlack, radius: 3.0, offset: CGSize(width: 0, height: 0), opacity: 1)
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
        
        self.lblOTP?.textColor = UIColor.CustomColor.tabBarColor
        self.lblOTP?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 9.0))
        
        self.lblCaregiverRating?.textColor = UIColor.CustomColor.subscriptionColor
        self.lblCaregiverRating?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 18.0))
        
        self.vwSeprator?.backgroundColor = UIColor.CustomColor.borderColorSession
        
        self.vwOTP?.backgroundColor = UIColor.CustomColor.priceColor17
        self.vwOTP?.cornerRadius = 5.0
        
        self.lblApplication?.setApplicationCountHeaderAttributedTextLable(firstText: "0\n", SecondText: "Applications")
    }
    
    func setPostedJobData(obj : JobModel){
        self.lblUserName?.text = self.isSelectedTab == .Substitute ? obj.jobName : obj.name
        self.lblTime?.text = obj.startDateTime
        self.lblChat?.text = obj.userFullName
        /*if let user = UserModel.getCurrentUserFromDefault() {
            self.imgProfile?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }*/
        if obj.jobStatus == .Completed || obj.jobStatus == .Upcoming {
            self.imgProfile?.setImage(withUrl: obj.profileImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        self.lblOTP?.text = "OTP \(obj.verificationCode)"
        self.vwRating?.rating = Double(obj.jobRating) ?? 0
        self.lblApplication?.setApplicationCountHeaderAttributedTextLable(firstText: "\(obj.totalApplication)\n", SecondText: "Applications")
    }
    
    func setJobApplicantData(obj : JobApplicantsModel,alreadyHired : Bool){
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUserName?.text = obj.userFullName
        self.vwRating?.rating = Double(obj.caregiverRatingAverage ) ?? 0
        if alreadyHired &&  !(obj.isHire == "1") {
            self.vwApplicationMain?.isHidden = true
            self.stackMentorSessionButtons?.isHidden = true
            self.lblApplication?.text = ""
        } else {
            self.vwApplicationMain?.isHidden = !(obj.isHire == "1")
            self.stackMentorSessionButtons?.isHidden = obj.isHire == "1"
            self.lblApplication?.text = "Hired"
        }
        
    }
    
    func setCateGiverData(obj : CaregiverListModel){
        self.lblUserName?.text = obj.categoryNames
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblChat?.text = obj.fullName
        self.lblTime?.text = "\(obj.totalJobCompleted) Jobs Completed"
        
        self.lblApplication?.setApplicationCountHeaderAttributedTextLable(firstText: "\(obj.totalJobWithMe)\n", SecondText: "Jobs")
    }
    
    func setCateGiverSearchData(obj : CaregiverListModel){
        self.lblUserName?.text = obj.categoryNames
        self.imgProfile?.setImage(withUrl: obj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblChat?.text = obj.fullName
        self.lblTime?.text = "\(obj.totalJobCompleted) Jobs Completed"
        
        self.lblApplication?.setApplicationCountHeaderAttributedTextLable(firstText: "\(obj.totalJobOngoingWithMe)\n", SecondText: "Jobs")
        self.vwCaregiverRating?.rating = Double(obj.ratingAverage ) ?? 0
        self.lblCaregiverRating?.text = obj.ratingAverage
    }
}

// MARK: - NibReusable
extension MyJobListCell: NibReusable { }
