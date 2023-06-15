//
//  ChatUserListCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class ChatUserListCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwProfile: UIView?
    @IBOutlet weak var vwChatUnseen: UIView?
    @IBOutlet weak var vwMain: UIView?
    
    @IBOutlet weak var imgProfile: UIImageView?

    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var lblChatDesc: UILabel?
    
    // MARK: - Variables
    var isUnSeenChat : Bool = false {
        didSet{
            self.vwChatUnseen?.isHidden = !isUnSeenChat
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
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.vwChatUnseen?.roundedCornerRadius()
        self.vwProfile?.roundedCornerRadius()
        self.imgProfile?.roundedCornerRadius()
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblTime?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.lblChatDesc?.textColor = UIColor.CustomColor.textConnectLogin
        self.lblChatDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwChatUnseen?.backgroundColor = UIColor.CustomColor.countBGColor
    }
    
    func setUserMsgData(obj : ChatModel){
        self.lblUserName?.text = obj.name
        self.imgProfile?.setImage(withUrl: obj.thumbImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblChatDesc?.text = obj.message.decodingEmoji()
        self.lblTime?.text = obj.time
        //self.vwCountChat.isHidden = (obj.unreadMessages == "") ? true : false
        //let count : Int = Int(obj.unreadMessages) ?? 0
        //self.lblCountChat.text = (count > 10) ? "10+" : obj.unreadMessages
        //self.lblMsgTime.text = obj.time
        let count = Int(obj.unreadMessages) ?? 0
        self.vwChatUnseen?.isHidden = count == 0
    }
}

// MARK: - NibReusable
extension ChatUserListCell: NibReusable{}
