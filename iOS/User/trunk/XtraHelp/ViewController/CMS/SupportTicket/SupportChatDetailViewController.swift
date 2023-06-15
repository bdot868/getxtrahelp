//
//  SupportChatDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class SupportChatDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var vwCenterContentMain: UIView?
    @IBOutlet weak var vwBottomMain: UIView?
    
    @IBOutlet weak var constraintVWMainBottom: NSLayoutConstraint?
    
    @IBOutlet weak var txtMsg: UITextView?
    
    @IBOutlet weak var tblChat: UITableView?
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblChatStatus: UILabel?
    
    @IBOutlet weak var btnSendMsg: UIButton?
    @IBOutlet weak var btnAttach: UIButton?
    @IBOutlet weak var btnBack: UIButton?
    @IBOutlet weak var btnMore: UIButton?
    
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var imgProfile: UIImageView?
    @IBOutlet weak var vwSendMain: UIView?
    @IBOutlet weak var vwBottomTextView: UIView?
    @IBOutlet weak var constraintTxtMsgHeight: NSLayoutConstraint?
    
    // MARK: - Variables
    private var arrChatMsg : [TicketModel] = []
    var isChatClose : Bool = false
    var ticketData : TicketModel?
    private var ticketId : String = ""
    private var mediaName : String = ""
    //private var userID : String = ""
    private let imagePicker = ImagePicker()
    
    private var isOnlineUser : Bool = false {
        didSet {
            self.lblChatStatus?.text = isOnlineUser ? "Online" : "Offline"
            self.lblChatStatus?.textColor = isOnlineUser ? UIColor.CustomColor.chatStatusSuccessColor : UIColor.CustomColor.textConnectLogin
            self.lblChatStatus?.isHidden = !isOnlineUser
        }
    }
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //self.heightTopViewConstarint?.constant = self.view.safeAreaInsets.top + 10.0
        //print(self.heightTopViewConstarint?.constant ?? 0)
        
        //self.vwTopSubView?.layoutIfNeeded()
        //self.vwTopSubView?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 30.0)
        
        //self.vwCenterContentMain?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 40.0)
        
        //self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        
        self.vwProfileMain?.roundedCornerRadius()
        self.imgProfile?.roundedCornerRadius()
        
        self.vwBottomTextView?.clipsToBounds = true
        self.vwBottomTextView?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: -4, height: -5), opacity: 1)
        self.vwBottomTextView?.maskToBounds = false
        
        if let vw = self.vwSendMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        }
        
        self.vwSendMain?.clipsToBounds = true
        self.vwSendMain?.cornerRadius = (self.vwSendMain?.frame.width ?? 0.0) / 2
        self.vwSendMain?.shadow(UIColor.CustomColor.gradiantColorBottom, radius: 6.0, offset: CGSize(width: 4, height: 8), opacity: 0.5)
        self.vwSendMain?.maskToBounds = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Init Configure
extension SupportChatDetailViewController {
    private func InitConfig(){
        self.imagePicker.viewController = self
        WebSocketChat.shared.delegate = self
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        if let obj = self.ticketData {
            self.ticketId = obj.id
        }
        
        self.vwTopMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        
        self.lblUserName?.textColor = UIColor.CustomColor.whitecolor
        self.lblUserName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblChatStatus?.textColor = UIColor.CustomColor.chatStatusSuccessColor
        self.lblChatStatus?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        
        self.txtMsg?.placeholder = "Type your message..."
        self.txtMsg?.placeholderColor = UIColor.CustomColor.appPlaceholderColor
        self.txtMsg?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.txtMsg?.textColor = UIColor.CustomColor.blackColor
        self.txtMsg?.delegate = self
        self.txtMsg?.centerVertically()
        
        //self.vwCenterContentMain?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 30.0)
        
        //self.vwChatSub?.backgroundColor = UIColor.CustomColor.ColorBlack25Per
        
        self.tblChat?.register(ChatCell.self)
        self.tblChat?.register(TicketChatHeaderCell.self)
        self.tblChat?.estimatedRowHeight = 100.0
        self.tblChat?.rowHeight = UITableView.automaticDimension
        self.tblChat?.delegate = self
        self.tblChat?.dataSource = self
        
        self.vwBottomMain?.isHidden = self.isChatClose
        
        self.isOnlineUser = false
        
        //self.tblChat?.reloadSections(IndexSet(integer: 0), with: .none)
        self.getTicketDetailAPICall()
        self.getSuppportData()
    }
    
}

//MARK: - NotificateionValueDelegate methods
extension SupportChatDetailViewController {
    
