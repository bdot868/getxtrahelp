//
//  ChatDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class ChatDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var vwCenterContentMain: UIView?
    @IBOutlet weak var vwBottomMain: UIView?
    @IBOutlet weak var vwChatTextTypeMain: UIView?
    
    @IBOutlet weak var constraintVWMainBottom: NSLayoutConstraint?
    
    @IBOutlet weak var txtMsg: UITextView?
    
    @IBOutlet weak var tblChat: UITableView?
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblChatStatus: UILabel?
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    @IBOutlet weak var btnSendMsg: UIButton?
    @IBOutlet weak var btnAttach: UIButton?
    @IBOutlet weak var btnBack: UIButton?
    @IBOutlet weak var btnMore: UIButton?
    
    @IBOutlet weak var vwProfileMain: UIView?
    @IBOutlet weak var imgProfile: UIImageView?
    @IBOutlet weak var vwSendMain: UIView?
    @IBOutlet weak var vwBottomTextView: UIView?
    @IBOutlet weak var constraintTxtMsgHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwAttachMain: UIView?
    @IBOutlet var lblAttachSubText: [UILabel]?
    
    
    // MARK: - Variables
    private var arrChatMsg : [ChatModel] = []
    var isChatClose : Bool = false
    
    var chatUserID : String = ""
    private var chatGroupID : String = ""
    private var mediaName : String = ""
    private let imagePicker = ImagePicker()
    private var documentpicker = DocumentPicker()
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    var chatUserName : String = ""
    var chatUserImage : String = ""
    var loginUserId : String = ""
    var isFromChatInbox : Bool = false
    
    private var openAttachTextViewHeight : CGFloat = 0.0
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.lightGray
            
            return refreshControl
        }()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.addKeyboardObserver()
        WebSocketChat.shared.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.socketReConnectNotification(notification:)), name: Notification.Name(NotificationPostname.kReloadChatConnected), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Enable IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Disable IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
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
}

// MARK: - Init Configure
extension ChatDetailViewController {
    private func InitConfig(){
        
        WebSocketChat.shared.connectSocket()
        self.imagePicker.viewController = self
        self.imagePicker.isAllowsEditing = true
        self.documentpicker.viewController = self
        
        if let user = UserModel.getCurrentUserFromDefault() {
            self.loginUserId = user.id
        }
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.vwTopMain?.backgroundColor = UIColor.clear
        
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
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
        self.tblChat?.estimatedRowHeight = 100.0
        self.tblChat?.rowHeight = UITableView.automaticDimension
        self.tblChat?.delegate = self
        self.tblChat?.dataSource = self
        
        self.tblChat?.addSubview(self.refreshControl)
        
        self.vwBottomMain?.isHidden = self.isChatClose
        
        self.lblUserName?.text = self.chatUserName
        self.imgProfile?.setImage(withUrl: self.chatUserImage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        
        self.lblAttachSubText?.forEach({
            $0.textColor = UIColor.CustomColor.appColor
            $0.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 10.0))
        })
        
        self.getChatListData()
    }
    
    @objc func socketReConnectNotification(notification: Notification) {
        print("Chat Reconnect Notification")
        if self.arrChatMsg.isEmpty {
            self.pageNo = 0
            self.arrChatMsg.removeAll()
            self.tblChat?.reloadData()
            self.getChatListData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
       self.getChatListData()
    }
    
}

