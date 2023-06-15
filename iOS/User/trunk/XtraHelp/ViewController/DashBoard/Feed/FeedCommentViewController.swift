//
//  FeedCommentViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class FeedCommentViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tblFeedComment: UITableView?
    
    @IBOutlet weak var vwSendMain: UIView?
    @IBOutlet weak var vwBottomTextView: UIView?
    
    @IBOutlet weak var btnAttach: UIButton?
    @IBOutlet weak var btnSendComment: UIButton?
    
    @IBOutlet weak var txtSendComment: UITextView?
    @IBOutlet weak var constraintTxtMsgHeight: NSLayoutConstraint?
    @IBOutlet weak var constraintVWMainBottom: NSLayoutConstraint?
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var arrComment : [FeedUserLikeModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    var selectedFeedData : FeedModel?
    
    private let imagePicker = ImagePicker()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.addKeyboardObserver()
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
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
extension FeedCommentViewController {
    private func InitConfig(){
        
        self.imagePicker.viewController = self
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblFeedComment?.register(FeedCommentCell.self)
        self.tblFeedComment?.estimatedRowHeight = 100.0
        self.tblFeedComment?.rowHeight = UITableView.automaticDimension
        self.tblFeedComment?.delegate = self
        self.tblFeedComment?.dataSource = self
        
        self.txtSendComment?.placeholder = "Type your message..."
        self.txtSendComment?.placeholderColor = UIColor.CustomColor.appPlaceholderColor
        self.txtSendComment?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.txtSendComment?.textColor = UIColor.CustomColor.blackColor
        self.txtSendComment?.delegate = self
        self.txtSendComment?.centerVertically()
        self.txtSendComment?.autocorrectionType = .no
        
        self.setupESInfiniteScrollinWithTableView()
        self.getFeedCommentUserList()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Comments", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: - NotificateionValueDelegate methods
extension FeedCommentViewController {
    
    //MARK:- Notification observer for keyboard
    func addKeyboardObserver () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        self.tblFeedComment?.addGestureRecognizer(tapGesture)
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
            
            self.constraintVWMainBottom?.constant = keyboardHeight + 20.0//+ (DeviceType.IS_PAD ? 18 : 9) + 30.0
            self.setScrollBottom()
            view.layoutIfNeeded()
        }
    }
    
    func setScrollBottom() {
        
        if self.arrComment.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrComment.count-1, section: 0)
                self.tblFeedComment?.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
extension FeedCommentViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrComment.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: FeedCommentCell.self)
        if self.arrComment.count > 0 {
            cell.setCommentFeedUserData(obj: self.arrComment[indexPath.row])
            
            cell.btnMoreSelect?.tag = indexPath.row
            cell.btnMoreSelect?.addTarget(self, action: #selector(self.btnMoreClicked(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.appNavigationController?.push(MentorProfileViewController.self)
    }
    
    @objc func btnMoreClicked(_ sender : UIButton){
        /*if self.arrComment.count > 0 {
            self.appNavigationController?.detachLeftSideMenu()
            self.appNavigationController?.present(PopupViewController.self,configuration: { (vc) in
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.isFromFeedTab = true
                vc.isFromFeedComment = true
                vc.feeddelegate = self
                vc.selectedFeedCommentData = self.arrComment[sender.tag]
            })
        }*/
        if self.arrComment.count > 0 {
            let obj = self.arrComment[sender.tag]
            let getDirectionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let reportAction = UIAlertAction(title: "Report", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                //self.appNavigationController?.detachLeftSideMenu()
                self.appNavigationController?.present(FeedReportPopupViewController.self,configuration: { (vc) in
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.selectedFeedCommentData = obj
                    vc.isFromComment = true
                })
            })
            
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.showAlert(withTitle: "", with: "Are you sure want to delete this feed comment?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
                    self.deleteFeedComment(feedID: obj.feedId, feedcommentid: obj.id)
                }, secondButton: ButtonTitle.No, secondHandler: nil)
            })
            //cancel
            let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
     
                
            })
            
            getDirectionMenu.popoverPresentationController?.sourceView = sender as? UIView
            //        getDirectionMenu.popoverPresentationController?.permittedArrowDirections = .down
            
            if let user = UserModel.getCurrentUserFromDefault() {
                if (user.id == obj.userId) {
                    getDirectionMenu.addAction(deleteAction)
                } else {
                    getDirectionMenu.addAction(reportAction)
                }
            }
            
            getDirectionMenu.addAction(cancelAction)
            self.present(getDirectionMenu, animated: true, completion: nil)
        }
    }
}