    //MARK:- Notification observer for keyboard
    func addKeyboardObserver () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        self.tblChat?.addGestureRecognizer(tapGesture)
    }
    
    func removeKeyboardObserver () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            
            self.constraintVWMainBottom?.constant = keyboardHeight + (DeviceType.IS_PAD ? 18 : 9)
            self.setScrollBottom()
            view.layoutIfNeeded()
        }
    }
    
    func setScrollBottom() {
        
        if self.arrChatMsg.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrChatMsg.count-1, section: 1)
                self.tblChat?.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        /*if self.arrChatMsg.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrChatMsg.count - 1, section: 0)
                self.tblTicket.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }*/
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
}

//MARK:- UITableView Delegate
extension SupportChatDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.arrChatMsg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: TicketChatHeaderCell.self)
            if let obj = self.ticketData {
                cell.lblTicketid?.text = "#\(obj.id)"
                cell.lblTicketTitle?.text = obj.title
                cell.lblTicketDesc?.text = obj.ticketdescription
                cell.lblTicketStatus?.text = (obj.status == "0") ? "Closed" : "Open"
            }
            cell.layoutIfNeeded()
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, with: ChatCell.self)
        /*if indexPath.row == 1 || indexPath.row == 8 || indexPath.row == 12 || indexPath.row == 17{
            cell.vwSendingImgMain?.isHidden = false
            cell.vwSendingMsgMain?.isHidden = true
            cell.vwIncomingImgMain?.isHidden = true
            cell.vwIncomingMsgMain?.isHidden = true
        } else if indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 18{
            cell.vwSendingImgMain?.isHidden = true
            cell.vwSendingMsgMain?.isHidden = true
            cell.vwIncomingImgMain?.isHidden = false
            cell.vwIncomingMsgMain?.isHidden = true
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 19 || indexPath.row == 15 {
            cell.vwSendingImgMain?.isHidden = true
            cell.vwSendingMsgMain?.isHidden = false
            cell.vwIncomingImgMain?.isHidden = true
            cell.vwIncomingMsgMain?.isHidden = true
            cell.lblSendMessage?.text = (indexPath.row == 4 || indexPath.row == 19) ? "Yes! I will be there.." : "Ok.. See you in the meeting.. I will be good if John be in the meeting.. He has to be there.!"
        } else {
            cell.vwSendingImgMain?.isHidden = true
            cell.vwSendingMsgMain?.isHidden = true
            cell.vwIncomingImgMain?.isHidden = true
            cell.vwIncomingMsgMain?.isHidden = false
        }*/
        if self.arrChatMsg.count > 0 {
            let obj = self.arrChatMsg[indexPath.row]
            cell.setSupportChatData(obj: obj)
            cell.btnImgSending?.tag = indexPath.row
            cell.btnImgIncoming?.tag = indexPath.row
            cell.btnImgSending?.addTarget(self, action: #selector(self.btnImgOpenClick(_:)), for: .touchUpInside)
            cell.btnImgIncoming?.addTarget(self, action: #selector(self.btnImgOpenClick(_:)), for: .touchUpInside)
            cell.delegate = self
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnImgOpenClick(_ sender : UIButton){
        if self.arrChatMsg.count > 0 {
            let obj = self.arrChatMsg[sender.tag]
            self.appNavigationController?.present(ImagePreviewViewController.self, configuration: { (vc) in
                vc.imageUrl = obj.ticketdescription
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
            })
        }
    }
}

//MARK:- Chat Cell Delegate
extension SupportChatDetailViewController : ChatCellDelegate {
    func openLink(url: String) {
        var updateUrl: String = url
        if !url.contains("http") || !url.contains("https") {
            updateUrl = "http://\(url)"
        }
        
        guard let urldata = URL(string: updateUrl) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urldata, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urldata)
        }
    }
}

