//
//  PaymentBillingViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

protocol paymentBillingDelegate {
    func selecetCard(obj : CardModel,applicantdata: JobApplicantsModel)
}

class PaymentBillingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var scrollview: UIScrollView?
    
    @IBOutlet weak var vwSaveCardMain: UIView?
    @IBOutlet weak var vwTransactionsMain: UIView?
    @IBOutlet weak var vwAddCardMain: UIView?
    
    @IBOutlet weak var btnAddCard: XtraHelpButton?
    @IBOutlet weak var btnSubmitJobPayment: XtraHelpButton?
    
    @IBOutlet weak var lblSaveCard: UILabel?
    @IBOutlet weak var lblTransactions: UILabel?
    
    @IBOutlet weak var tblSaveCard: UITableView?
    @IBOutlet weak var constraintTblSaveCardHeight: NSLayoutConstraint?
    @IBOutlet weak var tblTransactions: UITableView?
    @IBOutlet weak var constraintTblTransactionsHeight: NSLayoutConstraint?
    
    @IBOutlet weak var btnCancelJOb: UIButton?
    
    // MARK: - Variables
    private var arrCard : [CardModel] = []
    var isFromJobPayment : Bool = false
    var delegate : paymentBillingDelegate?
    private var selectedCard : CardModel?
    var selecetdJobApplicant : JobApplicantsModel?
    
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    private var arrTransaction : [TransactionModel] = []
    
    var isFromAwardJobPayment : Bool = false
    var awardJobID : String = ""
   
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.addTableviewOberver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}
// MARK: - Init Configure
extension PaymentBillingViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblSaveCard?.register(CardCell.self)
        //self.tblSaveCard?.isEditing = false
        //self.tblSaveCard?.gestureRecognizers?.removeAll()
        self.tblTransactions?.register(TransactionCell.self)
        
        [self.tblSaveCard,self.tblTransactions].forEach({
            $0?.estimatedRowHeight = 100.0
            $0?.rowHeight = UITableView.automaticDimension
            $0?.delegate = self
            $0?.dataSource = self
        })
        
        [self.lblTransactions,self.lblSaveCard].forEach({
            $0?.textColor = UIColor.CustomColor.tabBarColor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        })
        
        //self.vwAddCardMain?.isHidden = self.isFromJobPayment
        //self.vwTransactionsMain?.isHidden = self.isFromJobPayment
        
        self.btnCancelJOb?.titleLabel?.font = UIFont.RubikMedium(ofSize: 14.0)
        self.btnCancelJOb?.setTitleColor(UIColor.CustomColor.labelTextColor, for: .normal)
        
        self.getCardAPI()
        self.btnCancelJOb?.isHidden = !self.isFromAwardJobPayment
        if self.isFromAwardJobPayment {
            self.vwTransactionsMain?.isHidden = true
            self.btnSubmitJobPayment?.isHidden = false
            self.btnSubmitJobPayment?.setTitle("Pay Now", for: .normal)
        } else {
            self.vwTransactionsMain?.isHidden = self.isFromJobPayment
            self.btnSubmitJobPayment?.isHidden = !self.isFromJobPayment
            if !isFromJobPayment {
                self.setupESInfiniteScrollinWithTableView()
                self.getUserTransactionList()
            }
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: self.isFromJobPayment ? "Payment" : "Billing and payments", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        self.title = ""
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.clear, tintColor: UIColor.CustomColor.borderColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: Pagination tableview Mthonthd
extension PaymentBillingViewController {
    
    private func reloadTableData(){
        self.pageNo = 1
        self.arrTransaction.removeAll()
        self.tblTransactions?.reloadData()
        self.getUserTransactionList()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.reloadTableData()
        }
        
        self.scrollview?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getUserTransactionList()
                } else if self.pageNo <= self.totalPages {
                    self.getUserTransactionList(isshowloader: false)
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
extension PaymentBillingViewController {
    
    private func addTableviewOberver() {
        self.tblSaveCard?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
        self.tblTransactions?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblSaveCard?.observationInfo != nil {
            self.tblSaveCard?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
        if self.tblTransactions?.observationInfo != nil {
            self.tblTransactions?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblSaveCard && keyPath == ObserverName.kcontentSize {
                self.constraintTblSaveCardHeight?.constant = self.tblSaveCard?.contentSize.height ?? 0.0
            }
            if obj == self.tblTransactions && keyPath == ObserverName.kcontentSize {
                self.constraintTblTransactionsHeight?.constant = self.tblTransactions?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension PaymentBillingViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tblSaveCard ? self.arrCard.count : self.arrTransaction.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblSaveCard {
            let cell = tableView.dequeueReusableCell(for: indexPath, with: CardCell.self)
            //cell.btnMarkDefault?.isHidden = self.isFromJobPayment
            if self.isFromAwardJobPayment {
                cell.btnSelect?.isHidden = false
                cell.btnSelectMainCard?.isHidden = false
            } else {
                cell.btnSelect?.isHidden = !self.isFromJobPayment
                cell.btnSelectMainCard?.isHidden = !self.isFromJobPayment
            }
            if self.arrCard.count > 0 {
                let obj = self.arrCard[indexPath.row]
                cell.setupCardData(obj: obj)
                if let card = self.selectedCard, obj.cardId == card.cardId{
                    cell.btnSelect?.isSelected = true
                } else {
                    cell.btnSelect?.isSelected = false
                }
                
                cell.btnSelectMainCard?.tag = indexPath.row
                cell.btnSelectMainCard?.addTarget(self, action: #selector(self.btnSelectCardClicked(_:)), for: .touchUpInside)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, with: TransactionCell.self)
        if self.arrTransaction.count > 0 {
            cell.setTransactionData(obj: self.arrTransaction[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if tableView == self.tblSaveCard && self.isFromJobPayment{
            if self.arrCard.count > 0 {
                let obj = self.arrCard[indexPath.row]
                self.selectedCard = obj
                self.tblSaveCard?.reloadData()
            }
        }*/
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.isFromJobPayment || self.isFromAwardJobPayment {
            return nil
        } else {
            let item = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, boolValue) in
                //Write your code in here
                self.showAlert(withTitle: "", with: AlertTitles.kDeleteCard, firstButton: ButtonTitle.Yes, firstHandler: { (alert) in
                    if self.arrCard.count > 0 {
                        self.deleteCardAPI(cardId: self.arrCard[indexPath.row].userCardId)
                    }
                }, secondButton: ButtonTitle.No, secondHandler: nil)
            }
            item.image = UIImage(named: "ic_DeleteCard")
            //item.backgroundColor = UIColor.white
            
            item.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
            
            let swipeActions = UISwipeActionsConfiguration(actions: [item])
            swipeActions.performsFirstActionWithFullSwipe = false
            
            return swipeActions
        }
    }
    
    @objc func btnSelectCardClicked(_ sender : UIButton){
        if self.isFromJobPayment || self.isFromAwardJobPayment{
            if self.arrCard.count > 0 {
                let obj = self.arrCard[sender.tag]
                self.selectedCard = obj
                self.tblSaveCard?.reloadData()
            }
        }
    }
}

// MARK: - IBAction
extension PaymentBillingViewController {
    @IBAction func btnAddCardClicked(_ sender: XtraHelpButton) {
        
        self.appNavigationController?.present(AddCardViewController.self,configuration: { (vc) in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
        })
    }
    
    @IBAction func btnSubmitJobPaymentClicked(_ sender: XtraHelpButton) {
        if let card = self.selectedCard {
            if self.isFromAwardJobPayment {
                self.awardJobSavePaymentDataAPI(cardId: card.cardId)
            } else {
                if let applicant = self.selecetdJobApplicant {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.selecetCard(obj: card, applicantdata: applicant)
                }
            }
        } else {
            self.showMessage("Please select card for payment", themeStyle: .warning, presentationStyle: .top)
        }
    }
    
    @IBAction func btnCancelJobClicked(_ sender: UIButton) {
        self.showAlert(withTitle: "", with: "Are you sure want to cancel this award job request?", firstButton: ButtonTitle.Yes, firstHandler: { alert in
            self.awardJobCanelDataAPI(jobid: self.awardJobID)
        }, secondButton: ButtonTitle.No, secondHandler: nil)
    }
}

//MARK:- UITableView Delegate
extension PaymentBillingViewController : addCardDelegate {
    func reloadCard() {
        self.getCardAPI()
    }
}

// MARK: - API
extension PaymentBillingViewController {
    private func getCardAPI(){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CardModel.getCardList(with: param, success: { (arrlist,msg) in
                self.arrCard = arrlist
                self.tblSaveCard?.reloadData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
            })
        }
    }
    
    private func deleteCardAPI(cardId : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserCardId : cardId
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            CardModel.deleteCard(with: param, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                self.getCardAPI()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func getUserTransactionList(isshowloader :Bool = true){
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
            
            TransactionModel.getUserTransaction(with: param, isShowLoader: isshowloader, success: { (arr,totalpage,msg) in
                //self.arrResources = arr
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrTransaction.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.tblTransactions?.reloadData()
                //self.vwNoData.isHidden = (self.arrCard.isEmpty && self.arrTransaction.isEmpty) ? false : true
                /*if self.arrCard.isEmpty && self.arrTransaction.isEmpty {
                    self.headerview?.setNoCardNoTransaction(isHide: true)
                }*/
                //self.lblNoData.isHidden = self.arrBlog.count == 0 ?  false : true
                //self.lblNoData.text = msg
                self.vwTransactionsMain?.isHidden = self.arrTransaction.isEmpty
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false )
                self.vwTransactionsMain?.isHidden = self.arrTransaction.isEmpty
                //self.vwNoData.isHidden = (self.arrCard.isEmpty && self.arrTransaction.isEmpty) ? false : true
                /*if self.arrCard.isEmpty && self.arrTransaction.isEmpty {
                    self.headerview?.setNoCardNoTransaction(isHide: true)
                }*/
                //self.lblNoData.isHidden = self.arrBlog.count == 0 ?  false : true
                if !error.isEmpty {
                    //showMessage(error)
                    //self.lblNoData.text = error
                }
            })
        }
    }
    
    private func awardJobSavePaymentDataAPI(cardId : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserCardId : cardId,
                kjobId : self.awardJobID
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.awardJobSavePaymentData(with: param) { strMessage in
                self.showMessage(strMessage, themeStyle: .success)
                XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
                XtraHelp.sharedInstance.setJobEndSelecetdTab = .Upcoming
                self.appNavigationController?.showDashBoardViewController()
            } failure: { statuscode, error, customError in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            }
        }
    }
    
    private func awardJobCanelDataAPI(jobid : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            self.view.endEditing(true)
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kuserJobId : jobid
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            JobModel.cancelMyPostedJob(with: param, success: { ( msg) in
                self.showMessage(msg,themeStyle: .success)
                self.appNavigationController?.showDashBoardViewController()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension PaymentBillingViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Payment
    }
}

// MARK: - AppNavigationControllerInteractable
extension PaymentBillingViewController: AppNavigationControllerInteractable{}