// MARK: - FeedCellDelegate
extension FeedCommentViewController : feedPopupDelegate {
    func feedCommentReport(btn: UIButton, obj: FeedUserLikeModel) {
        self.view.endEditing(true)
        //self.appNavigationController?.detachLeftSideMenu()
        self.appNavigationController?.present(FeedReportPopupViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.selectedFeedData = self.selectedFeedData
            vc.selectedFeedCommentData = obj
            vc.isFromComment = true
        })
    }
    
    func feedCommentDelete(btn: UIButton, obj: FeedUserLikeModel) {
        self.view.endEditing(true)
        self.showAlert(withTitle: "", with: "Are you sure want to delete this feed comment?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
            self.deleteFeedComment(feedID: obj.feedId, feedcommentid: obj.id)
        }, secondButton: ButtonTitle.No, secondHandler: nil)
    }
    
    func feedReport(btn: UIButton, obj: FeedModel) {
        
    }
    
    func feedDelete(btn: UIButton, obj: FeedModel) {
        
    }
}

//MARK:- Textfeild Delegate
extension FeedCommentViewController : UITextViewDelegate {
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


//MARK: Pagination tableview Mthonthd
extension FeedCommentViewController {
    
    private func reloadFeedData(isScrollBottom :Bool = false){
        self.view.endEditing(true)
        self.pageNo = 1
        //self.arrComment.removeAll()
        //self.tblFeedComment?.reloadData()
        //self.getFeedCommentUserList(isshowloader: true, isScrollBottom: isScrollBottom)
        self.getFeedCommentUserList(isshowloader: false, isScrollBottom: false,isFromPullRefresh : true)
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblFeedComment?.es.addPullToRefresh {
            [unowned self] in
            self.reloadFeedData()
        }
        
        self.tblFeedComment?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getFeedCommentUserList()
                } else if self.pageNo <= self.totalPages {
                    self.getFeedCommentUserList(isshowloader: false)
                } else {
                    self.tblFeedComment?.es.noticeNoMoreData()
                }
            } else {
                self.tblFeedComment?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblFeedComment?.footer?.animator as? ESRefreshFooterAnimator {
            animator.noMoreDataDescription = ""
        }
    }
    
    /**
     This function is used to hide the footer infinte loading.
     - Parameter success: Used to know API reponse is succeed or fail.
     */
    //Harshad
    func hideFooterLoading(success: Bool) {
        if success {
            if self.pageNo == self.totalPages {
                self.tblFeedComment?.es.noticeNoMoreData()
            }
            else {
                self.tblFeedComment?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblFeedComment?.es.stopLoadingMore()
            self.tblFeedComment?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}

// MARK: - IBAction
extension FeedCommentViewController {
    @IBAction func btnSendCommentClicked(_ sender: UIButton) {
        if !(self.txtSendComment?.isEmpty ?? false) {
            self.view.endEditing(true)
            self.setFeedComment()
        }
    }
    
    @IBAction func btnAttachClicked(_ sender: UIButton) {
        /*self.view.endEditing(true)
        self.imagePicker.isAllowsEditing = true
        self.imagePicker.pickImage(sender, "Select Image") { (img,url) in
            self.mediaAPICall(img: img,index : sender.tag)
        }*/
    }
}

//MARK:- API Call
extension FeedCommentViewController{
    
    private func getFeedCommentUserList(isshowloader :Bool = true,isScrollBottom :Bool = false,isFromPullRefresh : Bool = false){
        if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedData {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "15",
                ksearch : "",
                kuserFeedId : feeddata.id
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedUserLikeModel.getFeedLikeCommentUser(with: param,isShowLoader: isshowloader, isFromComment: true,  success: { (arr,totalpage,msg) in
                //self.arrUser.append(contentsOf: arr)
                if self.pageNo == 1 {
                    self.arrComment.removeAll()
                }
                self.tblFeedComment?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrComment.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrComment.count == 0 ? false : true
                self.tblFeedComment?.reloadData()
                
                //self.setScrollBottom()
                if isScrollBottom {
                    self.setTxtMsgHeight(value: 35.0)
                } else {
                    self.setScrollBottom()
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblFeedComment?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    self.lblNoData?.text = error
                    if pageNo == 1 {
                        self.arrComment.removeAll()
                    }
                    self.lblNoData?.isHidden = self.arrComment.count == 0 ? false : true
                    self.tblFeedComment?.reloadData()
                } else {
                    if !error.isEmpty {
                        self.showMessage(error, themeStyle: .error)
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                    }
                }
                if isScrollBottom {
                    self.setTxtMsgHeight(value: 35.0)
                } else if !isFromPullRefresh {
                    self.setScrollBottom()
                }
            })
        }
    }
    
    private func deleteFeedComment(feedID : String,feedcommentid : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kfeedId : feedID,
                kcommentId : feedcommentid
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.deleteFeed(with: param,isFromComment : true, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                self.reloadFeedData()
            }, failure: { (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func setFeedComment(){
        if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedData {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserFeedId : feeddata.id,
                kcomment : (self.txtSendComment?.text ?? "").encodindEmoji()
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.setFeedComment(with: param, success: { (msg) in
                self.txtSendComment?.text = ""
                self.pageNo = 1
                self.getFeedCommentUserList(isshowloader: true, isScrollBottom: true)
            }, failure: { (statuscode,error, errorType) in
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension FeedCommentViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.FeedTab
    }
}

// MARK: - AppNavigationControllerInteractable
extension FeedCommentViewController: AppNavigationControllerInteractable { }