//MARK:- Textfeild Delegate
extension SupportChatDetailViewController : UITextViewDelegate {
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
       // print(textView.contentSize.height)
        if textView.contentSize.height <= 120 && textView.contentSize.height > 35{
            self.setTxtMsgHeight(value: textView.contentSize.height)
        } else if textView.contentSize.height < 35 {
            self.setTxtMsgHeight(value: 35.0)
        }
    }
    
    private func setTxtMsgHeight(value : CGFloat){
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.constraintTxtMsgHeight?.constant = value
            self.setScrollBottom()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - IBAction
extension SupportChatDetailViewController {
    
    @IBAction func btnSendMsgClicked(_ sender: UIButton) {
        if !(self.txtMsg?.text ?? "").isValidString() {
            self.sendMessage(msg: (self.txtMsg?.text ?? "").encodindEmoji(), replytype: supportReplyType.message.rawValue)
        }
    }
    
    @IBAction func btnMoreClicked(_ sender: UIButton) {
        let alertmenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let OpenCloseAction = UIAlertAction(title: self.isChatClose ? "ReOpen Ticket" : "Close Ticket", style: .default) { alert in
            
        }
        
        let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .default) { alert in
            
        }
    
        alertmenu.popoverPresentationController?.sourceView = sender as? UIView
        alertmenu.addAction(OpenCloseAction)
        alertmenu.addAction(cancelAction)
        self.present(alertmenu, animated: true, completion: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.appNavigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imagePicker.pickImage(sender, "Select Media") { (img,url) in
            self.mediaAPICall(img: img)
        }
    }
}

//MARK:- Socket Methods
extension SupportChatDetailViewController : webSocketChatDelegate{
    private func getSuppportData(){
        let dictionary : [String:Any] = [khookMethod: AppConstant.WebSocketAPI.kuserSupportTicketMessageList,
                                         kticket_id : self.ticketId]
        WebSocketChat.shared.writeSocketData(dict: dictionary)
        
    }
    
    private func sendMessage(msg : String,replytype: String){
        if replytype == supportReplyType.message.rawValue {
            self.txtMsg?.text = ""
            self.setTxtMsgHeight(value: 35.0)
        }
        let dictionary : [String:Any] = [khookMethod: AppConstant.WebSocketAPI.kuserSupportTicketReply,
                                         kticket_id : self.ticketId,
                                         kdescription : msg.encodindEmoji(),
                                         kreplyType : replytype]
        WebSocketChat.shared.writeSocketData(dict: dictionary)
        self.mediaName = ""
    }
    
    func SendReceiveData(dict: [String : AnyObject]) {
        print(dict)
        if let hookmethod = dict[khookMethod] as? String {
            
            if let group = dict[kadminData] as? [String:Any] {
                self.isOnlineUser = (group[kisOnline] as? String ?? "0") == "1"
            }
            
            if hookmethod == AppConstant.WebSocketAPI.kuserSupportTicketMessageList {
                if let dataarr = dict[kData] as? [[String:Any]] {
                    self.arrChatMsg = dataarr.compactMap(TicketModel.init)
                    self.tblChat?.reloadData()
                    self.setScrollBottom()
                }
            } else {
                if let dataarr = dict[kData] as? [String:Any],let model = TicketModel.init(dictionary: dataarr) {
                    self.arrChatMsg.append(model)
                    self.tblChat?.reloadData()
                    self.setScrollBottom()
                }
            }
        }
    }
}

// MARK: - API CAll
extension SupportChatDetailViewController {
    
    private func mediaAPICall(img : UIImage) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType,
        ]
        
        UserModel.uploadMedia(with: dict, image: img, success: { (media) in
            //self.mediaName = msg
            self.sendMessage(msg: media, replytype: supportReplyType.media.rawValue)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            
            if !error.isEmpty {
                //self.showAlert(withTitle: errorType.rawValue, with: error)
                self.showMessage(error, themeStyle: .error)
            }
            
        })
    }
    
    private func getTicketDetailAPICall() {
        if let user = UserModel.getCurrentUserFromDefault(),let ticketdata = self.ticketData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kticketId : ticketdata.id
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            TicketModel.getTicketDetail(with: param, isShowLoader: true,  success: { (ticket,msg) in
                //self.arrResources = arr
                self.ticketData = ticket
                if let obj = self.ticketData {
                    self.isChatClose = obj.status == "0"
                    self.btnMore?.isHidden = !(obj.status == "0")
                }
                //self.ticketTitle = ticket.title
                //self.ticketDescription = ticket.ticketdescription
                self.tblChat?.reloadSections(IndexSet(integer: 0), with: .none)
                //self.btnReopen.isHidden = ticket.status == "0" ? false : true
                self.vwBottomMain?.isHidden = ticket.status == "0" ? true : false
                //self.vwBottomSpace.backgroundColor = ticket.status == "0" ? UIColor.clear : UIColor.CustomColor.chatBackColor
                //self.configureNavigationBar(hideReopenBtn: ticket.status == "0" ? false : true)
                
                
                self.setScrollBottom()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    
                } else {
                    if !error.isEmpty {
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                        self.showMessage(error, themeStyle: .error)
                    }
                }
            })
        }
    }
    
    private func reopenTicketAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kticketId : "\(self.ticketId)"
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            TicketModel.reopenTicket(with: param, isShowLoader: true,  success: { (msg) in
                
                //self.btnReopen.isHidden = true
                //self.configureNavigationBar(hideReopenBtn: true)
                self.vwBottomMain?.isHidden = false
                if let data = self.ticketData{
                    data.status = "1"
                }
                //self.vwBottomSpace.backgroundColor = UIColor.CustomColor.chatBackColor
                self.tblChat?.reloadSections(IndexSet(integer: 0), with: .none)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    
                } else {
                    if !error.isEmpty {
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                        self.showMessage(error, themeStyle: .error)
                    }
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension SupportChatDetailViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension SupportChatDetailViewController: AppNavigationControllerInteractable { }
