//
//  FAQViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 30/11/21.
//

import UIKit

class FAQViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTalkHeader: UILabel?
    @IBOutlet weak var lblFAQHeader: UILabel?
    @IBOutlet weak var lblNeedHelp: UILabel?
    @IBOutlet weak var lblNeedHelpDesc: UILabel?
    @IBOutlet weak var lblActiveHeader: UILabel?
    @IBOutlet weak var lblActiveCount: UILabel?
    @IBOutlet weak var lblHelpNavTitle: UILabel!
    
    @IBOutlet weak var vwTalkMain: UIView?
    @IBOutlet weak var vwFAQMain: UIView?
    @IBOutlet weak var vwHelpMain: UIView?
    @IBOutlet weak var vwActiveMain: UIView?
    @IBOutlet weak var vwActiveSub: UIView?
    @IBOutlet weak var vwActiveDot: UIView?
    
    @IBOutlet weak var tblFAQ: UITableView?
    @IBOutlet weak var constraintTblFAQHeight: NSLayoutConstraint?
    
    @IBOutlet weak var vwSearch: SearchView?
    
    @IBOutlet weak var btnBack: UIButton?
    @IBOutlet weak var btnActiveTicket: UIButton?
    
    @IBOutlet weak var scrollview: UIScrollView?
    
    // MARK: - Variables
    private var arrFaq : [FAQModel] = []
    
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
        //self.configureNavigationBar()
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        self.addTableviewOberver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       // print("Safe Area : \(self.view.safeAreaInsets.top)")
        //let top = self.view.safeAreaInsets.top / 2
        //self.constraintTopviewTop?.constant = (top > 40) ? (top + 5.0) : (top - 5.0)
        
        //self.vwActiveDot?.roundedCornerRadius()
        
        //self.btnBack?.cornerRadius = (self.btnBack?.frame.height ?? 1.0) / 3
    }
    
}

// MARK: - Init Configure
extension FAQViewController {
    private func InitConfig(){
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTalkHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTalkHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        [self.lblFAQHeader,self.lblNeedHelp].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        })
        
        self.lblNeedHelpDesc?.textColor = UIColor.CustomColor.talkDescColor
        self.lblNeedHelpDesc?.font = UIFont.RubikLight(ofSize: GetAppFontSize(size: 15.0))
        
        self.lblActiveHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblActiveHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblActiveCount?.textColor = UIColor.CustomColor.whitecolor
        self.lblActiveCount?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 9.0))
        
        self.vwActiveSub?.cornerRadius = 9.0
        self.vwActiveSub?.backgroundColor = UIColor.CustomColor.whitecolor
        self.lblHelpNavTitle?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        self.lblHelpNavTitle?.textColor = UIColor.CustomColor.tabBarColor
        
        self.vwActiveDot?.backgroundColor = UIColor.CustomColor.countBGColor
        self.vwActiveDot?.cornerRadius = 4.0
        
        self.vwSearch?.txtSearch?.returnKeyType = .search
        self.vwSearch?.txtSearch?.delegate = self
        self.vwSearch?.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
        
        self.tblFAQ?.register(HelpSupportCell.self)
        //self.tblFAQ?.register(headerFooterViewType: HelpSupportHeaderSectionCell.self)
        self.tblFAQ?.rowHeight = UITableView.automaticDimension
        self.tblFAQ?.delegate = self
        self.tblFAQ?.dataSource = self
        self.setupESInfiniteScrollinWithTableView()
        self.getFaqList()
        
        /*let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)*/
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "FAQs", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

extension FAQViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let tbl = self.tblFAQ, touch.view?.isDescendant(of: tbl) == true {
            return false
        }
        return true
    }
}

//MARK: Pagination tableview Mthonthd
extension FAQViewController {
    
    private func reloadFAQData(){
        self.pageNo = 1
        self.arrFaq.removeAll()
        self.tblFAQ?.reloadData()
        self.getFaqList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            //self.reloadFeedData()
            self.reloadFAQData()
            //self.tblFeed.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
        }
        
