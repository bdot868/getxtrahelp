//
//  ChatCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 09/10/21.
//

import UIKit

protocol ChatCellDelegate {
    func openLink(url : String)
}

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var sendMsgView: UIView?
    @IBOutlet weak var incomeMsgView: UIView?
    // MARK: - IBOutlet

    @IBOutlet weak var vwSendingMsgMain: UIView?
    @IBOutlet weak var vwSendingImgMain: UIView?
    @IBOutlet weak var lblSendMessage: ActiveLabel?
    @IBOutlet weak var imgSeding: UIImageView?
    @IBOutlet weak var lblSendingTime: UILabel?
    @IBOutlet weak var lblSendingImgTime: UILabel?
    @IBOutlet weak var imgSendingMsgUserProfile: UIImageView?
    @IBOutlet weak var imgSendingImgUserProfile: UIImageView?
    
    @IBOutlet weak var vwIncomingMsgMain: UIView?
    @IBOutlet weak var vwIncomingImgMain: UIView?
    @IBOutlet weak var imgIncoming: UIImageView?
    @IBOutlet weak var lblIncomingMsg: ActiveLabel?
    @IBOutlet weak var lblIncomingTime: UILabel?
    @IBOutlet weak var lblIncomingImgTime: UILabel?
    @IBOutlet weak var imgIncomingUser: UIImageView?
    @IBOutlet weak var vwIncomingUserMain: UIView?
    @IBOutlet weak var imgIncomingImageUser: UIImageView?
    @IBOutlet weak var vwIncomingImageUserMain: UIView?
   
    @IBOutlet weak var btnImgIncoming: UIButton?
    @IBOutlet weak var btnImgSending: UIButton?
    
    @IBOutlet weak var vwIncomingFilesMain: UIView?
    @IBOutlet weak var vwIncomingFilesSub: UIView?
    @IBOutlet weak var vwIncomingFilesUserMain: UIView?
    @IBOutlet weak var imgIncomingFilesUserProfile: UIImageView?
    @IBOutlet weak var lblIncomingFilesTime: UILabel?
    @IBOutlet weak var lblIncomingFilesName: UILabel?
    @IBOutlet weak var btnIncomingFiles: UIButton?
    
    @IBOutlet weak var vwSendingFilesMain: UIView?
    @IBOutlet weak var vwSendingFilesSub: UIView?
    @IBOutlet weak var lblSendingFilesTime: UILabel?
    @IBOutlet weak var lblSendingFilesName: UILabel?
    @IBOutlet weak var btnSendingFiles: UIButton?
    @IBOutlet weak var imgSendingFileUserProfile: UIImageView?
    
    @IBOutlet weak var vwIncomingCareGiverMain: UIView?
    @IBOutlet weak var vwIncomingCareGiverSub: UIView?
    @IBOutlet weak var lblIncominhCaregiverName: UILabel?
    @IBOutlet weak var lblIncominhCaregiverCategory: UILabel?
    @IBOutlet weak var vwIncomingCaregiverRating: CosmosView?
    @IBOutlet weak var lblIncominhCaregiverExperience: UILabel?
    @IBOutlet weak var lblIncominhCaregiverNextAvailable: UILabel?
    @IBOutlet weak var lblIncominhCaregiverNextAvailableValue: UILabel?
    @IBOutlet weak var imgIncomingCaregiverProfile: UIImageView?
    @IBOutlet weak var imgIncomingCaregiverUserProfile: UIImageView?
    @IBOutlet weak var lblIncominhCaregiverTime: UILabel?
    @IBOutlet weak var btnIncominhCaregiver: UIButton?
    
    @IBOutlet weak var vwSendingCareGiverMain: UIView?
    @IBOutlet weak var vwSendingCareGiverSub: UIView?
    @IBOutlet weak var lblSendingCaregiverName: UILabel?
    @IBOutlet weak var lblSendingCaregiverCategory: UILabel?
    @IBOutlet weak var vwSendingCaregiverRating: CosmosView?
    @IBOutlet weak var lblSendingCaregiverExperience: UILabel?
    @IBOutlet weak var lblSendingCaregiverNextAvailable: UILabel?
    @IBOutlet weak var lblSendingCaregiverNextAvailableValue: UILabel?
    @IBOutlet weak var imgSendinggCaregiverProfile: UIImageView?
    @IBOutlet weak var lblSendingCaregiverTime: UILabel?
    @IBOutlet weak var btnSendingCaregiver: UIButton?
    @IBOutlet weak var imgSendingCaregiverUserProfile: UIImageView?
    
    // MARK: - Variables
    private var wordsLink : [String] = []
    var delegate : ChatCellDelegate?
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
    
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.imgIncomingImageUser?.roundedCornerRadius()
        self.imgIncomingUser?.roundedCornerRadius()
        self.imgIncomingFilesUserProfile?.roundedCornerRadius()
        self.imgIncomingCaregiverUserProfile?.roundedCornerRadius()
        self.imgIncomingCaregiverProfile?.roundedCornerRadius()
        self.imgSendinggCaregiverProfile?.roundedCornerRadius()
        
        self.imgSendingMsgUserProfile?.roundedCornerRadius()
        self.imgSendingImgUserProfile?.roundedCornerRadius()
        self.imgSendingFileUserProfile?.roundedCornerRadius()
        self.imgSendingCaregiverUserProfile?.roundedCornerRadius()
        
        if let vw = self.sendMsgView {
            //vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            vw.clipsToBounds = true
            //$0?.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
            vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
        
        if let vw = self.vwSendingFilesSub {
            //vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            vw.clipsToBounds = true
            //$0?.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
            vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
        
        if let vw = self.incomeMsgView {
            
            //vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            vw.clipsToBounds = true
            //$0?.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
            vw.roundCorners(corners: [.topLeft,.topRight,.bottomRight], radius: 20.0)
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
        
        if let vw = self.vwIncomingFilesSub {
            
            //vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            vw.clipsToBounds = true
            //$0?.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
            vw.roundCorners(corners: [.topLeft,.topRight,.bottomRight], radius: 20.0)
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
        
        if let vw = self.vwIncomingCareGiverSub {
            
            //vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            vw.clipsToBounds = true
            //$0?.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
            vw.roundCorners(corners: [.topLeft,.topRight,.bottomRight], radius: 20.0)
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
        
        if let vw = self.vwSendingCareGiverSub {
            //vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            vw.clipsToBounds = true
            //$0?.cornerRadius = DeviceType.IS_PAD ? 15.0 : 15.0
            vw.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 20.0)
            //self.borderWidth(1.0)
            //self.borderColor(UIColor.CustomColor.loginBGBorderColor)
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
        }
        
    }
    
    // MARK: - Init Configure
    private func InitConfig() {
        
        //self.vwSendingMsgMain?.cornerRadius = 16.0//roundCorners([.topLeft,.topRight,.bottomLeft], radius: 25.0)
        //self.vwIncomingMsgMain?.cornerRadius = 16.0
       
        //self.incomeMsgView?.backgroundColor = UIColor.CustomColor.whitecolor
        self.lblIncomingMsg?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblIncomingMsg?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        //self.vwIncomingFilesSub?.backgroundColor = UIColor.CustomColor.whitecolor
        self.lblIncomingFilesName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblIncomingFilesName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        //self.vwSendingMsgMain?.backgroundColor = UIColor.CustomColor.registerColor
        //self.sendMsgView?.backgroundColor = UIColor.CustomColor.outgoingChatBGColor
        self.lblSendMessage?.textColor = UIColor.CustomColor.appColor
        self.lblSendMessage?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        //self.vwSendingFilesSub?.backgroundColor = UIColor.CustomColor.outgoingChatBGColor
        self.lblSendingFilesName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblSendingFilesName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        [self.lblIncominhCaregiverName,self.lblSendingCaregiverName].forEach({
            $0?.textColor = UIColor.CustomColor.appColor
            $0?.font = UIFont.RubikBold(ofSize: GetAppFontSize(size: 13.0))
        })
        
        [self.lblIncominhCaregiverCategory,self.lblSendingCaregiverCategory].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
            $0?.numberOfLines = 0
        })
        
        [self.incomeMsgView,self.vwIncomingFilesSub,self.vwIncomingCareGiverSub].forEach({
            $0?.backgroundColor = UIColor.CustomColor.whitecolor
        })
        
        [self.sendMsgView,self.vwSendingFilesSub,self.vwSendingCareGiverSub].forEach({
            $0?.backgroundColor = UIColor.CustomColor.outgoingChatBGColor
        })
        
        [self.lblSendingCaregiverExperience,self.lblIncominhCaregiverExperience].forEach({
            $0?.setExperienceAttributedTextLable(firstText: "Experience\n", SecondText: "0 Years")
        })
        
        [self.lblSendingCaregiverNextAvailable,self.lblIncominhCaregiverNextAvailable].forEach({
            $0?.textColor = UIColor.CustomColor.SuccessStaus
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 9.0))
        })
        
        [self.lblSendingCaregiverNextAvailableValue,self.lblIncominhCaregiverNextAvailableValue].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 11.0))
        })
        
        [self.lblSendingTime,self.lblIncomingTime,self.lblSendingImgTime,self.lblIncomingImgTime,self.lblIncomingFilesTime,self.lblSendingFilesTime,self.lblSendingCaregiverTime,self.lblIncominhCaregiverTime].forEach({
            $0?.textColor = UIColor.CustomColor.textConnectLogin
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        self.imgSeding?.cornerRadius = 20.0
        self.imgIncoming?.cornerRadius = 20.0
        
        //self.lblSendMessage.addInterlineSpacing(spacingValue: 5.0)
        self.lblSendMessage?.enabledTypes = [.url]
        self.lblSendMessage?.URLColor = UIColor.CustomColor.settingEditBtnColor
        self.lblSendMessage?.removeHandle(for: .url)
        self.lblSendMessage?.handleURLTap { (url) in
            let strurl = url.absoluteString.lowercased()
            var updateUrl = url.absoluteString
            if !strurl.contains("http") && !strurl.contains("https") {
                updateUrl = "http://\(strurl)"
            }
            print(updateUrl)
            if let del = self.delegate {
                del.openLink(url: updateUrl)
            }
            /*guard let urldata = URL(string: updateUrl) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urldata, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }*/
        }
        
        //self.lblIncomingMsg.addInterlineSpacing(spacingValue: 5.0)
        self.lblIncomingMsg?.enabledTypes = [.url]
        self.lblIncomingMsg?.URLColor = UIColor.CustomColor.settingEditBtnColor
        self.lblIncomingMsg?.removeHandle(for: .url)
        self.lblIncomingMsg?.handleURLTap { (url) in
            let strurl = url.absoluteString.lowercased()
            var updateUrl = url.absoluteString
            if !strurl.contains("http") && !strurl.contains("https") {
                updateUrl = "http://\(strurl)"
            }
            print(updateUrl)
            if let del = self.delegate {
                del.openLink(url: updateUrl)
            }
            /*guard let urldata = URL(string: updateUrl) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urldata, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }*/
        }
        /*[self.lblSendMessage,self.lblIncomingMsg].forEach{
            $0?.isUserInteractionEnabled = true
            //let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapTermLable))
            //$0?.addGestureRecognizer(tap)
        }*/
    }
    
    func SetChatMessageData(obj : ChatModel,loginUserId : String){
        if loginUserId == obj.sender {
            self.vwSendingMsgMain?.isHidden = false
            self.vwIncomingMsgMain?.isHidden = true
            self.lblSendMessage?.text = obj.message.decodingEmoji()
            self.lblSendingTime?.text = obj.time
            self.imgSendingMsgUserProfile?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        } else {
            self.vwSendingMsgMain?.isHidden = true
            self.vwIncomingMsgMain?.isHidden = false
            self.lblIncomingMsg?.text = obj.message.decodingEmoji()
            self.lblIncomingTime?.text = obj.time
            self.imgIncomingUser?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        
        self.vwIncomingImgMain?.isHidden = true
        self.vwSendingImgMain?.isHidden = true
        self.vwSendingFilesMain?.isHidden = true
        self.vwIncomingFilesMain?.isHidden = true
        self.vwSendingCareGiverMain?.isHidden = true
        self.vwIncomingCareGiverMain?.isHidden = true
    }
    
    func SetChatImageViewData(obj : ChatModel,loginUserId : String){
        let url : String = "\(AppConstant.API.MAIN_URL)/assets/uploads/\(obj.message)"
        if loginUserId == obj.sender {
            self.vwSendingImgMain?.isHidden = false
            self.vwIncomingImgMain?.isHidden = true
            self.imgSeding?.setImage(withUrl: url, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            self.lblSendingImgTime?.text = obj.time
            self.imgSendingImgUserProfile?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        } else {
            self.vwSendingImgMain?.isHidden = true
            self.vwIncomingImgMain?.isHidden = false
            self.imgIncoming?.setImage(withUrl: url, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            self.lblIncomingImgTime?.text = obj.time
            self.imgIncomingImageUser?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        
        self.vwSendingMsgMain?.isHidden = true
        self.vwIncomingMsgMain?.isHidden = true
        self.vwSendingFilesMain?.isHidden = true
        self.vwIncomingFilesMain?.isHidden = true
        self.vwSendingCareGiverMain?.isHidden = true
        self.vwIncomingCareGiverMain?.isHidden = true
    }
    
    func SetChatFilesData(obj : ChatModel,loginUserId : String){
        //let url : String = "\(AppConstant.API.MAIN_URL)/assets/uploads/\(obj.message)"
        if loginUserId == obj.sender {
            self.vwSendingFilesMain?.isHidden = false
            self.vwIncomingFilesMain?.isHidden = true
            self.lblSendingFilesName?.text = obj.message
            self.lblSendingFilesTime?.text = obj.time
            self.imgSendingFileUserProfile?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        } else {
            self.vwSendingFilesMain?.isHidden = true
            self.vwIncomingFilesMain?.isHidden = false
            self.lblIncomingFilesName?.text = obj.message
            self.imgIncomingFilesUserProfile?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            self.lblIncomingFilesTime?.text = obj.time
        }
        
        self.vwSendingMsgMain?.isHidden = true
        self.vwIncomingMsgMain?.isHidden = true
        self.vwSendingImgMain?.isHidden = true
        self.vwIncomingImgMain?.isHidden = true
        self.vwSendingCareGiverMain?.isHidden = true
        self.vwIncomingCareGiverMain?.isHidden = true
    }
    
    func SetChatCareGiverData(obj : ChatModel,loginUserId : String){
        //let url : String = "\(AppConstant.API.MAIN_URL)/assets/uploads/\(obj.message)"
        if loginUserId == obj.sender {
            self.vwSendingCareGiverMain?.isHidden = false
            self.vwIncomingCareGiverMain?.isHidden = true
            //self.lblSendingFilesName?.text = obj.message
            self.lblSendingCaregiverTime?.text = obj.time
            
            self.imgSendingCaregiverUserProfile?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            
            if let caregiverobj = obj.suggestedProvider {
                self.lblSendingCaregiverName?.text = caregiverobj.fullName
                if !caregiverobj.categoryNames.isEmpty {
                    //let arrExplode = caregiverobj.categoryNames.replace(string: ",", replacement: ",\n")//components(separatedBy: ",")
                    self.lblSendingCaregiverCategory?.text = caregiverobj.categoryNames.replace(string: ", ", replacement: ",\n")
                }
                //self.lblSendingCaregiverCategory?.text = caregiverobj.categoryNames
                self.vwSendingCaregiverRating?.rating = Double(caregiverobj.ratingAverage) ?? 0
                self.imgSendinggCaregiverProfile?.setImage(withUrl: caregiverobj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                self.lblSendingCaregiverExperience?.setExperienceAttributedTextLable(firstText: "Job Complated\n", SecondText: caregiverobj.totalJobCompleted)
            }
        } else {
            self.vwSendingCareGiverMain?.isHidden = true
            self.vwIncomingCareGiverMain?.isHidden = false
            //self.lblIncomingFilesName?.text = obj.message
            self.lblIncominhCaregiverTime?.text = obj.time
            
            self.imgIncomingCaregiverUserProfile?.setImage(withUrl: obj.senderImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            
            if let caregiverobj = obj.suggestedProvider {
                self.lblIncominhCaregiverName?.text = caregiverobj.fullName
                //self.lblIncominhCaregiverCategory?.text = caregiverobj.categoryNames
                if !caregiverobj.categoryNames.isEmpty {
                    //let arrExplode = caregiverobj.categoryNames.replace(string: ",", replacement: ",\n")//components(separatedBy: ",")
                    self.lblIncominhCaregiverCategory?.text = caregiverobj.categoryNames.replace(string: ", ", replacement: ",\n")
                }
                self.vwIncomingCaregiverRating?.rating = Double(caregiverobj.ratingAverage) ?? 0
                self.imgIncomingCaregiverProfile?.setImage(withUrl: caregiverobj.profileImageThumbUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                self.lblIncominhCaregiverExperience?.setExperienceAttributedTextLable(firstText: "Job Complated\n", SecondText: caregiverobj.totalJobCompleted)
            }
        }
        
        self.vwSendingMsgMain?.isHidden = true
        self.vwIncomingMsgMain?.isHidden = true
        self.vwSendingImgMain?.isHidden = true
        self.vwIncomingImgMain?.isHidden = true
        self.vwSendingFilesMain?.isHidden = true
        self.vwIncomingFilesMain?.isHidden = true
    }
    
    func setSupportChatData(obj : TicketModel){
        if obj.forReply == .user {
            
            if (supportReplyType.init(rawValue: obj.replyType) ?? .message) == .message {
                self.vwSendingImgMain?.isHidden = true
                self.vwIncomingMsgMain?.isHidden = true
                self.vwIncomingImgMain?.isHidden = true
                self.vwSendingMsgMain?.isHidden = false
                self.lblSendMessage?.text = obj.ticketdescription.decodingEmoji()
                self.lblSendingTime?.text = obj.time
                self.imgSendingMsgUserProfile?.setImage(withUrl: obj.ticketdescription, placeholderImage: UIImage(named: DefaultPlaceholderImage.AppPlaceholder) ?? UIImage(), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            } else {
                self.vwSendingImgMain?.isHidden = false
                self.vwIncomingMsgMain?.isHidden = true
                self.vwIncomingImgMain?.isHidden = true
                self.vwSendingMsgMain?.isHidden = true
                //let url = AppConstant.API.MAIN_URL + "/assets/uploads/" + obj.ticketdescription
                self.imgSeding?.setImage(withUrl: obj.ticketdescription, placeholderImage: UIImage(named: DefaultPlaceholderImage.AppPlaceholder) ?? UIImage(), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                self.lblSendingImgTime?.text = obj.time
            }
        } else {
            if (supportReplyType.init(rawValue: obj.replyType) ?? .message) == .message {
                self.vwSendingImgMain?.isHidden = true
                self.vwIncomingMsgMain?.isHidden = false
                self.vwIncomingImgMain?.isHidden = true
                self.vwSendingMsgMain?.isHidden = true
                self.lblIncomingMsg?.text = obj.ticketdescription.decodingEmoji()
                self.imgIncomingUser?.setImage(withUrl: obj.name, placeholderImage: UIImage(named: DefaultPlaceholderImage.UserAppPlaceholder) ?? UIImage(), indicatorStyle: .white, isProgressive: true, imageindicator: .medium)
                self.lblIncomingTime?.text = obj.time
                self.imgSendingImgUserProfile?.setImage(withUrl: obj.ticketdescription, placeholderImage: UIImage(named: DefaultPlaceholderImage.AppPlaceholder) ?? UIImage(), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            } else {
                self.vwSendingImgMain?.isHidden = true
                self.vwIncomingMsgMain?.isHidden = true
                self.vwIncomingImgMain?.isHidden = false
                self.vwSendingMsgMain?.isHidden = true
                self.imgIncomingImageUser?.setImage(withUrl: obj.profileimage, placeholderImage: UIImage(named: DefaultPlaceholderImage.UserAppPlaceholder) ?? UIImage(), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                //let url = AppConstant.API.MAIN_URL + "/assets/uploads/" + obj.ticketdescription
                self.imgIncoming?.setImage(withUrl: obj.ticketdescription, placeholderImage: UIImage(named: DefaultPlaceholderImage.AppPlaceholder) ?? UIImage(), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                self.lblIncomingImgTime?.text = obj.time
            }
        }
    }
}

// MARK: - NibReusable
extension ChatCell : NibReusable{}
