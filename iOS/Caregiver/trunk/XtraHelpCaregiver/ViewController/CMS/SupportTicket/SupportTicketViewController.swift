//
//  SupportTicketViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class SupportTicketViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tblSupportTicket: UITableView?
    
    @IBOutlet weak var lblNoData: NoDataFoundLabel?
    // MARK: - Variables
    private var arrTicket : [TicketModel] = []
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

// MARK: - Init Configure
extension SupportTicketViewController {
    private func InitConfig(){
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblSupportTicket?.register(SupportTicketCell.self)
        self.tblSupportTicket?.register(SupportTicketHeaderCell.self)
        self.tblSupportTicket?.estimatedRowHeight = 100.0
        self.tblSupportTicket?.rowHeight = UITableView.automaticDimension
        self.tblSupportTicket?.delegate = self
        self.tblSupportTicket?.dataSource = self
        
        self.setupESInfiniteScrollinWithTableView()
        self.getTicketList()
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Help & Support", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK:- UITableView Delegate
extension SupportTicketViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.arrTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: SupportTicketHeaderCell.self)
            //cell.btnCreateTicket?.addTarget(self, action: self.btnCreateTicketClicked(cell.btnCreateTicket ?? UIButton()), for: .touchUpInside)
            cell.btnCreateTicket?.addTarget(self, action: #selector(self.btnCreateTicketClicked(_:)), for: .touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, with: SupportTicketCell.self)
        //cell.isTicketClose = (indexPath.row == 1 || indexPath.row == 2)
        /*if indexPath.row == 0 {
            cell.lblticketSubject?.text = "My subscription is not renewed, but the payment is done."
            cell.lblticketDesc?.text = "I have made the payment, but I am still not able to get access to the recorded sessions. Can you please process the glitch?"
        } else if indexPath.row == 1 {
            cell.lblticketSubject?.text = "How to update the schedule?"
            cell.lblticketDesc?.text = "I have update the schedule, but I am still not able to get access to the schedule sessions. Can you please process the glitch?"
        } else if indexPath.row == 2 {
            cell.lblticketSubject?.text = "I am not able to retrieve the recorded sessions."
            cell.lblticketDesc?.text = "I have update the schedule, but I am still not able to get access to the schedule sessions. Can you please process the glitch?"
        } else if indexPath.row == 3 {
            cell.lblticketSubject?.text = "Forgot Password."
            cell.lblticketDesc?.text = "Can you please process the glitch?"
        }*/
        if self.arrTicket.indices ~= indexPath.row {
            let obj = self.arrTicket[indexPath.row]
            cell.setupTicketData(obj: obj)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrTicket.count > 0 {
            let obj = self.arrTicket[indexPath.row]
            self.appNavigationController?.push(SupportChatDetailViewController.self,configuration: { vc in
                vc.isChatClose = (obj.status == "0")
                vc.ticketData = obj
            })
        }
    }
    
    @objc func btnCreateTicketClicked(_ sender : UIButton){
        //@objc func btnCreateTicketClicked(_ sender : UIButton){
        self.appNavigationController?.present(AddTicketViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
        })
    }
}

//MARK: Pagination tableview Mthonthd
extension SupportTicketViewController {
    
    private func reloadTicketData(){
        self.view.endEditing(true)
        //self.reloadFeedData()
        self.pageNo = 1
        self.arrTicket.removeAll()
        self.tblSupportTicket?.reloadData()
        self.getTicketList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.tblSupportTicket?.es.addPullToRefresh {
            [unowned self] in
            self.reloadTicketData()
            //self.tblFeed.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        }
        
        tblSupportTicket?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    //if self.isLoadingLikeTbl {
                    self.getTicketList()
                    //}
                } else if self.pageNo <= self.totalPages {
                    //if self.isLoadingLikeTbl {
                    self.getTicketList(isshowloader: false)
                    //}
                } else {
                    self.tblSupportTicket?.es.noticeNoMoreData()
                }
            } else {
                self.tblSupportTicket?.es.noticeNoMoreData()
            }
        }
        if let animator = self.tblSupportTicket?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.tblSupportTicket?.es.noticeNoMoreData()
            }
            else {
                self.tblSupportTicket?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.tblSupportTicket?.es.stopLoadingMore()
            self.tblSupportTicket?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}
extension SupportTicketViewController{
    
    private func getTicketList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "10",
                ksearch : ""
                
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            TicketModel.getTicketList(with: param, isShowLoader: isshowloader,  success: { (arr,totalpage) in
                //self.arrResources = arr
                self.tblSupportTicket?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrTicket.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.lblNoData?.isHidden = self.arrTicket.count == 0 ? false : true
                self.tblSupportTicket?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.tblSupportTicket?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false)
                if statuscode == APIStatusCode.NoRecord.rawValue {
                    self.lblNoData?.isHidden = false
                    self.lblNoData?.text = error
                    self.tblSupportTicket?.reloadData()
                } else {
                    if !error.isEmpty {
                        self.showMessage(error, themeStyle: .error)
                        //self.showAlert(withTitle: errorType.rawValue, with: error)
                    }
                }
            })
        }
    }
}

// MARK: - Add New Ticket Delegate
extension SupportTicketViewController : addNewTicketDelegate{
    func addnewticket() {
        self.reloadTicketData()
    }
}

// MARK: - ViewControllerDescribable
extension SupportTicketViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension SupportTicketViewController: AppNavigationControllerInteractable { }