        scrollview?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    //if self.isLoadingLikeTbl {
                    self.getFaqList()
                    //}
                } else if self.pageNo <= self.totalPages {
                    //if self.isLoadingLikeTbl {
                    self.getFaqList(isshowloader: false)
                    //}
                } else {
                    self.scrollview?.es.noticeNoMoreData()
                }
            } else {
                self.scrollview?.es.noticeNoMoreData()
            }
        }
        if let animator = self.scrollview?.footer?.animator as? ESRefreshFooterAnimator {
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
                self.scrollview?.es.noticeNoMoreData()
            }
            else {
                self.scrollview?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.scrollview?.es.stopLoadingMore()
            self.scrollview?.es.noticeNoMoreData()
            self.isLoading = true
        }
    }
}

//MARK: - Tableview Observer
extension FAQViewController {
    
    private func addTableviewOberver() {
        self.tblFAQ?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblFAQ?.observationInfo != nil {
            self.tblFAQ?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblFAQ && keyPath == ObserverName.kcontentSize {
                self.constraintTblFAQHeight?.constant = self.tblFAQ?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension FAQViewController : UITableViewDataSource, UITableViewDelegate {
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return 1//3//self.arrFaq.count
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if self.arrFaq.count > 0 {
            return self.arrFaq[section].faqList.count
        }*/
        return self.arrFaq.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /* if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, with: HelpSupportHeaderCell.self)
            
            return cell
        } else {*/
            let cell = tableView.dequeueReusableCell(for: indexPath, with: HelpSupportCell.self)
        /*if indexPath.row == 0 {
            cell.lblCMSDesc?.text = "What all categories are available at Momentor?"
        } else if indexPath.row == 1 {
            cell.lblCMSDesc?.text = "Can we plan personal sessions?"
        } else if indexPath.row == 2 {
            cell.lblCMSDesc?.text = "What if I miss the workshop, will I get a recorded session?"
        } else if indexPath.row == 3 {
            cell.lblCMSDesc?.text = "How can we plan a session with our mentors?"
        }*/
        if self.arrFaq.count > 0 {
            cell.lblCMSDesc?.text = self.arrFaq[indexPath.row].name
        }
            return cell
        //}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrFaq.count > 0 {
            self.appNavigationController?.push(TermConditionViewController.self,configuration: { (vc) in
                vc.isFromFAQ = true
                vc.selectedFAQId = self.arrFaq[indexPath.row].id
            })
        }
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = tableView.dequeueReusableHeaderFooterView(HelpSupportHeaderSectionCell.self)
        /*if self.arrFaq.count > 0 {
            let obj = self.arrFaq[section]
            //self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView" ) as! MapTableHeaderView
            hView?.lblHeader.text = obj.caregoryName
        }*/
        return hView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height : CGFloat = DeviceType.IS_PAD ? 80.0 : 40.0
        /*if self.arrFaq.count > 0{
          let obj = self.arrFaq[section]
            height = obj.caregoryName == "" ? 0.0 : height
        }*/
        return 0.0//height//DeviceType.IS_PAD ? 80.0 : 40.0
    }*/
}

// MARK: - IBAction
extension FAQViewController {
    @IBAction func btnActiveTicketClicked(_ sender: UIButton) {
        print("Click")
        self.appNavigationController?.push(SupportTicketViewController.self)
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension FAQViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if !(textField.isEmpty) {
            self.reloadFAQData()
        }
        return true
    }
    
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
        if textField.isEmpty {
            //self.view.endEditing(true)
            self.reloadFAQData()
        }
    }
}

//MARK:- API Call
extension FAQViewController {
    private func getFaqList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "20",
                ksearch : self.vwSearch?.txtSearch?.text ?? "",
                ktype : XtraHelp.sharedInstance.carGiverType
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FAQModel.getFAQList(with: param,isShowLoader : isshowloader, success: { (arr,totalpage,msg) in
                //self.arrResources = arr
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrFaq.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.tblFAQ?.reloadData()
                
                //self.lblNoData.text = msg
                //self.lblNoData.isHidden = self.arrFaq.count > 0 ? true : false
            }, failure: {(statuscode,error, errorType) in
                print(error)
                //if !error.isEmpty {
                   // self.showAlert(withTitle: errorType.rawValue, with: error)
                //}
                //self.lblNoData.text = "\(error)"
                //self.lblNoData.isHidden = self.arrFaq.count > 0 ? true : false
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension FAQViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension FAQViewController: AppNavigationControllerInteractable { }