//MARK: - NotificateionValueDelegate methods
extension ChatDetailViewController {
    
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
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom + 25.0
                }
            }
            
            self.constraintVWMainBottom?.constant = (keyboardHeight > 0) ? keyboardHeight : 30.0 //+ (DeviceType.IS_PAD ? 18 : 9)
            self.setScrollBottom()
            //self.vwCenterContentMain?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 40.0)
            self.vwCenterContentMain?.layoutIfNeeded()
            view.layoutIfNeeded()
        }
    }
    
    func setScrollBottom() {
        
        if self.arrChatMsg.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrChatMsg.count-1, section: 0)
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
extension ChatDetailViewController : UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMsg.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath, with: ChatCell.self)
        if self.arrChatMsg.count > 0 {
            let obj = self.arrChatMsg[indexPath.row]
            switch MessageReplyType.init(rawValue: obj.type) ?? .Text {
            case .Text:
                
                cell.SetChatMessageData(obj: obj, loginUserId: self.loginUserId)
                //cell.delegate = self
                
                break
            case .Image:
                
                cell.SetChatImageViewData(obj: obj, loginUserId: self.loginUserId)
                
                cell.btnImgSending?.tag = indexPath.row
                cell.btnImgIncoming?.tag = indexPath.row
                
                cell.btnImgSending?.addTarget(self, action: #selector(self.btnImgOpenClick(_:)), for: .touchUpInside)
                cell.btnImgIncoming?.addTarget(self, action: #selector(self.btnImgOpenClick(_:)), for: .touchUpInside)
                
                break
            case .Video:
                break
            case .CareGiver:
                cell.SetChatCareGiverData(obj: obj, loginUserId: self.loginUserId)
                
                cell.btnIncominhCaregiver?.tag = indexPath.row
                cell.btnSendingCaregiver?.tag = indexPath.row
                
                cell.btnIncominhCaregiver?.addTarget(self, action: #selector(self.btnCaregiverOpenClick(_:)), for: .touchUpInside)
                cell.btnSendingCaregiver?.addTarget(self, action: #selector(self.btnCaregiverOpenClick(_:)), for: .touchUpInside)
                break
            case .Files:
                cell.SetChatFilesData(obj: obj, loginUserId: self.loginUserId)
                
                cell.btnIncomingFiles?.tag = indexPath.row
                cell.btnSendingFiles?.tag = indexPath.row
                
                cell.btnIncomingFiles?.addTarget(self, action: #selector(self.btnFilesOpenClick(_:)), for: .touchUpInside)
                cell.btnSendingFiles?.addTarget(self, action: #selector(self.btnFilesOpenClick(_:)), for: .touchUpInside)
                break
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func btnCaregiverOpenClick(_ sender : UIButton){
    }
    
    @objc func btnFilesOpenClick(_ sender : UIButton){
        if self.arrChatMsg.count > 0 {
            let obj = self.arrChatMsg[sender.tag]
            guard let urldata = URL(string: "\(AppConstant.API.MAIN_URL)/assets/uploads/\(obj.message)") else { return }
            let safariVC = SFSafariViewController(url: urldata)
            safariVC.delegate = self
            safariVC.modalTransitionStyle = .crossDissolve
            safariVC.modalPresentationStyle = .overFullScreen
            self.present(safariVC, animated: true,completion: nil)
        }
    }
    
    @objc func btnImgOpenClick(_ sender : UIButton){
        if self.arrChatMsg.count > 0 {
            let obj = self.arrChatMsg[sender.tag]
            let url : String = "\(AppConstant.API.MAIN_URL)/assets/uploads/\(obj.message)"
            self.appNavigationController?.present(ImagePreviewViewController.self, configuration: { (vc) in
                vc.imageUrl = url
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
            })
        }
    }
}

// MARK: - SFSafariViewControllerDelegate
extension ChatDetailViewController : SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Textfeild Delegate
extension ChatDetailViewController : UITextViewDelegate {
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

// MARK: - Chat Messages Methods
extension ChatDetailViewController {
    private func getChatListData(){
        
        self.lblNoData?.isHidden = self.arrChatMsg.count == 0 ? false : true
        self.lblNoData?.text = "Waiting for message list..."
        
        let dictionary : [String:Any] = [khookMethod: isFromChatInbox ? AppConstant.WebSocketAPI.kchatmessagelist : AppConstant.WebSocketAPI.kusermessagelist,
                                         kid : self.chatUserID,
                                         kpage : "\(self.pageNo)",
                                         klimit : "20"]
        WebSocketChat.shared.writeSocketData(dict: dictionary)
        
    }
    
    private func sendMessage(msg : String,replytype: String,fileRealName : String = ""){
        
        self.txtMsg?.text = ""
        var dictionary : [String:Any] = [khookMethod: AppConstant.WebSocketAPI.kmessage,
                                         krecipient_id : self.chatGroupID,
                                         kmessage : msg.encodindEmoji(),
                                         ktype : replytype]
        if !fileRealName.isEmpty {
            dictionary[kattachmentRealName] = fileRealName
        }
        WebSocketChat.shared.writeSocketData(dict: dictionary)
        self.mediaName = ""
        self.setTxtMsgHeight(value: 35)
    }
    
    private func mediaAPICall(img : UIImage) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadMedia(with: dict, image: img, success: { (msg) in
            self.mediaName = msg
            
            self.sendMessage(msg: self.mediaName, replytype: MessageReplyType.Image.rawValue)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
                //self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })
    }
    
    private func mediaPDFAPICall(data : Data,filename : String) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadPDFMedia(with: dict, pdfdata: data, success: { (medianame,mediaurl) in
            //self.mediaName = msg
            self.sendMessage(msg: medianame, replytype: MessageReplyType.Files.rawValue,fileRealName : filename)
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
}

// MARK: - WebSocket Delegate
extension ChatDetailViewController : webSocketChatDelegate{
    func SendReceiveData(dict: [String : AnyObject]) {
        print(dict)
        //self.tblChat?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        //self.refreshControl.endRefreshing()
        if let hookmethod = dict[khookMethod] as? String {
            if hookmethod == AppConstant.WebSocketAPI.kchatmessagelist || hookmethod == AppConstant.WebSocketAPI.kusermessagelist {
                //self.tblTicket.es.stopPullToRefresh()
                self.refreshControl.endRefreshing()
                if let group = dict[kgroup] as? [String:Any] {
                    //let groupstatus = group[kgroupStatus] as? String ?? ""
                    //self.vwBottomTypeText.isHidden = groupstatus == "1" ? false : true
                    self.lblUserName?.text = group[kname] as? String ?? ""
                    self.chatGroupID = group[kid] as? String ?? ""
                    
                }
                
                let totalpages = dict["total_page"] as? String ?? "0"
                print(totalpages)
                self.totalPages = Int(totalpages) ?? 0
                
                if let dataarr = dict[kData] as? [[String:Any]] {
                    let arrNewData = dataarr.compactMap(ChatModel.init)
                    var arrMainChatList : [ChatModel] = []
                    arrMainChatList.append(contentsOf: arrNewData.reversed())
                    if self.arrChatMsg.count > 0 {
                        arrMainChatList.append(contentsOf: self.arrChatMsg)
                    }
                    self.arrChatMsg = arrMainChatList//.append(contentsOf: arrNewData)
                    //self.arrChatMsg.reverse()
                   // DispatchQueue.main.async {
                        self.tblChat?.reloadData()
                    if self.pageNo == 1 {
                        self.setScrollBottom()
                    }
                    //}
                    
                }
                
                if self.pageNo == self.totalPages{
                    self.refreshControl.removeFromSuperview()
                    self.tblChat?.refreshControl = nil
                }
                
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrChatMsg.count > 0 ? true : false
                self.lblNoData?.text = "No Messages Available!"
                
                
            }  else {
                if let dataarr = dict[kData] as? [String:Any],let model = ChatModel.init(dictionary: dataarr) {
                    self.arrChatMsg.append(model)
                    self.tblChat?.reloadData()
                    self.setScrollBottom()
                }
                self.lblNoData?.isHidden = self.arrChatMsg.count > 0 ? true : false
                self.lblNoData?.text = "No Messages Available!"
            }
        }
    }
}

// MARK: - IBAction
extension ChatDetailViewController {
    
    @IBAction func btnSendMsgClicked(_ sender: UIButton) {
        if !(self.txtMsg?.isEmpty ?? false) {
            self.sendMessage(msg: self.txtMsg?.text ?? "", replytype: MessageReplyType.Text.rawValue)
        }
    }
    
    @IBAction func btnMoreClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.appNavigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAttachClicked(_ sender: UIButton) {
        self.view.endEditing(true)
       
        self.btnAttach?.isSelected = !(self.btnAttach?.isSelected ?? false)
        if self.btnAttach?.isSelected ?? false {
            self.openAttachTextViewHeight = self.constraintTxtMsgHeight?.constant ?? 0.0
            self.setTxtMsgHeight(value: 35.0)
            self.vwChatTextTypeMain?.isHidden = true
            self.vwAttachMain?.isHidden = false
            self.vwSendMain?.isHidden = true
        } else {
            self.setTxtMsgHeight(value: self.openAttachTextViewHeight)
            self.vwChatTextTypeMain?.isHidden = false
            self.vwAttachMain?.isHidden = true
            self.vwSendMain?.isHidden = false
        }
    }
    
    @IBAction func btnAttachCareGiverClicked(_ sender: UIButton) {
        self.appNavigationController?.present(ListCommonDataPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.OpenFromType = .SubstituteJob
            vc.delegate = self
            vc.isFromChatDetailCaregiverShare = true
        })
    }
    
    @IBAction func btnAttachImageClicked(_ sender: UIButton) {
        self.imagePicker.pickImage(sender, "Select Media") { (img,url) in
            self.mediaAPICall(img: img)
        }
    }
    
    @IBAction func btnAttachFilesClicked(_ sender: UIButton) {
        self.documentpicker.openDocumentPicker(){ (url) in
           
            if url != nil {
                do{
                    let imageData: Data = try Data(contentsOf: url)
                    //audio/mpeg
                    //self.fileName = url.lastPathComponent
                    self.mediaPDFAPICall(data: imageData,filename: url.lastPathComponent)
                    //m4a
                    print(imageData)
                }catch{
                    print("Unable to load data: \(error)")
                }
            }
        }
    }
}

//MARK : - ListCommonDataDelegate
extension ChatDetailViewController : ListCommonDataDelegate {
    func selectHearAboutData(obj: HearAboutUsModel) {
        
    }
    
    func selectCertificateTypeData(obj: licenceTypeModel, selectIndex: Int) {
        
    }
    
    func selectWorkSpecialityData(obj: WorkSpecialityModel) {
        
    }
    
    func selectInsuranceTypeData(obj: InsuranceTypeModel, selectIndex: Int) {
        
    }
    
    func selectWorkMethodTransportationData(obj: WorkMethodOfTransportationModel) {
        
    }
    
    func selectDisabilitiesData(obj: [WorkDisabilitiesWillingTypeModel]) {
        
    }
    
    func selectAdditionalQuestionData(obj: [AdditionalQuestionModel],isFromModifyQuestion : Bool) {
    }
    
    func selectSubstituteCaregiverData(obj: CaregiverListModel) {
        //self.caregiverSubstituteJobAPICall(caregiverid: obj.id)
        self.sendMessage(msg: obj.id, replytype: MessageReplyType.CareGiver.rawValue,fileRealName : "")
    }
}

// MARK: - ViewControllerDescribable
extension ChatDetailViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Chat
    }
}

// MARK: - AppNavigationControllerInteractable
extension ChatDetailViewController: AppNavigationControllerInteractable { }
