//
//  ChatListViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class ChatListViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tblChat: UITableView?
    
    @IBOutlet weak var vwSearch: SearchView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    
    // MARK: - Variables
    private var arrChatList : [ChatModel] = []
    private var isSearchAPICall : Bool = false
    private var isSearchClick : Bool = false
    
    private var noMsgVailableText : String = "No messages available!"
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        
        WebSocketChat.shared.delegate = self
        self.getChatListData()
    }
}

// MARK: - Init Configure
extension ChatListViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblChat?.register(ChatUserListCell.self)
        self.tblChat?.estimatedRowHeight = 100.0
        self.tblChat?.rowHeight = UITableView.automaticDimension
        self.tblChat?.delegate = self
        self.tblChat?.dataSource = self
        
        self.vwSearch?.txtSearch?.delegate = self
        self.vwSearch?.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.setupESInfiniteScrollinWithTableView()
    }
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Messages", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension ChatListViewController {
    
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblChat?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.arrChatList.removeAll()
            self.tblChat?.reloadData()
            self.getChatListData()
        }
    }
}

//MARK:- UITableView Delegate
extension ChatListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath, with: ChatUserListCell.self)
        //cell.isUnSeenChat = indexPath.row == 0 || indexPath.row == 1
        if self.arrChatList.count > 0 {
            cell.setUserMsgData(obj: self.arrChatList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if self.arrChatList.count > 0 {
            let obj = self.arrChatList[indexPath.row]
            self.appNavigationController?.push(ChatDetailViewController.self,configuration: { (vc) in
                vc.chatUserID = obj.id
                vc.chatUserName = obj.name
                vc.chatUserImage = obj.thumbImage
                vc.isFromChatInbox = true
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in
            //Write your code in here
            self.showAlert(withTitle: "", with: "Are you sure want to delete this chat?", firstButton: ButtonTitle.Yes, firstHandler: { (alert) in
                if self.arrChatList.count > 0 {
                    self.deleteChat(id: self.arrChatList[indexPath.row].id)
                }
            }, secondButton: ButtonTitle.No, secondHandler: nil)
        }
        item.image = UIImage(named: "ic_DeleteBlack")
        //item.backgroundColor = UIColor.white
        
        item.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

extension ChatListViewController : webSocketChatDelegate{
    func SendReceiveData(dict: [String : AnyObject]) {
        print(dict)
        self.tblChat?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        if let hookmethod = dict[khookMethod] as? String {
            
            self.lblNoData?.text = ""
            if hookmethod == AppConstant.WebSocketAPI.kchatinbox {
                //self.refreshControl.endRefreshing()
                self.arrChatList.removeAll()
                if let dataarr = dict[kData] as? [[String:Any]] {
                    self.arrChatList = dataarr.compactMap(ChatModel.init)
                    
                    self.lblNoData?.isHidden = self.arrChatList.count > 0 ? true : false
                    self.lblNoData?.text = self.noMsgVailableText
                    self.tblChat?.reloadData()
                } else {
                    self.lblNoData?.isHidden = false
                    self.lblNoData?.text = self.noMsgVailableText
                }
            } else if hookmethod == AppConstant.WebSocketAPI.kremovechatmessagelist {
                //self.showMessage("Chat Deleted Successfully")
                self.getChatListData()
                print("Chat Deleted Successfully")
            } else {
                self.lblNoData?.isHidden = self.arrChatList.count > 0 ? true : false
                self.lblNoData?.text = self.noMsgVailableText
            }
        }
    }
    
    private func getChatListData(){
        
        self.lblNoData?.isHidden = self.arrChatList.count == 0 ? false : true
        self.lblNoData?.text = "Waiting for fetch messages!"
        
        //self.vwSearch?.txtSearch?.resignFirstResponder()
        let dictionary : [String:Any] = [khookMethod: AppConstant.WebSocketAPI.kchatinbox,
                                         ksearch : self.vwSearch?.txtSearch?.text ?? ""]
        WebSocketChat.shared.writeSocketData(dict: dictionary)
    }
    
    private func deleteChat(id : String){
        
        let dictionary : [String:Any] = [khookMethod: AppConstant.WebSocketAPI.kremovechatmessagelist,
                                         kid : id]
        WebSocketChat.shared.writeSocketData(dict: dictionary)
    }
}

//MARK: - TextField Delegate
extension ChatListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.vwSearch?.txtSearch == textField {
            if textField.returnKeyType == .search {
                self.isSearchClick = true
                self.isSearchAPICall = false
                self.vwSearch?.txtSearch?.text = textField.text ?? ""
                self.getChatListData()
            }
        }
        return true
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        if textField.text == "" || textField.isEmpty {
            self.isSearchClick = false
            self.isSearchAPICall = false
            textField.resignFirstResponder()
            self.getChatListData()
        } else {
            if !self.isSearchAPICall {
                if self.isSearchClick {
                    self.isSearchClick = false
                }
                self.isSearchAPICall = true
                delay(seconds: 1.0) {
                    if !self.isSearchClick {
                        self.isSearchAPICall = false
                        if textField.text != "" {
                            self.getChatListData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension ChatListViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Chat
    }
}

// MARK: - AppNavigationControllerInteractable
extension ChatListViewController: AppNavigationControllerInteractable { }
